// Buffer tank for mini horizontal gel-electrophoresis box
outer_x = 120;
outer_y = 70;
outer_z = 40;
wall_thick = 3;
floor_thick = 3;
platform_x = 60;
platform_y = outer_y - 2*wall_thick;
platform_z_bottom = floor_thick;
platform_z_top = 13;
platform_h = platform_z_top - platform_z_bottom;
hole_diam = 2;
hole_y = 0;
hole_z = 30;
inner_x = outer_x - 2*wall_thick;
inner_y = platform_y;
inner_z = outer_z - floor_thick;

$fn = 64;

difference() {
    union() {
        // Floor
        translate([0, 0, floor_thick/2]) cube([outer_x, outer_y, floor_thick]);
        // Walls
        walls_z_center = floor_thick + inner_z/2;
        // Left
        translate([-outer_x/2 + wall_thick/2, 0, walls_z_center]) cube([wall_thick, outer_y, inner_z]);
        // Right
        translate([outer_x/2 - wall_thick/2, 0, walls_z_center]) cube([wall_thick, outer_y, inner_z]);
        // Front
        translate([0, -outer_y/2 + wall_thick/2, walls_z_center]) cube([inner_x, wall_thick, inner_z]);
        // Back
        translate([0, outer_y/2 - wall_thick/2, walls_z_center]) cube([inner_x, wall_thick, inner_z]);
        // Platform
        translate([0, 0, platform_z_bottom + platform_h/2]) cube([platform_x, platform_y, platform_h]);
    }
    // Inner cavity (extends 0.05 mm past faces to avoid coplanar edges)
    translate([0, 0, floor_thick + inner_z/2]) cube([inner_x + 0.05, inner_y + 0.05, inner_z + 0.05]);
    // Electrode wire holes (extend 1 mm past walls)
    rotate([0, 90, 0]) cylinder(d=hole_diam, h=outer_x + 2, center=true);
}
// Platform was removed by cavity subtraction; add it back to preserve the solid block
translate([0, 0, platform_z_bottom + platform_h/2]) cube([platform_x, platform_y, platform_h]);