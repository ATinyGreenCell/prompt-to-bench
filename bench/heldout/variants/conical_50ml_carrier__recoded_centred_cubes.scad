// KNOWN-RIGHT ALTERNATIVE (must pass): a correct part coded independently, with centred cubes
$fn=64;
difference(){ union(){ translate([-45,-45,0]) cube([90,90,35]); for(x=[-40,40]) translate([x,0,97.5]) cube([10,16,125],center=true); }
 for(x=[-21,21],y=[-24,24]) translate([x,y,5]) cylinder(d=30.5,h=31);
 translate([0,0,150]) cube([100,10.4,10.4],center=true); }
translate([0,60,5]) cube([100,10,10],center=true);
