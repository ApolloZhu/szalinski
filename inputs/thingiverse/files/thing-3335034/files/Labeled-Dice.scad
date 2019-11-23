/* [Global] */

// Total Size
final_scale = 10;
// Number of sides
labels = ["one","two","three","four","five","six"];
// Truncate Radius
max_radius = 1.5;
// Font Size
font_size = 0.8;

/* [Polyhedra Solving] */

// Number of iterations
iterations = 1000;
// Neighborhood Size
neighborhood = 10;
// Power Law
power_law = 2;
// Learning Rate
learning_rate = 10;
// Learning Rate Decay
learning_rate_decay = 0.95;

/* [Advanced] */

// Large unit size
block_size = 100;
// Font Depth
font_depth = 0.1;
// Font Name
font_name = "Arial";
// Force Antipoles
force_antipole = 0;

module die(final_scale = 10, labels, max_radius, font_size, font_name) {


    nonparallel = len(labels) <= 4 || ((len(labels)+1) % 2 == 0);

    function random_points(points) = [ for(i=[0:points]) rands(-1,1,3) ];
    function units(list) = [ for(i = list) i / norm(i) ];
    function sum_sublist(v,e) = e==0 ? v[e] : (v[e] + sum_sublist(v,e-1));
    function sum_list(v) = sum_sublist(v,len(v)-1);
    function force(i,j) = (j - i) * ((norm(j - i)==0 || norm(j - i)>neighborhood)?0:pow(norm(j - i), -power_law));
    function delta(list,i) = sum_list([ for(j = [0:len(list)-1]) force(list[i], list[j]) ]) + ((nonparallel&&(force_antipole==0))?[0,0,0]:sum_list([ for(j = [0:len(list)-1]) force(list[i], -1 * list[j]) ]));
    function iterate(list, rate) = units([ for(i = [0:len(list)-1]) list[i] + rate * delta(list,i) ]);
    function balanced_sphere(n, rate) = (n == 0) ? units(random_points((nonparallel)?(len(labels)-1):(len(labels)/2-1))) : iterate(balanced_sphere(n-1, rate), rate*pow(learning_rate_decay,n));


    module element(pt, label) {
        rotate(acos((pt*[0,0,1])/norm(pt)),cross(pt,[0,0,1]))
        difference() {
            polyhedron( points=[
                [-block_size, block_size, 1],
                [block_size, block_size, 1],
                [block_size, -block_size, 1],
                [-block_size, -block_size, 1],
                [-block_size, block_size, -block_size],
                [block_size, block_size, -block_size],
                [block_size, -block_size, -block_size],
                [-block_size, -block_size, -block_size]
            ], faces=[
                [0, 1, 2, 3],
                [4, 7, 6, 5],
                [0, 4, 5, 1],
                [1, 5, 6, 2],
                [2, 6, 7, 3],
                [3, 7, 4, 0]
            ]);
            
            translate([0,0,1-font_depth])
            linear_extrude(height = 2*font_depth, convexity = 10){
                text(text = label, font = font_name, size = font_size, valign = "center", halign = "center");
            }
        }
        
    }

    module intersect_list(v,e) {
        if(e==0) {
            element(v[e], labels[e]);
        } else {
            intersection() {
                element(v[e], labels[e]);
                intersect_list(v,e-1);
            };
        }
    }

    pts = balanced_sphere(iterations, -learning_rate);
    sphere_points = (nonparallel)?pts:concat(pts, [ for(i = pts) -1 * i ]);
    topside = sphere_points[len(sphere_points)-1];
    scale(final_scale/max_radius)
    translate([0,0,1]) 
    rotate(-acos((topside*[0,0,1])/norm(topside)),cross(topside,[0,0,1]))
    intersection() {
        sphere(r=max_radius, $fa=5, $fs=0.1);
        intersect_list(sphere_points, len(sphere_points)-1);

    }

}


function die_position(n) = 25 * [floor((n-1) / 5), ((n) % 5), 0];

/** Time Dice 

translate(die_position(1)) die(
    final_scale = final_scale, 
    labels = ["Mon","Tue","Wed","Thur","Fri","Sat","Sun"], 
    max_radius = 1.4, 
    font_size = .6,
    font_name = "Comic Sans MS");

translate(die_position(2)) die(
    final_scale = final_scale, 
    labels = ["Mon","Tue","Wed","Thur","Fri"], 
    max_radius = 1.7, 
    font_size = .75,
    font_name = "Comic Sans MS");

translate(die_position(3)) die(
    final_scale = final_scale, 
    labels = ["Jan","Feb","Mar","Apr","May","June","July","Aug","Sept","Oct","Dec"], 
    max_radius = 1.25, 
    font_size = 0.4,
    font_name = "Comic Sans MS");
**/

/** Single Dice 

**/
die(
    final_scale = final_scale, 
    labels = labels, 
    max_radius = max_radius, 
    font_size = font_size,
    font_name = font_name);

