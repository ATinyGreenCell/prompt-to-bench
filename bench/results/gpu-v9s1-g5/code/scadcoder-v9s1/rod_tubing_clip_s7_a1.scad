// Snap-on tubing clip for a 12.7 mm lab stand rod
// Print orientation: flat on bed, extruded upward in +Z

// ---------------- Parameters ----------------
clip_height      = 10;    // extrusion height (Z), mm
wall_thick       = 3;     // ring wall thickness, mm

rod_inner        = 12.7;  // stand rod diameter, mm
rod_outer        = rod_inner + 2 * wall_thick;  // 18.7 mm
rod_opening      = 10;    // gap width on -X side of rod ring, mm

tubing_inner     = 6;     // tubing diameter, mm
tubing_outer     = tubing_inner + 2 * wall_thick;  // 12 mm
tubing_opening   = 4.5;   // gap width on +X side of tubing ring, mm

bridge_start     = 8;     // bridge begins here (X), mm
bridge_end       = 12;    // bridge ends here (X), mm
bridge_width     = 6;     // bridge size in Y, mm

eps              = 0.5;   // cutter overshoot past faces, mm

$fn = 96;

// ---------------- Profile (XY) ----------------
profile = union() {
    // Rod ring (centred at origin)
    difference() {
        circle(d = rod_outer);
        // remove x < 0 and -5 < y < 5
        translate([-rod_opening / 2, -rod_opening / 2, -eps])
            cube([rod_opening, rod_opening, 2 * eps]);
    }

    // Tubing ring (centred at x = 15, y = 0)
    difference() {
        translate([bridge_end + eps, 0, 0])
            circle(d = tubing_outer);
        // remove x > 15 and -2.25 < y < 2.25
        translate([bridge_end + eps, -tubing_opening / 2, -eps])
            cube([tubing_opening, tubing_opening, 2 * eps]);
    }

    // Solid bridge between x = 8 and x = 12
    translate([bridge_start, -bridge_width / 2, 0])
        cube([bridge_end - bridge_start, bridge_width, 1]);
};

// ---------------- Part ----------------
translate([0, 0, 0])
    linear_extrude(height = clip_height)
        profile;