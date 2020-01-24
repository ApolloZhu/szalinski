/*  EasyShelves. Free Shape Generator. Enables users of the Moidules
    modules to create customized pieces to connect with 90° / 60° / 30° angled pieces.
    EasyShelves is Not Moidules.
    Copyright (C) 2015  PMorel for Thilab (www.thilab.fr)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

//Depth of the piece (back)
depth=50; //[15:150]
// Wood Thickness
wood_thickness=5; //[1:30]
// Wall thickness (must be less than wood_thickness)
wall_thickness=3; 
// Length of the front side wrapping the wood
front_side_length=35; //[15:150]
// Do you want to add a foot to the piece ? (works only if the widest angle is <= 180)
add_foot = "no"; //[yes,no]
// Foot height
foot_height = 38; //[15:150]
//Fillet to reinforce the walls (will be reduced automatically to max 10% of wood_thickness)
fillet_size_user = 0.5; //[1,0.5,0.3,0.2,0.15,0.1]

//Screws
number_of_screws = 1; //[0,1,2]
//Screw diameter
screw_diameter = 4; //[1:12]
//Create holes for interior screws
interior_screws = "no"; //[yes,no]
//Create holes for exterior screws
exterior_screws = "no"; //[yes,no]

//Must we draw the first bracket
first_bracket = "yes"; //[yes,no]
//Second bracket angle. If you choose none then the following brackets will be ignored.
angle_2 = 45; //[none,30,45,60,90,120,135,150,180,210,225,240,270,300,315,330]
//Third bracket angle. If you choose none then the following brackets will be ignored.
angle_3 = 90; //[none,30,45,60,90,120,135,150,180,210,225,240,270,300,315,330]
//Fourth bracket angle. If you choose none then the following brackets will be ignored.
angle_4 = 135 ; //[none,30,45,60,90,120,135,150,180,210,225,240,270,300,315,330]
//Fiveth bracket angle. If you choose none then the following brackets will be ignored.
angle_5 = 180; //[none,30,45,60,90,120,135,150,180,210,225,240,270,300,315,330]
//Sixth bracket angle. If you choose none then the following brackets will be ignored.
angle_6 = "none"; //[none,30,45,60,90,120,135,150,180,210,225,240,270,300,315,330]
//Sixth bracket angle. If you choose none then the following brackets will be ignored.
angle_7 = "none"; //[none,30,45,60,90,120,135,150,180,210,225,240,270,300,315,330]
//Sixth bracket angle.
angle_8 = "none"; //[none,30,45,60,90,120,135,150,180,210,225,240,270,300,315,330]

//Force the base angle of the polygon in case it's not well calculated (zero to deactivate this feature)
forced_angle = 0; // [0,30,45,60,90]

// Horizontal pass-through
h_pass_through = true;

// Vertical pass-through
v_pass_through = false;

/* [Hidden] */
// The size of the minimum center cube
hCube = wood_thickness+2*wall_thickness;
// The size of the bottom of the foot
squareFeet=(min(front_side_length,depth))*2/3;

fillet_size = (fillet_size_user > wood_thickness/10) ? wood_thickness/10 : fillet_size_user;

freeShapeGenerator();

/*difference() {
linear_extrude(height=1) projection(cut=true) 
translate([0,0,depth/2-screw_diameter]) rotate ([90,0,0]) freeShapeGenerator();
    drawSymbol(true);
}*/

module drawSymbol(symetric) {
    translate([0,-0.05,-0.1]) linear_extrude(height=2)  asymetricalSymbol();

    mirror([0,1,0]) translate([0,-0.05,-0.1]) linear_extrude(height=2) asymetricalSymbol();
}

module asymetricalSymbol() {
    polygon(points=[[hCube/3,-hCube/3],[-hCube/3,-hCube/3],[0,0]], paths=[[0,1,2]]);
}
/* The main module to generate the module */
/* The code is messy but I didn't find a way to let the user enter the parameters in a nice way. OpenScad (2015.03) and Customizer are still limited for complex parameters. (If you find a better way please let me know */
module freeShapeGenerator() {
    
