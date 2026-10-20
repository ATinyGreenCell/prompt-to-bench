// Dimensions for DIY Magnetic Stirrer Housing
// Units: mm

// Overall Geometry
outer_size = 90;       // Outer dimensions (X and Y)
wall_thickness = 2.5;  // Thickness of the four walls
top_plate_thickness = 2; // Thickness of the top plate (stirring surface)

// Fan Mounting
fan_mount_hole_dia = 4.5; // Diameter of M4 screw holes
fan_mount_spacing = 71.5; // Distance between mounting holes (square pattern)

// Cable Notch
notch_width = 12;      // Width of the notch
notch_depth = 8;       // Depth of the notch (down from top)
notch_z_start = 32;    // Z coordinate where notch starts (bottom of notch)
notch_z_end = 40;      // Z coordinate where notch ends (top of notch)

// Derived Dimensions
inner_size = outer_size - (2 * wall_thickness); // Inner box dimensions
mount_hole_offset = fan_mount_spacing / 2;      // Offset from center to mounting holes
notch_center_x = outer_size / 2;                // X position of notch center

// Rendering
$fn = 64; // High resolution for curved surfaces

// Main Housing Assembly
module stirrer_housing() {
    union() {
        // 1. Top Plate (Stirring Surface)
        // Positioned at z=0 to z=2
        translate([0, 0, 0])
        difference() {
            // Base plate
            cube([outer_size, outer_size, top_plate_thickness], center=true);
            
            // Cut mounting holes
            for (x = [-mount_hole_offset, mount_hole_offset]) {
                for (y = [-mount_hole_offset, mount_hole_offset]) {
                    translate([x, y, top_plate_thickness / 2])
                    cylinder(d = fan_mount_hole_dia, h = top_plate_thickness + 0.1, center=true);
                }
            }
        }

        // 2. Walls
        // Positioned at z=2 to z=40
        translate([0, 0, top_plate_thickness])
        difference() {
            // Base box walls
            cube([outer_size, outer_size, 40], center=true);
            
            // Cut out the inner cavity
            translate([0, 0, -0.1])
            cube([inner_size, inner_size, 40.2], center=true);
            
            // Cut out the cable notch
            // The notch is centered along the wall. 
            // Assuming the notch is on the +X wall (right side) for this example.
            // The wall is at x = outer_size/2.
            translate([notch_center_x, 0, notch_z_start - top_plate_thickness])
            cube([notch_width, outer_size, notch_z_end - notch_z_start + 0.1], center=true);
        }
    }
}

// Render the part
stirrer_housing();