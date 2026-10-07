// Dimensions in millimetres
$fn = 64;
DIMENSIONS = {
    outer_width = 90;       // Outer box width/length
    outer_height = 40;      // Box height (wall thickness + open depth)
    top_plate_thickness = 2; // Top plate material thickness
    wall_thickness = 2.5;   // Wall material thickness
    screw_hole_diameter = 4.5;
    screw_pattern_side = 71.5; // Square pattern for M4 screws (top plate)
    notch_width = 12;       // Cable notch width
    notch_depth = 8;        // Cable notch depth from open edge
};

// Top plate with M4 screw holes
module top_plate() {
    translate([0, 0, -top_plate_thickness / 2]) {
        difference() {
            cube([outer_width, outer_height, top_plate_thickness]);

            // Cut out screw hole pattern (slightly oversized to avoid coplanar cuts)
            for (x = -screw_pattern_side/2 + screw_hole_diameter/2: screw_pattern_side/2: screw_hole_diameter) {
                for (y = -screw_pattern_side/2 + screw_hole_diameter/2: screw_pattern_side/2: screw_hole_diameter) {
                    translate([x, y, 0]) {
                        cylinder(d=1.5, h=top_plate_thickness + 0.2);
                    }
                }
            }
        }
    }
}

// Wall with cable notch
module wall_with_notch() {
    translate([outer_width / 2, outer_height / 2, -wall_thickness / 2]) {
        difference() {
            // Main wall (slightly oversized)
            cube([outer_width, outer_height + wall_thickness, wall_thickness]);

            // Cable notch
            translate([0, 0, wall_thickness]) { // Move to top of wall
                cylinder(d=notch_width/2 + 0.1, h=notch_depth);
            }
        }
    }
}

// Create all walls (left, right, front, back)
module create_walls() {
    // Left and right walls
    for (side = -outer_height: outer_height: outer_height) {
        translate([-outer_width/2, side, 0]) {
            wall_with_notch();
        }
        translate([outer_width/2, side, 0]) {
            wall_with_notch();
        }
    }

    // Front and back walls (mirrored)
    for (side = -outer_height: outer_height: outer_height) {
        translate([0, side, 0]) {
            mirror([1, 1, 0]) { wall_with_notch() };
        }
    }
}

// Combine top plate and walls
union() {
    top_plate();
    create_walls();
}