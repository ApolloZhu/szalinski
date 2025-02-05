use std::{fmt::Debug, str::FromStr};

use crate::au::ArgList;
use crate::permute::{Partitioning, Permutation};
use crate::solve::solve;
use crate::{
    au::{CadCtx, AU},
    cad::{Cad, EGraph, MetaAnalysis, Rewrite},
    num::{num, Num},
};
use egg::{rewrite as rw, *};
use itertools::Itertools;
use std::collections::{BTreeMap, HashMap, HashSet};

fn is_not_zero(var: &'static str) -> impl Fn(&mut EGraph, Id, &Subst) -> bool {
    let var = var.parse().unwrap();
    let zero = Cad::Num(num(0.0));
    move |egraph, _, subst| !egraph[subst[var]].nodes.contains(&zero)
}

// fn is_eq(v1: &'static str, v2: &'static str) -> ConditionEqual<Cad> {
//     let p1: Pattern<Cad> = v1.parse().unwrap();
//     let p2: Pattern<Cad> = v2.parse().unwrap();
//     ConditionEqual::new(p1, p2)
// }

fn is_pos(vars: &[&'static str]) -> impl Fn(&mut EGraph, Id, &Subst) -> bool {
    let vars: Vec<Var> = vars.iter().map(|v| v.parse().unwrap()).collect();
    move |egraph, _, subst| {
        vars.iter().all(|v| {
            egraph[subst[*v]].nodes.iter().all(|n| {
                if let Cad::Num(num) = n {
                    num.to_f64() > 0.0
                } else {
                    true
                }
            })
        })
    }
}

#[rustfmt::skip]
pub fn pre_rules() -> Vec<Rewrite> {
    vec![
        rw!("union_comm"; "(Binop Union ?a ?b)" => "(Binop Union ?b ?a)"),
        rw!("inter_comm"; "(Binop Inter ?a ?b)" => "(Binop Inter ?b ?a)"),
        rw!("fold_nil"; "(Binop ?bop ?a ?b)" => "(Fold ?bop (List ?a ?b))"),
        rw!("fold_cons"; "(Binop ?bop ?a (Fold ?bop ?list))" => "(Fold ?bop (Cons ?a ?list))"),

        rw!(
            "flatten_union";
            "(Fold Union ?list)" => {
                let list = "?list".parse().unwrap();
                let op = Cad::Union;
                Flatten { list, op }
            }
        ),

        // rw!("union_consr"; "(Binop Union (Fold Union ?list) ?a)" => "(Fold Union (Cons ?a ?list))"),
        rw!("inter_consr"; "(Binop Inter (Fold Inter ?list) ?a)" => "(Fold Inter (Cons ?a ?list))"),

        // TODO can't parse this now
        // rw!("consl"; "(Binop ?bop (Fold ?bop (List ?items...)) ?a)" => "(Fold ?bop (List ?items... ?a))"),

        //     "(Fold Union (List (Fold Union (List ?list...)) ?rest...))" =>
        //     "(Fold Union (List ?rest... ?list...))"),
        // rw!("flatten_inter";
        //     "(Fold Inter (List (Fold Inter (List ?list...)) ?rest...))" =>
        //     "(Fold Inter (List ?rest... ?list...))"),

        // rw!("union_consr"; "(Binop Union ?a (Fold Union ?list))" => "(Fold Union (Cons ?a ?list))"),
        // rw!("inter_consr"; "(Binop Inter ?a (Fold Inter ?list))" => "(Fold Inter (Cons ?a ?list))"),
        // rw!("list_nil"; "Nil" => "(List)"),
        // rw!("list_cons"; "(Cons ?a (List ?b...))" => "(List ?a ?b...)"),
        // rw!("nil_list"; "(List)" => "Nil"),
        // rw!("cons_list"; "(List ?a ?b...)" => "(Cons ?a (List ?b...))"),


    ]
}

#[rustfmt::skip]
pub fn rules() -> Vec<Rewrite> {


    sz_param!(CAD_IDENTS: bool = true);

    let mut rules = vec![
        // rw!("union_comm"; "(Binop Union ?a ?b)" => "(Binop Union ?b ?a)"),
        // rw!("inter_comm"; "(Binop Inter ?a ?b)" => "(Binop Inter ?b ?a)"),
        // rw!("fold_nil"; "(Binop ?bop ?a ?b)" => "(Fold ?bop (List ?a ?b))"),
        // rw!("fold_cons"; "(Binop ?bop ?a (Fold ?bop ?list))" => "(Fold ?bop (Cons ?a ?list))"),
        // rw!("union_consr"; "(Binop Union (Fold Union ?list) ?a)" => "(Fold Union (Cons ?a ?list))"),
        // rw!("inter_consr"; "(Binop Inter (Fold Inter ?list) ?a)" => "(Fold Inter (Cons ?a ?list))"),

        // rw("flatten_union",
        //    "(Fold Union (List (Fold Union (List ?list...)) ?rest...))",
        //    "(Fold Union (List ?rest... ?list...))"),
        // rw("flatten_inter",
        //    "(Fold Inter (List (Fold Inter (List ?list...)) ?rest...))",
        //    "(Fold Inter (List ?rest... ?list...))"),


        // math rules

        rw!("add_comm"; "(+ ?a ?b)" => "(+ ?b ?a)"),
        rw!("add_zero"; "(+ 0 ?a)" => "?a"),

        rw!("sub_zero"; "(- ?a 0)" => "?a"),

        rw!("mul_zero"; "(* 0 ?a)" => "0"),
        rw!("mul_one"; "(* 1 ?a)" => "?a"),
        rw!("mul_comm"; "(* ?a ?b)" => "(* ?b ?a)"),

        rw!("div_one"; "(/ ?a 1)" => "?a"),
        // rw!("mul_div"; "(* ?a (/ ?b ?a))" => "?b"),
        // rw!("div_mul"; "(/ (* ?a ?b) ?a)" => "?b"),
        rw!("mul_div"; "(* ?a (/ ?b ?a))" => "?b"
            if is_not_zero("?a")),
        rw!("div_mul"; "(/ (* ?a ?b) ?a)" => "?b"
            if is_not_zero("?a")),
        // rw!("mul_div_div"; "(* (/ ?a ?b) (/ ?c ?d))" => "(/ (* ?a ?c) (* ?b ?d))"),
        // rw!("div_div"; "(/ (/ ?a ?b) ?a)" => "(/ 1 ?b)"),

        // list rules

        rw!("fold_nil"; "(Binop ?bop ?a ?b)" => "(Fold ?bop (List ?a ?b))"),

        // cad rules

        // TODO: yz: this is not supported yet. Possibly a pre-rule
        // rw!("diff_to_union";
        //    "(Fold Diff (List ?a ?rest...))" =>
        //    "(Binop Diff ?a (Fold Union (List ?rest...)))"),

        rw!("fold_op"; "(Fold ?bop (Affine ?aff ?param ?cad))"=> "(Affine ?aff ?param (Fold ?bop ?cad))"),

        rw!("union_trans"; "(Union (Trans ?x ?y ?z ?a) (Trans ?x ?y ?z ?b))"=> "(Trans ?x ?y ?z (Union ?a ?b))"),

        rw!("inter_empty"; "(Inter ?a Empty)"=> "Empty"),

        // idempotent
        rw!("union_same"; "(Union ?a ?a)"=> "?a"),
        rw!("inter_same"; "(Inter ?a ?a)"=> "?a"),

        rw!("inter_union"; "(Inter ?a (Union ?a ?b))"=> "?a"),
        rw!("repeat_mapi"; "(Repeat ?n ?x)"=> "(MapI ?n ?x)"),
    ];

    if *CAD_IDENTS {
        rules.extend(vec![
            rw!("scale_flip"; "(Affine Scale (Vec3 -1 -1 1) ?a)"=> "(Affine Rotate (Vec3 0 0 180) ?a)"),

            rw!("scale_trans";
               "(Affine Scale (Vec3 ?a ?b ?c) (Affine Trans (Vec3 ?x ?y ?z) ?m))" =>
               "(Affine Trans (Vec3 (* ?a ?x) (* ?b ?y) (* ?c ?z))
              (Affine Scale (Vec3 ?a ?b ?c) ?m))"),

            rw!("trans_scale"; "(Affine Trans (Vec3 ?x ?y ?z) (Affine Scale (Vec3 ?a ?b ?c) ?m))"=> "(Affine Scale (Vec3 ?a ?b ?c) (Affine Trans (Vec3 (/ ?x ?a) (/ ?y ?b) (/ ?z ?c)) ?m))"),

            // rw("scale_rotate",
            //    "(Scale (Vec3 ?a ?a ?a) (Rotate (Vec3 ?x ?y ?z) ?m))",
            //    "(Rotate (Vec3 ?x ?y ?z) (Scale (Vec3 ?a ?a ?a) ?m))"),

            // rw("rotate_scale",
            //    "(Scale (Vec3 ?a ?a ?a) (Rotate (Vec3 ?x ?y ?z) ?m))",
            //    "(Rotate (Vec3 ?x ?y ?z) (Scale (Vec3 ?a ?a ?a) ?m))"),

            // primitives

            rw!("cone_scale";
               "(Cylinder (Vec3 ?h ?r1 ?r2) ?params ?center)" =>
               "(Affine Scale (Vec3 1 1 ?h)
                (Cylinder (Vec3 1 ?r1 ?r2) ?params ?center))"),

            rw!("scale_cone";
                "(Affine Scale (Vec3 1 1 ?h)
                  (Cylinder (Vec3 1 ?r1 ?r2) ?params ?center))" =>
                "(Cylinder (Vec3 ?h ?r1 ?r2) ?params ?center)"
                if is_pos(&["?h"])
            ),

            rw!("cylinder_scale";
               "(Cylinder (Vec3 ?h ?r ?r) ?params ?center)" =>
               "(Affine Scale (Vec3 ?r ?r ?h)
              (Cylinder (Vec3 1 1 1) ?params ?center))"),
            rw!("scale_cylinder";
                "(Affine Scale (Vec3 ?r ?r ?h)
              (Cylinder (Vec3 1 1 1) ?params ?center))" =>
                "(Cylinder (Vec3 ?h ?r ?r) ?params ?center)"
                if is_pos(&["?r", "?h"])
            ),

            rw!("cube_scale";
               "(Cube (Vec3 ?x ?y ?z) ?center)" =>
               "(Affine Scale (Vec3 ?x ?y ?z)
              (Cube (Vec3 1 1 1) ?center))"),
            rw!(
                "scale_cube";
                "(Affine Scale (Vec3 ?x ?y ?z)
              (Cube (Vec3 1 1 1) ?center))" =>
                "(Cube (Vec3 ?x ?y ?z) ?center)"
                if is_pos(&["?x", "?y", "?z"])
            ),

            rw!("sphere_scale";
               "(Sphere ?r ?params)" =>
               "(Affine Scale (Vec3 ?r ?r ?r)
              (Sphere 1 ?params))"),
            rw!(
                "scale_sphere";
                "(Affine Scale (Vec3 ?r ?r ?r)
              (Sphere 1 ?params))" =>
                "(Sphere ?r ?params)"
                if is_pos(&["?r"])
            ),

            // affine rules

            rw!("id"; "(Affine Trans (Vec3 0 0 0) ?a)"=> "?a"),

            rw!("combine_scale"; "(Affine Scale (Vec3 ?a ?b ?c) (Affine Scale (Vec3 ?d ?e ?f) ?cad))"=> "(Affine Scale (Vec3 (* ?a ?d) (* ?b ?e) (* ?c ?f)) ?cad)"),
            rw!("combine_trans"; "(Affine Trans (Vec3 ?a ?b ?c) (Affine Trans (Vec3 ?d ?e ?f) ?cad))"=> "(Affine Trans (Vec3 (+ ?a ?d) (+ ?b ?e) (+ ?c ?f)) ?cad)"),

        ]);
    }

    // rules.push(rw!(
    //     "listapplier";
    //     "?list" => {
    //         let var = "?list".parse().unwrap();
    //         ListApplier { var }
    //     }
    // ));

    if *CAD_IDENTS {
        // add the intro rules only for cads
        let id_affines = &[
            ("scale", "Affine Scale (Vec3 1 1 1)"),
            ("trans", "Affine Trans (Vec3 0 0 0)"),
            ("rotate", "Affine Rotate (Vec3 0 0 0)"),
        ];
        let possible_cads = &[
            ("affine", "(Affine ?op ?param ?cad)"),
            ("bop", "(Binop ?op ?cad1 ?cad2)"),
            ("fold", "(Fold ?op ?cads)"),
        ];
        for (aff_name, id_aff) in id_affines {
            for (cad_name, cad) in possible_cads {
                let intro = format!("id_{}_{}_intro", aff_name, cad_name);
                let outer: Pattern<_> = format!("({} {})", id_aff, cad).parse().unwrap();
                let cad: Pattern<_> = cad.parse().unwrap();
                rules.push(rw!(intro; cad => outer));
            }

            // elim rules work for everything
            let elim = format!("id_{}_elim", aff_name);
            let outer: Pattern<_> = format!("({} ?a)", id_aff).parse().unwrap();
            rules.push(rw!(elim; outer => "?a"));
        }
    }

    println!("Using {} rules", rules.len());

    rules
}
// this partition will partition all at once
fn partition_list<U, F, K>(args: &[U], mut key_fn: F) -> Option<(Partitioning, Permutation)>
where
    F: FnMut(usize, &U) -> K,
    K: Ord + Eq + Debug + Clone,
    U: Ord,
{
    // allow easy disabling
    sz_param!(PARTITIONING: bool = true);
    if !*PARTITIONING {
        return None;
    }

    // parts is normalized in that key is enumerated in sorted order,
    // and value (each partition) is also sorted.
    let mut parts: BTreeMap<K, Vec<usize>> = Default::default();
    for (i, arg) in args.iter().enumerate() {
        let key = key_fn(i, arg);
        let part = parts.entry(key).or_default();
        part.push(i);
    }
    // normalize each partition
    for (_, part) in &mut parts {
        part.sort_by_key(|i| &args[*i]);
    }

    sz_param!(PARTITIONING_MAX: usize = 5);
    if parts.len() <= 1 || parts.len() > *PARTITIONING_MAX {
        return None;
    }
    // println!("parts: {:?}", parts);

    let mut order = Vec::new();
    let mut lengths = Vec::new();
    for (_, part) in &parts {
        order.extend(part);
        lengths.push(part.len());
    }
    let part = Partitioning::from_vec(lengths);

    let perm = Permutation::from_vec(order);

    return Some((part, perm));
}

