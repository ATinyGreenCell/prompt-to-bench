// KNOWN-RIGHT ALTERNATIVE (must pass): a correct part coded independently, the profile as one polygon
// YZ profile as a polygon, extruded along X
difference(){ rotate([90,0,90]) linear_extrude(84,center=true) polygon([[-30,0],[4,0],[4,46],[16.5,46],[16.5,0],[20.5,0],[20.5,50],[0,50],[0,6],[-30,6]]);
 for(i=[0:7]) translate([-31.5+9*i,-15,-1]) cylinder(d=6.4,h=8,$fn=40); }
