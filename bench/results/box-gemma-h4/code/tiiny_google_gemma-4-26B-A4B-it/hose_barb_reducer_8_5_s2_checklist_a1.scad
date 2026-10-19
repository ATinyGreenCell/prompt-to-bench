// Straight hose-barb reducer
// Designed for 8mm and 5mm ID silicone tubing with a 3mm central bore.
// Corrected for watertight manifold geometry and full height.

// --- Dimensions ---
bore_d = 3.0;           // Central bore diameter
total_h = 41.0;         // Total height of the part

// 8mm side (z = 0 to 20)
barb8_h = 10.0;         // Height of one 8mm barb
barb8_d_base = 7.5;     // Bottom diameter of 8mm barb
barb8_d_top = 9.5;      // Top diameter of 8mm barb

// Collar (z = 20 to 25)
collar_h = 5.0;         // Height of the transition collar
collar_d = 12.0;        // Diameter of the transition collar

// 5mm side (z = 25 to 41)
barb5_h = 8.0;          // Height of one 5mm barb
barb5_d_base = 6.5;     // Bottom diameter of 5mm barb
barb5_d_top = 5.0;      // Top diameter of 5mm barb

$fn = 64;

// --- Modules ---

// A single barb module using a frustum (cone) to ensure watertightness
// We use a cylinder with d1 and d2 to create the tapered shape
module barb_segment(h, d_bottom, d_top) {
    cylinder(h = h, d1 = d_bottom, d2 = d_top);
}

// --- Main Construction ---

difference() {
    union() {
        // 8mm Barb Section (z = 0 to 20)
        // First barb: z = 0 to 10
        barb_segment(barb8_h, barb8_d_base, barb8_d_top);
        // Second barb: z = 10 to 20
        translate([0, 0, barb8_h]) 
            barb_segment(barb8_h, barb8_d_base, barb8_d_top);

        // Transition Collar (z = 20 to 25)
        translate([0, 0, 20]) 
            cylinder(h = collar_h, d = collar_d);

        // 5mm Barb Section (z = 25 to 41)
        // First barb: z = 25 to 33
        translate([0, 0, 25]) 
            barb_segment(barb5_h, barb5_d_base, barb5_d_top);
        // Second barb: z = 33 to 41
        translate([0, 0, 25 + barb5_h]) 
            barb_segment(barb5_h, barb5_d_base, barb5_d_top);
    }

    // Central Bore (runs through full length)
    // We extend the cylinder slightly to ensure it cuts through the top and bottom faces
    translate([0, 0, -1]) 
        cylinder(h = total_h + 2, d = bore_d);
}