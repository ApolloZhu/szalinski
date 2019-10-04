use std::f64::consts;

use smallvec::smallvec;

use crate::{
    cad::{Cad, EGraph, ListVar, Variable, Vec3},
    num::Num,
};
use egg::{
    egraph::AddResult,
    expr::{Expr, Id},
};

fn f(u: usize) -> f64 {
    u as f64
}

#[derive(Debug, PartialEq)]
pub struct VecFormula {
    x: Formula,
    y: Formula,
    z: Formula,
}

#[derive(Debug, PartialEq)]
enum Formula {
    Deg1(Deg1),
    Deg2(Deg2),
}

impl Formula {
    fn add_to_egraph(&self, egraph: &mut EGraph) -> Id {
        match self {
            Formula::Deg1(f) => {
                let a = egraph.add(Expr::unit(Cad::Num(f.a.into()))).id;
                let b = egraph.add(Expr::unit(Cad::Num(f.b.into()))).id;
                let i = egraph.add(Expr::unit(Cad::ListVar(ListVar("i")))).id;
                let mul = egraph.add(Expr::new(Cad::Mul, smallvec![a, i])).id;
                egraph.add(Expr::new(Cad::Add, smallvec![mul, b])).id
            }
            Formula::Deg2(f) => unimplemented!(),
        }
    }
}

fn add_mapi(egraph: &mut EGraph, n: usize, vf: VecFormula) -> AddResult {
    let n = egraph.add(Expr::unit(Cad::Num(n.into()))).id;
    let x = vf.x.add_to_egraph(egraph);
    let y = vf.y.add_to_egraph(egraph);
    let z = vf.z.add_to_egraph(egraph);
    let vec = egraph.add(Expr::new(Cad::Vec, smallvec![x, y, z])).id;
    egraph.add(Expr::new(Cad::MapI, smallvec![n, vec]))
}

#[derive(Debug, PartialEq)]
struct Deg1 {
    a: f64,
    b: f64,
}

#[derive(Debug, PartialEq)]
struct Deg2 {
    a: f64,
    b: f64,
    c: f64,
}

fn solve_deg1(vs: &[Num]) -> Option<Deg1> {
    let i1 = 0.0;
    let i2 = 1.0;
    let o1 = vs[0].to_f64();
    let o2 = vs[1].to_f64();
    let b = (o1 * i2) - (o2 * i1) / (i2 - i1);
    let a = (o2 - b) / i2;
    let mut ivs = vs.iter().enumerate();
    if ivs.all(|(i, &v)| v.is_close(a * f(i) + b)) {
        Some(Deg1 { a, b })
    } else {
        None
    }
}

fn solve_deg2(vs: &[Num]) -> Option<Deg2> {
    let i1 = 0.0;
    let i2 = 1.0;
    let i3 = 2.0;
    let o1 = vs[0].to_f64();
    let o2 = vs[1].to_f64();
    let o3 = vs[2].to_f64();
    let a = (((o2 * i3) - (o3 * i2)) - ((i2 - i3) * (((o1 * i2) - (o2 * i1)) / (i1 - i2))))
        / ((i2 - i3) * ((i2 * i3) - (i1 * i2)));
    let c = (a * i1 * i2) - (((o1 * i2) - (o2 * i1)) / (i1 - i2));
    let b = (o3 - c - (a * i3 * i3)) / i3;
    let mut ivs = vs.iter().enumerate();

    let works = ivs.all(|(i, &v)| v.is_close(a * f(i * i) + b * f(i) + c));

    if works {
        Some(Deg2 { a, b, c })
    } else {
        None
    }
}

fn solve_one(xs: &[Num], ys: &[Num], zs: &[Num]) -> Option<VecFormula> {
    let x = solve_deg1(&xs).map(Formula::Deg1)?;
    let y = solve_deg1(&ys).map(Formula::Deg1)?;
    let z = solve_deg1(&zs).map(Formula::Deg1)?;
    Some(VecFormula { x, y, z })
}

