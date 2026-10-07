// Dimensions for the Magnetic Stirrer Housing (Final Correction)

// Overall dimensions
outer_x = 90;  // Outer width of the housing in X direction (mm)
outer_y = 90;  // Outer depth of the housing in Y direction (mm)
top_plate_thickness = 2; // Thickness of the top plate resting on the bed (mm)
wall_thickness = 2.5;    // Thickness of the side walls (mm)
total_height = 40;       // Total height of the housing (mm)

// Screw hole dimensions
screw_diameter = 4.5; // Diameter of the screw holes (mm)
screw_pattern_size = 71.5; // Side length for the square pattern of screw holes (mm)
screw_spacing = 10;    // Spacing between centers of the screw holes (approximate, derived from pattern size)

// Cable notch dimensions
notch_width = 12;      // Width of the power cable notch (mm)
notch_depth = 8;       // Depth of the notch from the open edge (mm)
notch_z_start = total_height - notch_depth; // Z coordinate where the notch starts (40 - 8 = 32)

// --- Main Housing Construction ---

module housing() {
    // 1. Top Plate (Base resting on Z=0 to Z=2)
    translate([0, 0, 0]) {
        cube([outer_x, outer_y, top_plate_thickness]);
    }

    // Define the inner cavity dimensions based on outer size and wall thickness
    inner_x = outer_x - 2 * wall_thickness; // 90 - 5 = 85 mm
    inner_y = outer_y - 2 * wall_thickness; // 90 - 5 = 85 mm

    // 2. Walls (Rising from Z=2 to Z=40)
    
    // Front Wall (X = outer_x/2 - wall_thickness/2, Y = 0)
    translate([outer_x/2 - wall_thickness/2, 0, top_plate_thickness]) {
        cube([wall_thickness, inner_y, total_height - top_plate_thickness]);
    }

    // Back Wall (X = -outer_x/2 + wall_thickness/2, Y = 0)
    translate([-outer_x/2 + wall_thickness/2, 0, top_plate_thickness]) {
        cube([wall_thickness, inner_y, total_height - top_plate_thickness]);
    }

    // Left Wall (X = 0, Y = outer_y/2 - wall_thickness/2)
    translate([0, outer_y/2 - wall_thickness/2, top_plate_thickness]) {
        cube([inner_x, wall_thickness, total_height - top_plate_thickness]);
    }

    // Right Wall (X = outer_x/2, Y = outer_y/2 - wall_thickness/2)
    translate([outer_x/2, outer_y/2 - wall_thickness/2, top_plate_thickness]) {
        cube([inner_x, wall_thickness, total_height - top_plate_thickness]);
    }

    // 3. Cable Notch (Cut into the Right Wall)
    translate([outer_x/2, outer_y/2 - wall_thickness/2, top_plate_thickness]) {
        difference() {
            // The main Right Wall block volume
            cube([inner_x, wall_thickness, total_height - top_plate_thickness]);

            // Cutout shape: A rectangular prism representing the cable path
            translate([0, 0, notch_z_start]) {
                cube([notch_width, wall_thickness, notch_depth]);
            }
        }
    }


    // 4. Screw Holes (On the Top Plate)
    top_plate_center_x = outer_x / 2;
    top_plate_center_y = outer_y / 2;

    // Iterate through the pattern area to place holes
    for (i = [0 : floor(screw_pattern_size / screw_spacing) - 1]) {
        for (j = [0 : floor(screw_pattern_size / screw_spacing) - 1]) {
            
            // Calculate position based on the pattern size and spacing
            x_pos = top_plate_center_x - (screw_pattern_size / 2) + i * screw_spacing;
            y_pos = top_plate_center_y - (screw_pattern_size / 2) + j * screw_spacing;

            // Translate to the top plate level (Z=0) and drill the hole
            translate([x_pos, y_pos, top_plate_thickness]) {
                cylinder(r = screw_diameter / 2, h = 1, $fn = 64); // Drill a small cylinder through the plate
            }
        }
    }
}

housing();