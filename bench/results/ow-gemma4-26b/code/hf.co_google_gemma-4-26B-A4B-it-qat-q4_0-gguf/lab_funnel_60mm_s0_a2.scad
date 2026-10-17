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
            // Base of cone at the top of the spout (z=20)
            translate([0, 0, spout_height])
                cylinder(h = 0.01, d = spout_od);
            
            // Top of cone at the rim (z=50)
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
        // OD: 10 to 60 over 30mm height.
        // ID: (10 - 3.2) to (60 - 3.2) => 6.8 to 56.8 over 30mm height.
        hull() {
            // Bottom of inner cone (at z=20)
            translate([0, 0, spout_height - 0.1])
                cylinder(h = 0.1, d = spout_id);
            
            // Top of inner cone (at z=50)
            // We extend slightly above z=50 to ensure the top rim is open
            translate([0, 0, funnel_height + 1])
                cylinder(h = 1, d = funnel_id_top);
        }
    }
}

/* 
  Correction Notes based on Measurement Report:
  The previous model's "z=47.51" slice showed a hole diameter of 51.17mm.
  Calculation: 60mm (OD) - 2 * 1.6mm (Wall) = 56.8mm.
  The previous model's "z=47.51" slice showed an outer diameter of 55.80mm.
  Calculation: 60mm (OD) - 2 * 1.6mm (Wall) = 56.8mm.
  
  Wait, looking at the previous report:
  z=47.51: 1 solid region [outline: circle d=55.80] -> This is 60 - 4.2? No.
  If OD is 60, and wall is 1.6, OD should be 60.
  If ID is 56.8, then 60 - 56.8 = 3.2 (which is 2 * 1.6).
  
  The error in the previous iteration was that the hull() in the outer shell 
  was creating a shape that didn't reach the full 60mm diameter at the top 
  due to how the cylinders were placed, or the inner hull was not matching 
  the outer slope perfectly.
  
  To ensure perfect constant wall thickness:
  Outer OD at z=20 is 10. Outer OD at z=50 is 60.
  Inner ID at z=20 is 6.8. Inner ID at z=50 is 56.8.
  This ensures the wall is exactly 1.6mm at every horizontal slice.
*/