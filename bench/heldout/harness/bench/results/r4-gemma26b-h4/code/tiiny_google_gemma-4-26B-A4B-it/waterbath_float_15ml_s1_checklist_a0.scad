// Floating tube holder for seven 15mL conical tubes
// Designed to be printed upside down (skirt/sleeves at Z=0, plate at Z=20)
// Note: The user requested the plate to lie on the bed (z=0 to 3), 
// but also stated it is "printed upside down" to trap air.
// To ensure the part is printed correctly for the intended function (air trapped),
// I will model it such that the flat plate is at the TOP (Z=20) and the 
// hollow features (skirt and sleeves) are at the BOTTOM (Z=0), 
// so the user can print it with the flat plate on the bed if they prefer, 
// OR I will follow the literal instruction: "A flat plate... lies on the bed (z=0 to 3)".
// Re-reading: "Flipped for use, the skirt and sleeves trap air under the plate".
// This means the plate must be the bottom surface when floating.
// To achieve this in FDM, the plate should be printed on the bed (Z=0) 
// and the features grow upwards, then the whole thing is flipped.
// However, the prompt says "printed upside down" AND "plate lies on the bed".
// This is a contradiction. I will follow the geometric description:
// Plate at Z=0 to 3, features rising to Z=20.

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
num_holes            = 7;     // Total holes (1 center + 6 perimeter)

$fn = 64;

// --- Helper Modules ---

// A regular hexagon defined by its "across flats" dimension
module hexagon_plate(across_flats, height) {
    // Distance from center to vertex (circumradius)
    // r_flat = R * cos(30) => R = r_flat / cos(30)
    r_vertex = (across_flats / 2) / cos(30);
    
    // To align flats parallel to X axis, we rotate the hexagon
    // A standard hexagon has vertices at 0, 60, 120...
    // To have a flat on top/bottom (parallel to X), we rotate 30 degrees.
    rotate([0, 0, 30])
    cylinder(h = height, d = r_vertex * 2, $fn = 6);
}

// --- Main Construction ---

// We build the part such that the plate is at Z=0 to 3
// and the features rise to Z=20.
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
        // The first hole is on the +X axis
        rotate([0, 0, angle])
        translate([hole_circle_diam / 2, 0, plate_thickness])
        cylinder(h = sleeve_height - plate_thickness, d = sleeve_outer_diam);
    }

    // 3. The Hexagonal Skirt
    // The skirt is a hollow hexagon. We create it using a difference of two hexagons.
    // The skirt is 84mm across flats.
    translate([0, 0, plate_thickness])
    difference() {
        hexagon_plate(skirt_across_flats, skirt_height);
        // Subtract the inner part to create the wall
        // The wall is 2mm, so the inner across-flats is 84 - (2*2) = 80? 
        // No, "2mm wall" usually means the thickness of the shell.
        // If the outer is 84, the inner is 84 - 2*2 = 80.
        hexagon_plate(skirt_across_flats - 2 * skirt_wall, skirt_height + 1);
    }
}

// 4. The Holes (Subtraction)
// We subtract the holes from the entire assembly
difference() {
    // We wrap the whole thing in a dummy union to ensure difference works on the whole object
    // But in OpenSCAD, it's cleaner to just subtract from the union above.
    // Let's redefine the structure to be cleaner.
}

// --- Final Corrected Structure ---

difference() {
    // The Solid Body
    union() {
        // Plate
        hexagon_plate(plate_across_flats, plate_thickness);
        
        // Sleeves
        translate([0, 0, plate_thickness])
        cylinder(h = sleeve_height - plate_thickness, d = sleeve_outer_diam);
        
        for (i = [0 : 5]) {
            rotate([0, 0, i * 60])
            translate([hole_circle_diam / 2, 0, plate_thickness])
            cylinder(h = sleeve_height - plate_thickness, d = sleeve_outer_diam);
        }
        
        // Skirt
        translate([0, 0, plate_thickness])
        difference() {
            hexagon_plate(skirt_across_flats, skirt_height);
            hexagon_plate(skirt_across_flats - 2 * skirt_wall, skirt_height + 1);
        }
    }

    // The Holes (Cuts)
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