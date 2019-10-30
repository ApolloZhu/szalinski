height = 9.4; // Height of mounting hole
thickness = 4; // Thickness of plate and hole
//Screws
screws_spacing = 31; // NEMA17 = 31, Titan = 37
screws_diameter = 3.2;
screw2_y_offset = 0; // NEMA17 = 0, Tital = 0.75
second_screw_holes = false; // Adds second set of holes to allow flipping
//Sensor
sensor_diameter = 12.2;
sensor_drop = 0; // Vertical drop of the sensor
sensor_standoff=1; // How far off the mounting plate to put the mounting hole - For a 12mm sensor with the standard lock washers, it needs to be 1mm if no drop, 5mm if it has any drop

mount_width = thickness+thickness/2+screws_spacing+thickness/2+thickness;
mount_start = mount_width/2-sensor_diameter/2-thickness;

//Mount
$fn=50;
difference() {
	cube([thickness, mount_width, height+sensor_drop]);
	
	//Screws 1
	translate([-0.5, thickness+thickness/2, height/2+sensor_drop])
	rotate([0,90,0])
	cylinder(d=screws_diameter, h=thickness+1);
    if (second_screw_holes) {
        // 1b
        translate([-0.5, thickness+thickness/2, height/2-screw2_y_offset])
        rotate([0,90,0])
        cylinder(d=screws_diameter, h=thickness+1);
    }
	//Screws 2
	translate([-0.5, thickness+thickness/2+screws_spacing, height/2+sensor_drop+screw2_y_offset])
	rotate([0,90,0])
	cylinder(d=screws_diameter, h=thickness+1);
    if (second_screw_holes) {
        // 2b
        translate([-0.5, thickness+thickness/2+screws_spacing, height/2])
        rotate([0,90,0])
        cylinder(d=screws_diameter, h=thickness+1);
    }
	//angle
	translate([-0.5, 0, height*0.57+sensor_drop])
	rotate([45,0,0])
	cube([thickness+1, 100, height]);
	//angle
	translate([-0.5, mount_width, height*0.57+sensor_drop])
	rotate([45,0,0])
	cube([thickness+1, 100, height]);
}
//Sensor
$fn=50;
difference() {
	union() {
		translate([sensor_diameter/2+thickness+sensor_standoff,mount_start+thickness+sensor_diameter/2, 0])
		cylinder(d=sensor_diameter+2*thickness, h=height);

		translate([thickness, mount_start, 0])
		cube([sensor_diameter/2+sensor_standoff, sensor_diameter/2, height]);

		translate([thickness, mount_start+sensor_diameter+thickness/2, 0])
		cube([sensor_diameter/2+sensor_standoff, sensor_diameter/2, height]);
        
		translate([thickness, mount_start, 0])
		cube([sensor_standoff, sensor_diameter + thickness * 2, height]);
	}
	translate([sensor_diameter/2+thickness+sensor_standoff,mount_start+thickness+sensor_diameter/2, -0.5])
	cylinder(d=sensor_diameter, h=height+1);
}
