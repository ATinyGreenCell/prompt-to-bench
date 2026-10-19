// --- Dimensions (mm) ---
collar_diameter = 13.0;      // Diameter of the base collar
collar_thickness = 1.5;      // Height of the base collar
sleeve_outer_diameter = 10.8; // Diameter of the main sleeve body
sleeve_total_height = 21.5;   // Total height from the bed (z=0 to z=21.5)
bore_diameter = 6.2;         // Diameter of the central hole
bore_clearance = 0.1;        // Extra length for cutting to avoid coplanar faces

// --- Constants ---
$fn = 64;

// --- Implementation ---

// The part is printed upside down as requested: 
// The collar lies on the bed (z=0 to 1.5)
// The sleeve rises from the collar to z=21.5

difference() {
    // The solid body
    union() {
        // 1. The Base Collar
        // Rests on the bed at z=0
        cylinder(h = collar_thickness, d = collar_diameter);

        // 2. The Sleeve Body
        // Rises from the top of the collar (z = 1.5) to the total height (z = 21.5)
        // Height of this segment = 21.5 - 1.5 = 20.0
        translate([0, 0, collar_thickness])
            cylinder(h = sleeve_total_height - collar_thickness, d = sleeve_outer_diameter);
    }

    // 3. The Bore (Subtraction)
    // The bore runs through the full height (0 to 21.5)
    // We extend it by bore_clearance on both ends to ensure no thin walls remain at the faces
    translate([0, 0, -bore_clearance])
        cylinder(h = sleeve_total_height + (2 * bore_clearance), d = bore_diameter);
}

// Note on the previous error: 
// The previous code had a logic error where the difference() block was empty 
// and the actual subtraction was placed outside the difference() scope.
// This version correctly wraps the union inside the difference.