    /* The lack of value is converted to 360 so that it's ignored by the min function */
    real_angle_2 = (angle_2 == "none") ? 360 : angle_2;
    real_angle_3 = (angle_3 == "none") ? 360 : (real_angle_2==360) ? 360 : angle_3;
    real_angle_4 = (angle_4 == "none") ? 360 : (real_angle_3==360) ? 360 :angle_4;
    real_angle_5 = (angle_5 == "none") ? 360 : (real_angle_4==360) ? 360 :angle_5;
    real_angle_6 = (angle_6 == "none") ? 360 : (real_angle_5==360) ? 360 :angle_6;
    real_angle_7 = (angle_7 == "none") ? 360 : (real_angle_6==360) ? 360 :angle_7;
    real_angle_8 = (angle_8 == "none") ? 360 : (real_angle_7==360) ? 360 :angle_8;
    
    /*Difference between the consecutive angles */
    diff_angle_3_2 = real_angle_3 - real_angle_2;
    diff_angle_4_3 = real_angle_4 - real_angle_3;
    diff_angle_5_4 = real_angle_5 - real_angle_4;
    diff_angle_6_5 = real_angle_6 - real_angle_5;
    diff_angle_7_6 = real_angle_7 - real_angle_6;
    diff_angle_8_7 = real_angle_8 - real_angle_7;
    
    /*Angle of the triangles in the regular polygon that must be created in the center of the piece */
    angle_candidate = forced_angle != 0 ? forced_angle : min(real_angle_2,
            real_angle_3!=360?diff_angle_3_2:360,
            real_angle_4!=360?diff_angle_4_3:360,
            real_angle_5!=360?diff_angle_5_4:360,
            real_angle_6!=360?diff_angle_6_5:360,
            real_angle_7!=360?diff_angle_7_6:360,
            real_angle_8!=360?diff_angle_8_7:360) % 90 ;
    max_angle= max(real_angle_2,
            real_angle_3!=360?real_angle_3:0,
            real_angle_4!=360?real_angle_4:0,
            real_angle_5!=360?real_angle_5:0,
            real_angle_6!=360?real_angle_6:0,
            real_angle_7!=360?real_angle_7:0,
            real_angle_8!=360?real_angle_8:0) ; 
    polygon_angle = (angle_candidate == 0) ? 90 : angle_candidate;
    
    /* size of the regular polygon side */
    polygon_side = hCube;
    
    /* Number of sides of the regular polygon */
    nSides = 360/polygon_angle;
    
    /* How much the brackets must be shifted from the center (apothem) */
    shift=max(hCube/2, polygon_side/(2*tan(polygon_angle/2)));
    
    /* Radius of the circumscribed circle of the regular polygon */
    polygon_radius = polygon_side/(2*sin(polygon_angle/2));
    
