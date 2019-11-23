// 5V mechanical relay case
// GNU GPL v3
// version : 1.1
// date : 2018/11/18
// remixed from '5v relay case' by Zekin
//
//  change logs:
//  -date : 2018/11/18
//    Change dimensions to fit OMRON G3MB-202P solid state relay
//  -date : 2018/10/30
//    Making it easier to customize using Customizer by
//      Eliminate coordinate based variables (substituted by width, length, distance...)
//      Increase number of calculated values
//      Reduce number of manually defined variables
//    Added 4 cyclinders to the top piece to keep relay board in place.
//    Added ability to choose which part is generated.
//    Fix error with the top right standoff (One of the standoff's position was defined with hard-coded value).
//    Larger text. With the original setting the text was barely printable and was hard to read.


/* [specs of the relay] */
// length of relay board in mm
rlength = 34.2;
// width of relay board in mm
rwidth = 25.2;
// height of relay board in mm (height of the tallest component on the relay board)
rheight = 22.6;
// distance between pcb mounting holes along the longer side of the relay
rmount_hole_dist_long = 28.2;
// distance between pcb mounting holes along the shorter side of the relay
rmount_hole_dist_short = 19.5;

/* [specs of the case itself] */
// Wall thickness in mm. A value of 4-5 times your nozzle size would be adequate.
thickness = 1.6;
// clearance between relay board and the case's wall
clearance = 1;
// thickness of the relay PCB board
board_thickness = 2;
// Radius in mm of the main power cord (-1 to remove completely)
power_cord_r=4.2;
// Height of 5V control pins' hole
pins_height = 7;
// Text shown below 5V control pins' hole. Change this if the order of your pins is different.
pins_text="+  -  S";

/* [other parameters] */
// the number of facets used to generate an arc
$fn = 60 ;
// Tolerance for assembling parts in mm
margin=0.25 ;
// Set which part to generate. 1 for bottom, 2 for top and 3 for both
generate_part = 3;



// --------------
//hidden

/*[Supports]*/
bsupport_h = clearance * 1.5 + thickness;  // bottom stand-off height

/*[Power Cord hole]*/
// X position for the center of the power cord hole (from outside)
Hole_x = rlength + thickness*2 + clearance*2 + power_cord_r;
// Z position for the center of the power cord hole
Hole_z=bsupport_h + thickness + power_cord_r / 2 + board_thickness;

/*[Box size]*/
// inner length (X axis) in mm
box_length = rlength + clearance*2 + power_cord_r*2 + clearance*2 + board_thickness;
// inner width (Y axis) in mm
box_width = rwidth + clearance*2;
// inner base height (Z axis) in mm
bottom_height = rheight*0.8 + clearance + thickness;
// Inner top height in mm
top_height = rheight * 0.2 + clearance;

/*[5V control pin hole]*/
Pin_y = thickness + clearance + 2 * 2; // Y lower position (from outside)
Pin_z = bsupport_h + thickness; // Z lower position
pins_width = rmount_hole_dist_short - 2 * 2; // Y size


// --------------
// modules definition

// Cube with rounded vertical ridge
module roundedCube(size, radius) {
    hull() {
        translate([radius, radius]) cylinder(r = radius, h = size[2]);
        translate([size[0] - radius, radius]) cylinder(r = radius, h = size[2]);
        translate([size[0] - radius, size[1] - radius]) cylinder(r = radius, h = size[2]);
        translate([radius, size[1] - radius]) cylinder(r = radius, h = size[2]);
    }
}

// triangular prism for holding the top part
module prism(e,w){
   translate([-w/2, 0, -e]) polyhedron(
       points=[[0,0,0], [w,0,0], [w,e,e], [0,e,e], [0,0,2*e], [w,0,2*e]],
       faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
   ) ;
}



// --------------
// Objects definition

