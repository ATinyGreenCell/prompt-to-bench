// Cabinet door pull handle
// Print orientation: posts stand on the bed (z = 0), bar on top (z = 20..28)

$fn = 64;

// --- Posts ---
post_d       = 10;    // post diameter
post_h       = 20;    // post height (z = 0 to 20)
post_x       = 32;    // post axis offset from centre (x = -32 and +32)

// --- Bar ---
bar_len      = 74;    // bar length (X)
bar_w        = 10;    // bar width (Y)
bar_t        = 8;     // bar thickness (Z), z = 20 to 28

// --- Screw holes ---
screw_d      = 3.4;   // screw hole diameter
screw_depth  = 12;    // hole depth from the bottom face of each post

// --- Misc ---
eps          = 0.5;   // overshoot for clean boolean cuts
overlap      = 0.01;  // small overlap so posts fuse into the bar

difference() {
    union() {
        // Posts
        for (sx = [-1, 1])
            translate([sx * post_x, 0, 0])
                cylinder(d = post_d, h = post_h + overlap);

        // Bar on top of the posts
        translate([-bar_len / 2, -bar_w / 2, post_h])
            cube([bar_len, bar_w, bar_t]);
    }

    // Screw holes up each post axis from the bottom face
    for (sx = [-1, 1])
        translate([sx * post_x, 0, -eps])
            cylinder(d = screw_d, h = screw_depth + eps);
}