    difference() {
        union() {
            // FabLab logo
            if( !v_pass_through && !h_pass_through)
                logo();

            // The first bracket can be erased by the user
            if( first_bracket == "yes" ) {
                    bracket(interior_screws,interior_screws,hCube/2-0.1);
            }
            if( real_angle_2 != 360 ) {
                bracketwithShift(real_angle_2, polygon_angle, polygon_side);
            }
            if( real_angle_3 != 360 ) {
                bracketwithShift(real_angle_3, polygon_angle, polygon_side);
            }
            if( real_angle_4!= 360 ) {
                bracketwithShift(real_angle_4, polygon_angle, polygon_side);
            }
            if( real_angle_5 != 360 ) {
                bracketwithShift(real_angle_5, polygon_angle, polygon_side);
            }
            if( real_angle_6 != 360 ) {
                bracketwithShift(real_angle_6, polygon_angle, polygon_side);
            }
            if( real_angle_7 != 360 ) {
                bracketwithShift(real_angle_7, polygon_angle, polygon_side);
            }
            if( real_angle_8 != 360 ) {
                bracketwithShift(real_angle_8, polygon_angle, polygon_side);
            }
            /* The center of the piece*/
            hull() {
                center(); // The minimal center cube
                if( first_bracket == "yes" ) {
                        triangle(hCube/2, polygon_angle);
                }
                if( real_angle_2 != 360 ) {
                    triangleWithShift(real_angle_2, polygon_angle, polygon_side);
                }
                if( real_angle_3 != 360 ) {
                    triangleWithShift(real_angle_3, polygon_angle, polygon_side);
                }
                if( real_angle_4!= 360 ) {
                    triangleWithShift(real_angle_4, polygon_angle, polygon_side);
                }
                if( real_angle_5 != 360 ) {
                    triangleWithShift(real_angle_5, polygon_angle, polygon_side);
                }
                if( real_angle_6 != 360 ) {
                    triangleWithShift(real_angle_6, polygon_angle, polygon_side);
                }
                if( real_angle_7 != 360 ) {
                    triangleWithShift(real_angle_7, polygon_angle, polygon_side);
                }
                if( real_angle_8 != 360 ) {
                    triangleWithShift(real_angle_8, polygon_angle, polygon_side);
                }
            }
            //Adding the fillets (90° only)
            if(angle_2 == 90 && first_bracket == "yes") {
                fillet_width=15;
                filletBL(fillet_width,-fillet_width/2-hCube/2-wall_thickness*sqrt(2),0,-fillet_width/2-hCube/2-wall_thickness*sqrt(2),depth);
            }
            if(diff_angle_3_2 == 90) {
                fillet_width=15;
                rotate([0,angle_2,0]) filletBL(fillet_width,-fillet_width/2-hCube/2-wall_thickness*sqrt(2),0,-fillet_width/2-hCube/2-wall_thickness*sqrt(2),depth);
            }
            if(diff_angle_4_3 == 90) {
                fillet_width=15;
                rotate([0,angle_3,0]) filletBL(fillet_width,-fillet_width/2-hCube/2-wall_thickness*sqrt(2),0,-fillet_width/2-hCube/2-wall_thickness*sqrt(2),depth);
            }
            if(diff_angle_5_4 == 90) {
                fillet_width=15;
                rotate([0,angle_4,0]) filletBL(fillet_width,-fillet_width/2-hCube/2-wall_thickness*sqrt(2),0,-fillet_width/2-hCube/2-wall_thickness*sqrt(2),depth);
            }
            if(diff_angle_6_5 == 90) {
                fillet_width=15;
                rotate([0,angle_5,0]) filletBL(fillet_width,-fillet_width/2-hCube/2-wall_thickness*sqrt(2),0,-fillet_width/2-hCube/2-wall_thickness*sqrt(2),depth);
            }
            if(diff_angle_7_6 == 90) {
                fillet_width=15;
                rotate([0,angle_6,0]) filletBL(fillet_width,-fillet_width/2-hCube/2-wall_thickness*sqrt(2),0,-fillet_width/2-hCube/2-wall_thickness*sqrt(2),depth);
            }
            if(diff_angle_8_7 == 90) {
                fillet_width=15;
                rotate([0,angle_7,0]) filletBL(fillet_width,-fillet_width/2-hCube/2-wall_thickness*sqrt(2),0,-fillet_width/2-hCube/2-wall_thickness*sqrt(2),depth);
            }
            if(add_foot=="yes") {
                translate([0,-depth,hCube/2]) foot(foot_height);
            }
            if(add_foot=="yes" && max_angle ==180) {
                mirror([1,0,0]) translate([0,-depth,hCube/2])  foot(foot_height);
            }
        }
        /* Substract the boards footprint */
        union() {
            if( first_bracket == "yes" ) {
                translate([hCube/2,-depth,-hCube/2]) 
                    boardH(hCube/2);
            }
            if( real_angle_2 != 360 ) {
                boardHWithShift(real_angle_2, polygon_angle, polygon_side);
            }
            if( real_angle_3 != 360 ) {
               boardHWithShift(real_angle_3, polygon_angle, polygon_side);
            }
            if( real_angle_4 != 360 ) {
               boardHWithShift(real_angle_4, polygon_angle, polygon_side);
            }    
            if( real_angle_5 != 360 ) {
               boardHWithShift(real_angle_5, polygon_angle, polygon_side);
            }    
            if( real_angle_6 != 360 ) {
               boardHWithShift(real_angle_6, polygon_angle, polygon_side);
            }    
            if( real_angle_7 != 360 ) {
               boardHWithShift(real_angle_7, polygon_angle, polygon_side);
            }    
            if( real_angle_8 != 360 ) {
               boardHWithShift(real_angle_8, polygon_angle, polygon_side);
            }
            if( h_pass_through == true ) {
                passthrough_board(0, shift);
            }
            if( v_pass_through == true ) {
                passthrough_board(90, shift);
            }
        }
    }
}

