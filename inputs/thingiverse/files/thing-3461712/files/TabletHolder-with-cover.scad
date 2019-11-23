difference(){
    union(){
        $fn=50;
        minkowski()
        {
        //cube([220,140,25],center=true);    
            cube([200,115,20],center=true);    
            cylinder(r=5,h=1);
        }
        
        }
    
    union(){
        translate([0,19,0]){
           cube([192,150,11.5],center=true);
        }
        translate([0,0,10]){
            cube([170,90,70],center=true);
        }
        translate([100,15,0])
        {
            cube([50,40,10],center=true);
        }
        translate([100,-35,0])
        {
            cube([50,30,10],center=true);
        }
        translate([100,62,-8])
        {
            $fn=100;
            sphere(r=1.5,center=true);
        }
        translate([-100,62,-8])
        {
            $fn=100;
            sphere(r=1.5,center=true);
        }
        translate([100,-62,-8])
        {
            $fn=100;
            sphere(r=1.5,center=true);
        }
        translate([-100,-62,-8])
        {
            $fn=100;
            sphere(r=1.5,center=true);
        }
        translate([0,-55,0])
        {
            $fn=100;
            rotate([90,0,0])
            cylinder(r=8,h=30,center=true);
        }
        /*translate([97,-55,0])
        {
            cube([20,20,20],center=true);
        }*/
        
    }
    //cube([200,120,15],center=true);
    }

    translate([-40,-60,-10.5])
        {
            rotate([0,180,0])
            {
                linear_extrude(height = 2, center = true, convexity = 10, twist = 0)   
                text("JAKOB");
            }
        }//*/
    
difference(){
    union(){
    translate([83, 0,9.5])
        {
           cube([30,100,3],center=true);
        }
    translate([-83,0,9.5])
        {
            cube([30,100,3],center=true);
        }
    translate([0,44,9.5])
        {
            cube([150,30,3],center=true);
        }
    translate([0,-44,9.5])
        {
            cube([150,30,3],center=true);
        }
    
    }
    union(){
    translate([83, 0, 8.5])
        {
           cube([20,30,10],center=true);
        }
    translate([-83, 0, 8.5])
        {
           cube([20,30,10],center=true);
        }
    translate([0,44,10])
        {
            cube([30,20,12],center=true);
        }
    translate([0,-44,10])
        {
            cube([30,20,12],center=true);
        }
    }
}

//sun shielding cover with headphones hook
module cover ()
{
    minkowski()
        {
            //half cover
            translate([50,0,-15]){
            cube([105,120,2],center=true);
            /*full cover
            translate([0,0,-15]){  
                cube([203,120,2],center=true);//*/
            }
            $fn=100;
            cylinder(r=5,h=1);
        }
    
    translate([100,-64,-10])
    {
        cube([10,2,11],center=true);
    }
    translate([100,64,-10])
    {
        cube([10,2,11],center=true);
    }
    
    translate([100,62.5,-8])
        {
            $fn=100;
            sphere(r=1.5,center=true);
        }
    translate([100,-62.5,-8])
        {
            $fn=100;
            sphere(r=1.5,center=true);
        }
    translate([0,-64,-10])
        {
        cube([5,2,10],center=true);
        
        }
    translate([0,-64,-3])
        {
          rotate([0,90,0])
            {
                $fn=100;
               cylinder(r=2.5,h=5,center=true);
            }  
        }
    translate([0,64,-10])
        {
        cube([5,2,10],center=true);
        
        }
    translate([0,64,-3])
        {
          rotate([0,90,0])
            {
                $fn=100;
               cylinder(r=2.5,h=5,center=true);
            }  
        }
     translate([0,0,-19])
        {
            cube([10,10,10], center=true);
        }
     translate([0,0,-24])
        {
            cube([10,70,3], center=true);
        }
}


cover();


//Tablet
/*
color([0,1,0])
cube([190,113,10],center=true);
color([0,0,1])
cube([153,85,20],center=true);*/