// KNOWN-RIGHT ALTERNATIVE (must pass): a correct part coded independently, built from a corner and moved, seats by rotate_extrude
// built at a corner, then moved; seats via rotate_extrude
translate([-40,-12,0]) difference(){ cube([80,24,20]);
 for(i=[0:7]) translate([8.5+i*9,12,0]) rotate_extrude($fn=48) polygon([[0,2],[1.5,2],[3.2,12],[3.2,21],[0,21]]);
 translate([9.8,12-6-1.65,-0.5]) cube([60.4,3.3,10.7]); translate([9.8,12+6-1.65,-0.5]) cube([60.4,3.3,10.7]); }
