// Dimensions for NEMA 17 L-shaped mounting bracket
// Base plate dimensions
base_width = 50;       // X extent: -25 to 25
base_depth = 45;      // Y extent: 0 to 45
base_height = 5;       // Z extent: 0 to 5

// Base plate hole positions
hole1_x = -17;
hole1_y = 30;
hole2_x = 17;
hole2_y = 30;
hole_diameter = 4.5;   // M4 clearance

// Vertical motor plate dimensions
motor_plate_width = 50; // X extent: -25 to 25
motor_plate_depth = 5; // Y extent: 0 to 5
motor_plate_height = 50; // Z extent: 0 to 50

// Motor boss hole
boss_hole_diameter = 23;
boss_center_x = 0;
boss_center_z = 28;

// M3 screw holes
screw_hole_diameter = 3.4;
screw_pattern_size = 31; // Square pattern size
screw_pattern_center_x = 0;
screw_pattern_center_z = 28;

// Gusset dimensions
gusset_thickness = 5;
gusset_leg_y = 20;
gusset_leg_z = 20;
gusset_corner_y = 5;
gusset_corner_z = 5;

// Main union of solid parts
main_part = union(
    // Base plate
    translate([0, base_depth/2, base_height/2])
        cube([base_width, base_depth, base_height], center = true),
    
    // Vertical motor plate
    translate([0, motor_plate_depth/2, motor_plate_height/2])
        cube([motor_plate_width, motor_plate_depth, motor_plate_height], center = true),
    
    // Left gusset (right triangle in YZ plane, extruded in X)
    // Triangle vertices: (y=5, z=5) corner, (y=25, z=5) leg, (y=5, z=25) leg
    translate([-22.5, 5, 5])
        rotate([0, 0, 0])
        linear_extrude(height = gusset_thickness)
        polygon([[0, 0], [0, gusset_leg_y], [gusset_leg_z, gusset_leg_y]]),
    
    // Right gusset (right triangle in YZ plane, extruded in X)
    translate([22.5, 5, 5])
        rotate([0, 0, 0])
        linear_extrude(height = gusset_thickness)
        polygon([[0, 0], [0, gusset_leg_y], [gusset_leg_z, gusset_leg_y]])
);

// Subtract holes from the main part
result = difference() {
    main_part;
    
    // Base plate M4 holes (through holes)
    for (x_pos = [hole1_x, hole2_x]) {
        translate([x_pos, hole1_y, 0])
            cylinder(d = hole_diameter, h = base_height + 1, center = false);
    }
    
    // Motor plate boss hole (through Y)
    translate([boss_center_x, 0, boss_center_z])
        cylinder(d = boss_hole_diameter, h = motor_plate_depth + 1, center = false);
    
    // Motor plate M3 screw holes (through Y)
    // Pattern: 31mm square centered at (0, 28)
    // Holes at +/- 15.5 from center
    for (x_off = [-15.5, 15.5]) {
        for (z_off = [-15.5, 15.5]) {
            translate([boss_center_x + x_off, 0, boss_center_z + z_off])
                cylinder(d = screw_hole_diameter, h = motor_plate_depth + 1, center = false);
        }
    }
};

// Render the final part
render() {
    translate([0, 0, 0])
        color("blue")
        result;
}