module passthrough_board( theAngle, shift ) {
    sphere_radius = fillet_size*wall_thickness;
    board_cube_thickness = wood_thickness-sphere_radius*2;
    
    
    rotate([0, theAngle, 0])
        translate([0,-depth/2+wall_thickness+sphere_radius,0])
            minkowski() {
                sphere($fn=32, r=sphere_radius);
                cube([hCube+4*sphere_radius,depth,hCube-wall_thickness*2-2*sphere_radius], center=true);
            }
}


function calcShift(theAngle, polygon_angle, polygon_side) = (theAngle==90 ||theAngle==180 || theAngle==270) ? hCube/2 : polygon_side/(2*tan(polygon_angle/2));


module bracketwithShift(theAngle, polygon_angle, polygon_side) {
    rotate([0,theAngle]) {
        bracket(interior_screws,interior_screws,calcShift(theAngle, polygon_angle, polygon_side)-0.1);
    }
}

module triangleWithShift(theAngle, polygon_angle, polygon_side) {
    rotate([0,theAngle]) {
        triangle(calcShift(theAngle, polygon_angle, polygon_side), polygon_angle);
    }
}

module boardHWithShift(theAngle, polygon_angle, polygon_side) {
    theShift=calcShift(theAngle, polygon_angle, polygon_side);
    rotate([0,theAngle]) {
        translate([theShift,-depth,-hCube/2]) 
            boardH(theShift);
    }
}
/* Draw the the triangle shape formed by the center of the piece 
    and the extermities of a polygon side */
module triangle(shift, angle) {
    rotate([90,0,0]) linear_extrude(height=depth) polygon(points=[[0,0],[shift,hCube/2],[shift,-hCube/2]],paths=[[0,1,2]]);

}

/* Minimal center cube */
module center() {
    rotate([90,0,0]) linear_extrude(height=depth) polygon(points=[[hCube/2,hCube/2],[hCube/2,-hCube/2],[-hCube/2,hCube/2],[-hCube/2,-hCube/2]],paths=[[0,1,3,2]]);

}

// DRaw the logo at the good place
module logo() {
    translate([0,2,0]) 
        rotate([90,0,0]) 
            resize(newsize=[hCube-4,hCube-4,3]) 
                simpleFablabLogo(2);
}

