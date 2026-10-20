// Lab Funnel Design
// Dimensions measured in mm, printed upright (XY plane at z=0)

// --- User Specifications ---
spout_od = 10;          // Outer diameter of spout
spout_height = 20;      // Height of spout section
funnel_top_od = 60;     // Outer diameter at the rim
funnel_total_height = 50; // Total height of the part
wall_thickness = 1.6;   // Wall thickness everywhere

// --- Calculated Dimensions ---
spout_id = spout_od - 2 * wall_thickness;
funnel_base_id = spout_id; // Funnel base ID matches spout ID
funnel_top_id = funnel_top_od - 2 * wall_thickness;

// Radii
spout_r_out = spout_od / 2;
spout_r_in = spout_id / 2;
funnel_base_r_out = spout_od / 2;
funnel_base_r_in = spout_id / 2;
funnel_top_r_out = funnel_top_od / 2;
funnel_top_r_in = funnel_top_id / 2;

// --- Geometry Construction ---

module funnel() {
    // 1. Create the solid outer shell (Spout + Cone)
    // We build this as a single solid object first.
    
    // Spout section (Cylinder)
    cylinder(h = spout_height, r = spout_r_out, center = false);
    
    // Funnel section (Cone)
    // Base at z = spout_height, Top at z = funnel_total_height
    // We use a cylinder with r1 and r2 to create the taper
    translate([0, 0, spout_height])
    cylinder(h = funnel_total_height - spout_height, r1 = funnel_base_r_out, r2 = funnel_top_r_out, center = false);
    
    // 2. Subtract the hollow interior
    // We create a solid shape representing the empty space and subtract it.
    // To ensure watertightness and avoid coplanar faces, we offset the cut slightly.
    
    // The hollow shape consists of a cylinder (spout) and a cone (funnel).
    // We combine them into a single subtraction object.
    
    // Subtraction Object:
    // A. Spout hole (Cylinder)
    // Offset z by 0.01 to ensure the cut goes slightly past the base of the spout
    // and slightly past the top of the spout to ensure the cone transition is clean.
    translate([0, 0, -0.01])
    cylinder(h = spout_height + 0.02, r = spout_r_in, center = false);
    
    // B. Funnel hole (Cone)
    // The cone hole starts exactly where the spout hole ends (z=20)
    // and goes to the top. We extend it slightly past the top to ensure the rim is open.
    translate([0, 0, spout_height - 0.01])
    cylinder(h = (funnel_total_height - spout_height) + 0.02, r1 = funnel_base_r_in, r2 = funnel_top_r_in, center = false);
}

// --- Main Execution ---
// Center the part on the XY plane (0,0)
// The part rests on z=0.
translate([0, 0, 0])
funnel();