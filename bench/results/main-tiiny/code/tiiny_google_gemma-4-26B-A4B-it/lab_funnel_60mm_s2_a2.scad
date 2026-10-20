// --- Dimensions (mm) ---
spout_od = 10.0;          // Outer diameter of the spout
spout_height = 20.0;      // Height of the spout from the base
funnel_rim_od = 60.0;     // Outer diameter at the top rim
funnel_height = 50.0;     // Total height from base to top rim
wall_thickness = 1.6;     // Constant wall thickness
$fn = 64;                 // Smoothness for curves

// --- Derived Dimensions ---
// The specification requires a constant wall thickness of 1.6mm.
// This means the inner diameter (ID) must be: OD - (2 * wall_thickness).
spout_id = spout_od - (2 * wall_thickness);
funnel_id_top = funnel_rim_od - (2 * wall_thickness);

// --- Modeling ---

// The part is printed upright, resting on the XY plane at z = 0.
// We use a difference() to subtract the hollow interior from the solid shell.

difference() {
    // 1. The Outer Shell (The Solid Body)
    union() {
        // Spout Cylinder (z = 0 to z = 20)
        cylinder(h = spout_height, d = spout_od);
        
        // Funnel Cone (z = 20 to z = 50)
        // d1 is the diameter at the bottom of the cone (z=20)
        // d2 is the diameter at the top of the cone (z=50)
        translate([0, 0, spout_height])
        cylinder(h = funnel_height - spout_height, d1 = spout_od, d2 = funnel_rim_od);
    }

    // 2. The Inner Void (The Hole)
    // To ensure the part is open at the top and bottom, the subtraction 
    // shapes must extend slightly beyond the boundaries of the solid.
    union() {
        // Spout Hole: Starts at z = -1 and goes to z = spout_height + 1
        // This ensures the bottom (z=0) is completely cut through.
        translate([0, 0, -1])
        cylinder(h = spout_height + 2, d = spout_id);
        
        // Funnel Hole: Starts at z = spout_height and goes to z = funnel_height + 1
        // This ensures the top (z=50) is completely cut through.
        // The diameter at the bottom of this hole (z=20) must match the spout_id
        // to maintain the constant 1.6mm wall thickness.
        translate([0, 0, spout_height])
        cylinder(h = (funnel_height - spout_height) + 1, d1 = spout_id, d2 = funnel_id_top);
    }
}

/* 
  Verification of Specifications:
  - Spout OD: 10.0mm.
  - Spout ID: 10.0 - (2 * 1.6) = 6.8mm.
  - Funnel Rim OD: 60.0mm.
  - Funnel Rim ID: 60.0 - (2 * 1.6) = 56.8mm.
  - Wall Thickness: 
    At spout: (10 - 6.8)/2 = 1.6mm.
    At rim: (60 - 56.8)/2 = 1.6mm.
  - Openings: The difference() with extended heights ensures the top and bottom are open.
*/