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

// --- Main Construction ---
union() {
    // 1. The 8mm Barb Section (Z = 0 to 20)
    // We use a loop to create the stacked barbs
    for (i = [0 : barb8_count - 1]) {
        translate([0, 0, i * barb8_height])
        barb_shape(barb8_base_dia, barb8_top_dia, barb8_height);
    }

    // 2. The Transition Collar (Z = 20 to 25)
    translate([0, 0, 20])
    cylinder(h = collar_height, d = collar_dia);

    // 3. The 5mm Barb Section (Z = 25 to 41)
    // Note: The user specified Z=25 to 41 for two 8mm barbs. 
    // 25 + 8 + 8 = 41. This fits perfectly.
    for (i = [0 : barb5_count - 1]) {
        translate([0, 0, 25 + (i * barb5_height)])
        barb_shape(barb5_base_dia, barb5_top_dia, barb5_height);
    }
}

// Subtract the bore through the entire length
difference() {
    // This is a dummy union to allow the difference to wrap the whole object
    // In OpenSCAD, it's cleaner to wrap the whole union in a difference
    // but to follow the logic of the prompt, we subtract from the union above.
    // However, the standard way is:
    // difference() { [The Union] ; [The Bore] }
    // Since I already defined the union, I will wrap the whole block.
}

// Re-structuring for proper OpenSCAD difference logic:
// (The code above is the logic, the actual code below is the implementation)

// --- Implementation ---
// I will rewrite the structure to ensure the difference() works correctly.

// (Self-correction: I will provide the final clean version below)