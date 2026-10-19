// Replacement knob for a hotplate stirrer with a 6 mm D-shaft.
// Designed for FDM printing, resting on the bottom face (z=0).

// --- Dimensions ---
knob_d        = 30.0;    // Diameter of the knob
knob_h        = 15.0;    // Total height of the knob
shaft_d       = 6.2;     // Diameter of the D-shaft bore
shaft_flat_d  = 4.7;     // Distance from flat to opposite side of D-shaft
shaft_depth   = 12.0;    // Depth of the blind D-bore
groove_d      = 2.0;     // Diameter of the grip grooves
groove_count  = 18;      // Number of vertical grip grooves
pointer_w     = 1.5;     // Width of the pointer groove
pointer_d     = 1.0;     // Depth of the pointer groove

$fn = 64;

// --- Geometry ---

module d_shaft_bore() {
    // The D-shape is created by taking a cylinder and cutting it with a cube.
    // The distance from center to flat is shaft_flat_d / 2.
    // We subtract a cube that starts at the flat position and extends outwards.
    difference() {
        cylinder(h = shaft_depth + 0.1, d = shaft_d);
        
        // The flat is at x = -shaft_flat_d / 2.
        // We subtract a cube that covers the area from the flat to the edge of the cylinder.
        translate([-shaft_d, -shaft_d, -0.1])
            cube([shaft_d - (shaft_flat_d / 2), shaft_d * 2, shaft_depth + 0.2]);
    }
}

module grip_grooves() {
    // Vertical grooves around the perimeter
    for (i = [0 : groove_count - 1]) {
        angle = i * (360 / groove_count);
        rotate([0, 0, angle])
            translate([knob_d / 2, 0, -0.5])
                cylinder(h = knob_h + 1, d = groove_d);
    }
}

module pointer_groove() {
    // Pointer groove on the top face.
    // Runs from center to outer edge, 1.5mm wide, 1mm deep.
    // Aligned with the flat side (negative X direction).
    // We use a cube and translate it to the top face.
    translate([0, -pointer_w / 2, knob_h - pointer_d])
        cube([knob_d / 2 + 1, pointer_w, pointer_d + 0.1]);
}

// --- Final Assembly ---

difference() {
    // 1. The main body
    cylinder(h = knob_h, d = knob_d);
    
    // 2. Subtract D-shaft bore (blind bore at bottom)
    translate([0, 0, -0.01]) 
        d_shaft_bore();
    
    // 3. Subtract Grip Grooves (around the perimeter)
    grip_grooves();
    
    // 4. Subtract Pointer Groove (on the top face, aligned with D-flat)
    // The D-flat is on the negative X side.
    // The pointer_groove module already handles the negative X direction.
    pointer_groove();
}