// KNOWN-RIGHT ALTERNATIVE (must pass): a correct part coded independently, as a union of extruded hexagons and cylinders
$fn=96; pos=concat([[0,0]],[for(k=[0:5])[27*cos(60*k),27*sin(60*k)]]); module hexagon(af) circle(d=af/cos(30), $fn=6);
difference(){ union(){ linear_extrude(3) hexagon(90); linear_extrude(20) difference(){hexagon(84);hexagon(80);}
 for(p=pos) translate([p.x,p.y,0]) cylinder(d=21.5,h=20); } for(p=pos) translate([p.x,p.y,-1]) cylinder(d=17.5,h=22); }
