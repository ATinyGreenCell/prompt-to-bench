// Stand rod and tubing clip - printed flat, 10 mm tall extrusion
// Units: mm. $fn = 96 for ring resolution.

// ---------------- Parameters ----------------
clip_height      = 10;    // extrusion height (Z)
stand_d          = 12.7;  // stand rod diameter (ring inner diameter)
stand_wall       = 3;     // stand ring wall thickness
stand_outer      = stand_d + 2 * stand_wall; // 18.7 mm
stand_cut_width  = 10;    // opening cut out of -X side of stand ring

tubing_d         = 6;     // tubing inner diameter
tubing_wall      = 2;     // tubing ring wall thickness
tubing_outer     = tubing_d + 2 * tubing_wall; // 10 mm
tubing_x         = 15;    // tubing ring centre X
tubing_cut_width = 4.5;   // opening cut out of +X side of tubing ring

bridge_x1        = 8;     // bridge start X
bridge_x2        = 12;    // bridge end X
bridge_w         = 6;     // bridge width (Y)

eps              = 0.5;   // cutter overshoot past faces
// ---------------- Model ----------------
difference() {
    // Stand ring, centred at origin, opening on -X side
    ring(stand_outer, stand_d, clip_height, stand_cut_width, eps);

    // Tubing ring, centred at x = 15, opening on +X side
    translate([tubing_x, 0, 0])
        ring(tubing_outer, tubing_d, clip_height, tubing_cut_width, eps);

    // Solid bridge between x = 8 and x = 12, width 6 (Y)
    translate([bridge_x1 - eps, -bridge_w / 2, 0])
        cube([bridge_x2 - bridge_x1 + 2 * eps, bridge_w, clip_height]);
}

// ---------------- Helpers ----------------
module ring(outer, inner, h, cut_w, overshoot) {
    // Ring with a rectangular opening cut out of the -X side
    difference() {
        cylinder(h = h, d = outer, $fn = 96);
        translate([-outer / 2 - overshoot, -cut_w / 2, 0])
            cube([cut_w + 2 * overshoot, cut_w, h]);
    }
}