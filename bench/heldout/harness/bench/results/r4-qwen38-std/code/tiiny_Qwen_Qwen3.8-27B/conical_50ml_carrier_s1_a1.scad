// ---------------------------------------------------------------------------
// 50 mL conical tube carrier, printed as two parts side by side.
// Part 1: base block + two end posts (posts have through-holes along X).
// Part 2: square handle bar that is pushed through both posts after printing.
// All dimensions in mm. Print orientation: parts rest on XY plane at z = 0.
// ---------------------------------------------------------------------------

// ---- Part 1 : base block ---------------------------------------------------
base_w   = 90;   // base block width  (X)
base_d   = 90;   // base block depth   (Y)
base_h   = 35;   // base block height  (Z)

seat_d   = 30.5; // blind seat diameter
seat_dep = 30;   // blind seat depth (leaves a 5 mm floor)
seat_x   = [-21, 21];   // seat centre X positions
seat_y   = [-24, 24];   // seat centre Y positions

// ---- Part 1 : end posts ----------------------------------------------------
post_t   = 10;   // post thickness (X)
post_w   = 16;   // post width     (Y)
post_h   = 160;  // post height    (Z)
post_x   = [-45, 45];  // post centre X (flush with base end faces)
post_hole = 10.4;      // square through-hole size (X through)
post_hole_z = 150;     // hole centre height (Z)

// ---- Part 2 : handle bar ---------------------------------------------------
bar_t    = 10;   // bar thickness (X)
bar_w    = 10;   // bar width     (Y)
bar_l    = 100;  // bar length    (Z, vertical after printing)
bar_y    = 60;   // bar centre Y (spans y = 55..65, 10 mm gap to base +Y face)

$fn = 64;

// ===========================================================================
// PART 1 : base block + two posts
// ===========================================================================
part1();

module part1() {
    // Base block, centred on origin in X and Y, resting on z = 0
    base = cube([base_w, base_d, base_h], center = [true, true, false]);

    // Four blind tube seats (cut from the top, 5 mm floor remains)
    seats = for (sx = seat_x, sy = seat_y)
        translate([sx, sy, base_h + 0.5])
            cylinder(h = seat_dep + 1, d = seat_d);

    // Two end posts, flush with the base end faces, centred on y = 0
    posts = for (px = post_x)
        translate([px, 0, 0])
            cube([post_t, post_w, post_h], center = [true, true, false]);

    // Square through-holes in each post, along X, centred at z = 150
    holes = for (px = post_x)
        translate([px, 0, post_hole_z])
            cube([post_t + 1, post_hole, post_hole], center = [true, true, true]);

    difference() {
        union() {
            base;
            posts;
        }
        union() {
            seats;
            holes;
        }
    }
}

// ===========================================================================
// PART 2 : handle bar (printed lying on the bed along X, centred on x = 0)
// After printing it is pushed through both posts.
// ===========================================================================
part2();

module part2() {
    // Square bar 10 x 10 mm, 100 mm long, lying on the bed along X,
    // centred on x = 0, at y = 55..65 (10 mm gap to the base +Y face).
    translate([0, bar_y, 0])
        cube([bar_l, bar_w, bar_t], center = [true, true, false]);
}