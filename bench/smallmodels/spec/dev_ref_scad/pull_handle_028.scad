// Cabinet door pull handle
// Print orientation: posts standing on the bed (z = 0), bar on top.

$fn = 64;

// ---- Posts ----
post_d       = 12;    // post diameter
post_h       = 30;    // post height (z = 0 to 30)
post_x       = 48;    // post axis offset from origin in X (at +/-48)

// ---- Bar ----
bar_l        = 108;   // bar length (X)
bar_w        = 12;    // bar width (Y)
bar_t        = 6;     // bar thickness (z = 30 to 36)

// ---- Screw holes ----
hole_d       = 3.4;   // screw hole diameter
hole_depth   = 12;    // screw hole depth from bottom face

eps          = 0.5;   // overlap / overcut allowance

difference() {
    union() {
        // Posts (extend slightly into the bar for a solid union)
        for (sx = [-1, 1])
            translate([sx * post_x, 0, 0])
                cylinder(d = post_d, h = post_h + eps);

        // Bar
        translate([-bar_l / 2, -bar_w / 2, post_h])
            cube([bar_l, bar_w, bar_t]);
    }

    // Screw holes up each post axis from the bottom face
    for (sx = [-1, 1])
        translate([sx * post_x, 0, -eps])
            cylinder(d = hole_d, h = hole_depth + eps);
}
