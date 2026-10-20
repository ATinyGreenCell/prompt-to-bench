module outer_shape() {
                cylinder(h = spout_height, r = spout_r, center = false); // r=5 (10mm)
                translate([0, 0, spout_height]) {
                    cylinder(h = funnel_height, r1 = spout_r, r2 = funnel_rim_r, center = false); // r1=5, r2=30 (60mm)
                }
            }
            module inner_shape() {
                cylinder(h = spout_height, r = spout_inner_r, center = false); // r=3.4 (6.8mm)
                translate([0, 0, spout_height]) {
                    cylinder(h = funnel_height, r1 = spout_inner_r, r2 = funnel_rim_inner_r, center = false); // r1=3.4, r2=28.4 (56.8mm)
                }
            }
            difference() {
                outer_shape();
                translate([0, 0, -epsilon]) { inner_shape(); }
            }