// KNOWN-RIGHT ALTERNATIVE (must pass): a correct part coded independently, from cubes instead of a 2-D profile
// built from cubes in print orientation
difference(){ union(){ cube([5,28.4,105]); translate([-25,0,0]) cube([30,5,105]); translate([-25,23.4,0]) cube([90,5,105]); }
 for(z=[17.5:35:87.5]) translate([42,20,z]) rotate([-90,0,0]) cylinder(d=20,h=12,$fn=72); }
