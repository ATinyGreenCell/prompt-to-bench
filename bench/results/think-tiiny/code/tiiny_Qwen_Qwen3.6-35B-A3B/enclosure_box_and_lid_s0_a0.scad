// Dimensions
outer_x = 70;           // Box/Lid outer length (X)
outer_y = 50;           // Box/Lid outer width (Y)
outer_z = 30;           // Box outer height (Z)
wall_thick = 2;         // Box wall thickness
floor_thick = 2;        // Box floor thickness
inner_x = outer_x - 2 * wall_thick;
inner_y = outer_y - 2 * wall_thick;
inner_z = outer_z - floor_thick;
// Add 0.01 mm to inner dimensions to avoid coplanar faces
inner_cavity_x = inner_x + 0.01;
inner_cavity_y = inner_y + 0.01;
inner_cavity_z = inner_z + 0.01;

plate_thick = 2;        // Lid plate thickness
lip_outer_x = 65.6;     // Lip outer length (X)
lip_outer_y = 45.6;     // Lip outer width (Y)
lip_wall_thick = 1.5;   // Lip wall thickness
lip_height = 4;         // Lip height (Z)
lip_inner_x = lip_outer_x - 2 * lip_wall_thick;
lip_inner_y = lip_outer_y - 2 * lip_wall_thick;
// Add 0.01 mm to inner dimensions to avoid coplanar faces
lip_inner_cavity_x = lip_inner_x + 0.01;
lip_inner_cavity_y = lip_inner_y + 0.01;
lip_inner_cavity_z = lip_height + 0.01;

// Placement
gap = 10;               // Gap between parts (mm)
box_x = -75;            // Box X origin
lid_x = 5;              // Lid X origin
y_center = 0;           // Y origin

$fn = 64;

// Part 1: Box
translate([box_x, y_center, 0]) {
    difference() {
        cube([outer_x, outer_y, outer_z], center = false);
        // Inner cavity
        translate([wall_thick, wall_thick, floor_thick]) {
            cube([inner_cavity_x, inner_cavity_y, inner_cavity_z], center = false);
        }
    }
}

// Part 2: Lid
translate([lid_x, y_center, 0]) {
    difference() {
        union() {
            // Plate
            cube([outer_x, outer_y, plate_thick], center = false);
            // Lip
            lip_x_offset = (outer_x - lip_outer_x) / 2;
            lip_y_offset = (outer_y - lip_outer_y) / 2;
            translate([lip_x_offset, lip_y_offset, plate_thick]) {
                cube([lip_outer_x, lip_outer_y, lip_height], center = false);
            }
        }
        // Inner cavity of the lip
        translate([lip_x_offset + lip_wall_thick, lip_y_offset + lip_wall_thick, plate_thick]) {
            cube([lip_inner_cavity_x, lip_inner_cavity_y, lip_inner_cavity_z], center = false);
        }
    }
}