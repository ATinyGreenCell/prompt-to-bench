// Float for seven 15 mL conical tubes
// Dimensions measured with calipers

// Plate dimensions
plate_across_flats = 90;   // mm, across flats
plate_thickness = 3;       // mm, z = 0 to 3
plate_wall = 2;            // mm, skirt wall thickness

// Hole dimensions
hole_diameter = 17.5;      // mm, through-hole diameter
hole_radius = hole_diameter / 2;
sleeve_wall = 2;           // mm, sleeve wall thickness
sleeve_outer_diameter = hole_diameter + 2 * sleeve_wall; // 21.5 mm
sleeve_height = 20;        // mm, sleeve rises to z = 20

// Hole positions
center_hole_offset = 0;    // mm, from origin
circle_diameter = 54;      // mm, diameter of circle for six outer holes
circle_radius = circle_diameter / 2; // 27 mm

// Skirt dimensions
skirt_across_flats = 84;   // mm, across flats outside (3 mm in from plate edge)
skirt_height = 20;         // mm, rises to z = 20

// Quality
$fn = 64;

// Helper: regular hexagon across flats, two flats parallel to X axis
module hex_across_flats(across_flats, height) {
    // A hexagon with two flats parallel to X axis has vertices at angles
    // 30, 90, 150, 210, 270, 330 degrees from the center.
    // The distance from center to each flat is across_flats/2.
    // The distance from center to each vertex is across_flats / sqrt(3).
    r = across_flats / sqrt(3);
    linear_extrude(height = height, convexity = 10)
    polygon(points = [
        [r * cos(30),  r * sin(30)],
        [r * cos(90),  r * sin(90)],
        [r * cos(150), r * sin(150)],
        [r * cos(210), r * sin(210)],
        [r * cos(270), r * sin(270)],
        [r * cos(330), r * sin(330)]
    ]);
}

// Build the float
difference() {
    // Solid plate
    hex_across_flats(plate_across_flats, plate_thickness);

    // Solid skirt (hexagonal, 2 mm wall, 84 mm across flats outside)
    // The skirt is a hollow hexagonal prism.
    // Outer hexagon: 84 mm across flats
    // Inner hexagon: 84 - 2*2 = 80 mm across flats
    translate([0, 0, 0])
    hex_across_flats(skirt_across_flats, skirt_height);

    // Remove the inner part of the skirt to make it hollow (2 mm wall)
    // Inner across flats = 84 - 2*2 = 80
    inner_skirt_across_flats = skirt_across_flats - 2 * plate_wall;
    translate([0, 0, -0.01]) // extend slightly below to ensure clean cut
    hex_across_flats(inner_skirt_across_flats, skirt_height + 0.02);

    // Solid sleeves around each hole
    // Seven sleeves: one at center, six on 54 mm diameter circle
    // Sleeve outer diameter = 21.5 mm, height = 20 mm
    // Sleeve inner diameter = 17.5 mm (matches hole)
    
    // Center sleeve
    translate([0, 0, 0])
    cylinder(h = sleeve_height, r = sleeve_outer_diameter / 2, $fn = $fn);

    // Six outer sleeves
    for (i = [0:5]) {
        angle = i * 60; // degrees, first on +X axis
        x = circle_radius * cos(angle);
        y = circle_radius * sin(angle);
        translate([x, y, 0])
        cylinder(h = sleeve_height, r = sleeve_outer_diameter / 2, $fn = $fn);
    }

    // Cut through-holes in the plate (17.5 mm diameter)
    // Center hole
    translate([0, 0, -0.01])
    cylinder(h = plate_thickness + 0.02, r = hole_radius, $fn = $fn);

    // Six outer holes
    for (i = [0:5]) {
        angle = i * 60;
        x = circle_radius * cos(angle);
        y = circle_radius * sin(angle);
        translate([x, y, -0.01])
        cylinder(h = plate_thickness + 0.02, r = hole_radius, $fn = $fn);
    }

    // Cut out the inside of the sleeves (to make them hollow with 2 mm wall)
    // Center sleeve inner cut
    translate([0, 0, -0.01])
    cylinder(h = sleeve_height + 0.02, r = hole_radius, $fn = $fn);

    // Six outer sleeve inner cuts
    for (i = [0:5]) {
        angle = i * 60;
        x = circle_radius * cos(angle);
        y = circle_radius * sin(angle);
        translate([x, y, -0.01])
        cylinder(h = sleeve_height + 0.02, r = hole_radius, $fn = $fn);
    }
}