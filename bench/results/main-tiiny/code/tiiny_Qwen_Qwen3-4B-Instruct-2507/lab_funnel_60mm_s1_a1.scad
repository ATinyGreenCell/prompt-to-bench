// Lab funnel design with straight spout and conical top
// Units: millimeters
// Print orientation: upright, wide opening at top, rests on z=0
// Wall thickness: 1.6 mm throughout
// Spout: 10 mm outer diameter from z=0 to z=20
// Cone: widens from 10 mm at z=20 to 60 mm at z=50
// Open at both ends (bottom and top)

$fn = 64;  // High resolution for smooth curves

// Dimensions
spout_length = 20;
cone_height = 30;  // from z=20 to z=50
spout_od = 10.0;
spout_id = spout_od - 2 * 1.6;  // inner diameter of spout (bore)
cone_start_od = 10.0;
cone_end_od = 60.0;
wall_thickness = 1.6;

// Spout: cylinder from z=0 to z=20 with 1.6 mm wall
spout = difference() {
    // Outer cylinder of spout
    translate([0, 0, 0])
        cylinder(h=spout_length, r=spout_od/2, f=1);
    
    // Inner cylinder (bore) to remove the inner part
    translate([0, 0, 0])
        cylinder(h=spout_length, r=spout_id/2, f=1);
};

// Cone: from z=20 to z=50, outer diameter increases from 10 to 60 mm
// We create a cone with taper by extruding a polygon
cone = difference() {
    // Outer cone: from z=20 to z=50
    // Use a rotated extrusion to create a cone with linear taper
    rotate([90, 0, 0])  // rotate to align with z-axis
        linear_extrude(height=cone_height, center=true, convexity=0)
            polygon([
                [0, 0],
                [cone_start_od/2, 0],
                [cone_end_od/2, 0],
                [cone_end_od/2, cone_height],
                [0, cone_height]
            ]);
    
    // Inner bore of the cone: same inner diameter as spout (6.8 mm)
    // This is a cylinder from z=20 to z=50 with inner diameter 6.8 mm
    translate([0, 0, 20])
        cylinder(h=cone_height, r=spout_id/2, f=1);
};

// Final funnel: union of spout and cone
funnel = union() {
    spout;
    cone;
};

// Final model: centered at origin, built from z=0 to z=50
// The funnel is open at both ends by design
// The part is printed upright with wide opening at the top

// Render the funnel
translate([0, 0, 0])
    funnel;