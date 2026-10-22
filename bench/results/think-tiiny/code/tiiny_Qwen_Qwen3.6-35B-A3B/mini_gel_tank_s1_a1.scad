$fn = 64;

// Outer dimensions
outer_x = 120;
outer_y = 70;
outer_z = 40;

// Wall and floor thickness
wall_thick = 3;
floor_thick = 3;

// Derived inner dimensions
inner_x = outer_x - 2 * wall_thick;
inner_y = outer_y - 2 * wall_thick;
inner_z = outer_z - floor_thick;

// Platform dimensions
plat_x = 60;
plat_y = inner_y;
plat_top_z = 13;
plat_bottom_z = floor_thick;
plat_height = plat_top_z - plat_bottom_z;

// Hole dimensions
hole_diam = 2;
hole_z = 30;
hole_y = 0;
hole_x_pos = outer_x / 2;

// Build the part
difference() {
    union() {
        // Tank shell (outer box minus inner cavity)
        difference() {
            translate([-outer_x / 2, -outer_y / 2, 0]) cube([outer_x, outer_y, outer_z], center = false);
            translate([-outer_x / 2 + wall_thick, -outer_y / 2 + wall_thick, floor_thick]) cube([inner_x, inner_y, inner_z], center = false);
        }
        // Raised platform
        translate([-plat_x / 2, -plat_y / 2, plat_bottom_z]) cube([plat_x, plat_y, plat_height], center = false);
    }
    // Electrode holes
    for (x = [-hole_x_pos, hole_x_pos]) {
        translate([x, hole_y, hole_z]) cylinder(r = hole_diam / 2, h = outer_z + 0.1, center = false);
    }
}