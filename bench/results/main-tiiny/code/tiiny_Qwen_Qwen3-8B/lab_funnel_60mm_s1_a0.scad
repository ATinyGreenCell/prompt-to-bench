// Lab Funnel Design Parameters
spout_outer_diameter = 10;  // mm
spout_height = 20;          // mm
cone_base_diameter = 10;    // mm at z = 20
cone_rim_diameter = 60;     // mm at z = 50
cone_height = 30;           // mm from base to rim
wall_thickness = 1.6;       // mm
bore_diameter = spout_outer_diameter - 2 * wall_thickness; // 6.8 mm

// Spout section: cylinder with wall thickness
$fn = 64;

// Spout body (outer cylinder)
spout_outer = cylinder(r=spout_outer_diameter/2, h=spout_height, $fn=64);

// Spout bore (inner cylinder)
spout_inner = cylinder(r=bore_diameter/2, h=spout_height, $fn=64);

// Cone section: frustum with wall thickness
// Outer cone
cone_outer = cylinder(r1=cone_base_diameter/2, r2=cone_rim_diameter/2, h=cone_height, $fn=64);

// Inner cone (bore)
cone_inner = cylinder(r1=bore_diameter/2, r2=(cone_rim_diameter - 2 * wall_thickness)/2, h=cone_height, $fn=64);

// Combine spout and cone
funnel = union() {
    spout_outer;
    translate([0, 0, spout_height]) cone_outer;
}

// Cut inner bore from the funnel
funnel_with_bore = difference() {
    funnel;
    translate([0, 0, spout_height]) cone_inner;
}

// Final funnel with wall thickness
result = funnel_with_bore;

// Render the funnel
result;