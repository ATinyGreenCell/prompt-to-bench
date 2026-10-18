// Snap-on clip: tubing holder next to a 12.7 mm lab stand rod
// Print orientation: flat on the bed (XY), extruded up in +Z

// ---------------- Parameters ----------------
clip_h      = 10;    // extrusion height (Z), mm
wall        = 3;     // rod ring wall thickness, mm

rod_id      = 12.7;  // stand rod diameter, mm
rod_od      = rod_id + 2 * wall;   // outer diameter of rod ring, mm

tube_id     = 6;     // tubing inner diameter, mm
tube_od     = tube_id + 2 * wall;  // tubing ring outer diameter, mm
tube_x      = 15;    // tubing ring centre X, mm

bridge_w    = 6;     // bridge width along X, mm (y = +/- bridge_w/2)
bridge_x1   = 8;     // bridge start X, mm
bridge_x2   = 12;    // bridge end X, mm

cut_w       = 10;    // rod ring opening width (along X), mm
cut_h       = 10;    // opening height (along Y), mm

eps         = 0.5;   // cutter overshoot past faces, mm
$fn         = 96;    // circle resolution

// ---------------- Profile ----------------
profile = union() {
    // Rod ring (centred at origin) with opening on the -X side
    difference() {
        translate([0, 0, -eps])
            cylinder(d = rod_od, h = clip_h + 2 * eps, $fn = 96);
        // x < 0 and -5 < y < 5 removed -> snapping opening
        translate([-cut_w / 2, -cut_h / 2, -eps])
            cube([cut_w, cut_h, clip_h + 2 * eps]);
    }

    // Tubing ring, centred at x = 15, y = 0, opening toward +X
    translate([tube_x, 0, -eps])
        difference() {
            cylinder(d = tube_od, h = clip_h + 2 * eps, $fn = 96);
            translate([tube_x + wall, -tube_id / 2, -eps])
                cube([(tube_id / 2 + eps) * 2, tube_id, clip_h + 2 * eps]);
        }

    // Solid bridge joining the two rings (does not block either hole)
    translate([bridge_x1, -bridge_w / 2, -eps])
        cube([bridge_x2 - bridge_x1, bridge_w, clip_h + 2 * eps]);
}

// ---------------- Part ----------------
translate([0, 0, 0])
    linear_extrude(height = clip_h)
        profile;