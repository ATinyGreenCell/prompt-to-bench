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
    // Two flats parallel to X axis means the hexagon is oriented with points at +/-90 deg (Y axis)
    // and flats at +/-30, +/-150 deg. 
    // A regular hexagon defined by circle(r, $fn=6) has a flat at 0 degrees by default.
    // To have flats parallel to X, we need the flat to be horizontal.
    // Default circle($fn=6) has vertices at 0, 60, 120... so flats are at 30, 90, 150...
    // Wait, circle($fn=6) in OpenSCAD creates a hexagon with a vertex at (r, 0).
    // The flats are perpendicular to the vertices. So flat normals are at 30, 90, 150...
    // A flat parallel to X has a normal parallel to Y (90 or 270).
    // So the default orientation already has flats parallel to X?
    // Let's check: Vertex at 0 deg -> (r, 0). Next vertex at 60 deg.
    // The edge between 0 and 60 is not a flat face of the polygon approximation?
    // No, $fn=6 creates 6 vertices. The edges connect them.
    // Vertices: 0, 60, 120, 180, 240, 300.
    // Edges: 0-60, 60-120, 120-180, 180-240, 240-300, 300-0.
    // Edge 60-120 is vertical? No.
    // Midpoint of 60 and 120 is at 90 deg. The edge is perpendicular to 90 deg. So it is horizontal (parallel to X).
    // So the default circle($fn=6) has two flats parallel to X.
    // Therefore, NO rotation is needed for the plate.
    linear_extrude(height = plate_thickness, convexity = 10)
        circle(r = plate_radius, $fn = 6);

    // Hexagonal skirt rising from plate to z = 20
    // Sides parallel to the plate's.
    // Same logic: default circle($fn=6) has sides parallel to X and Y?
    // Flats are at 30, 90, 150, 210, 270, 330 degrees relative to center?
    // No, the normals are at 30, 90, 150...
    // Normal at 90 is Y. So the face is perpendicular to Y, i.e., parallel to X.
    // Normal at 30 is ... face is perpendicular to 30 deg.
    // The plate has flats parallel to X. The skirt should have sides parallel to the plate's.
    // So the skirt should also have flats parallel to X.
    // Default circle($fn=6) works.
    translate([0, 0, plate_thickness])
        linear_extrude(height = skirt_height, convexity = 10)
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