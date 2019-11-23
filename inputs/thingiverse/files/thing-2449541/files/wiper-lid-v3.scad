$diameter=58;
$thickness=3;
$lip=3;
$height=11;
$fine=100;

rotate([180,0,0])
{
    union()
    {
        //Cap
        difference()
        {
            union()
            {
                    //Wings
                translate([-($diameter*1.25)/2,(-$diameter*0.5)/2,$height-$thickness-1])
                {
                    minkowski()
                    {
                        cylinder(r=$lip,$fn=$fine);
                        cube([$diameter*1.25,$diameter*0.5,$thickness]);
                    }
                }

                cylinder(h=$height,d=$diameter+($thickness*2),$fn=$fine);
            }

            translate([0,0,-$thickness])
            {
                cylinder(h=$height,d=$diameter,$fn=$fine);
            }
            //Text
            translate([0,0,$height-1])
            {
                linear_extrude(height=2)
                {
                    text(text="Wiper Fluid",size=9, halign="center", valign="center");
                }
            }
        }
        
        //Lip
        translate([0,0,$height/10])
        {
            rotate_extrude($fn=$fine)
                translate([($diameter-($lip/2)+$thickness)/2, 0,])
                    circle(r1=$lip,$fn=$fine/2);
        }

            
    }
}