macro_rules! get_meta_list {
    ($egraph:expr, $eclass:expr) => {
        match &$egraph[$eclass].data.list {
            Some(ids) => ids,
            None => return vec![],
        }
    };
}

#[derive(Debug)]
struct Flatten {
    op: Cad,
    list: Var,
}

impl Applier<Cad, MetaAnalysis> for Flatten {
    fn apply_one(
        &self,
        egraph: &mut EGraph,
        eclass: Id,
        map: &Subst,
        _searcher_ast: Option<&PatternAst<Cad>>,
        _rule_name: Symbol,
    ) -> Vec<Id> {
        fn get_nested_fold<'a>(egraph: &'a EGraph, op: &'a Cad, id: Id) -> Option<&'a [Id]> {
            let is_op = |i| egraph[i].nodes.iter().any(|c| c == op);
            let get_list = |i| egraph[i].data.list.as_ref().map(Vec::as_slice);
            egraph[id]
                .nodes
                .iter()
                .find(|n| matches!(n, Cad::Fold(_)) && is_op(n.children()[0]))
                .and_then(|n| get_list(n.children()[1]))
        }

        let ids = get_meta_list!(egraph, map[self.list]);
        let mut new_ids = Vec::new();
        for id in ids {
            match get_nested_fold(egraph, &self.op, *id) {
                Some(ids) => new_ids.extend(ids.iter().copied()),
                None => new_ids.push(*id),
            }
        }

        let new_list = egraph.add(Cad::List(new_ids));
        let op = egraph.add(self.op.clone());
        let new_fold = egraph.add(Cad::Fold([op, new_list]));

        let results = vec![new_fold];
        for result in results.iter() {
            egraph.union(eclass, *result);
        }
        results
    }
}