// Draw the base bracket shape
module bracket( left_screws, right_screws, shift) {
    translate([shift,-depth,-hCube/2]) 
        rotate([90,0,90]) {
            difference() {
                cube([depth,hCube,front_side_length]);
                
                //Draw the left screws
                if( left_screws == "yes" ) {
                    width = wall_thickness;
                    height = front_side_length;
                    if( number_of_screws == 1 ) { 
                      translate([depth/2,width+1,height/2]) rotate([90,0,0]) cylinder($fn=24, r=screw_diameter/2, h=width+2);                
                    } else if(number_of_screws == 2) {
                      translate([depth/3,width+1,height/2]) rotate([90,0,0]) cylinder($fn=24, r=screw_diameter/2, h=width+2);                
                      translate([depth*2/3,width+1,height/2]) rotate([90,0,0]) cylinder($fn=24, r=screw_diameter/2, h=width+2);             
                    }
                }
                //Draw the right screws
                if( right_screws == "yes" ) {
                    width = wall_thickness;
                    screw_shift = wall_thickness*2 + wood_thickness + 1;
                    height = front_side_length;
                    if( number_of_screws == 1 ) { 
                      translate([depth/2,screw_shift,height/2]) rotate([90,0,0]) cylinder($fn=24, r=screw_diameter/2, h=width+2);                
                    } else if(number_of_screws == 2) {
                      translate([depth/3,screw_shift,height/2]) rotate([90,0,0]) cylinder($fn=24, r=screw_diameter/2, h=width+2);                
                      translate([depth*2/3,screw_shift,height/2]) rotate([90,0,0]) cylinder($fn=24, r=screw_diameter/2, h=width+2);             
                    }
                }
           }
       }
}

module boardH( shift ) {
    sphere_radius = (fillet_size*wall_thickness)*2 >= wood_thickness ? fillet_size*(wood_thickness - 0.1) : fillet_size*wall_thickness;
    board_cube_thickness = wood_thickness-sphere_radius*2;
    echo("board_cube_thickness : ",board_cube_thickness," sphere_radius",sphere_radius);
    rotate([90,0,90]) 
        translate([wall_thickness+sphere_radius,hCube/2-board_cube_thickness/2,wall_thickness/2]) 
            minkowski() {
                sphere($fn=32, r=sphere_radius);
                cube([depth-wall_thickness,board_cube_thickness, front_side_length +shift-hCube/2]);
            }
}

//Add a foot to the piece
module foot( foot_length ) {
    linear_extrude(height=foot_height, scale=[2/3,2/3])
        square([foot_length, depth]);
}


//Add a fillet in the bottom left corner
module filletBL(width, cornerX, cornerY, cornerZ, depth){
        rotate([0,-90,0])
            fillet(width, cornerX, cornerY, cornerZ, depth);
}

// Creates of fillet using the difference between a cube and a cylinder
// Used only for squared angles
module fillet(width, cornerX, cornerY, cornerZ, depth) {
    translate([cornerX,cornerY,cornerZ])
        rotate([90,0,0])
            difference() {
                cube([width,width,depth], false);
                translate([0,0,-1]) cylinder(h=depth+2, r=width);
            }

}

// Draw the FabLab logo
module simpleFablabLogo() {
    linear_extrude(height=3) 
        poly_path40();
}


