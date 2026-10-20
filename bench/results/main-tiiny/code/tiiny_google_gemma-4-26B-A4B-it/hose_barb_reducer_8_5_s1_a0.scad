// --- Dimensions (mm) ---
bore_diameter = 3.0;             // Internal bore diameter
total_height = 41.0;             // Total height of the part

// 8mm Tubing Section (z = 0 to 20)
barb8_count = 2;                 // Number of barbs for 8mm side
barb8_height = 10.0;             // Height of each 8mm barb
barb8_base_dia = 7.5;            // Bottom diameter of 8mm barb
barb8_top_dia = 9.5;             // Top diameter of 8mm barb

// Transition Collar (z = 20 to 25)
collar_height = 5.0;             // Height of the cylindrical collar
collar_diameter = 12.0;          // Diameter of the collar

// 5mm Tubing Section (z = 25 to 41)
barb5_count = 2;                 // Number of barbs for 5mm side
barb5_height = 8.0;              // Height of each 5mm barb
barb5_base_dia = 6.5;            // Bottom diameter of 5mm barb
barb5_top_dia = 5.0;             // Top diameter of 5mm barb

// --- Rendering Settings ---
$fn = 64;

// --- Main Construction ---
union() {
    // 8mm Barb Section
    for (i = [0 : barb8_count - 1]) {
        translate([0, 0, i * barb8_height])
        barb_shape(barb8_base_dia, barb8_top_dia, barb8_height);
    }

    // Transition Collar
    translate([0, 0, 20])
    cylinder(h = collar_height, d = collar_diameter);

    // 5mm Barb Section
    // Note: The user specified z=25 to 41. 
    // 25 + (2 * 8) = 41. This fits perfectly.
    for (i = [0 : barb5_count - 1]) {
        translate([0, 0, 25 + (i * barb5_height)])
        barb_shape(barb5_base_dia, barb5_top_dia, barb5_height);
    }
}

// --- Subtract the Bore ---
difference() {
    // We use a union of the parts above, but to ensure a clean subtraction, 
    // we wrap the whole thing in a difference.
    // However, to keep the code clean, I will wrap the entire logic in a difference.
    // Let's redefine the structure to be cleaner.
}

// Re-structuring for proper difference() logic
// (The code above is the 'positive' part, now we subtract the bore)

// Corrected Structure:
// We will use a module to define the outer shell and then subtract the bore.

module outer_shell() {
    // 8mm Barb Section
    for (i = [0 : barb8_count - 1]) {
        translate([0, 0, i * barb8_height])
        barb_shape(barb8_base_dia, barb8_top_dia, barb8_height);
    }

    // Transition Collar
    translate([0, 0, 20])
    cylinder(h = collar_height, d = collar_diameter);

    // 5mm Barb Section
    for (i = [0 : barb5_count - 1]) {
        translate([0, 0, 25 + (i * barb5_height)])
        barb_shape(barb5_base_dia, barb5_top_dia, barb5_height);
    }
}

// Final Assembly
difference() {
    outer_shell();
    
    // The Bore
    // We extend the bore slightly beyond the top and bottom to ensure a clean cut
    translate([0, 0, -1])
    cylinder(h = total_height + 2, d = bore_diameter);
}

// --- Helper Modules ---

module barb_shape(base_d, top_d, h) {
    // Creates a frustum (tapered cylinder)
    // Since the user wants a "sawtooth" profile (taper then step back),
    // the barb_shape represents one single tapered segment.
    // The "step back" is handled by the fact that the next barb starts at a smaller diameter.
    // However, the prompt says "grows linearly... then steps straight back".
    // This implies the barb itself is a frustum.
    
    hull() {
        translate([0, 0, 0])
        cylinder(h = 0.01, d = base_d);
        translate([0, 0, h])
        cylinder(h = 0.01, d = top_d);
    }
}

// Note on the "sawtooth" requirement:
// The prompt describes the profile of the barb. 
// A single barb grows from base to top. 
// The "step back" occurs at the junction between barbs or at the end of a barb.
// My implementation of barb_shape creates the tapered part.
// The loop handles the stacking.