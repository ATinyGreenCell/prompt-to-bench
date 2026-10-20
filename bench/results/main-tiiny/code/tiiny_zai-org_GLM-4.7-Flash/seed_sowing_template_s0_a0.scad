// Sowing Template for 90 mm Petri Dish
// Units: mm

// Dimensions
dish_diameter = 90;      // Outer diameter of the Petri dish
disc_diameter = 85;      // Diameter of the template disc
disc_thickness = 2;      // Thickness of the template
hole_diameter = 3;       // Diameter of the sowing holes
hole_spacing = 9;        // Centre-to-centre spacing of the holes
notch_width = 10;        // Width of the orientation notch (X axis)
notch_depth = 4;         // Depth of the orientation notch (Y axis, measured in from rim)

// Derived Dimensions
rim_thickness = (dish_diameter - disc_diameter) / 2; // 2.5 mm
hole_radius = hole_diameter / 2;
notch_half_width = notch_width / 2;

// Settings
$fn = 64;

module sowing_template() {
    union() {
        // Main Disc
        translate([0, 0, disc_thickness / 2])
            cylinder(h = disc_thickness, d = disc_diameter, center = true);

        // Orientation Notch (Cut into the rim)
        // Positioned at +Y, centered on Y axis
        translate([0, (disc_diameter / 2) - notch_depth, 0])
            cube([notch_width, notch_depth, disc_thickness + 1], center = true);

        // Grid of Through-Holes
        // Calculate offset from center to start the grid
        let (offset = (hole_spacing * 3) / 2) {
            for (x = [-offset, 0, offset]) {
                for (y = [-offset, 0, offset]) {
                    translate([x, y, disc_thickness / 2])
                        cylinder(h = disc_thickness + 0.1, d = hole_diameter, center = true);
                }
            }
        }
    }
}

sowing_template();