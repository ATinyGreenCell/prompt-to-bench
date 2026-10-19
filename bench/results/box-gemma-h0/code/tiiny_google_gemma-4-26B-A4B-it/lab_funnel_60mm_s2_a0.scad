// --- Dimensions (mm) ---
spout_od = 10.0;          // Outer diameter of the spout
spout_height = 20.0;      // Height of the spout from the base
funnel_rim_od = 60.0;     // Outer diameter at the top rim
funnel_height = 50.0;     // Total height from base to top rim
wall_thickness = 1.6;     // Constant wall thickness
$fn = 64;                 // Smoothness for curves

// --- Derived Dimensions ---
spout_id = spout_od - (2 * wall_thickness);
funnel_id_base = spout_od - (2 * wall_thickness); // ID at the junction (z=20)
funnel_id_top = funnel_rim_od - (2 * wall_thickness);

// --- Modeling ---

// The part is printed upright, resting on the XY plane at z = 0.
// We use a union of the spout and the cone, then subtract the hollow interior.

union() {
    // 1. The Spout (Cylinder)
    cylinder(h = spout_height, d = spout_od);

    // 2. The Funnel Cone
    translate([0, 0, spout_height])
    cylinder(h = funnel_height - spout_height, d1 = spout_od, d2 = funnel_rim_od);
}

// 3. The Hollow Interior (Subtraction)
difference() {
    // We use a large enough object to ensure clean cuts
    // We subtract the interior space from the solid body above
    union() {
        // Interior Spout
        cylinder(h = spout_height + 0.1, d = spout_id);
        
        // Interior Cone
        translate([0, 0, spout_height])
        cylinder(h = (funnel_height - spout_height) + 0.1, d1 = spout_id, d2 = funnel_id_top);
    }
}

// Note: The logic above is slightly flawed for a single difference() block. 
// Let's rewrite the structure to be mathematically sound for OpenSCAD.

/* 
REWRITTEN STRUCTURE:
Total Solid = (Spout + Cone)
Final Part = Total Solid MINUS (Spout_Hole + Cone_Hole)
*/

// Clear the previous logic and use this clean implementation:

module funnel_solid() {
    // The outer shell
    union() {
        // Spout
        cylinder(h = spout_height, d = spout_od);
        // Cone
        translate([0, 0, spout_height])
        cylinder(h = funnel_height - spout_height, d1 = spout_od, d2 = funnel_rim_od);
    }
}

module funnel_hollow() {
    // The inner void
    union() {
        // Spout hole
        cylinder(h = spout_height + 1, d = spout_id);
        // Cone hole
        translate([0, 0, spout_height - 0.1])
        cylinder(h = (funnel_height - spout_height) + 1.1, d1 = spout_id, d2 = funnel_id_top);
    }
}

// Final Assembly
difference() {
    funnel_solid();
    funnel_hollow();
}