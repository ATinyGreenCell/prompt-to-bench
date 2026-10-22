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
// To ensure flats are parallel to X, we define the polygon such that 
// the distance between top and bottom edges is d_flats.
module hexagon_flat(d_flats, height) {
    // Apothem (distance from center to midpoint of side) is d_flats / 2
    // Radius to vertex R = apothem / cos(30)
    r_vertex = (d_flats / 2) / cos(30);
    
    linear_extrude(height = height)
    // To have flats parallel to X, the vertices should be at 30, 90, 150...
    // This places the midpoints of the sides at 0, 60, 120... (on the X axis)
    // Wait, if midpoints are on X axis, flats are parallel to Y.
    // To have flats parallel to X, midpoints must be at 90, 270...
    // So we rotate the standard polygon by 30 degrees.
    rotate([0, 0, 30])
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

union() {
    // 1. The Base Plate
    // The hexagon_flat module already includes the 30 deg rotation to ensure 
    // the flats are parallel to the X axis.
    hexagon_flat(plate_across_flats, plate_thickness);

    // 2. The Sleeves and Skirt
    difference() {
        union() {
            // The Hexagonal Skirt
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

        // 3. The Holes
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