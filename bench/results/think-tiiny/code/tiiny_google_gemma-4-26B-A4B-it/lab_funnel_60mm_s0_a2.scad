// --- Dimensions ---
spout_od = 10;             // Outer diameter of the spout (mm)
spout_height = 20;         // Height of the spout (mm)
funnel_top_od = 60;        // Outer diameter at the top rim (mm)
funnel_height = 30;        // Height of the cone section (mm)
wall_thickness = 1.6;      // Wall thickness (mm)

// --- Calculated Values ---
// To maintain a constant radial wall thickness, the inner diameter 
// must be exactly the outer diameter minus twice the wall thickness.
spout_id = spout_od - 2 * wall_thickness; 
funnel_top_id = funnel_top_od - 2 * wall_thickness;

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
        // Spout Bore: A cylinder from z=-1 to z=20.
        // Extending to z=-1 ensures the bottom is completely open.
        translate([0, 0, -1])
            cylinder(d=spout_id, h=spout_height + 1);
        
        // Funnel Bore: A cone from z=20 to z=51.
        // Starting at z=20 ensures the inner diameter matches the spout bore (6.8mm),
        // maintaining the 1.6mm wall thickness through the transition.
        // Extending to z=51 ensures the top is completely open.
        translate([0, 0, spout_height])
            cylinder(d1=spout_id, d2=funnel_top_id, h=funnel_height + 1);
    }
}