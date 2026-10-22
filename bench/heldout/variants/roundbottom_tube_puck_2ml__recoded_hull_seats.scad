// KNOWN-RIGHT ALTERNATIVE (must pass): a correct part coded independently, each seat as a hull() of a sphere and a cylinder
$fn=64;
difference(){ intersection(){ cylinder(d=80,h=26,$fn=180); translate([-40,-40,0]) cube([74,80,26]); }
 for(k=[0:7]) translate([25*cos(45*k),25*sin(45*k),0]) hull(){ translate([0,0,11.6]) sphere(r=5.6); translate([0,0,27]) cylinder(r=5.6,h=1); } }
