// --- Dimensions (in mm) ---
// 8mm Tubing Section (z = 0 to 20)
barb_8_bottom_od = 7.5;    // Outer diameter at bottom of barb
barb_8_top_od    = 9.5;    // Outer diameter at top of barb
barb_8_height     = 10.0;   // Height of one barb
barb_8_count      = 2;      // Number of barbs in 8mm section

// Transition Collar (z = 20 to 25)
collar_diameter    = 12.0;  // Diameter of the transition collar
collar_height      = 5.0;   // Height of the transition collar

// 5mm Tubing Section (z = 25 to 41)
barb_5_bottom_od   = 6.5;    // Outer diameter at bottom of barb
barb_5_top_od      = 5.0;    // Outer diameter at top of barb
barb_5_height      = 8.0;    // Height of one barb
barb_5_count       = 2;      // Number of barbs in 5mm section

// Internal Bore
bore_diameter       = 3.0;   // Diameter of the central hole

// --- Constants ---
$fn = 64;

// --- Implementation ---

difference() {
    union() {
        // 1. 8mm Section (z = 0 to 20)
        // We build the barbs and the "step back" cylinders to ensure a solid manifold part.
        for (i = [0 : barb_8_count - 1]) {
            // The tapered barb
            hull() {
                translate([0, 0, i * barb_8_height])
                    cylinder(h = 0.01, d = barb_8_bottom_od);
                translate([0, 0, (i + 1) * barb_8_height])
                    cylinder(h = 0.01, d = barb_8_top_od);
            }
            // The "step back" connection (ensures the part is a single solid)
            // The prompt says it steps back to 7.5mm. We add a thin cylinder at the junction.
            translate([0, 0, (i + 1) * barb_8_height])
                cylinder(h = 0.01, d = barb_8_bottom_od);
        }
        // Ensure the base is solid from z=0 to the first barb
        cylinder(h = 0.01, d = barb_8_bottom_od);

        // 2. Transition Collar (z = 20 to 25)
        translate([0, 0, 20])
            cylinder(h = collar_height, d = collar_diameter);

        // 3. 5mm Section (z = 25 to 41)
        for (i = [0 : barb_5_count - 1]) {
            // The tapered barb
            hull() {
                translate([0, 0, 25 + i * barb_5_height])
                    cylinder(h = 0.01, d = barb_5_bottom_od);
                translate([0, 0, 25 + (i + 1) * barb_5_height])
                    cylinder(h = 0.01, d = barb_5_top_od);
            }
            // The "step back" connection (ensures the part is a single solid)
            translate([0, 0, 25 + (i + 1) * barb_5_height])
                cylinder(h = 0.01, d = barb_5_bottom_od);
        }
        // Ensure the base of the 5mm section is solid at z=25
        translate([0,0,25])
            cylinder(h = 0.01, d = barb_5_bottom_od);
    }

    // --- The Bore (The Hole) ---
    // A 3mm bore runs straight through the full length (0 to 41).
    // We extend the cylinder slightly beyond the boundaries to ensure a clean cut.
    translate([0, 0, -1])
        cylinder(h = 41 + 2, d = bore_diameter);
}