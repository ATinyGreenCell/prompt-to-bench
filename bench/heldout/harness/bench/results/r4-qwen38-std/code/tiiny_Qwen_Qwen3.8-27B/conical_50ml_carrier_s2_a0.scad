// =====================================================================
// 4x 50 mL conical tube carrier, printed as two parts side by side.
// Part 1: base block + two posts (posts have square through-holes).
// Part 2: square handle bar (pushed through both posts after printing).
// Units: mm.  Print orientation: parts rest on XY plane (z = 0), +Z up.
// =====================================================================

$fn = 64;

// ---------------- Part 1 : base block ----------------
base_w   = 90;   // X extent of base block
base_d   = 90;   // Y extent of base block
base_h   = 35;   // Z height of base block

// Blind tube seats (50 mL conical tubes)
seat_d   = 30.5; // seat diameter
seat_dep = 30;   // seat depth (leaves a 5 mm floor)
seat_x   = [-21, 21];   // X centres of the four seats
seat_y   = [-24, 24];   // Y centres of the four seats

// ---------------- Part 1 : posts ----------------
post_t   = 10;   // post thickness along X
post_w   = 16;   // post width along Y
post_h   = 160;  // post height (z = 0 .. 160)
post_x   = [-45, 45]; // X centres (flush with the two X end faces)
post_hole = 10.4;     // square through-hole size (X x Y)
post_hole_z = 150;    // Z centre of the square hole

// ---------------- Part 2 : handle bar ----------------
bar_s    = 10;   // square bar cross-section (X x Y)
bar_len  = 100;  // bar length along X
bar_y0   = 55;   // bar Y start (10 mm gap to the base +Y face at y = 45)
bar_y1   = 65;   // bar Y end

// =====================================================================
// PART 1  (base + posts, centred on the origin in X and Y)
// =====================================================================
part1();

// =====================================================================
// PART 2  (handle bar, offset in +Y so it prints beside part 1)
// =====================================================================
part2();

// ---------------------------------------------------------------------
// Part 1 : base block with four blind seats, plus two posts with square
//          through-holes.  Posts are unioned onto the base, then the
//          square holes are cut (cutters extend 1 mm past each face).
// ---------------------------------------------------------------------
module part1() {
    union() {
        // --- base block ---
        translate([-base_w/2, -base_d/2, 0])
            cube([base_w, base_d, base_h]);

        // --- four blind tube seats (cut from the base) ---
        for (sx = seat_x)
            for (sy = seat_y)
                difference() {
                    // (seat cutters are applied to the base below)
                }

        // --- two posts (unioned onto the base) ---
        for (px = post_x)
            translate([px - post_t/2, -post_w/2, 0])
                cube([post_t, post_w, post_h]);
    }

    // Apply the seat and post-hole cuts to the whole part-1 solid.
    difference() {
        // (the union above is re-declared here so the cuts apply to it)
        union() {
            translate([-base_w/2, -base_d/2, 0])
                cube([base_w, base_d, base_h]);

            for (px = post_x)
                translate([px - post_t/2, -post_w/2, 0])
                    cube([post_t, post_w, post_h]);
        }

        // four blind seats, cut 1 mm past the top face (z = 35)
        for (sx = seat_x)
            for (sy = seat_y)
                translate([sx, sy, 0])
                    cylinder(h = seat_dep + 1, d = seat_d, $fn = 64);

        // square through-holes in the two posts, cut 1 mm past each face
        for (px = post_x)
            translate([px - post_t/2 - 1,
                       post_hole_z - post_hole/2,
                       post_hole_z - post_hole/2])
                cube([post_t + 2, post_hole, post_hole]);
    }
}

// ---------------------------------------------------------------------
// Part 2 : square handle bar lying on the bed along X, centred on x = 0,
//          spanning y = 55 .. 65 (10 mm gap to the base +Y face).
// ---------------------------------------------------------------------
module part2() {
    translate([-bar_len/2, bar_y0, 0])
        cube([bar_len, bar_s, bar_s]);
}