for (z_center = groove_centers) {
    z_start = z_center - groove_width/2;
    z_end = z_center + groove_width/2;
    // Subtract the handle in groove region, then add back the reduced cylinder
    translate([0, 0, z_start])
        difference() {
            cylinder(h = groove_width + 0.02, r = handle_radius, center = false);
            translate([0, 0, -0.01])
                cylinder(h = groove_width + 0.02, r = handle_radius - groove_depth, center = false);
        }
}