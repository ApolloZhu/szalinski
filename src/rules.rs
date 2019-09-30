use std::{fmt::Debug, hash::Hash, rc::Rc};

use egg::{
    egraph::{AddResult, Metadata},
    expr::{Expr, Id, QuestionMarkName, RecExpr},
    parse::ParsableLanguage,
    pattern::{Applier, Rewrite, WildMap},
};

use indexmap::IndexMap;
use log::*;
use smallvec::{smallvec, SmallVec};

use crate::cad::{Cad, EGraph, Meta, Num};

fn rw<M: Metadata<Cad>>(name: &str, lhs: &str, rhs: &str) -> Rewrite<Cad, M> {
    Cad::parse_rewrite(name, lhs, rhs).unwrap()
}

#[rustfmt::skip]
pub fn rules() -> Vec<Rewrite<Cad, Meta>> {
    vec![
        rw("defloat", "(Float ?a)", "?a"),

        rw("list_nil", "Nil", "(List)"),
        rw("list_cons", "(Cons ?a (List ?b...))", "(List ?a ?b...)"),

        rw("union_nil", "(Union ?a ?b)", "(FoldUnion (Cons ?a (Cons ?b Nil)))"),
        rw("union_cons", "(Union ?a (FoldUnion ?list))", "(FoldUnion (Cons ?a ?list))"),

        rw("do_trans",  "(Trans  ?x ?y ?z ?a)", "(Do Trans  (Vec ?x ?y ?z) ?a)"),
        rw("do_rotate", "(Rotate ?x ?y ?z ?a)", "(Do Rotate (Vec ?x ?y ?z) ?a)"),
        rw("do_scale",  "(Scale  ?x ?y ?z ?a)", "(Do Scale  (Vec ?x ?y ?z) ?a)"),
        rw("undo_trans",  "(Do Trans  (Vec ?x ?y ?z) ?a)", "(Trans  ?x ?y ?z ?a)"),
        rw("undo_rotate", "(Do Rotate (Vec ?x ?y ?z) ?a)", "(Rotate ?x ?y ?z ?a)"),
        rw("undo_scale",  "(Do Scale  (Vec ?x ?y ?z) ?a)", "(Scale  ?x ?y ?z ?a)"),

        rw("map_nil",
           "(Cons (Do ?op ?param ?cad) Nil)",
           "(Map ?op (Cons ?param Nil) (Cons ?cad Nil))"),
        rw("map_cons",
           "(Cons (Do ?op ?param ?cad) (Map ?op ?params ?cads))",
           "(Map ?op (Cons ?param ?params) (Cons ?cad ?cads))"),

        rw("union_trans",
           "(Union (Trans ?x ?y ?z ?a) (Trans ?x ?y ?z ?b))",
           "(Trans ?x ?y ?z (Union ?a ?b))"),

        // NOTE we do these rules in ListApplier now
        // rw("nil_repeat",
        //    "(List ?a)",
        //    "(Repeat 1 ?a)"),

        // rw("cons_repeat",
        //    "(Cons ?a (Repeat ?n ?a))",
        //    "(Repeat (+ ?n 1) ?a)"),

        rw("diff_union",
           "(Diff (Union ?a ?b) ?c)",
           "(Union ?a (Diff ?b ?c))"),

        rw("diff",
           "(Diff (Diff ?a ?b) ?c)",
           "(Diff ?a (Union ?b ?c))"),

        // NOTE this explode the egraph
        // rw("diff2",
        //    "(Diff ?a (Union ?b ?c))",
        //    "(Diff (Diff ?a ?b) ?c)"),

        rw("combine_op",
           "(Do ?op (Vec ?a ?b ?c) (Do ?op (Vec ?d ?e ?f) ?cad))",
           "(Do ?op (Vec (+ ?a ?d) (+ ?b ?e) (+ ?c ?f)) ?cad)"),

        rw("lift_op",
           "(Union (Do ?op ?params ?a) (Do ?op ?params ?b))",
           "(Do ?op ?params (Union ?a ?b))"),


        rw("rotate_zero", "(Rotate 0 0 0 ?a)", "?a"),
        rw("trans_zero", "(Trans 0 0 0 ?a)", "?a"),

        rw("scale_trans",
           "(Scale ?a ?b ?c (Trans ?x ?y ?z ?m))",
           "(Trans (* ?a ?x) (* ?b ?y) (* ?c ?z) (Scale ?a ?b ?c ?m))"),

        rw("trans_scale",
           "(Trans ?x ?y ?z (Scale ?a ?b ?c ?m))",
           "(Scale ?a ?b ?c (Trans (/ ?x ?a) (/ ?y ?b) (/ ?z ?c) ?m))"),

        rw("scale_rotate",
           "(Scale ?a ?a ?a (Rotate ?x ?y ?z ?m))",
           "(Rotate ?x ?y ?z (Scale ?a ?a ?a ?m))"),

        rw("rotate_scale",
           "(Scale ?a ?a ?a (Rotate ?x ?y ?z ?m))",
           "(Rotate ?x ?y ?z (Scale ?a ?a ?a ?m))"),

        Rewrite {
            name: "listapplier".into(),
            lhs: Cad::parse_pattern("(List ?items...)").unwrap(),
            applier: Rc::new(ListApplier {
                var: "?items...".parse().unwrap(),
            }),
            conditions: vec![],
        }
    ]
}

