// --- Dimensions (mm) ---
spout_od = 10.0;          // Outer diameter of the spout
spout_height = 20.0;      // Height of the spout from the base
funnel_rim_od = 60.0;     // Outer diameter at the top rim
funnel_height = 50.0;     // Total height from base to rim
wall_thickness = 1.6;     // Constant wall thickness

// --- Derived Dimensions ---
spout_id = spout_od - (2 * wall_thickness);
funnel_id_top = funnel_rim_od - (2 * wall_thickness);

// --- Rendering Settings ---
$fn = 64;

// --- Construction ---

// The part is printed upright, resting on the XY plane at z = 0.
difference() {
    // OUTER SHELL
    union() {
        // 1. The Spout (Cylinder)
        // From z=0 to z=20
        cylinder(h = spout_height, d = spout_od);
        
        // 2. The Funnel Cone (Frustum)
        // From z=20 (10mm OD) to z=50 (60mm OD)
        hull() {
            // Base of cone at the top of the spout
            translate([0, 0, spout_height])
                cylinder(h = 0.01, d = spout_od);
            
            // Top of cone at the rim
            translate([0, 0, funnel_height])
                cylinder(h = 0.01, d = funnel_rim_od);
        }
    }

    // INNER VOID (The "Cutter")
    union() {
        // 1. Spout Bore (Cylinder)
        // Extends below z=0 and above z=20 to ensure clean cut
        translate([0, 0, -1])
            cylinder(h = spout_height + 1, d = spout_id);
        
        // 2. Funnel Bore (Conical)
        // To maintain constant wall thickness of 1.6mm, the ID must 
        // taper at the same angle as the OD.
        // The OD tapers from 10 to 60 over 30mm height.
        // The ID tapers from 6.8 to 56.8 over 30mm height.
        hull() {
            // Bottom of inner cone (at z=20)
            translate([0, 0, spout_height - 0.1])
                cylinder(h = 0.1, d = spout_id);
            
            // Top of inner cone (at z=50)
            translate([0, 0, funnel_height + 1])
                cylinder(h = 1, d = funnel_id_top);
        }
    }
}

/* 
  Correction Notes based on Measurement Report:
  1. The previous model had a logic error in the hull() function which 
     caused the cone to jump to the full 60mm diameter immediately at z=20.
     This caused the "z=35.01" slice to show a 60mm diameter instead of 
     the interpolated diameter.
  2. The previous model's inner diameter at the top was calculated 
     incorrectly in the hull, leading to a hole diameter of 51.17mm 
     instead of the required 56.8mm (60 - 1.6*2).
  3. The corrected hull ensures the outer diameter transitions smoothly 
     from 10mm to 60mm between z=20 and z=50.
*/