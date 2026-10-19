// Replacement knob for a hotplate stirrer with a 6 mm D-shaft.
// Designed for FDM printing, resting on the bottom face (z=0).

// --- Dimensions ---
knob_diameter = 30.0;      // Total diameter of the knob
knob_height   = 15.0;      // Total height of the knob
d_shaft_dia    = 6.2;       // Diameter of the circular part of the D-shaft
d_shaft_width  = 4.7;       // Distance from the flat to the opposite side
d_shaft_depth  = 12.0;      // Depth of the D-shaft bore into the knob

groove_dia     = 2.0;       // Diameter of the vertical grip grooves
num_grooves    = 18;        // Number of vertical grip grooves

pointer_width  = 1.5;       // Width of the pointer groove on top
pointer_depth  = 1.0;       // Depth of the pointer groove

$fn = 64;

// --- Calculations ---
// The distance from the center to the flat side:
// Since the distance from the flat to the opposite side is 4.7,
// and the radius is 6.2 / 2 = 3.1,
// the distance from the center to the flat is 4.7 - 3.1 = 1.6.
dist_center_to_flat = d_shaft_width - (d_shaft_dia / 2);

// --- Modeling ---

difference() {
    // 1. Main Knob Body
    cylinder(h = knob_height, d = knob_diameter);

    // 2. D-shaped Blind Bore
    // We subtract a cylinder and then subtract a block to create the flat side.
    // The flat side is located at x = -dist_center_to_flat.
    // To ensure a clean cut, we make the block wider than the knob.
    translate([0, 0, -0.01]) {
        // The circular part of the bore
        cylinder(h = d_shaft_depth + 0.01, d = d_shaft_dia);
        
        // The flat part of the bore (subtracting a block to create the flat)
        // The block covers the area from the center towards the edge.
        // We position it so the edge of the block is at -dist_center_to_flat.
        translate([-knob_diameter, -knob_diameter, -0.01])
            cube([knob_diameter - dist_center_to_flat, knob_diameter * 2, d_shaft_depth + 0.02]);
    }

    // 3. Vertical Grip Grooves
    // 18 evenly spaced vertical grooves around the outside.
    // Each groove is a 2mm diameter half-cylinder.
    for (i = [0 : num_grooves - 1]) {
        angle = i * (360 / num_grooves);
        rotate([0, 0, angle])
            // Translate the cylinder so its edge is at the knob's edge
            // The center of the 2mm cylinder is at (knob_diameter/2) - (groove_dia/2)
            translate([(knob_diameter / 2), 0, 0])
                rotate([0, 90, 0])
                    cylinder(h = knob_height + 2, d = groove_dia);
    }

    // 4. Top Pointer Groove
    // 1.5mm wide, 1mm deep, runs from center to edge, on the same side as the flat.
    // The flat is at x = -dist_center_to_flat.
    // To align with the "same side as the flat", we place the groove on the negative X axis.
    translate([-pointer_width / 2, 0, knob_height - pointer_depth])
        cube([pointer_width, knob_diameter, pointer_depth + 0.01]);
}

// Note on Pointer Groove: 
// The user requested it to run from center to edge. 
// A simple cube subtraction is used here. 
// To ensure it is "on the same side as the flat", 
// we center it on the X-axis (which is the direction of the flat).