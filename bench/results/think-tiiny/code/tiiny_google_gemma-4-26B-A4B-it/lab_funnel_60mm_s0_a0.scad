// --- Dimensions ---
spout_od = 10;             // Outer diameter of the spout (mm)
spout_height = 20;         // Height of the spout (mm)
funnel_top_od = 60;        // Outer diameter at the top rim (mm)
funnel_height = 30;        // Height of the cone section (mm)
wall_thickness = 1.6;      // Wall thickness (mm)

// --- Calculated Values ---
spout_id = spout_od - 2 * wall_thickness; // Inner diameter of the spout
funnel_top_id = funnel_top_od - 2 * wall_thickness; // Inner diameter at the top rim

// --- Parameters ---
$fn = 64;

// --- Model ---
difference() {
    // Outer Shell
    union() {
        // Spout: A straight cylinder from z=0 to z=20
        cylinder(d=spout_od, h=spout_height);
        
        // Funnel: A cone (frustum) from z=20 to z=50
        translate([0, 0, spout_height])
            cylinder(d1=spout_od, d2=funnel_top_od, h=funnel_height);
    }

    // Inner Hollow (to be subtracted)
    union() {
        // Spout Bore: A cylinder that extends slightly below z=0 to ensure an open bottom
        translate([0, 0, -1])
            cylinder(d=spout_id, h=spout_height + 2);
        
        // Funnel Bore: A cone that extends slightly above z=50 to ensure an open top
        // It starts at the spout junction to create a continuous internal passage
        translate([0, 0, spout_height - 1])
            cylinder(d1=spout_id, d2=funnel_top_id, h=funnel_height + 2);
    }
}