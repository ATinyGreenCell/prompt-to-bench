// Dimensions
bore_dia = 3.0;               // Inner bore diameter (mm)
barb8_bottom_dia = 7.5;       // 8mm tubing barb bottom diameter (mm)
barb8_top_dia = 9.5;          // 8mm tubing barb top diameter (mm)
barb8_height = 10.0;          // Height of each 8mm barb (mm)
collar_dia = 12.0;            // Collar diameter (mm)
collar_height = 5.0;          // Collar height (mm)
barb5_bottom_dia = 6.5;       // 5mm tubing barb bottom diameter (mm)
barb5_top_dia = 5.0;          // 5mm tubing barb top diameter (mm)
barb5_height = 8.0;           // Height of each 5mm barb (mm)
total_height = 41.0;          // Total height of the part (mm)

// Resolution
fn = 64;

// Part Construction
difference() {
    union() {
        // 8mm Barb Section (Z = 0 to 20)
        // Two identical barbs stacked
        for (i = [0 : 1]) {
            translate([0, 0, i * barb8_height]) {
                cylinder(h = barb8_height, d1 = barb8_bottom_dia, d2 = barb8_top_dia);
            }
        }

        // Collar Section (Z = 20 to 25)
        translate([0, 0, 20]) {
            cylinder(h = collar_height, d = collar_dia);
        }

        // 5mm Barb Section (Z = 25 to 41)
        // Two identical barbs stacked
        translate([0, 0, 25]) {
            for (i = [0 : 1]) {
                translate([0, 0, i * barb5_height]) {
                    cylinder(h = barb5_height, d1 = barb5_bottom_dia, d2 = barb5_top_dia);
                }
            }
        }
    }

    // Central Bore (runs through full length)
    // We extend the cylinder slightly beyond the boundaries to ensure a clean cut
    translate([0, 0, -1]) {
        cylinder(h = total_height + 2, d = bore_dia);
    }
}