pub fn reroll(egraph: &mut EGraph) {
    let mut au = AU::default();
    let pattern: Pattern<Cad> = "(Fold Union ?list)".parse().unwrap();
    let list_var = Var::from_str(&"?list").unwrap();
    let matches = pattern.search(egraph);

    for m in matches {
        for subst in &m.substs {
            let root_id = subst[list_var];
            let list = egraph[root_id].data.list.as_ref().unwrap().clone();
            let list_len = list.len();

            // Step 3: compute and build rerolled exprs
            let mut part_to_ids = HashMap::<Vec<Id>, Vec<Id>>::new();
            let au_groups: Vec<(CadCtx, Vec<Id>, Vec<Vec<Num>>)> =
                get_au_groups(egraph, &list, &mut au);
            eprintln!("au_groups.len(): {}", au_groups.len());
            for (template, ids, anti_substs) in au_groups {
                // anti_substs[i] denotes potential anti-substitutions for ids[i].
                // in many cases there will be only one, but there may be many as well.
                // compute all possible partition of the list
                let part_perms = get_all_part_perms(&anti_substs);

                // eprintln!("part_perms.len(): {}", part_perms.len());
                // Solve for each partition
                for (part, perm) in part_perms {
                    let anti_substs_parts: Vec<Vec<ArgList>> =
                        part.apply(&perm.apply(&anti_substs));
                    let id_parts = part.apply(&perm.apply(&ids));

                    for (anti_substs, mut ids) in
                        anti_substs_parts.into_iter().zip(id_parts.into_iter())
                    {
                        ids.sort();
                        if anti_substs.len() > 1 {
                            let solved_ids = solve(egraph, &anti_substs, &template);
                            let vec_of_ids = part_to_ids.entry(ids).or_default();
                            for id in solved_ids.iter() {
                                vec_of_ids.push(*id);
                            }
                        }
                    }
                }

                // also add the dumb list that does no solving
                // let col_len = anti_substs[0].len();
                // let arr_of_cols = (0..col_len)
                //     .map(|i| anti_substs.iter().map(|row| row[i]).collect_vec())
                //     .collect_vec();
                // let n = egraph.add(Cad::Num(anti_substs.len().into()));
                // let arg_ids = arr_of_cols
                //     .iter()
                //     .map(|col| {
                //         let elems = col.iter().map(|n| egraph.add(Cad::Num(*n))).collect_vec();
                //         let list_id = egraph.add(Cad::List(elems));
                //         let var_id = egraph.add(Cad::ListVar(ListVar("i0".into())));
                //         egraph.add(Cad::GetAt([list_id, var_id]))
                //     })
                //     .collect_vec();
                // let no_solving =
                //     SolveResult::from_loop_params(vec![n], arg_ids).assemble(egraph, &template);

                // part_to_ids.entry(ids).or_default().push(no_solving);
            }

            // Step 4: try to combine different parts
            let mut part_to_ids = part_to_ids
                .into_iter()
                .filter_map(|(part, ids)| {
                    if ids.len() > 0 {
                        for id in ids.iter().skip(1) {
                            egraph.union(ids[0], *id);
                        }

                        Some((part, ids[0]))
                    } else {
                        None
                    }
                })
                .collect_vec();

            eprintln!(
                "start searching: option_len: {} list_len: {list_len}",
                part_to_ids.len()
            );
            part_to_ids.sort_by(|a, b| a.0.len().cmp(&b.0.len()).reverse());

            let mut singleton_part_to_ids = HashMap::new();
            for id in list.iter() {
                let list_id = egraph.add(Cad::List(vec![*id]));
                singleton_part_to_ids.insert(*id, list_id);
            }
            search_combinations_and_add(
                &part_to_ids,
                &singleton_part_to_ids,
                egraph,
                root_id,
                &mut vec![],
                &mut HashSet::default(),
                0,
                list_len,
                3,
            );
        }
    }

    egraph.rebuild();
}

