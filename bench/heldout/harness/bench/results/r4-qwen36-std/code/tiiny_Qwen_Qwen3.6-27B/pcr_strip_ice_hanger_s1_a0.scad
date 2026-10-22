// Dimensions (mm)
wall_thickness = 12;
extrusion_length = 84;
inner_leg_y_start = 0;
inner_leg_y_end = 4;
outer_leg_y_start = 16.5;
outer_leg_y_end = 20.5;
leg_z_start = 0;
leg_z_end = 50;
bridge_z_start = 46;
bridge_z_end = 50;
wall_gap = 12.5;
ledge_thickness = 6;
ledge_y_start = 0;
ledge_y_end = -30;
tube_hole_diameter = 6.4;
tube_spacing = 9;
tube_y_pos = -15;
num_tubes = 8;

// Resolution for curved shapes
$fn = 64;

// Main profile in YZ plane, extruded along X
linear_extrude(height = extrusion_length, center = true, convexity = 10)
union() {
    // Inner leg
    translate([inner_leg_y_start, leg_z_start])
        square([inner_leg_y_end - inner_leg_y_start, leg_z_end - leg_z_start]);
    
    // Outer leg
    translate([outer_leg_y_start, leg_z_start])
        square([outer_leg_y_end - outer_leg_y_start, leg_z_end - leg_z_start]);
    
    // Bridge
    translate([inner_leg_y_start, bridge_z_start])
        square([outer_leg_y_end - inner_leg_y_start, bridge_z_end - bridge_z_start]);
    
    // Ledge
    translate([ledge_y_end, leg_z_start])
        square([inner_leg_y_start - ledge_y_end, ledge_thickness]);
}

// Tube holes: 8 vertical through-holes along X, centered, at y = -15
for (i = [0 : num_tubes - 1]) {
    x_pos = (i - (num_tubes - 1) / 2) * tube_spacing;
    translate([x_pos, tube_y_pos, ledge_thickness / 2])
        cylinder(h = ledge_thickness + 0.02, r = tube_hole_diameter / 2, center = true);
}