// Generated using the wonderfull Path2OpenScad inkscape Extension 
// available on Thingiverse : http://www.thingiverse.com/thing:25036
module poly_path40() {
    union() {
     polygon([[-113.086164,-71.074377],[-77.778164,-91.457377],[-55.149164,-78.352377],[-55.987067,-74.691892],[-56.266599,-71.113142],[-56.027801,-67.631488],[-55.310714,-64.262291],[-54.155378,-61.020910],[-52.601835,-57.922707],[-50.690126,-54.983043],[-48.460292,-52.217277],[-45.952373,-49.640770],[-43.206411,-47.268883],[-37.160521,-43.200410],[-30.642950,-40.134743],[-23.974024,-38.194767],[-19.180403,-37.010129],[-14.253674,-36.125681],[-9.231322,-35.550910],[-4.150829,-35.295307],[0.950319,-35.368361],[6.034639,-35.779562],[11.064647,-36.538397],[16.002860,-37.654358],[20.811793,-39.136933],[25.453962,-40.995611],[29.891885,-43.239882],[34.088077,-45.879236],[38.005053,-48.923160],[41.605331,-52.381146],[44.851427,-56.262682],[47.705856,-60.577258],[48.949931,-64.379804],[49.568270,-68.124306],[49.604901,-71.791152],[49.103855,-75.360732],[48.109162,-78.813436],[46.664853,-82.129654],[44.814958,-85.289775],[42.603507,-88.274188],[40.074531,-91.063283],[37.272059,-93.637450],[34.240122,-95.977078],[31.022751,-98.062557],[27.663976,-99.874276],[24.207826,-101.392625],[20.698333,-102.597993],[17.179526,-103.470771],[14.443417,-104.468102],[11.657642,-105.169567],[5.971229,-105.851131],[0.188554,-105.847934],[-5.622114,-105.492451],[-11.392510,-105.117153],[-17.054365,-105.054513],[-22.539412,-105.637005],[-25.194299,-106.274073],[-27.779384,-107.197102],[-29.046027,-108.168695],[-30.880170,-109.138350],[-35.054110,-111.075933],[-36.795485,-112.045905],[-37.907513,-113.018027],[-38.090983,-113.993321],[-37.046684,-114.972810],[0.069836,-136.395377],[113.272836,-71.043377],[116.982574,-72.420481],[119.740675,-74.075423],[121.630183,-75.971814],[122.734146,-78.073267],[123.135609,-80.343396],[122.917619,-82.745812],[122.163222,-85.244128],[120.955463,-87.801958],[117.512047,-92.950608],[113.251739,-97.900663],[104.937926,-106.040597],[96.028509,-114.229549],[86.464963,-121.591986],[76.323575,-128.113172],[65.680633,-133.778371],[54.612425,-138.572847],[43.195238,-142.481864],[31.505360,-145.490686],[19.619080,-147.584578],[7.612683,-148.748802],[-4.437541,-148.968623],[-16.455305,-148.229306],[-28.364321,-146.516114],[-40.088302,-143.814312],[-51.550960,-140.109163],[-62.676006,-135.385931],[-73.387154,-129.629881],[-81.297202,-124.785764],[-88.896270,-119.464296],[-96.155932,-113.687320],[-103.047759,-107.476681],[-109.543324,-100.854222],[-115.614198,-93.841789],[-121.231954,-86.461226],[-126.368164,-78.734377],[-113.086164,-71.074377]]);

      polygon([[131.502836,-70.082377],[127.040325,-68.617531],[123.637388,-66.369704],[121.167239,-63.472839],[119.503093,-60.060878],[118.518165,-56.267766],[118.085670,-52.227446],[118.078821,-48.073862],[118.370836,-43.940957],[118.370836,-21.035377],[93.706836,-7.043377],[91.085580,-9.626731],[88.246957,-11.704382],[85.223954,-13.301695],[82.049555,-14.444036],[78.756750,-15.156770],[75.378522,-15.465263],[71.947861,-15.394880],[68.497751,-14.970988],[65.061179,-14.218951],[61.671133,-13.164136],[55.162561,-10.247634],[49.235928,-6.424406],[44.155126,-1.897377],[40.602084,1.677464],[37.238908,5.527907],[34.094603,9.625758],[31.198174,13.942818],[28.578628,18.450893],[26.264970,23.121787],[24.286204,27.927303],[22.671337,32.839246],[21.449374,37.829419],[20.649321,42.869626],[20.300182,47.931672],[20.430964,52.987360],[21.070672,58.008494],[22.248311,62.966878],[23.992887,67.834317],[26.333406,72.582613],[28.986527,75.559562],[31.903296,77.969790],[35.044803,79.841238],[38.372139,81.201843],[41.846394,82.079546],[45.428658,82.502285],[49.080023,82.497998],[52.761578,82.094626],[56.434415,81.320106],[60.059625,80.202379],[63.598296,78.769382],[67.011521,77.049055],[70.260390,75.069336],[73.305994,72.858166],[76.109422,70.443482],[78.631766,67.853223],[80.852555,66.009319],[82.846332,63.975338],[86.277790,59.449597],[89.176012,54.500914],[91.790873,49.354201],[94.372248,44.234371],[97.170011,39.366336],[100.434035,34.975010],[102.318981,33.028397],[104.414196,31.285303],[118.370836,23.202623],[118.370836,68.518623],[5.135836,133.893623],[4.463149,137.952345],[4.536198,141.252177],[5.279106,143.856796],[6.615996,145.829877],[8.470992,147.235096],[10.768218,148.136128],[13.431797,148.596648],[16.385853,148.680332],[22.861891,147.971896],[29.589320,146.520223],[41.370306,143.424783],[52.552846,139.725206],[63.364496,135.112591],[73.757523,129.639959],[83.684193,123.360329],[93.096771,116.326721],[101.947524,108.592155],[110.188717,100.209649],[117.772617,91.232225],[124.651489,81.712900],[130.777600,71.704696],[136.103215,61.260631],[140.580601,50.433725],[144.162022,39.276998],[146.799747,27.843468],[148.446039,16.186157],[149.053166,4.358083],[149.005525,-5.307850],[148.338669,-14.953871],[147.055612,-24.538381],[145.159368,-34.019783],[142.652954,-43.356481],[139.539384,-52.506877],[135.821673,-61.429374],[131.502836,-70.082377]]);

