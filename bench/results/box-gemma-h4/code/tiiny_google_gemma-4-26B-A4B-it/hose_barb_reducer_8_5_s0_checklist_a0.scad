// Straight hose-barb reducer
// Designed for 8mm and 5mm ID tubing with a 3mm central bore.

// --- Dimensions ---
bore_d       = 3.0;    // Central bore diameter
barb8_h      = 10.0;   // Height of one 8mm barb
barb8_d_bot  = 7.5;    // Bottom diameter of 8mm barb
barb8_d_top  = 9.5;    // Top diameter of 8mm barb
barb5_h      = 8.0;    // Height of one 5mm barb
barb5_d_bot  = 6.5;    // Bottom diameter of 5mm barb
barb5_d_top  = 5.0;    // Top diameter of 5mm barb
collar_d     = 12.0;   // Diameter of the transition collar
collar_h     = 5.0;    // Height of the transition collar (25 - 20)

// --- Derived Geometry ---
total_h_8mm  = barb8_h * 2; // 20mm
total_h_5mm  = barb5_h * 2; // 16mm
total_height = total_h_8mm + collar_h + total_h_5mm; // 20 + 5 + 16 = 41mm

$fn = 64;

// --- Modules ---

// A single barb for the 8mm side (tapering up)
module barb8_segment() {
    cylinder(h = barb8_h, d1 = barb8_d_bot, d2 = barb8_d_top);
}

// A single barb for the 5mm side (tapering up)
module barb5_segment() {
    cylinder(h = barb5_h, d1 = barb5_d_bot, d2 = barb5_d_top);
}

// --- Final Assembly ---

difference() {
    // Main Body
    union() {
        // 8mm Barb Section (z = 0 to 20)
        // First barb
        barb8_segment();
        // Second barb (stacked)
        translate([0, 0, barb8_h]) barb8_segment();
        
        // Transition Collar (z = 20 to 25)
        translate([0, 0, total_h_8mm]) 
            cylinder(h = collar_h, d = collar_d);
            
        // 5mm Barb Section (z = 25 to 41)
        // First barb
        translate([0, 0, total_h_8mm + collar_h]) 
            barb5_segment();
        // Second barb (stacked)
        translate([0, 0, total_h_8mm + collar_h + barb5_h]) 
            barb5_segment();
    }

    // Central Bore (runs through full length)
    // We extend the cylinder slightly beyond the height to ensure a clean cut
    translate([0, 0, -1]) 
        cylinder(h = total_height + 2, d = bore_d);
}