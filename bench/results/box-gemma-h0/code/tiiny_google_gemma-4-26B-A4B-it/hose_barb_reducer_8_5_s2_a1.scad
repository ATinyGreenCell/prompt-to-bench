// --- Dimensions (mm) ---
bore_diameter = 3.0;           // Internal hole diameter
total_height = 41.0;           // Total height of the part

// 8mm Tubing Barb Section (Z = 0 to 20)
barb8_count = 2;               // Number of barbs for 8mm side
barb8_height = 10.0;           // Height of each barb
barb8_base_dia = 7.5;          // Bottom diameter of barb
barb8_top_dia = 9.5;           // Top diameter of barb

// Transition Collar (Z = 20 to 25)
collar_dia = 12.0;             // Diameter of the cylindrical collar
collar_height = 5.0;           // Height of the collar

// 5mm Tubing Barb Section (Z = 25 to 41)
barb5_count = 2;               // Number of barbs for 5mm side
barb5_height = 8.0;            // Height of each barb
barb5_base_dia = 6.5;          // Bottom diameter of barb
barb5_top_dia = 5.0;           // Top diameter of barb

// --- Constants ---
$fn = 64;

// --- Modules ---

// Module to create a single barb with a linear taper
module barb_shape(base_dia, top_dia, height) {
    cylinder(h = height, d1 = base_dia, d2 = top_dia);
}

// --- Main Construction ---

difference() {
    // The main body of the reducer
    union() {
        // 1. The 8mm Barb Section (Z = 0 to 20)
        // Two identical barbs, stacked.
        for (i = [0 : barb8_count - 1]) {
            translate([0, 0, i * barb8_height])
            barb_shape(barb8_base_dia, barb8_top_dia, barb8_height);
        }

        // 2. The Transition Collar (Z = 20 to 25)
        translate([0, 0, 20])
        cylinder(h = collar_height, d = collar_dia);

        // 3. The 5mm Barb Section (Z = 25 to 41)
        // Two identical barbs, stacked.
        for (i = [0 : barb5_count - 1]) {
            translate([0, 0, 25 + (i * barb5_height)])
            barb_shape(barb5_base_dia, barb5_top_dia, barb5_height);
        }
    }

    // Subtract the bore through the entire length
    // We extend the cylinder slightly beyond the bounds to ensure a clean cut
    translate([0, 0, -1])
    cylinder(h = total_height + 2, d = bore_diameter);
}