fn search_combinations_and_add(
    part_to_ids: &[(Vec<Id>, Id)],
    singleton_part_to_ids: &HashMap<Id, Id>,
    egraph: &mut EGraph,
    root_id: Id,
    // part ids that are used
    cur_buffer: &mut Vec<Id>,
    ids_covered: &mut HashSet<Id>,
    cur_pos: usize,
    target_size: usize,
    limit: usize,
) {
    let todo_size = target_size - ids_covered.len();
    if limit == 0 || todo_size == 0 {
        // fill with singleton list
        let mut cur_buffer = cur_buffer.clone();
        for (part, id) in singleton_part_to_ids {
            if !ids_covered.contains(part) {
                cur_buffer.push(*id);
            }
        }
        // insert into the e-graph
        if cur_buffer.len() == 1 {
            egraph.union(root_id, cur_buffer[0]);
        } else {
            let list_id = egraph.add(Cad::List(cur_buffer));
            let concat_id = egraph.add(Cad::Concat([list_id]));
            egraph.union(root_id, concat_id);
        }
    } else {
        // for i in cur_pos..(part_to_ids.len() - todo_size + 1) {
        for i in cur_pos..part_to_ids.len() {
            let (part, id) = &part_to_ids[i];
            if part.iter().all(|id| !ids_covered.contains(id)) {
                cur_buffer.push(*id);
                ids_covered.extend(part);
                search_combinations_and_add(
                    part_to_ids,
                    singleton_part_to_ids,
                    egraph,
                    root_id,
                    cur_buffer,
                    ids_covered,
                    i + 1,
                    target_size,
                    limit - 1,
                );
                part.iter().for_each(|id| assert!(ids_covered.remove(id)));
                cur_buffer.pop();
            }
        }
    }
}