fn solve_vec(egraph: &mut EGraph, list: &[Vec3]) -> Vec<AddResult> {
    // print!("Solving: [");
    // for v in list {
    //     print!("({:.2}, {:.2}, {:.2}), ", v.0, v.1, v.2);
    // }
    // println!("]");

    if list.iter().all(|&v| v == list[0]) {
        // don't infer here, it'll become a repeat
        return vec![];
    }

    let xs: Vec<Num> = list.iter().map(|v| v.0).collect();
    let ys: Vec<Num> = list.iter().map(|v| v.1).collect();
    let zs: Vec<Num> = list.iter().map(|v| v.2).collect();

    let len = xs.len();
    assert_eq!(len, ys.len());
    assert_eq!(len, zs.len());

    let mut results = vec![];

    if let Some(formula) = solve_one(&xs, &ys, &zs) {
        results.push(add_mapi(egraph, len, formula));
    }

    let perms = [
        permutation::sort(&xs[..]),
        permutation::sort(&ys[..]),
        permutation::sort(&zs[..]),
    ];

    for perm in &perms {
        // println!("Trying sort {:?}", perm);
        let xs = perm.apply_slice(&xs[..]);
        let ys = perm.apply_slice(&ys[..]);
        let zs = perm.apply_slice(&zs[..]);
        if let Some(formula) = solve_one(&xs, &ys, &zs) {
            // println!("Found with sort {:?}: {:?}", perm, formula);
            let p = Cad::Variable(Variable(format!("{:?}", perm)));
            let e = Expr::new(
                Cad::Unsort,
                smallvec![
                    egraph.add(Expr::unit(p)).id,
                    add_mapi(egraph, len, formula).id,
                ],
            );
            results.push(egraph.add(e));
        }
    }
    results
}

fn polar_one(center: (f64, f64, f64), v: Vec3) -> Vec3 {
    let (x, y, z) = (v.0.to_f64(), v.1.to_f64(), v.2.to_f64());
    let (a, b, c) = center;
    let (xa, yb, zc) = (x - a, y - b, z - c);
    let r = (xa * xa + yb * yb + zc * zc).sqrt();
    // println!("r: {}", r);
    let theta = yb.atan2(xa) * 180.0 / consts::PI;
    let phi = if r == 0.0 {
        0.0
    } else {
        (zc / r).acos() * 180.0 / consts::PI
    };
    // println!("xa: {} yb: {} zc: {}", xa, yb, zc);
    // println!("r: {} t: {} p: {}", r, theta, phi);
    (r.into(), theta.into(), phi.into())
}

fn polarize(list: &[Vec3]) -> (Vec3, Vec<Vec3>) {
    let xc = list.iter().map(|v| v.0.to_f64()).sum::<f64>();
    let yc = list.iter().map(|v| v.1.to_f64()).sum::<f64>();
    let zc = list.iter().map(|v| v.2.to_f64()).sum::<f64>();
    let n = f(list.len());
    let center = (xc / n, yc / n, zc / n);
    let new_list = list.iter().map(|&v| polar_one(center, v)).collect();
    let num_center = (center.0.into(), center.1.into(), center.2.into());
    (num_center, new_list)
}

fn add_num(egraph: &mut EGraph, n: Num) -> Id {
    static NS: &[f64] = &[consts::SQRT_2, 0.0, 90.0, 180.0, 270.0, 360.0];

    for &known_n in NS {
        if n == known_n.into() {
            return egraph.add(Expr::unit(Cad::Num(known_n.into()))).id;
        }
    }
    egraph.add(Expr::unit(Cad::Num(n))).id
}

fn add_vec(egraph: &mut EGraph, v: Vec3) -> Id {
    let x = add_num(egraph, v.0);
    let y = add_num(egraph, v.1);
    let z = add_num(egraph, v.2);
    egraph.add(Expr::new(Cad::Vec, smallvec![x, y, z])).id
}

pub fn solve(egraph: &mut EGraph, list: &[Vec3]) -> Vec<AddResult> {
    let mut results = solve_vec(egraph, list);
    // println!("{:?}", list);
    let (center, polar_list) = polarize(&list);
    for res in solve_vec(egraph, &polar_list) {
        let e = Expr::new(
            Cad::Unpolar,
            smallvec![
                add_num(egraph, list.len().into()),
                add_vec(egraph, center),
                res.id
            ],
        );
        results.push(egraph.add(e));
    }
    results
}

#[cfg(test)]
mod tests {
    use super::*;

    fn mk_test_vec(v: &[f64]) -> Vec<Num> {
        v.iter().map(|&v| v.into()).collect()
    }

    #[test]
    fn deg1_test1() {
        let input = mk_test_vec(&[1.0, 2.0, 3.0, 4.0]);
        let res = solve_deg1(&input).unwrap();
        assert_eq!(res.a, 1.0);
    }

    #[test]
    fn deg1_test2() {
        let input = mk_test_vec(&[0.0, 0.0, 0.0, 0.0]);
        let res = solve_deg1(&input).unwrap();
        assert_eq!(res.a, 0.0);
    }

    #[test]
    fn deg1_fail() {
        let input = mk_test_vec(&[0.0, 0.0, 0.0, 1.0]);
        assert_eq!(solve_deg1(&input), None);
    }

    #[test]
    fn deg2_test1() {
        let input = mk_test_vec(&[0.0, 1.0, 4.0, 9.0]);
        let res = solve_deg2(&input).unwrap();
        assert_eq!(res.a, 1.0);
    }

    #[test]
    fn deg2_fail() {
        let input = mk_test_vec(&[0.0, 1.0, 14.0, 9.0]);
        assert_eq!(solve_deg2(&input), None);
    }
}
