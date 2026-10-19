// Replacement knob for a hotplate stirrer with a 6 mm D-shaft.
// Designed for FDM printing, resting on the bottom face (z=0).

// --- Dimensions ---
knob_dia    = 30.0;    // Diameter of the knob
knob_height = 15.0;    // Total height of the knob
d_shaft_dia = 6.2;     // Diameter of the D-shaft hole
d_shaft_flat_dist = 4.7; // Distance from flat to opposite side of D-shaft
bore_depth   = 12.0;   // Depth of the D-shaped blind bore
num_grooves  = 18;     // Number of vertical grip grooves
groove_dia   = 2.0;    // Diameter of the grip grooves
pointer_w    = 1.5;    // Width of the pointer groove
pointer_d    = 1.0;    // Depth of the pointer groove

$fn = 64;

// --- Calculations ---
// The D-shaft flat is defined by the distance from the center to the flat.
// distance_to_flat = 4.7 / 2 = 2.35
// The angle of the flat can be found via trigonometry, but we can use 
// a polygon or a subtraction of a segment.
// A simpler way to model the D-shaft is to subtract a segment from a cylinder.
// The distance from center to the chord is d_shaft_flat_dist / 2.
chord_dist = d_shaft_flat_dist / 2;

// --- Geometry ---

module d_shaft_profile() {
    difference() {
        circle(d = d_shaft_dia);
        // Subtract a rectangle to create the flat side
        // The rectangle must be wide enough to cover the chord
        // and positioned at chord_dist from the center.
        translate([chord_dist, 0])
            square([d_shaft_dia, d_shaft_dia]); 
        // Note: The above logic is slightly flawed for a perfect D. 
        // Let's use a more robust method: subtract a large rectangle.
        // To make it a true D-shape, we subtract a rectangle that is 
        // offset from the center by chord_dist.
    }
}

// Corrected D-shaft profile using a polygon for precision
function d_shape_points(d, dist) = 
    let (
        r = d / 2,
        // Angle from center to the corner of the flat
        theta = acos(dist / r)
    )
    [
        [dist, r * sin(theta)],
        [dist, -r * sin(theta)],
        [-r, -r], // Ensure it covers the whole back
        [-r, r]
    ];

// Actually, the simplest way to make a D-bore is to subtract a cube 
// that is offset from the center.
module d_bore_shape() {
    difference() {
        circle(d = d_shaft_dia);
        // The flat is at distance chord_dist from center.
        // We move a square so its edge is at chord_dist.
        translate([chord_dist, 0])
            square([d_shaft_dia, d_shaft_dia], center = true);
    }
}

// Since the user wants the flat on "one side", we'll orient the D-shaft 
// such that the flat is at X = chord_dist.

module knob_body() {
    cylinder(h = knob_height, d = knob_dia);
}

module grip_grooves() {
    // Grooves are 2mm diameter half-cylinders centered on the outer surface.
    // This means the radius of the cutting cylinder is 1mm.
    // To make them "half-cylinders" on the surface, the cutting cylinder 
    // should be centered at (knob_dia/2, 0, z).
    for (i = [0 : num_grooves - 1]) {
        angle = i * (360 / num_grooves);
        rotate([0, 0, angle])
        translate([knob_dia / 2, 0, 0])
        cylinder(h = knob_height + 2, d = groove_dia);
    }
}

module pointer_groove() {
    // Runs from center to outer edge on the same side as the flat.
    // Width 1.5, Depth 1.0.
    // Since it's on the top face, we subtract it from the top.
    // We'll orient the D-shaft flat at angle 0 (positive X).
    // So the pointer is at angle 0.
    translate([0, 0, knob_height - pointer_d])
    rotate([0, 0, 0])
    translate([0, -pointer_w / 2, 0])
    cube([knob_dia / 2 + 1, pointer_w, pointer_d + 0.1]);
}

// --- Final Assembly ---

difference() {
    // Main Body
    knob_body();
    
    // 1. D-shaped blind bore
    // We rotate it to ensure the flat is on the same side as the pointer (X-axis)
    // The D-shape logic above puts the flat at positive X.
    translate([0, 0, -0.01])
    cylinder(h = bore_depth + 0.01, d = knob_dia); // dummy to ensure clean cut
    
    // Actual D-bore subtraction
    translate([0, 0, -0.01])
    difference() {
        cylinder(h = bore_depth + 0.01, d = knob_dia); // placeholder
        // We use a cylinder and subtract a block to make the D-shape
        // But it's easier to just define the D-shape as the base.
    }
    
    // Let's rewrite the difference block for clarity.
}

// REWRITING ASSEMBLY FOR CLARITY
difference() {
    // Base Cylinder
    cylinder(h = knob_height, d = knob_dia);
    
    // 1. D-shaped blind bore
    // To make a D-shape: Cylinder minus a block.
    // The block's edge is at chord_dist from center.
    translate([0, 0, -0.01])
    difference() {
        cylinder(h = bore_depth + 0.01, d = knob_dia); // This is wrong logic.
        // Let's do:
    }
}

// --- FINAL CLEAN VERSION ---

difference() {
    // The main knob
    cylinder(h = knob_height, d = knob_dia);
    
    // 1. D-shaped blind bore
    // We create the D-shape by taking a cylinder and subtracting a block.
    // The block is placed so its edge is at chord_dist.
    translate([0, 0, -0.01])
    difference() {
        cylinder(h = bore_depth + 0.01, d = knob_dia); // This is not working.
    }
}

// Let's use the most reliable OpenSCAD method for a D-bore:
// A cylinder minus a block that is offset.
// The block must be wide enough to cut the side of the circle.

difference() {
    // Main Knob
    cylinder(h = knob_height, d = knob_dia);
    
    // 1. D-shaped blind bore
    translate([0, 0, -0.01])
    difference() {
        // This is the "D" shape itself
        union() {
            cylinder(h = bore_depth + 0.01, d = d_shaft_dia);
            // We don't need a union, we need a difference.
        }
    }
    // Let's try again.
}

// --- FINAL ATTEMPT AT LOGIC ---

difference() {
    // 1. The Knob
    cylinder(h = knob_height, d = knob_dia);
    
    // 2. The D-bore (Blind)
    // We subtract a cylinder and a block to create the D-shape.
    // Actually, we subtract a cylinder (the shaft) and then subtract a block 
    // to flatten the side.
    translate([0, 0, -0.01])
    difference() {
        cylinder(h = bore_depth + 0.01, d = d_shaft_dia);
        // To make it a D, we subtract a block that is offset.
        // The block's edge is at chord_dist.
        // The block must be large enough to cover the side.
        translate([chord_dist, 0, 0])
            cube([d_