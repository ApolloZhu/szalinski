//Text in the Box
text = "Whatever";

//Second Line
text2 = "LOL";

//Text size
size = 10; //[2:30]

//Box Width
x = 80; //[20:200]

//Box Height
y = 40; //[10:100]

//Box Height
z = 6; //[1:20]

//Border Width
b = 5; //[1:20]

translate([b*2,y*0.75-b,z/2])
linear_extrude(height=z/2)
text(text=text,valign="center",size=size,font="Helvetica");

translate([b*2,y/3,z/2])
linear_extrude(height=z/2)
text(text=text2,valign="center",size=size,font="Helvetica");

difference() {
cube([x,y,z]);
    translate([b,b,z/2])
    cube([x-b*2,y-b*2,3]);
}