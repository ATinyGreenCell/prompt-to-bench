$fn = 64;

// Dimensions
bore_d = 3;
h_8 = 10;
od_8_bot = 7.5;
od_8_top = 9.5;
h_5 = 8;
od_5_bot = 6.5;
od_5_top = 5.0;
z_collar_start = 20;
z_collar_end = 25;
collar_d = 12;
z_5_start = 25;
z_5_end = 41;

// Profile Points (X, Z)
// Note: In linear_extrude, the shape is defined in X-Y plane, extruded along Z.
// We map Z to Y.
// We trace the outer wall clockwise.

outer_wall = [
    [0, 0], // Center bottom
    [od_8_bot, 0], // Bottom outer
    [od_8_top, h_8], // Top of first 8mm barb
    [od_8_top, h_8], // Step back
    [od_8_bot, h_8], // Bottom of first 8mm barb
    [od_8_top, h_8 * 2], // Top of second 8mm barb
    [od_8_top, h_8 * 2], // Step back
    [od_8_bot, h_8 * 2], // Bottom of second 8mm barb
    [collar_d / 2, h_8 * 2], // Step to collar
    [collar_d / 2, z_collar_end], // Top of collar
    [collar_d / 2, z_collar_end], // Step back
    [od_5_bot, z_collar_end], // Bottom of first 5mm barb
    [od_5_top, z_5_start + h_5], // Top of first 5mm barb
    [od_5_top, z_5_start + h_5], // Step back
    [od_5_bot, z_5_start + h_5], // Bottom of first 5mm barb
    [od_5_top, z_5_end], // Top of second 5mm barb
    [od_5_top, z_5_end], // Step back
    [od_5_bot, z_5_end], // Bottom of second 5mm barb
    [0, z_5_end] // Step to center
];

// Construct the part
module part() {
    // Extrude the outer wall
    linear_extrude(height = z_5_end, center = false) {
        polygon(outer_wall);
    }

    // Subtract the bore
    // The bore is a cylinder along the Z axis
    translate([0, 0, 0])
    cylinder(r = bore_d / 2, h = z_5_end, center = false);
}

part();