thickness = 3;
rInner=13;
rOuter=19;
height = 12;
slitWidth=4;
slitHeight=12;
numSlits=4;


difference(){
	union(){
		cylinder(r=rOuter, h=thickness);
		cylinder(r=rInner, h=height);
		translate([0,0,height]){ 
		rotate_extrude(convexity = 10, $fn = 100)
		translate([rInner-thickness/2, 0, 0])
		circle(r = 1.5, $fn = 100);
	}
	}
	translate([0,0,thickness]) cylinder(r=rInner-thickness, h=height);
	for(i=[1:numSlits]){
		rotate([0,0,i*360/numSlits]) translate([0,0,height+thickness-slitHeight]) cube([rOuter,slitWidth,slitHeight]);
	}
}

translate([0,0,thickness/2]){ 
rotate_extrude(convexity = 10, $fn = 100)
translate([rOuter, 0, 0])
circle(r = 1.5, $fn = 100);
}