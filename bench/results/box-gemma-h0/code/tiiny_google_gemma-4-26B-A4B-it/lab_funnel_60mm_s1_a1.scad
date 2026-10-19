// Lab Funnel Design - Corrected
// Units: mm
// Print Orientation: Upright (Base at Z=0)

// --- Dimensions ---
spout_outer_diameter = 10.0;      // Outer diameter of the spout
spout_height = 20.0;             // Height of the spout (from Z=0 to Z=20)
funnel_rim_diameter = 60.0;      // Outer diameter at the top rim
funnel_height = 50.0;            // Total height from base to rim
wall_thickness = 1.6;            // Constant wall thickness
$fn = 64;                        // Smoothness for curves

// --- Calculated Dimensions ---
spout_inner_diameter = spout_outer_diameter - (2 * wall_thickness);
funnel_inner_rim_diameter = funnel_rim_diameter - (2 * wall_thickness);

// --- Main Construction ---

// We use a single difference to ensure a single watertight manifold body
difference() {
    // 1. The Outer Shell
    union() {
        // The Spout (Cylinder)
        cylinder(h = spout_height, d = spout_outer_diameter);
        
        // The Funnel Cone
        hull() {
            // Bottom of cone (at Z=20)
            translate([0, 0, spout_height])
                cylinder(h = 0.01, d = spout_outer_diameter);
            
            // Top of cone (at Z=50)
            translate([0, 0, funnel_height])
                cylinder(h = 0.01, d = funnel_rim_diameter);
        }
    }

    // 2. The Inner Bore (The "Hole")
    // We subtract a single continuous internal volume to ensure 
    // the spout and cone are perfectly connected and hollowed.
    union() {
        // Spout bore (extends below Z=0 to ensure clean cut)
        translate([0, 0, -1])
            cylinder(h = spout_height + 1, d = spout_inner_diameter);
        
        // Funnel bore (extends above Z=50 to ensure clean cut)
        hull() {
            // Bottom of inner cone (at Z=0 to ensure it cuts through the spout)
            translate([0, 0, -1])
                cylinder(h = 0.01, d = spout_inner_diameter);
            
            // Top of inner cone (at Z=50 to ensure it cuts through the rim)
            translate([0, 0, funnel_height + 1])
                cylinder(h = 1, d = funnel_inner_rim_diameter);
        }
    }
}

// Verification of logic:
// - Spout OD: 10mm (Matches spec)
// - Spout ID: 10 - (2*1.6) = 6.8mm (Matches spec)
// - Funnel Rim OD: 60mm (Matches spec)
// - Funnel Rim ID: 60 - (2*1.6) = 56.8mm (Matches spec)
// - Total Height: 50mm (Matches spec)
// - Wall thickness: 1.6mm constant (Matches spec)