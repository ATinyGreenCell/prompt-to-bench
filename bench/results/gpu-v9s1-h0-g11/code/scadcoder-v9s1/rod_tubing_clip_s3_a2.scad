// Snap-on clip: tubing holder next to a 12.7 mm lab stand rod
// Print orientation: flat on the bed (XY), extruded up in +Z

// ---------------- Parameters ----------------
clip_h      = 10;    // extrusion height (Z), mm
wall        = 2;     // wall thickness for all rings, mm

rod_id      = 12.7;  // stand rod diameter, mm
rod_od      = rod_id + 2 * wall;   // outer diameter of the rod ring, mm
rod_x0      = 0;     // rod ring centre X
rod_y0      = 0;     // rod ring centre Y

tube_id     = 6;     // tubing inner diameter, mm
tube_od     = tube_id + 2 * wall;  // tubing ring outer diameter, mm
tube_x0     = 15;    // tubing ring centre X
tube_y0     = 0;     // tubing ring centre Y

bridge_x0   = 10;    // bridge span middle X (between x = 8 and x = 12)
bridge_w    = 6;     // bridge width along Y, mm

eps         = 0.5;   // cutter overshoot past faces, mm
$fn         = 96;    // circle resolution

// ---------------- Profile ----------------
module ring_2d(od, x0, y0) {
    translate([x0, y0, 0])
        difference() {
            cylinder(d = od, h = 1);
            translate([0, 0, -eps])
                cylinder(d = od - 2 * wall, h = 1 + 2 * eps);
        }
}

module opening(w, h, x0, y0) {
    translate([x0, y0, 0])
        difference() {
            translate([-w / 2, -h / 2, 0])
                cube([w, h, 1]);
            translate([-w / 2 - eps, -h / 2 - eps, 0])
                cube([w + 2 * eps, h + 2 * eps, 1]);
        }
}

// ---------------- Model ----------------
difference() {
    union() {
        // Rod ring (18.7 mm OD) with a 10 mm wide opening on the -X side
        ring_2d(rod_od, rod_x0, rod_y0);
        opening(w = 10, h = 10, x0 = rod_x0 - 5, y0 = rod_y0);

        // Tubing ring (10 mm OD) with a 4.5 mm wide opening on the +X side
        ring_2d(tube_od, tube_x0, tube_y0);
        opening(w = 4.5, h = tube_od, x0 = tube_x0 + 2.25, y0 = tube_y0);

        // Solid bridge between x = 8 and x = 12, 6 mm wide in Y
        translate([bridge_x0 - 3, -bridge_w / 2, 0])
            cube([6, bridge_w, 1]);
    }

    // Cut the stand rod through the rod ring
    translate([rod_x0, 0, 0])
        cylinder(d = rod_id, h = clip_h + 2 * eps, center = true);
}

// ---------------- Output ----------------
translate([0, 0, 0])
    linear_extrude(height = clip_h)
        profile();

module profile() {
    // 2-D profile drawn in XY, then extruded to Z
    union() {
        // Rod ring (18.7 mm OD) with a 10 mm wide opening on the -X side
        ring_2d(rod_od, rod_x0, rod_y0);
        opening(w = 10, h = 10, x0 = rod_x0 - 5, y0 = rod_y0);

        // Tubing ring (10 mm OD) with a 4.5 mm wide opening on the +X side
        ring_2d(tube_od, tube_x0, tube_y0);
        opening(w = 4.5, h = tube_od, x0 = tube_x0 + 2.25, y0 = tube_y0);

        // Solid bridge between x = 8 and x = 12, 6 mm wide in Y
        translate([bridge_x0 - 3, -bridge_w / 2, 0])
            cube([6, bridge_w, 1]);
    }

    // Cut the stand rod through the rod ring
    translate([rod_x0, 0, 0])
        cylinder(d = rod_id, h = clip_h + 2 * eps, center = true);
}