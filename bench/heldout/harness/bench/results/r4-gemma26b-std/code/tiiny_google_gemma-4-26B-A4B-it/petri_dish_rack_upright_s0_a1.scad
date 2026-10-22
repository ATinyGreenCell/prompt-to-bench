// --- Dimensions ---
base_length = 203;          // X dimension of the base
base_width = 80;            // Y dimension of the base
base_height = 20;           // Z dimension of the base

dish_radius = 46;           // Radius of the cylinder used to cut the cradle
cradle_z_center = 52;       // Z coordinate of the cylinder axis
cradle_offset = 2;          // Extra length for cutting operations

divider_thickness = 3;       // Thickness of each divider plate
divider_height = 60;        // Height of each divider plate
divider_count = 11;          // Number of divider plates
divider_spacing_x = 20;      // Distance between divider centers

// --- Parameters ---
$fn = 64;

// --- Corrected Assembly Logic ---
// The previous report showed the part was centered at Z=0 (ranging from -10 to 60).
// The instructions state: "it rests on the XY plane at z = 0 and builds upward (+Z)".
// Therefore, the base must be translated so its bottom is at Z=0.
// Base Z range: 0 to 20.
// Divider Z range: 0 to 60.

// We must also ensure the cradle is cut correctly. 
// The cradle axis is at Z = 52. 
// The base is at Z = [0, 20]. 
// The cradle bottom is at 52 - 46 = 6.
// Since 6 is within the [0, 20] range, the cradle will cut into the top of the base.

module base_with_groove() {
    difference() {
        // The base block: translated so bottom is at Z=0
        // Center is at [0, 0, base_height/2]
        translate([0, 0, base_height / 2])
            cube([base_length, base_width, base_height], center = true);
        
        // The cradle cylinder
        // Axis runs along X, at Y=0, Z=52.
        // We translate the cylinder so its axis is at Z=52.
        // Note: The cylinder is subtracted from the base.
        translate([0, 0, cradle_z_center])
            rotate([0, 90, 0])
                cylinder(h = base_length + cradle_offset * 2, r = dish_radius, center = true);
    }
}

module dividers() {
    for (i = [0 : divider_count - 1]) {
        x_pos = -100 + (i * divider_spacing_x);
        // Dividers rise from Z=0 to Z=60.
        // Center is at [x_pos, 0, divider_height/2]
        translate([x_pos, 0, divider_height / 2])
            cube([divider_thickness, base_width, divider_height], center = true);
    }
}

// Final Render
// The union ensures the part is a single solid.
// The dividers are added to the base_with_groove.
// Because the cradle is only subtracted from the base, the dividers remain solid.
union() {
    base_with_groove();
    dividers();
}

// Verification of requirements:
// 1. Base: 203x80x20, centered on XY, bottom at Z=0.
// 2. Cradle: Radius 46, Axis X, Y=0, Z=52. Bottom at Z=6.
// 3. Dividers: 11 plates, 3mm thick, 80mm wide, Z=0 to 60, X = -100 to 100.
// 4. Cradle not cut through dividers: Handled by subtracting cradle only from base.