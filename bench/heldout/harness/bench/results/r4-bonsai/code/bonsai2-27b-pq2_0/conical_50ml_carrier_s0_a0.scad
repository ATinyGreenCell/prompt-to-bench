// 4x 50 mL conical tube carrier, two parts printed side by side
// Part 1: base block + two posts with through square holes
// Part 2: handle bar (printed separately, inserted through posts)

$fn = 64;

// ---- Part 1: base block ----
base_w  = 90;   // X width
base_d  = 90;   // Y depth
base_h  = 35;   // Z height

// Blind tube seats
seat_d  = 30.5; // diameter
seat_depth = 30; // depth (5 mm floor)
seat_x  = 21;   // +/- X centre
seat_y  = 24;   // +/- Y centre

// ---- Part 1: posts ----
post_x  = 10;   // thickness along X
post_y  = 16;   // width along Y
post_z  = 160;  // top height
hole_x  = 10.4; // square hole side, along X
hole_y  = 10.4; // square hole side, along Y
hole_z  = 150;  // hole centre height

// ---- Part 2: handle bar ----
bar_w   = 10;   // X width
bar_d   = 10;   // Y depth
bar_l   = 100;  // length along X
bar_y   = 55;   // bar centre Y (spans 55..65, 10 mm gap from base +Y face at 45)

// ===================== PART 1 =====================
translate([0, 0, 0]) {
    // Base block
    cube([base_w, base_d, base_h], center = [0, 0, base_h/2]);

    // Four blind tube seats
    for (xx = [-1, 1]) {
        for (yy = [-1, 1]) {
            translate([xx * seat_x, yy * seat_y, 0]) {
                difference() {
                    cylinder(d = seat_d, h = seat_depth + 0.01, center = [0, 0, seat_depth/2]);
                    // floor is implicit (cylinder stops at seat_depth)
                }
            }
        }
    }

    // Two posts at X ends, flush with end faces
    for (xx = [-1, 1]) {
        translate([xx * (base_w/2 - post_x/2), 0, 0]) {
            cube([post_x, post_y, post_z], center = [0, 0, post_z/2]);

            // Square through-hole along X, centred at z = hole_z
            difference() {
                cube([post_x + 0.01, post_y, post_z], center = [0, 0, post_z/2]);
                translate([0, 0, hole_z]) {
                    cube([hole_x, hole_y, post_z + 0.01], center = [0, 0, 0]);
                }
            }
        }
    }
}

// ===================== PART 2: handle bar =====================
translate([0, bar_y, 0]) {
    cube([bar_l, bar_d, bar_w], center = [0, 0, bar_w/2]);
}