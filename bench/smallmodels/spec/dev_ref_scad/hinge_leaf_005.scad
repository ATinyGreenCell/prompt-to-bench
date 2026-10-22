// Pin hinge leaf - one half of a 5-knuckle pin hinge
// Print orientation: plate flat on bed, knuckles along +Y edge

$fn = 96;

// ---- Plate ----
plate_len   = 50;   // length along X
plate_wid   = 20;   // width along Y
plate_thk   = 3;    // thickness along Z

// ---- Knuckles ----
n_segments  = 5;                       // total hinge segments along length
seg_len     = plate_len / n_segments;  // 10 mm per segment
knuckle_d   = 6;                       // knuckle outer diameter
knuckle_y   = plate_wid / 2;           // axis Y position (y = 10)
knuckle_z   = 3;                       // axis Z position (z = 3)

// ---- Pin hole ----
pin_d       = 3;    // pin hole diameter
eps         = 0.5;  // overshoot for clean cuts

difference() {
    union() {
        // Flat plate centred on origin
        translate([-plate_len/2, -plate_wid/2, 0])
            cube([plate_len, plate_wid, plate_thk]);

        // Knuckles on 1st, 3rd, 5th segments (indices 0, 2, 4)
        for (i = [0 : 2 : n_segments - 1])
            translate([-plate_len/2 + i*seg_len, knuckle_y, knuckle_z])
                rotate([0, 90, 0])
                    cylinder(d = knuckle_d, h = seg_len);
    }

    // Pin hole along the common knuckle axis, through all knuckles
    translate([-plate_len/2 - eps, knuckle_y, knuckle_z])
        rotate([0, 90, 0])
            cylinder(d = pin_d, h = plate_len + 2*eps);
}
