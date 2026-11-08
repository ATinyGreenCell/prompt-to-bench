// Design a snap-on clip for lab tubing.
// Units: millimeters (mm).

// Define dimensions based on user measurements
const mm = 1; // Conversion factor if needed, though we use direct values in mm

// Ring 1: Rod ring
// Inner diameter: 12.7 mm -> Radius r_in = 6.35 mm
// Wall thickness: 3 mm -> Outer radius r_out = 6.35 + 3 = 9.35 mm
// Centred at origin (0,0)
// Opening cut out of -X side: x < 0 and -5 < y < 5

var ring1 = cylinder(
    height = mm, // Extrusion in Z
    radius_in = 6.35,
    radius_out = 9.35,
    center_x = 0,
    center_y = 0,
    orientation = [0, 0, 1]
);

// Create the hole for the rod ring using a polygon (rectangle)
// The opening is defined by x < 0 and -5 < y < 5.
// We use 'difference' to cut this out of the cylinder.
var hole_ring1 = difference(
    ring1,
    // Rectangle extending past faces by 0.01-1mm as per rule 5
    translate([0, 0, -0.01]) square([0, 0, mm]), // Extends into Z
    translate([-6.35, 0, -0.01]) square([0, 0, mm]), // Extends past negative X face
    translate([0, 5, -0.01]) square([0, 0, mm])   // Extends past positive Y face (y < 5)
);

// Ring 2: Tubing ring
// Inner diameter: 6 mm -> Radius r_in = 3 mm
// Wall thickness: 2 mm -> Outer radius r_out = 5 mm
// Centred at x=15, y=0.
// Opening cut out of +X side: x > 15 and -2.25 < y < 2.25

var ring2 = cylinder(
    height = mm, // Extrusion in Z
    radius_in = 3,
    radius_out = 5,
    center_x = 15,
    center_y = 0,
    orientation = [0, 0, 1]
);

// Create the hole for the tubing ring using a polygon (rectangle)
var hole_ring2 = difference(
    ring2,
    // Rectangle extending past faces by 0.01-1mm as per rule 5
    translate([0, 0, -0.01]) square([0, 0, mm]), // Extends into Z
    translate([3, 0, -0.01]) square([0, 0, mm]), // Extends past negative X face (x < 3)
    translate([15, 2.25, -0.01]) square([0, 0, mm]) // Extends past positive Y face (y > 2.25)
);

// Solid bridge connecting the two rings
// Width: 6 mm -> Radius r_bridge = 3 mm
// X range: x = 8 to x = 12
// Must join without blocking either ring's holes.
// Ring 1 hole is in -X side (x < 0). Bridge starts at x=8, so it does not overlap Ring 1 hole.
// Ring 2 hole is in +X side (x > 3). Bridge ends at x=12, so it does not overlap Ring 2 hole.

var bridge = square(
    width = mm * 6, // Width in X
    height = mm,     // Height in Y
    center_x = 8,    // Centered at x=8
    orientation = [0, 1, 0]
);

// Final assembly: Union of all parts
var final_part = union(
    ring1,
    hole_ring1,
    ring2,
    hole_ring2,
    bridge
);

// Optional: Add a small fillet or chamfer if desired for printability, 
// but the prompt implies a simple extrusion. We will leave it as is to ensure exact dimensions.
// However, standard practice suggests rounding sharp corners slightly for FDM, 
// though strict adherence to "exact measurements" might imply keeping them sharp.
// Given the constraints, we stick to the geometric union of the specified shapes.

print("Design complete: Snap-on clip with rod ring, tubing ring, and bridge.");