

demo=false;
diameter_of_rod=12.75;
diameter_of_cone_large=15;
diameter_of_cone_small=2;
diameter_of_starter_hole=3;
diameter_of_dasey_hole=2;
diameter_of_inner_hole=4.5;
diameter_of_dasey_stem_small=2.5;
diameter_of_dasey_stem_large=4.5;
diameter_of_spacer=11.75;
diameter_of_cone_tap=5;
height_of_rod=100;
height_of_cone=15;
height_of_starter_hole=80;
height_of_single_dasey_stem=20;
height_of_spacer=10;
height_of_cone_tab=5;
size_of_spacer=5;
wall_thickness=1;
dasey_thickness=1.5;
number_of_dasey_holes=12;

$fs=.5;


module body(){
	difference(){
		cylinder(r=diameter_of_rod/2,h=height_of_rod,$fn=number_of_dasey_holes);	translate([0,0,height_of_rod-diameter_of_dasey_stem_small-height_of_single_dasey_stem])cylinder(r=diameter_of_inner_hole/2,h=height_of_single_dasey_stem*2);
		translate([0,0,height_of_starter_hole])translate([0,0,-diameter_of_rod/2])rotate([0,90,0])translate([0,0,-diameter_of_rod])cylinder(r=diameter_of_starter_hole/2,h=diameter_of_rod*2);
		difference(){
			translate([0,0,height_of_rod-height_of_spacer-size_of_spacer])cylinder(r=diameter_of_rod,h=size_of_spacer);
			translate([0,0,height_of_rod-height_of_spacer-2*size_of_spacer])cylinder(r=diameter_of_spacer/2,h=3*size_of_spacer);
		}
		translate([0,0,-.01])cylinder(r=diameter_of_cone_tap/2,h=height_of_cone_tab);
	}
		
}

module cone(){
	translate([0,0,-1])union(){
		hull(){
			cylinder(r=diameter_of_cone_large/2,h=1);
			translate([0,0,-height_of_cone])sphere(r=diameter_of_cone_small);
		}
		cylinder(r=.95*diameter_of_cone_tap/2,h=1+height_of_cone_tab);
	}
}

module daisy(){
	union(){
		difference(){
			union(){
				for(dasey_index=[1:number_of_dasey_holes]){
					rotate([0,0,dasey_index*360/number_of_dasey_holes])translate([diameter_of_rod/2+diameter_of_dasey_hole/2,0,0])cylinder(r=wall_thickness+diameter_of_dasey_hole/2,h=dasey_thickness);
				}
				cylinder(r=diameter_of_rod/2+diameter_of_dasey_hole,h=dasey_thickness);
			}
			for(dasey_index=[1:number_of_dasey_holes]){
				rotate([0,0,dasey_index*360/number_of_dasey_holes])translate([diameter_of_rod/2+diameter_of_dasey_hole/2,0,-.1])cylinder(r=diameter_of_dasey_hole/2,h=dasey_thickness+2);
			}
			translate([0,0,-.001])cylinder(r=diameter_of_dasey_stem_large/2,h=dasey_thickness);
		}
		hull(){
			translate([0,0,dasey_thickness+height_of_single_dasey_stem])sphere(r=diameter_of_dasey_stem_small/2);
			translate([0,0,dasey_thickness/2])cylinder(r=diameter_of_dasey_stem_large/2,h=dasey_thickness);
		}
	}
}

module daisy_stem_2(){
	hull(){
		translate([0,0,-height_of_single_dasey_stem])sphere(r=diameter_of_dasey_stem_small/2);
		cylinder(r=diameter_of_dasey_stem_large/2,h=dasey_thickness/2);
	}
}
if(demo){
	body();
	cone();
	translate([0,0,height_of_rod+1])daisy_stem_2();
	translate([0,0,height_of_rod+1])daisy();
}else{
	body();
	translate([-diameter_of_rod,0,dasey_thickness/2])rotate([180,0,0])daisy_stem_2();
	translate([diameter_of_rod+2*diameter_of_dasey_hole+2*dasey_thickness,0,0])daisy();
	translate([0,diameter_of_rod+diameter_of_cone_large/2,height_of_cone_tab])rotate([180,0,0])cone();

}