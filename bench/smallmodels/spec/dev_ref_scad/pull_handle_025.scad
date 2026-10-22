// Cabinet door pull handle
// Print orientation: posts on the bed (z = 0), bar on top (z = 20..26)

$fn = 64;

// ---- Posts ----
post_d       = 10;    // post diameter
post_h       = 20;    // post height (z = 0 to 20)
post_spacing = 64;    // centre-to-centre distance (axes at x = -32 and x = 32)

// ---- Bar ----
bar_len = 74;         // bar length along X
bar_w   = 10;         // bar width along Y
bar_t   = 6;          // bar thickness along Z (z = 20 to 26)

// ---- Screw holes ----
hole_d     = 4.5;     // screw hole diameter
hole_depth = 10;      // depth from bottom face up the post axis

// ---- Misc ----
eps     = 0.5;        // cutter overshoot past cut faces
overlap = 0.01;       // small overlap so posts fuse with the bar

difference() {
    union() {
        // Posts
        for (sx = [-1, 1])
            translate([sx * post_spacing / 2, 0, 0])
                cylinder(d = post_d, h = post_h + overlap);

        // Bar
        translate([-bar_len / 2, -bar_w / 2, post_h])
            cube([bar_len, bar_w, bar_t]);
    }

    // Screw holes up each post axis from the bottom face
    for (sx = [-1, 1])
        translate([sx * post_spacing / 2, 0, -eps])
            cylinder(d = hole_d, h = hole_depth + eps);
}
