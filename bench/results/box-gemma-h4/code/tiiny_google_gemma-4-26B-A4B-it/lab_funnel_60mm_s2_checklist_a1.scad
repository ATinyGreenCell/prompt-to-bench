// Small Lab Funnel - Corrected
// Designed for FDM printing: printed upright, spout at bottom.

// --- Dimensions ---
spout_od     = 10.0;    // Outer diameter of the spout (mm)
spout_height = 20.0;    // Height of the spout (mm)
rim_od       = 60.0;    // Outer diameter at the top rim (mm)
funnel_height = 30.0;   // Height of the conical section (mm)
wall_thick   = 1.6;     // Wall thickness (mm)

// --- Derived Dimensions ---
spout_id     = spout_od - (2 * wall_thick);
rim_id       = rim_od - (2 * wall_thick);

$fn = 128;

// --- Geometry Construction ---

module funnel_body() {
    union() {
        // Spout section: sits on Z=0
        cylinder(h = spout_height, d = spout_od);
        
        // Conical section: starts at Z = spout_height
        translate([0, 0, spout_height])
        rotate_extrude() {
            polygon(points = [
                [spout_od / 2, 0],              // Bottom of cone profile
                [rim_od / 2, funnel_height]     // Top of cone profile
            ]);
        }
    }
}

module internal_hollow() {
    // Spout bore: goes through the bottom
    translate([0, 0, -1])
        cylinder(h = spout_height + 2, d = spout_id);
    
    // Conical bore: starts at Z = spout_height
    translate([0, 0, spout_height])
    rotate_extrude() {
        polygon(points = [
            [spout_id / 2, -1],              // Start slightly below spout junction
            [rim_id / 2, funnel_height + 1] // End slightly above rim
        ]);
    }
}

// Final Assembly
difference() {
    // The solid outer shell
    funnel_body();
    
    // The hollow interior
    internal_hollow();
}