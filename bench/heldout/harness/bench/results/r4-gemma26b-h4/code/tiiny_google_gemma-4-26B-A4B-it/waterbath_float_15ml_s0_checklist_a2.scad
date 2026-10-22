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
// To have flats parallel to X, the distance between top and bottom edges (Y) must be d_flats.
module hexagon_flat(d_flats, height) {
    // Apothem (distance from center to midpoint of side) is d_flats / 2
    // Radius to vertex R = apothem / cos(30)
    r_vertex = (d_flats / 2) / cos(30);
    
    linear_extrude(height = height)
    // To have flats parallel to X, the midpoints of the top/bottom sides must be at 90 and 270 deg.
    // A standard polygon starting at 0 deg has midpoints at 30, 90, 150...
    // Therefore, we rotate the polygon by 30 degrees to align the midpoints with 0, 60, 90... 
    // Wait, if midpoints are at 90 and 270, the flat is horizontal (parallel to X).
    // Standard polygon (0, 60, 120...) has midpoints at 30, 90, 150...
    // So we rotate by 30 degrees to move the 90 degree midpoint to 120 or 60? 
    // Let's use the explicit vertex positions for a hexagon with flats parallel to X.
    // Vertices for a hexagon with flats parallel to X:
    // The midpoints are at 90 and 270.
    // The vertices are at 30, 90+60=150, 150+60=210, 210+60=270... no.
    // If midpoints are at 90 and 270, vertices are at 0, 60, 120, 180, 240, 300.
    // Let's check: midpoint of 0 and 60 is 30. Midpoint of 60 and 120 is 90.
    // Yes! If vertices are at 0, 60, 120, 180, 240, 300, the midpoints are at 30, 90, 150...
    // A midpoint at 90 means a horizontal flat (parallel to X).
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
    // Using the corrected hexagon_flat which places flats parallel to X
    translate([0, 0, 0])
    linear_extrude(height = plate_thickness)
    hexagon_flat(plate_across_flats, 1);

    // 2. The Sleeves and Skirt
    difference() {
        union() {
            // The Hexagonal Skirt
            translate([0, 0, plate_thickness])
            linear_extrude(height = tube_sleeve_h)
            hexagon_flat(skirt_across_flats, 1);

            // The Seven Sleeves
            // Center sleeve
            translate([0, 0, plate_thickness])
            cylinder(h = tube_sleeve_h, d = tube_sleeve_od);

            // Six peripheral sleeves
            for (i = [0 : 5]) {
                angle = i * 60;
                rotate([0, 0, angle])
                translate([circle_dia / 2, 0, plate_thickness])
                cylinder(h = tube_sleeve_h, d = tube_sleeve_od);
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