if (generate_part != 2) {
    // Base
    translate([0,0,0]) {
        difference () {
            // Base unit
            roundedCube( [box_length+2*thickness, box_width+2*thickness, bottom_height+thickness], thickness) ;

            // hollowing the box
            translate([thickness,thickness,thickness]) cube ([box_length, box_width, bottom_height+thickness], false);
            translate([thickness/2, thickness/2, bottom_height]) cube ([box_length + thickness, box_width + thickness, 2*thickness]);
            
            
            // Recess for lid
            translate([thickness+(box_length/2), 1.5*thickness + box_width - 0.1, bottom_height + thickness/2]) prism(thickness/4+0.1, 10) ;
            translate([thickness+(box_length/2), 0.5*thickness + 0.1, bottom_height + thickness/2]) rotate([0,0,180]) prism(thickness/4+0.1, 10) ;
            

            // Pin opening
            opening_size = 3;
            translate([-thickness, Pin_y, Pin_z]) cube([3*thickness, pins_width, pins_height], false) ;
            translate([1, Pin_y + pins_width/2, Pin_z - (opening_size + 1)]) rotate([90,0,-90]) linear_extrude(height = 1)
                text(pins_text, size=opening_size, halign="center");
            
           
            // Outside opening for power cord
            translate([Hole_x, -thickness, Hole_z]) {
                rotate([-90, 0,0]) cylinder(r = power_cord_r, h = box_width+4*thickness);
            }
            translate([Hole_x-power_cord_r, -thickness, Hole_z]) cube([2*power_cord_r, box_width+4*thickness, bottom_height-Hole_z+2*thickness ], false) ;

            // Inside shape for power cord 
            translate([Hole_x-power_cord_r-thickness/2, thickness/2, Hole_z]) cube([2*power_cord_r+thickness, box_width+thickness, bottom_height-Hole_z+2*thickness ], false) ;
            //translate([Hole_x, thickness/2, Hole_z]) rotate([-90, 0,0]) cylinder(r = power_cord_r+thickness/2, h = box_width+thickness); //supprime car inutile et provoque une erreur 
        } 
        
        // Support
        bsupp_inner_h = bsupport_h + board_thickness * 2;
        translate([thickness + (box_width-rmount_hole_dist_short)/2, thickness + (box_width-rmount_hole_dist_short)/2]) union () {
            cylinder(r = 2, h = bsupport_h);
            cylinder(r = 1, h = bsupp_inner_h);
            
            translate([0, rmount_hole_dist_short]) cylinder(r = 2, h = bsupport_h);
            translate([0, rmount_hole_dist_short]) cylinder(r = 1, h = bsupp_inner_h);
            
            translate([rmount_hole_dist_long, 0]) cylinder(r = 2, h = bsupport_h);
            translate([rmount_hole_dist_long, 0]) cylinder(r = 1, h = bsupp_inner_h);
            
            translate([rmount_hole_dist_long, rmount_hole_dist_short]) cylinder(r = 2, h = bsupport_h);
            translate([rmount_hole_dist_long, rmount_hole_dist_short]) cylinder(r = 1, h = bsupp_inner_h);
        }

    }
}
//

if (generate_part != 1) {
    // lid
    translate([0, box_width+2*thickness + 10, 0]) {
        difference(){
            union() {
                // Base unit
                roundedCube( [box_length+2*thickness, box_width+2*thickness, top_height+thickness], thickness) ;
                // inside wall
                translate([thickness/2+margin, thickness/2+margin, top_height+thickness]) roundedCube( [box_length+thickness-2*margin, box_width+thickness-2*margin, thickness-margin], thickness/2-margin) ;


                // closing recess
                translate([thickness+(box_length/2), 1.5*thickness + box_width - margin, top_height+ 1.5*thickness]) prism(thickness/4, 10) ;
                translate([thickness+(box_length/2), thickness/2 + margin, top_height+ 1.5*thickness]) rotate([0,0,180]) prism(thickness/4, 10) ;


                // Wall for closing power cord hole
                // extern wall
                translate([Hole_x-power_cord_r+margin, 0, top_height+thickness]) cube([2*(power_cord_r-margin), box_width+2*thickness, bottom_height-Hole_z+thickness ], false) ;
                // inside wall (bigger) 
                translate([Hole_x-power_cord_r-thickness/2+margin, thickness/2+margin, top_height+thickness]) cube([2*(power_cord_r-margin)+thickness, box_width+thickness-2*margin, bottom_height-Hole_z+thickness ], false) ;


            }
            
        // hollowing the lid
            translate([thickness,thickness,thickness]) cube ([box_length, box_width, top_height+bottom_height], false);
            
        // Hole for power Cord
        translate([Hole_x, -thickness, top_height+bottom_height-Hole_z+2*thickness ]) {
            rotate([-90, 0,0]) cylinder(r = power_cord_r, h = box_width+4*thickness);
            }
        } ;
    }
    
    // Top stand-off
    // Top stand-off height
    tops_height = bottom_height + top_height - bsupport_h + thickness*2 - board_thickness;
    translate([thickness + (box_width-rmount_hole_dist_short)/2, box_width+2*thickness + 10 + thickness + (box_width-rmount_hole_dist_short)/2]) union () {
        difference() {
            cylinder(r = 2, h = tops_height);
            translate([0, 0, tops_height - board_thickness * 1.5])
                cylinder(r = 1 + margin, h = board_thickness * 1.5 );
        }
        
        difference() {
            translate([0, rmount_hole_dist_short]) cylinder(r = 2, h = tops_height);
            translate([0, rmount_hole_dist_short, tops_height - board_thickness * 1.5])
                cylinder(r = 1 + margin, h = board_thickness * 1.5 );
        }
        
        difference() {
            translate([rmount_hole_dist_long, 0]) cylinder(r = 2, h = tops_height);
            translate([rmount_hole_dist_long, 0, tops_height - board_thickness * 1.5])
                cylinder(r = 1 + margin, h = board_thickness * 1.5 );
        }
        
        difference() {
            translate([rmount_hole_dist_long, rmount_hole_dist_short]) cylinder(r = 2, h = tops_height);
            translate([rmount_hole_dist_long, rmount_hole_dist_short, tops_height - board_thickness * 1.5])
                cylinder(r = 1 + margin, h = board_thickness * 1.5 );
        }
    }
}