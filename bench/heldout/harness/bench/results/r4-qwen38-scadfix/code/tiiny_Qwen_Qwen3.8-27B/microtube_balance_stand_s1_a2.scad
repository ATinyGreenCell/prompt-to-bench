// 1.5 mL microcentrifuge tube stand for an analytical balance
// Printed standing up: rests on XY plane at z = 0, builds upward (+Z), centred on origin.

$fn = 64;

// ---- Overall body dimensions (mm) ----
base_d     = 50;   // base disc diameter
base_h     = 4;    // base disc height (z = 0 .. 4)
cone_top_d = 22;   // cone narrows to this diameter at z = 14
cone_h     = 10;   // cone height (z = 4 .. 14)
col_d      = 22;   // column diameter
col_h      = 19;   // column height (z = 14 .. 33)
top_z      = 33;   // top of the stand

// ---- Tube seat (bore) dimensions ----
seat_d = 11;       // seat bore diameter (z = 33 .. 23)
seat_h = 10;       // seat bore height (z = 23 .. 33)
tip_d  = 3;        // cone bore narrows to this at z = 6
tip_h  = 17;       // cone bore height (z = 6 .. 23)

// ---- Viewing window dimensions ----
win_w  = 4;        // window width in Y
win_z0 = 18;       // window bottom z
win_z1 = 30;       // window top z
win_h  = win_z1 - win_z0;

// ---- Build the solid body (base + cone + column) ----
module body() { union() {
    // base disc
    translate([0, 0, 0])
        cylinder(h = base_h, d = base_d);

    // cone narrowing from base_d to cone_top_d
    translate([0, 0, base_h])
        cylinder(h = cone_h, d1 = base_d, d2 = cone_top_d);

    // column
    translate([0, 0, base_h + cone_h])
        cylinder(h = col_h, d = col_d);
} }

// ---- Tube seat bore (cylinder + cone), extended 1 mm past the top ----
module seat() { union() {
    // seat cylinder: z = 23 .. 34 (1 mm past top at 33)
    translate([0, 0, 23])
        cylinder(h = 11, d = seat_d);

    // cone: z = 6 .. 23, narrowing from seat_d to tip_d
    translate([0, 0, 6])
        cylinder(h = tip_h, d1 = seat_d, d2 = tip_d);
} }

// ---- Viewing window: straight through the +X column wall, from the seat to the outside ----
// Box starts 1 mm inside the column outer wall (x = 10) and extends past it (to x = 12),
// so it removes only the +X wall and does not reach the seat bore (which ends at x = 5.5).
// This keeps the bore centred and the window a clean slot through the wall.
module window() { translate([10, -win_w / 2, win_z0])
    cube([2, win_w, win_h]); }

// ---- Final part: body minus seat bore minus viewing window ----
difference() {
    body();
    seat();
    window();
}