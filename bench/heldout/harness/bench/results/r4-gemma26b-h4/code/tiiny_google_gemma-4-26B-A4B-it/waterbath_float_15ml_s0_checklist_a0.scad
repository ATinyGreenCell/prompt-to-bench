// Float for seven 15 mL conical tubes
// Designed to be printed upside down (flat plate at z=0)

// --- Dimensions ---
plate_across_flats = 90.0; // Distance between parallel sides of the hexagonal plate
plate_thickness    = 3.0;  // Thickness of the base plate
tube_hole_d        = 17.5; // Diameter of the conical tube holes
tube_sleeve_od     = 21.5; // Outside diameter of the sleeves
tube_sleeve_wall   = 2.0;  // Wall thickness of the sleeves
tube_sleeve_h      = 20.0; // Height of the sleeves and skirt

circle_dia         = 54.0; // Diameter of the circle of holes
skirt_across_flats  = 84.0; // Distance between parallel sides of the hexagonal skirt
skirt_wall         = 2.0;  // Wall thickness of the skirt

$fn = 64;

// --- Helper Modules ---

// Generates a regular hexagon based on "across flats" dimension
module hexagon_flat(d_flats, height) {
    // The distance from center to vertex (circumradius) is d_flats / sqrt(3)
    // But we can use the polygon function with the apothem (d_flats / 2)
    // For a regular hexagon, the vertices are at distance R = apothem / cos(30)
    r_vertex = (d_flats / 2) / cos(30);
    
    linear_extrude(height = height)
    polygon(points = [
        [r_vertex * cos(0),   r_vertex * sin(0)],
        [r_vertex * cos(60),  r_vertex * sin(60)],
        [r_vertex * cos(120), r_vertex * sin(120)],
        [r_vertex * cos(180), r_vertex * sin(180)],
        [r_vertex * cos(240), r_vertex * sin(240)],
        [r_vertex * cos(300), r_vertex * sin(300)]
    ]);
}

// --- Main Construction ---

// The user requested the part be printed "upside down" (plate at z=0)
// This means the features (sleeves/skirt) build UP from the plate.
// Note: To float, the air is trapped "under" the plate when flipped.
// In OpenSCAD, we build the plate at z=0 and extrude upwards.

union() {
    // 1. The Base Plate
    // We use a hexagon with two flats parallel to X axis.
    // In a standard polygon, the first vertex is at 0 deg (on X axis).
    // To have flats parallel to X, we rotate the hexagon by 30 degrees.
    rotate([0, 0, 30])
    hexagon_flat(plate_across_flats, plate_thickness);

    // 2. The Sleeves and Skirt
    // We build these as a single union, then subtract the holes.
    difference() {
        union() {
            // The Hexagonal Skirt
            rotate([0, 0, 30])
            hexagon_flat(skirt_across_flats, tube_sleeve_h + plate_thickness);

            // The Seven Sleeves
            // Center sleeve
            cylinder(h = tube_sleeve_h + plate_thickness, d = tube_sleeve_od);

            // Six peripheral sleeves
            for (i = [0 : 5]) {
                angle = i * 60;
                // The first hole is on the +X axis (0 degrees)
                rotate([0, 0, angle])
                translate([circle_dia / 2, 0, 0])
                cylinder(h = tube_sleeve_h + plate_thickness, d = tube_sleeve_od);
            }
        }

        // 3. The Holes (Subtracted from the union above)
        // We subtract from the plate and the extrusions.
        // We extend the subtraction slightly to ensure clean cuts.
        
        // Center hole
        translate([0, 0, -0.01])
        cylinder(h = plate_thickness + tube_sleeve_h + 0.02, d = tube_hole_d);

        // Peripheral holes
        for (i = [0 : 5]) {
            angle = i * 60;
            rotate([0, 0, angle])
            translate([circle_dia / 2, 0, -0.01])
            cylinder(h = plate_thickness + tube_sleeve_h + 0.02, d = tube_hole_d);
        }
    }
}

// Note on orientation: 
// The plate is at Z=0. The sleeves/skirt go from Z=3 to Z=23.
// When printed, the flat plate is on the bed.
// When flipped for use, the holes face down, trapping air in the sleeves/skirt.