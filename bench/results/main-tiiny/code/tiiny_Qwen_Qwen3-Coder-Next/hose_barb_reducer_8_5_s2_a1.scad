for (i = [0:2]) {
    // Two identical barbs stacked, each 8 mm tall
    z_pos = 25 + i * 8;
    sawtooth_barb(z_barb5_bottom_dia, z_barb5_top_dia, z_barb5_step_dia, 8, z_pos);
}