      polygon([[-4.813164,133.999623],[-35.567164,116.245623],[-35.567164,81.300623],[-32.246234,79.514175],[-29.318122,77.378805],[-26.768999,74.930080],[-24.585039,72.203566],[-22.752414,69.234830],[-21.257297,66.059437],[-20.085860,62.712953],[-19.224275,59.230946],[-18.375357,52.002624],[-18.599921,44.658999],[-19.787350,37.484603],[-21.827024,30.763963],[-25.320512,21.997926],[-29.923380,13.520007],[-32.617694,9.478984],[-35.561587,5.617860],[-38.745804,1.972591],[-42.161090,-1.420865],[-45.798191,-4.526553],[-49.647851,-7.308516],[-53.700814,-9.730797],[-57.947825,-11.757441],[-62.379630,-13.352490],[-66.986974,-14.479988],[-71.760600,-15.103979],[-76.691254,-15.188507],[-80.342567,-14.339378],[-83.671600,-13.019465],[-86.681329,-11.272506],[-89.374732,-9.142235],[-91.754787,-6.672388],[-93.824471,-3.906704],[-95.586763,-0.888916],[-97.044639,2.337237],[-98.201078,5.728021],[-99.059057,9.239698],[-99.891544,16.450790],[-99.565923,23.620621],[-98.976266,27.080724],[-98.106014,30.399303],[-97.687723,33.308400],[-96.959849,36.117645],[-94.776823,41.499306],[-91.959875,46.669740],[-88.911943,51.754398],[-86.035967,56.878734],[-83.734886,62.168198],[-82.925849,64.914058],[-82.411639,67.748244],[-82.242621,70.686439],[-82.469164,73.744323],[-82.469164,89.175623],[-118.251164,68.518623],[-118.251164,-62.563377],[-121.419425,-65.176544],[-124.309507,-66.766069],[-126.937789,-67.429248],[-129.320651,-67.263378],[-131.474472,-66.365759],[-133.415633,-64.833687],[-135.160512,-62.764461],[-136.725489,-60.255377],[-139.381255,-54.306829],[-141.513968,-47.766425],[-144.734374,-36.023577],[-147.128118,-24.596624],[-148.560538,-13.035806],[-149.053166,-1.407144],[-148.627537,10.223338],[-147.305184,21.789620],[-145.107642,33.225677],[-142.056444,44.465488],[-138.173124,55.443031],[-133.479216,66.092283],[-127.996253,76.347222],[-121.745770,86.141826],[-114.749299,95.410072],[-107.028376,104.085938],[-98.604533,112.103402],[-89.499304,119.396441],[-79.734224,125.899033],[-71.185970,130.918472],[-62.323670,135.367666],[-53.187651,139.226633],[-43.818237,142.475388],[-34.255755,145.093949],[-24.540532,147.062331],[-14.712893,148.360550],[-4.813164,148.968623],[-4.813164,133.999623]]);
    }  
}