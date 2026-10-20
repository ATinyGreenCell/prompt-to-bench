// --- Dimensions ---
bore_diameter = 3.0;           // Internal bore diameter
barb_8_bottom_od = 7.5;        // 8mm tubing barb bottom OD
barb_8_top_od = 9.5;           // 8mm tubing barb top OD
barb_8_height = 10.0;          // Height of one 8mm barb
barb_8_count = 2;              // Number of 8mm barbs

collar_diameter = 12.0;        // Diameter of the middle collar
collar_height = 5.0;           // Height of the middle collar (25 - 20)

barb_5_bottom_od = 6.5;        // 5mm tubing barb bottom OD
barb_5_top_od = 5.0;           // 5mm tubing barb top OD
barb_5_height = 8.0;           // Height of one 5mm barb
barb_5_count = 2;              // Number of 5mm barbs

// --- Constants ---
$fn = 64;

// --- Helper Modules ---

// Module for the 8mm barb (Sawtooth profile: grows then steps back)
module barb_8_segment() {
    union() {
        // Tapered part
        cylinder(h = barb_8_height, d1 = barb_8_bottom_od, d2 = barb_8_top_od);
        // Step back part (the "sawtooth" shoulder)
        translate([0, 0, barb_8_height])
            cylinder(h = 0.01, d = barb_8_bottom_od);
    }
}

// Module for the 5mm barb (Sawtooth profile: shrinks then steps out)
module barb_5_segment() {
    union() {
        // Tapered part
        cylinder(h = barb_5_height, d1 = barb_5_bottom_od, d2 = barb_5_top_od);
        // Step out part (the "sawtooth" shoulder)
        translate([0, 0, barb_5_height])
            cylinder(h = 0.01, d = barb_5_bottom_od);
    }
}

// --- Main Assembly ---

module hose_barb_reducer() {
    difference() {
        union() {
            // 8mm Barb Section (Z = 0 to 20)
            for (i = [0 : barb_8_count - 1]) {
                translate([0, 0, i * barb_8_height])
                    barb_8_segment();
            }

            // Collar Section (Z = 20 to 25)
            translate([0, 0, 20])
                cylinder(h = collar_height, d = collar_diameter);

            // 5mm Barb Section (Z = 25 to 41)
            // Note: 25 + (2 * 8) = 41.
            for (i = [0 : barb_5_count - 1]) {
                translate([0, 0, 25 + (i * barb_5_height)])
                    barb_5_segment();
            }
        }

        // Internal Bore (Running through full length)
        // We extend the bore slightly beyond the total height to ensure a clean cut
        translate([0, 0, -1])
            cylinder(h = 45, d = bore_diameter);
    }
}

// Render the part
hose_barb_reducer();