fn get_float(expr: &RecExpr<Cad>) -> Num {
    match expr.as_ref().op {
        Cad::Num(f) => f.clone(),
        _ => panic!("Expected float, got {}", expr.to_sexp()),
    }
}

type Vec3 = (Num, Num, Num);
fn get_vec(expr: &RecExpr<Cad>) -> Option<Vec3> {
    if Cad::Vec == expr.as_ref().op {
        let args = &expr.as_ref().children;
        assert_eq!(args.len(), 3);
        let f0 = get_float(&args[0]);
        let f1 = get_float(&args[1]);
        let f2 = get_float(&args[2]);
        Some((f0, f1, f2))
    } else {
        None
    }
}

#[derive(Debug)]
struct ListApplier {
    var: QuestionMarkName,
}

// NOTE
// partitioning is unsound right now because it will reorder elements
fn partition_list<F, K>(egraph: &mut EGraph, ids: &[Id], mut key_fn: F) -> Option<AddResult>
where
    F: FnMut(usize, Id) -> K,
    K: Hash + Eq + Debug,
{
    let mut parts: IndexMap<K, SmallVec<_>> = Default::default();
    for (i, &id) in ids.iter().enumerate() {
        let key = key_fn(i, id);
        parts.entry(key).or_default().push(id);
    }
    if parts.len() > 1 {
        if parts.values().any(|ids| ids.len() > 2) {
            debug!("Partitioning: {:?}", parts);
            let new_ids = parts
                .into_iter()
                .map(|(op, ids)| egraph.add(Expr::new(Cad::List, ids)).id)
                .collect();
            let e = Expr::new(Cad::Concat, new_ids);
            return Some(egraph.add(e));
        }
    }
    None
}

impl Applier<Cad, Meta> for ListApplier {
    fn apply(&self, egraph: &mut EGraph, map: &WildMap) -> Vec<AddResult> {
        let ids = &map[&self.var];
        let bests: Vec<_> = ids
            .iter()
            .map(|&id| egraph[id].metadata.best.clone())
            .collect();
        let mut results = vec![];

        // try to solve a list
        if let Some(vec_list) = bests.iter().map(get_vec).collect::<Option<Vec<Vec3>>>() {
            let len = vec_list.len();
            if len > 2 {
                if let Some(formula) = crate::solve::solve(&vec_list) {
                    debug!("Found formula {:?}", formula);
                    let e = Expr::unit(Cad::MapI(len, formula));
                    results.push(egraph.add(e))
                }
            }
            // // try to partition things by operator
            // results.extend(partition_list(egraph, ids, |i, _| {
            //     vec_list[i].0
            // }));
        }

        // // try to partition things by operator
        // results.extend(partition_list(egraph, ids, |i, _| {
        //     bests[i].as_ref().op.clone()
        // }));

        // insert repeats
        if !ids.is_empty() && ids.iter().all(|id| ids[0] == *id) {
            let n = Num::new(ids.len() as f64).unwrap();
            let len = Expr::unit(Cad::Num(n));
            let e = Expr::new(Cad::Repeat, smallvec![egraph.add(len).id, ids[0]]);
            results.push(egraph.add(e))
        }

        results
    }
}
