// Pin hinge leaf: flat plate with three knuckles along the +Y edge
// Units: mm. Print orientation: plate flat on the bed (z = 0).

// ---------------- Parameters ----------------
plate_len    = 50;    // plate length along X
plate_wid    = 30;    // plate width along Y
plate_thk    = 3;     // plate thickness along Z

num_segments = 5;     // number of equal segments along the hinge edge
seg_len      = plate_len / num_segments;  // 10 mm per segment

knuckle_d    = 6;     // knuckle outer diameter
knuckle_y    = 15;    // knuckle axis Y position (at the +Y edge)
knuckle_z    = 3;     // knuckle axis Z position (top of plate)

pin_d        = 2.5;   // pin hole diameter
cut_extra    = 0.5;   // extra length so cutters pass beyond faces

knuckle_segs = [0, 2, 4];  // 0-based indices of segments 1, 3 and 5

$fn = 96;             // smoothness for curved shapes

// ---------------- Model ----------------
difference() {
    union() {
        // Flat plate, centred on origin in X and Y
        translate([-plate_len/2, -plate_wid/2, 0])
            cube([plate_len, plate_wid, plate_thk]);

        // Knuckles on segments 1, 3 and 5
        for (i = knuckle_segs)
            translate([-plate_len/2 + i*seg_len, knuckle_y, knuckle_z])
                rotate([0, 90, 0])
                    cylinder(d = knuckle_d, h = seg_len);
    }

    // Pin hole along the common knuckle axis, through every knuckle
    translate([-plate_len/2 - cut_extra, knuckle_y, knuckle_z])
        rotate([0, 90, 0])
            cylinder(d = pin_d, h = plate_len + 2*cut_extra);
}
