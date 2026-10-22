// Floating tube holder for seven 15mL conical tubes
// Designed to be printed upside down (skirt/sleeves at Z=0, plate at Z=20)
// Corrected orientation: Flats parallel to X axis.

// --- Dimensions ---
plate_across_flats = 90;    // Hexagon width across flats
plate_thickness    = 3;     // Thickness of the plate
hole_diameter       = 17.5;  // Diameter of the tube holes
sleeve_wall         = 2;     // Wall thickness of sleeves
sleeve_outer_diam    = 21.5; // Diameter of sleeves
sleeve_height        = 20;    // Height of sleeves from plate
skirt_across_flats   = 84;    // Hexagon width across flats for skirt
skirt_wall           = 2;     // Wall thickness of skirt
skirt_height         = 20;    // Height of skirt from plate
hole_circle_diam     = 54;    // Diameter of the circle of holes
num_holes            = 7;    // Total holes (1 center + 6 perimeter)

$fn = 64;

// --- Helper Modules ---

// A regular hexagon defined by its "across flats" dimension
module hexagon_plate(across_flats, height) {
    // Distance from center to vertex (circumradius)
    // r_flat = R * cos(30) => R = r_flat / cos(30)
    r_vertex = (across_flats / 2) / cos(30);
    
    // To have flats parallel to X axis:
    // Standard cylinder(fn=6) has vertices at 0, 60, 120...
    // This means flats are at 30, 90, 150... (Parallel to Y axis)
    // To make flats parallel to X, we rotate by 30 degrees.
    rotate([0, 0, 30])
    cylinder(h = height, d = r_vertex * 2, $fn = 6);
}

// --- Main Construction ---

difference() {
    // The Solid Body
    union() {
        // 1. The Base Plate
        hexagon_plate(plate_across_flats, plate_thickness);
        
        // 2. The Sleeves
        // Center sleeve
        translate([0, 0, plate_thickness])
        cylinder(h = sleeve_height - plate_thickness, d = sleeve_outer_diam);

        // 6 Perimeter sleeves
        for (i = [0 : 5]) {
            angle = i * 60;
            rotate([0, 0, angle])
            translate([hole_circle_diam / 2, 0, plate_thickness])
            cylinder(h = sleeve_height - plate_thickness, d = sleeve_outer_diam);
        }

        // 3. The Hexagonal Skirt
        translate([0, 0, plate_thickness])
        difference() {
            hexagon_plate(skirt_across_flats, skirt_height);
            // Subtract the inner part to create the wall
            hexagon_plate(skirt_across_flats - 2 * skirt_wall, skirt_height + 1);
        }
    }

    // 4. The Holes (Subtraction)
    // Center hole
    translate([0, 0, -1])
    cylinder(h = plate_thickness + 2, d = hole_diameter);

    // Perimeter holes
    for (i = [0 : 5]) {
        angle = i * 60;
        rotate([0, 0, angle])
        translate([hole_circle_diam / 2, 0, -1])
        cylinder(h = plate_thickness + 2, d = hole_diameter);
    }
}