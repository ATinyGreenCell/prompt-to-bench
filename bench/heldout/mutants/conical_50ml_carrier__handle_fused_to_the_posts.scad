// KNOWN-WRONG PART (must fail): the handle bar is printed in place through the posts (one body)
// Carrier for four 50 mL conical tubes with a carrying handle; two parts printed side by side
// Category: hardware. Part 1: a base block with four blind seats and two posts with square holes
// near the top. Part 2: a square handle bar, printed lying flat, pushed through both posts.
// Print: PETG, 0.2 mm layers, 4 perimeters; the posts are tall, so print slowly near the top.
// A drop of glue (or a tight fit) keeps the bar in place.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Carrier] */
base = [90, 90, 35];      // X, Y, Z [mm], centred on the origin
seat_d = 30.5;            // 50 mL conical tube is ~29-30 mm across
seat_depth = 30;          // 5 mm floor
seat_pos = [[-21, -24], [21, -24], [-21, 24], [21, 24]];
post = [10, 16];          // post X, Y; flush with the X end faces, centred on y = 0
post_top = 160;
hole = 10.4;              // square hole along X for the handle bar
hole_z = 150;
bar = [100, 10, 10];      // handle bar X, Y, Z
bar_gap = 10;             // gap between the bar and the base's +Y face

/* [Hidden] */
eps = 0.01;

// part 1: carrier
difference() {
    union() {
        translate([-base.x / 2, -base.y / 2, 0]) cube(base);
        for (s = [-1, 1])
            translate([s > 0 ? base.x / 2 - post.x : -base.x / 2, -post.y / 2, base.z - eps])
                cube([post.x, post.y, post_top - base.z + eps]);
    }
    for (p = seat_pos)
        translate([p.x, p.y, base.z - seat_depth]) cylinder(d = seat_d, h = seat_depth + 1, $fn = 128);
    translate([-base.x / 2 - 1, -hole / 2, hole_z - hole / 2]) cube([base.x + 2, hole, hole]);
}
// part 2: handle bar, beside the base on the +Y side
translate([-bar.x / 2, -bar.y / 2, hole_z - bar.z / 2]) cube(bar);
