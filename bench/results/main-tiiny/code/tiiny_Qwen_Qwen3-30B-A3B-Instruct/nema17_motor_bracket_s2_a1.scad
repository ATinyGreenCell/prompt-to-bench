// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed (z = 0), builds upward

// Dimensions
base_x_min = -25;
base_x_max = 25;
base_y_min = 0;
base_y_max = 45;
base_z = 5;

motor_plate_x_min = -25;
motor_plate_x_max = 25;
motor_plate_y_min = 0;
motor_plate_y_max = 5;
motor_plate_z = 50;

// Hole positions
m4_hole_diameter = 4.5;
m4_hole1_x = -17;
m4_hole1_y = 30;
m4_hole2_x = 17;
m4_hole2_y = 30;

// Motor boss hole
boss_hole_diameter = 23;
boss_hole_center_x = 0;
boss_hole_center_z = 28;

// M3 screw holes for motor mounting
m3_hole_diameter = 3.4;
m3_screw_spacing = 31;
m3_hole_offset = m3_screw_spacing / 2;

// Gussets
gusset_thickness = 5;
gusset_leg_length = 20;
gusset_base_y = 5;
gusset_base_z = 5;

// Set resolution for smooth curves
$fn = 64;

// Main module
module bracket() {
    // Base plate (on XY plane, z = 0 to 5)
    translate([0, 0, 0])
        cube([base_x_max - base_x_min, base_y_max - base_y_min, base_z], center = false);

    // Motor plate (attached to back edge of base plate, y = 0 to 5, z = 0 to 50)
    translate([0, 0, 0])
        cube([motor_plate_x_max - motor_plate_x_min, motor_plate_y_max - motor_plate_y_min, motor_plate_z], center = false);

    // Cut boss hole through both plates (centered at x=0, z=28, y=0 to 5)
    difference() {
        // Union of base and motor plate
        union() {
            translate([0, 0, 0])
                cube([base_x_max - base_x_min, base_y_max - base_y_min, base_z], center = false);
            translate([0, 0, 0])
                cube([motor_plate_x_max - motor_plate_x_min, motor_plate_y_max - motor_plate_y_min, motor_plate_z], center = false);
        }

        // Boss hole: cylinder through both plates
        translate([boss_hole_center_x, 0, boss_hole_center_z])
            cylinder(h = base_z + motor_plate_z + 1, r = boss_hole_diameter / 2, center = true);
    }

    // Cut M3 screw holes through both plates (in a square around boss hole)
    for (i = [0:1:3]) {
        angle = i * 90;
        x_offset = m3_hole_offset * cos(angle * 3.141592653589793 / 180);
        y_offset = m3_hole_offset * sin(angle * 3.141592653589793 / 180);
        hole_x = boss_hole_center_x + x_offset;
        hole_z = boss_hole_center_z + y_offset;

        difference() {
            // Union of base and motor plate
            union() {
                translate([0, 0, 0])
                    cube([base_x_max - base_x_min, base_y_max - base_y_min, base_z], center = false);
                translate([0, 0, 0])
                    cube([motor_plate_x_max - motor_plate_x_min, motor_plate_y_max - motor_plate_y_min, motor_plate_z], center = false);
            }

            // M3 hole: cylinder through both plates
            translate([hole_x, 0, hole_z])
                cylinder(h = base_z + motor_plate_z + 1, r = m3_hole_diameter / 2, center = true);
        }
    }

    // Cut M4 through-holes in base plate (at y = 30, z = 0 to 5)
    difference() {
        // Base plate
        translate([0, 0, 0])
            cube([base_x_max - base_x_min, base_y_max - base_y_min, base_z], center = false);

        // M4 hole 1
        translate([m4_hole1_x, m4_hole1_y, base_z / 2])
            cylinder(h = base_z + 1, r = m4_hole_diameter / 2, center = true);

        // M4 hole 2
        translate([m4_hole2_x, m4_hole2_y, base_z / 2])
            cylinder(h = base_z + 1, r = m4_hole_diameter / 2, center = true);
    }

    // Gussets: right triangle in YZ plane, legs 20mm, thickness 5mm
    // Left gusset: x = -25 to -20, y = 5 to 25, z = 5 to 25
    // Right gusset: x = 20 to 25, y = 5 to 25, z = 5 to 25

    // Left gusset: right triangle in YZ plane, right angle at (y=5, z=5), extending +Y and +Z
    // Use hull to form the triangular prism
    hull() {
        translate([-25, 5, 5]) cube([1, 1, 1], center = false); // corner at (y=5, z=5)
        translate([-25, 5 + gusset_leg_length, 5]) cube([1, 1, 1], center = false); // (y=25, z=5)
        translate([-25, 5, 5 + gusset_leg_length]) cube([1, 1, 1], center = false); // (y=5, z=25)
    }

    // Right gusset: same shape but at x = 20 to 25
    hull() {
        translate([20, 5, 5]) cube([1, 1, 1], center = false);
        translate([20, 5 + gusset_leg_length, 5]) cube([1, 1, 1], center = false);
        translate([20, 5, 5 + gusset_leg_length]) cube([1, 1, 1], center = false);
    }
}

// Render the bracket
bracket();