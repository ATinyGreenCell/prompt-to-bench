// Float for seven 15 mL conical tubes
// Designed to be printed upside down (plate on bed, features rising in +Z)

// --- Dimensions ---
plate_across_flats = 90.0;    // Hexagon plate width (flat-to-flat)
plate_thickness    = 3.0;     // Thickness of the base plate
tube_hole_d        = 17.5;    // Diameter of the conical tube holes
tube_sleeve_od     = 21.5;    // Outside diameter of the tube sleeves
sleeve_wall        = 2.0;     // Wall thickness of the sleeves
sleeve_height      = 20.0;    // Height of sleeves and skirt from the plate
tube_circle_d      = 54.0;    // Diameter of the circle passing through tube centers
skirt_across_flats  = 84.0;    // Width of the hexagonal skirt (flat-to-flat)
skirt_wall         = 2.0;     // Wall thickness of the skirt

$fn = 64;

// --- Helper Modules ---

// Generates a regular hexagon centered at origin
module hexagon(across_flats, height) {
    // Distance from center to vertex (circumradius) for a hexagon
    // across_flats = 2 * r * cos(30) => r = across_flats / sqrt(3)
    r_vertex = across_flats / cos(30);
    
    rotate([0, 0, 0])
    linear_extrude(height = height)
    for (i = [0 : 5]) {
        rotate([0, 0, i * 60])
        polygon(points = [[0, r_vertex], [r_vertex * cos(60), r_vertex * sin(60)], [r_vertex * cos(60), -r_vertex * sin(60)]]);
    }
}

// A more robust hexagon module using the polygon method
module hex_shape(across_flats, height) {
    r_vertex = across_flats / cos(30);
    linear_extrude(height = height)
    for (i = [0 : 5]) {
        rotate([0, 0, i * 60])
        polygon(points = [[0, r_vertex], [r_vertex * cos(60), r_vertex * sin(60)], [r_vertex * cos(60), -r_vertex * sin(60)]]);
    }
}

// Corrected Hexagon: A regular hexagon with flat sides parallel to X axis
// This means the vertices are at angles 30, 90, 150, etc.
module regular_hexagon(across_flats, height) {
    // Distance from center to midpoint of side (apothem) is across_flats / 2
    // r_vertex = apothem / cos(30)
    r_vertex = (across_flats / 2) / cos(30);
    
    linear_extrude(height = height)
    for (i = [0 : 5]) {
        rotate([0, 0, i * 60 + 30]) // Rotate by 30 to make flats parallel to X
        polygon(points = [[0, r_vertex], [r_vertex * cos(60), r_vertex * sin(60)], [r_vertex * cos(60), -r_vertex * sin(60)]]);
    }
}

// --- Main Construction ---

// Note: The user requested the plate to lie on the bed (z=0 to 3)
// and features to rise to z=20.

union() {
    // 1. The Base Plate
    // We use a hexagon with flats parallel to X.
    // To ensure the plate is a solid hexagon, we use the polygon method.
    difference() {
        // Create the solid plate
        rotate([0, 0, 30]) // Rotate to align flats with X axis
        cylinder(h = plate_thickness, d = plate_across_flats / cos(30), $fn = 6);
        
        // Note: The above is a simplification. Let's use the precise polygon method.
    }
    
    // Let's rebuild the plate properly to ensure exact dimensions
    // A hexagon with across_flats = 90 and flats parallel to X
    // The vertices are at 30, 90, 150, 210, 270, 330 degrees.
    
    // Actual Plate
    translate([0, 0, 0])
    rotate([0, 0, 30])
    cylinder(h = plate_thickness, d = plate_across_flats / cos(30), $fn = 6);

    // 2. The Sleeves and Skirt (Rising from the plate)
    // Since the plate is at z=0 to 3, features start at z=3 and go to z=23
    // However, the prompt says "rises from the plate to z=20". 
    // This implies the total height from Z=0 is 20.
    
    // Let's define the feature height as 20 - 3 = 17.
    feature_h = 20 - plate_thickness;

    // The Skirt
    translate([0, 0, plate_thickness])
    rotate([0, 0, 30])
    cylinder(h = feature_h, d = skirt_across_flats / cos(30), $fn = 6);

    // The Sleeves
    // One center, six on a circle of diameter 54 (radius 27)
    // First one on +X axis (0 degrees)
    for (a = [0, 60, 120, 180, 240, 300]) {
        translate([27 * cos(a), 27 * sin(a), plate_thickness])
        cylinder(h = feature_h, d = tube_sleeve_od, $fn = 64);
    }
    
    // Center sleeve
    translate([0, 0, plate_thickness])
    cylinder(h = feature_h, d = tube_sleeve_od, $fn = 64);
}

// 3. Subtract the holes
difference() {
    // We wrap the whole thing in a difference to cut the holes
    // But the prompt says "It has seven 17.5 mm through-holes"
    // This means the holes go through the plate AND the sleeves.
    
    // We need to re-structure to ensure the holes are cut through the entire assembly.
    // Let's use a clean structure.
}

// --- RE-STRUCTURED FINAL MODEL ---

module final_part() {
    difference() {
        // The Solid Body
        union() {
            // Plate
            rotate([0, 0, 30])
            cylinder(h = plate_thickness, d = plate_across_flats / cos(30), $fn = 6);
            
            // Skirt
            translate([0, 0, plate_thickness])
            rotate([0, 0, 30])
            cylinder(h = 20 - plate_thickness, d = skirt_across_flats / cos(30), $fn = 6);
            
            // Sleeves
            // Center
            translate([0, 0, plate_thickness])
            cylinder(h = 20 - plate_thickness, d = tube_sleeve_od, $fn = 64);
            
            // Perimeter Sleeves
            for (a = [0, 60, 120, 180, 240, 300]) {
                translate([tube_circle_d/2 * cos(a), tube_circle_d/2 * sin(a), plate_thickness])
                cylinder(h = 20 - plate_thickness, d = tube_sleeve_od, $fn = 64);
            }
        }

        // The Holes (Cutting through the entire height of 20mm)
        // Center hole
        translate([0, 0, -1])
        cylinder(h = plate_thickness + 2, d = tube_hole_d, $fn = 64);
        
        // Perimeter holes
        for (a = [0, 60, 120, 180, 240, 300]) {
            translate([tube_circle_d/2 * cos(a), tube_circle_d/2 * sin(a), -1])
            cylinder(h = plate_thickness + 2, d = tube_hole_d, $fn =