// Carrier for four 50 mL conical tubes, printed as two parts side by side.
// Units: millimetres. Print orientation: parts rest on the XY plane (z = 0),
// building upward (+Z). Part 1 is centred on the origin; Part 2 (handle) is
// offset in +Y so the two parts print side by side.

$fn = 64;

// ---------------- Part 1: base block + two posts ----------------
base_w   = 90;   // base block width  (X)
base_d   = 90;   // base block depth   (Y)
base_h   = 35;   // base block height  (Z)

seat_d   = 30.5; // blind seat diameter
seat_dep = 30;   // blind seat depth (leaves a 5 mm floor)
seat_x   = 21;   // seat centre |x|
seat_y   = 24;   // seat centre |y|

post_t   = 10;   // post thickness (X)
post_w   = 16;   // post width     (Y)
post_h   = 160;  // post height (top at z = 160)
post_x   = 40;   // post centre |x| (10 mm thick, flush with 90 mm end faces)
post_hole = 10.4;// square through-hole side (X)
post_hole_z = 150; // hole centre height

// ---------------- Part 2: handle bar ----------------
bar_t    = 10;   // bar thickness (X)
bar_w    = 10;   // bar width     (Y)
bar_len  = 100;  // bar length    (Z)
bar_y    = 60;   // bar centre Y (spans y = 55..65, 10 mm gap to base +Y face)

// ================= PART 1 =================
part1() ;

module part1() {
    union() {
        // Base block, centred on the origin
        translate([-base_w/2, -base_d/2, 0])
            cube([base_w, base_d, base_h]);

        // Four blind tube seats (30.5 mm dia, 30 mm deep, 5 mm floor)
        for (sx = [-seat_x, seat_x])
            for (sy = [-seat_y, seat_y])
                translate([sx, sy, base_h - seat_dep])
                    cylinder(h = seat_dep + 0.1, d = seat_d);

        // Two posts, flush with the X end faces, centred on y = 0
        for (px = [-post_x, post_x]) {
            translate([px - post_t/2, -post_w/2, 0])
                cube([post_t, post_w, post_h]);

            // 10.4 x 10.4 mm square through-hole along X, centred at z = 150
            translate([px - post_t/2 - 0.1, -post_hole/2, post_hole_z - post_hole/2])
                cube([post_t + 0.2, post_hole, post_hole]);
        }
    }
}

// ================= PART 2 (handle) =================
// Printed side by side with part 1 (offset in +Y). After printing, the bar is
// pushed through both posts (it spans y = 55..65, i.e. 10 mm clear of the base).
translate([0, bar_y, 0])
    part2();

module part2() {
    // Square bar 10 x 10 mm, 100 mm long, lying on the bed along X, centred on x = 0
    translate([-bar_len/2, -bar_w/2, 0])
        cube([bar_len, bar_w, bar_t]);
}