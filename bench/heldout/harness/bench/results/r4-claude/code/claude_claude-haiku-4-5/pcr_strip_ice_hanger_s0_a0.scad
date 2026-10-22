// PCR Strip Holder for Ice Bucket
// Units: mm

// Extrusion length (along X, centered at origin)
extrusion_length = 84;

// Inner leg (toward ice/inside bucket)
inner_leg_y_min = 0;
inner_leg_y_max = 4;
inner_leg_height = 50;

// Outer leg (outside bucket)
outer_leg_y_min = 16.5;
outer_leg_y_max = 20.5;
outer_leg_height = 50;

// Bridge at top (rests on bucket wall)
bridge_z_min = 46;
bridge_z_max = 50;

// Ledge (extends into ice, holds tubes)
ledge_y_min = -30;
ledge_y_max = 0;
ledge_thickness = 6;

// PCR tube holes (8 tubes, 9 mm apart, centered)
hole_diameter = 6.4;
hole_spacing = 9;
num_holes = 8;
hole_y = -15;

difference() {
    union() {
        // Inner leg
        translate([0, (inner_leg_y_min + inner_leg_y_max) / 2, inner_leg_height / 2]) {
            cube([extrusion_length, inner_leg_y_max - inner_leg_y_min, inner_leg_height], center = true);
        }
        
        // Outer leg
        translate([0, (outer_leg_y_min + outer_leg_y_max) / 2, outer_leg_height / 2]) {
            cube([extrusion_length, outer_leg_y_max - outer_leg_y_min, outer_leg_height], center = true);
        }
        
        // Bridge connecting legs at top
        translate([0, (inner_leg_y_max + outer_leg_y_min) / 2, (bridge_z_min + bridge_z_max) / 2]) {
            cube([extrusion_length, outer_leg_y_min - inner_leg_y_max, bridge_z_max - bridge_z_min], center = true);
        }
        
        // Ledge into ice
        translate([0, (ledge_y_min + ledge_y_max) / 2, ledge_thickness / 2]) {
            cube([extrusion_length, ledge_y_max - ledge_y_min, ledge_thickness], center = true);
        }
    }
    
    // Cut tube holes
    for (i = [0 : num_holes - 1]) {
        x_pos = (i - (num_holes - 1) / 2) * hole_spacing;
        translate([x_pos, hole_y, -0.01]) {
            cylinder(h = ledge_thickness + 0.02, r = hole_diameter / 2, $fn = 64);
        }
    }
}