fn get_all_part_perms(anti_substs: &Vec<ArgList>) -> HashSet<(Partitioning, Permutation)> {
    let m = anti_substs[0].len();
    // build possible partitions of the list
    // We only care about interesting columns, which hopefully aren't that many.
    let cands: Vec<_> = (1..m)
        .filter(|i| {
            !anti_substs
                .iter()
                .skip(1)
                .all(|anti_subst| anti_subst[*i] == anti_substs[0][*i])
        })
        .collect();

    // compute all possible partition of the list
    let mut part_perms = cands
        .iter()
        .cartesian_product(cands.iter())
        // when i == j, this corresponds partitioning by one key
        .filter(|(i, j)| i <= j)
        .filter_map(|(i, j)| partition_list(&anti_substs, |_, a_s| (a_s[*i], a_s[*j])))
        .collect::<HashSet<_>>();
    // also add the original list
    part_perms.insert((
        Partitioning::from_vec(vec![anti_substs.len()]),
        Permutation::from_vec((0..anti_substs.len()).collect_vec()),
    ));
    part_perms
}

fn get_au_groups(
    egraph: &EGraph,
    list: &Vec<Id>,
    au: &mut AU,
) -> Vec<(CadCtx, Vec<Id>, Vec<Vec<Num>>)> {
    let mut au_groups = HashMap::<CadCtx, HashMap<Id, Vec<Num>>>::default();

    // TODO: handle repeated substructures (or do we?)
    // Step 1: compute anti-unification
    for i in 0..list.len() {
        for j in i + 1..list.len() {
            let result = au.anti_unify_class(egraph, &(list[i], list[j]));
            eprintln!("result.len: {}", result.len());
            for (cad, args1, args2) in result {
                if !au_groups.contains_key(cad) {
                    au_groups.insert(cad.clone(), HashMap::default());
                }
                let map = au_groups.get_mut(cad).unwrap();
                map.entry(list[i]).or_insert_with(|| args1.clone());
                map.entry(list[j]).or_insert_with(|| args2.clone());
            }
        }
    }
    if au_groups.len() == 0 {
        return vec![];
    }
    eprintln!(
        "anti_unification done, templates found: {}",
        au_groups.len()
    );
    // flat buffer au_groups
    let au_groups: Vec<(CadCtx, Vec<Id>, Vec<Vec<Num>>)> = au_groups
        .into_iter()
        // .filter(|(_x, y)| y.len() > 2)
        .map(|(x, y)| {
            let mut y = y.into_iter().collect::<Vec<_>>();
            y.sort_by_key(|(id, _args)| *id);
            let mut ids = vec![];
            let mut list_of_args = vec![];
            for (id, args) in y {
                ids.push(id);
                list_of_args.push(args);
            }
            (x, ids, list_of_args)
        })
        .collect();

    // Step 2: shrink the AUs
    // we group by the ids they match and only take ones with smallest size
    // UPDATE: We don't do this, since there's no way to figure out which template is just universally "better"
    // than others.
    // sort by signature (ids), then by size of CadCtx
    // au_groups.sort_unstable_by(|a, b| a.1.cmp(&b.1).then_with(|| a.0.size().cmp(&b.0.size())));
    // let au_groups: Vec<(CadCtx, Vec<Id>)> = au_groups.into_iter().fold(vec![], |mut acc, a| {
    //     if acc.last().map_or(true, |b| a.1 != b.1) {
    //         acc.push(a);
    //     }
    //     acc
    // });
    au_groups
}
