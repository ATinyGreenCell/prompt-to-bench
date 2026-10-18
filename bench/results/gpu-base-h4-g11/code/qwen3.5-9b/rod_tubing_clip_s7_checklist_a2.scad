translate([0, 0, 0])
    linear_extrude(height = clip_h)
    difference() {
        circle(d = rod_od);
        translate([-rod_open_w / 2, -rod_open_y, 0])
        square([rod_open_w, rod_open_y * 2 + 0.1]);
    }