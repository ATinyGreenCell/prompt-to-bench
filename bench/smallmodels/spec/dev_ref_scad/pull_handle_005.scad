// Cabinet door pull handle
// Print orientation: posts on the bed (z = 0), bar on top (z = 25 to 33)

// ---------- Parameters ----------
post_d        = 14;    // post diameter
post_h        = 25;    // post height (z = 0 to 25)
post_x        = 48;    // post axis offset from origin in X (+/-)

bar_len       = 110;   // bar length (X)
bar_w         = 14;    // bar width (Y)
bar_t         = 8;     // bar thickness (Z), from z = 25 to 33

screw_d       = 4.5;   // screw hole diameter
screw_depth   = 10;    // screw hole depth from bottom face

eps           = 0.5;   // overlap / overshoot for clean booleans
$fn           = 96;    // curve resolution

// ---------- Model ----------
difference() {
    union() {
        // Posts
        for (sx = [-1, 1])
            translate([sx * post_x, 0, 0])
                cylinder(d = post_d, h = post_h + eps);  // small overlap into bar

        // Bar
        translate([-bar_len / 2, -bar_w / 2, post_h])
            cube([bar_len, bar_w, bar_t]);
    }

    // Screw holes up each post axis from the bottom face
    for (sx = [-1, 1])
        translate([sx * post_x, 0, -eps])
            cylinder(d = screw_d, h = screw_depth + eps);
}
