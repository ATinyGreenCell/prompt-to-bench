$fn = 64;

// Dimensions
base_x = 50;
base_y = 45;
base_z = 5;
base_hole_x = 17;
base_hole_y = 30;
base_hole_dia = 4.5;

vert_x = 50;
vert_y = 5;
vert_z = 50;

boss_dia = 23;
boss_z = 28;

screw_pitch = 31;
screw_dia = 3.4;

gusset_thickness = 5;
gusset_y_leg = 20;
gusset_z_leg = 20;
gusset_corner_y = 5;
gusset_corner_z = 5;

// Build the solid part
union() {
    // Base Plate
    translate([-base_x/2, 0, 0]) cube([base_x, base_y, base_z]);
    
    // Vertical Plate
    translate([-vert_x/2, 0, 0]) cube([vert_x, vert_y, vert_z]);
    
    // Left Gusset
    translate([-25, 0, 0]) rotate([0, 90, 0]) linear_extrude(height=gusset_thickness) 
        polygon([[gusset_corner_y, gusset_corner_z], [gusset_corner_y - gusset_y_leg, gusset_corner_z], [gusset_corner_y, gusset_corner_z + gusset_z_leg]]);
        
    // Right Gusset
    translate([20, 0, 0]) rotate([0, 90, 0]) linear_extrude(height=gusset_thickness) 
        polygon([[gusset_corner_y, gusset_corner_z], [gusset_corner_y - gusset_y_leg, gusset_corner_z], [gusset_corner_y, gusset_corner_z + gusset_z_leg]]);
}

// Cut holes
difference() {
    union() {
        translate([-base_x/2, 0, 0]) cube([base_x, base_y, base_z]);
        translate([-vert_x/2, 0, 0]) cube([vert_x, vert_y, vert_z]);
        translate([-25, 0, 0]) rotate([0, 90, 0]) linear_extrude(height=gusset_thickness) 
            polygon([[gusset_corner_y, gusset_corner_z], [gusset_corner_y - gusset_y_leg, gusset_corner_z], [gusset_corner_y, gusset_corner_z + gusset_z_leg]]);
        translate([20, 0, 0]) rotate([0, 90, 0]) linear_extrude(height=gusset_thickness) 
            polygon([[gusset_corner_y, gusset_corner_z], [gusset_corner_y - gusset_y_leg, gusset_corner_z], [gusset_corner_y, gusset_corner_z + gusset_z_leg]]