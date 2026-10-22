// KNOWN-RIGHT ALTERNATIVE (must pass): a correct part coded independently, the base as an extruded end profile
rotate([90,0,90]) translate([0,0,-101.5]) linear_extrude(203) difference(){ translate([-40,0]) square([80,20]); translate([0,52]) circle(r=46,$fn=180); }
for(i=[0:10]) translate([-100+20*i-1.5,-40,0]) cube([3,80,60]);
