// Pin hinge leaf - one half of a pin hinge
// Print orientation: plate flat on the bed (z = 0), knuckles up along +Y edge

$fn = 64;

// ---------- Plate ----------
plate_len   = 60;    // plate length along X (mm)
plate_wid   = 20;    // plate width along Y (mm)
plate_thk   = 2.5;   // plate thickness along Z (mm)

// ---------- Knuckles ----------
n_segments  = 5;                       // number of equal segments along the edge
seg_len     = plate_len / n_segments;  // segment length = 12 mm
knuckle_d   = 6;     // knuckle outer diameter (mm)
axis_y      = 10;    // knuckle axis Y position (mm)
axis_z      = 3;     // knuckle axis Z position (mm)

// ---------- Pin hole ----------
pin_d       = 2;     // pin hole diameter (mm)
eps         = 0.5;   // overshoot for clean boolean cuts (mm)

difference() {
    union() {
        // Flat plate, centred on origin in X and Y
        translate([-plate_len/2, -plate_wid/2, 0])
            cube([plate_len, plate_wid, plate_thk]);

        // Knuckles on 1st, 3rd and 5th segments (indices 0, 2, 4)
        for (i = [0 : 2 : n_segments - 1])
            translate([-plate_len/2 + i*seg_len, axis_y, axis_z])
                rotate([0, 90, 0])
                    cylinder(d = knuckle_d, h = seg_len);
    }

    // Pin hole along the common knuckle axis, through every knuckle
    translate([-plate_len/2 - eps, axis_y, axis_z])
        rotate([0, 90, 0])
            cylinder(d = pin_d, h = plate_len + 2*eps);
}
