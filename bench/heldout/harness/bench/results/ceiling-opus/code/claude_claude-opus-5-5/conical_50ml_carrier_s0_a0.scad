// Four-tube 50 mL conical carrier with push-through handle
// Two parts printed side by side: base with posts, and square handle bar

$fn = 96;

// ---------- Base block ----------
base_x      = 90;    // base length (X)
base_y      = 90;    // base width (Y)
base_h      = 35;    // base height (Z)

// ---------- Tube seats ----------
seat_d      = 30.5;  // seat diameter for 50 mL conical
seat_depth  = 30;    // blind seat depth (leaves 5 mm floor)
seat_x      = 21;    // seat centre offset in X (+/-)
seat_y      = 24;    // seat centre offset in Y (+/-)

// ---------- Posts ----------
post_t      = 10;    // post thickness (X)
post_w      = 16;    // post width (Y)
post_top    = 160;   // post top height (Z)

// ---------- Handle slot in posts ----------
slot_s      = 10.4;  // square through-hole size
slot_z      = 150;   // slot centre height

// ---------- Handle bar ----------
bar_s       = 10;    // bar cross-section (square)
bar_len     = 100;   // bar length (X)
bar_y0      = 55;    // bar near edge Y (10 mm gap to base +Y face)

eps         = 0.5;   // cutting overlap

// ================= Part 1: base with posts =================
module base_part() {
    difference() {
        union() {
            // base block
            translate([-base_x/2, -base_y/2, 0])
                cube([base_x, base_y, base_h]);
            // posts at both X ends, flush with end faces
            for (sx = [-1, 1])
                translate([sx > 0 ? base_x/2 - post_t : -base_x/2,
                           -post_w/2, 0])
                    cube([post_t, post_w, post_top]);
        }
        // four blind tube seats
        for (ix = [-1, 1], iy = [-1, 1])
            translate([ix*seat_x, iy*seat_y, base_h - seat_depth])
                cylinder(d = seat_d, h = seat_depth + eps);
        // square handle hole straight through both posts along X
        translate([-base_x/2 - eps, -slot_s/2, slot_z - slot_s/2])
            cube([base_x + 2*eps, slot_s, slot_s]);
    }
}

// ================= Part 2: handle bar =================
module handle_part() {
    translate([-bar_len/2, bar_y0, 0])
        cube([bar_len, bar_s, bar_s]);
}

base_part();
handle_part();