d=3.2;  // cable diameter
n=9;    // cable loop count

//l=22.6;
//h=7.9;
//b=7.1;
//d1=1.7;
//d2=2.83;

nx=1;   // how many you want
ny=2;   // 2 * 4 = 8 pcs

d1=d/2;
d2=(3/4)*d;
b=2*d;
l=(n+0.9)*d;
h=b;

e=0.001;

module outer(l,h,b,d1,d2){
    cylinder(r=b/2,h=h,$fn=24);
    difference(){
        translate([0,-b/2,0])cube([l-b/2,b,h]);
        translate([l-b/2-d2*sin(40),0,-e])rotate([0,0,-40])cube([b,b,h+2*e]);
        translate([l-b/2-d2*sin(40),0,-e])rotate([0,0,-50])cube([b,b,h+2*e]);
    }
}

module inner(l,h,b,d1,d2){
    translate([0,0,-e]){
        for (i=[0:n-1]){
            translate([i*d,0,0])cylinder(r=b/2-d1,h=h+2*e,$fn=24);
        }
//      translate([l-b,0,0])cylinder(r=b/2-d1,h=h+2*e,$fn=24);
        translate([0,-(b-2.6*d1)/2,0])cube([l-b,b-2.6*d1,h+2*e]);
        translate([0,-(b-2*d2)/2,0])cube([l,b-2*d2,h+2*e]);
    }
}

module clip(l,h,b,d1,d2){
    difference(){
        outer(l,h,b,d1,d2);
        inner(l,h,b,d1,d2);
    }
}

for(xi=[0:nx-1])
    for(yi=[0:ny-1])
        translate([xi*(l+1),yi*(b+1),0])clip(l,h,b,d1,d2);
