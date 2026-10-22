// Float for seven 15 mL conical tubes
// Designed to be printed upside down (flat plate on bed)

// General settings
$fn = 64;

// Plate dimensions
plate_across_flats = 90; // mm, across the flats
plate_thickness = 3; // mm

// Hole dimensions
hole_diameter = 17.5; // mm
hole_radius = hole_diameter / 2;
num_holes = 7;
hole_circle_diameter = 54; // mm, diameter of the circle on which the 6 outer holes lie
hole_circle_radius = hole_circle_diameter / 2;

// Sleeve dimensions
sleeve_wall = 2; // mm
sleeve_outer_diameter = hole_diameter + 2 * sleeve_wall; // 21.5 mm
sleeve_outer_radius = sleeve_outer_diameter / 2;
sleeve_height = 20; // mm

// Skirt dimensions
skirt_wall = 2; // mm
skirt_across_flats_outer = 84; // mm, across the flats (3 mm in from plate edge)
skirt_height = 20; // mm

// Derived values
plate_radius = plate_across_flats / 2; // 45 mm
skirt_radius = skirt_across_flats_outer / 2; // 42 mm

// Build the float
union() {
    // Flat hexagonal plate at z = 0 to 3
    // Rotate 30 degrees so that two flats are parallel to the X axis
    linear_extrude(height = plate_thickness, convexity = 10)
        rotate([0, 0, 30])
        circle(r = plate_radius, $fn = 6);

    // Hexagonal skirt rising from plate to z = 20
    // The skirt is a hollow hexagonal prism
    // Rotate 30 degrees so that sides are parallel to the plate's
    translate([0, 0, plate_thickness])
        linear_extrude(height = skirt_height, convexity = 10)
            rotate([0, 0, 30])
            difference() {
                circle(r = skirt_radius, $fn = 6);
                circle(r = skirt_radius - skirt_wall, $fn = 6);
            }

    // Seven sleeves rising from plate to z = 20
    // One at center, six on a 54 mm diameter circle
    for (i = [0 : num_holes - 1]) {
        if (i == 0) {
            // Center hole
            translate([0, 0, plate_thickness])
                linear_extrude(height = sleeve_height, convexity = 10)
                    difference() {
                        circle(r = sleeve_outer_radius, $fn = 64);
                        circle(r = hole_radius, $fn = 64);
                    }
        } else {
            // Outer holes: 60 degrees apart, first on +X axis
            angle = (i - 1) * 60;
            x = hole_circle_radius * cos(angle);
            y = hole_circle_radius * sin(angle);
            translate([x, y, plate_thickness])
                linear_extrude(height = sleeve_height, convexity = 10)
                    difference() {
                        circle(r = sleeve_outer_radius, $fn = 64);
                        circle(r = hole_radius, $fn = 64);
                    }
        }
    }
}