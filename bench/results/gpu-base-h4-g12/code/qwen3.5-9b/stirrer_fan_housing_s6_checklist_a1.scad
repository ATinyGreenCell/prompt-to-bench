for (i = [-1, 1]) {
        for (j = [-1, 1]) {
            translate([
                i * (screw_pattern_size / 2),
                j * (screw_pattern_size / 2),
                0
            ]) cylinder(h = top_thickness + 1, d = screw_hole_d);
        }
    }