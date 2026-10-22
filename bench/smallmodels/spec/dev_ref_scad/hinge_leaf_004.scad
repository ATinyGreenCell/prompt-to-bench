// Pin hinge leaf
// Prints flat: plate on the bed, knuckles along the +Y edge

$fn = 96;

// ---------- Plate ----------
plate_len   = 50;    // length along X
plate_wid   = 25;    // width along Y
plate_thk   = 2.5;   // thickness along Z

// ---------- Knuckles ----------
seg_count   = 5;                    // number of equal segments along the edge
seg_len     = plate_len / seg_count; // 10 mm per segment
knuckle_d   = 7;     // knuckle outer diameter
knuckle_y   = 12.5;  // knuckle axis Y position (plate +Y edge)
knuckle_z   = 3.5;   // knuckle axis Z position (bottom touches bed)

// ---------- Pin hole ----------
pin_d       = 3;     // pin hole diameter
cut_ext     = 0.5;   // overshoot of the hole past each knuckle face

// Segment indices (0-based) that carry knuckles: 1st, 3rd, 5th
knuckle_segs = [0, 2, 4];

// X start of a given segment
function seg_x0(i) = -plate_len/2 + i * seg_len;

module knuckle(i) {
    translate([seg_x0(i), knuckle_y, knuckle_z])
        rotate([0, 90, 0])
            cylinder(d = knuckle_d, h = seg_len);
}

module pin_cut(i) {
    translate([seg_x0(i) - cut_ext, knuckle_y, knuckle_z])
        rotate([0, 90, 0])
            cylinder(d = pin_d, h = seg_len + 2*cut_ext);
}

difference() {
    union() {
        // Flat plate centred on origin
        translate([-plate_len/2, -plate_wid/2, 0])
            cube([plate_len, plate_wid, plate_thk]);

        // Knuckles on segments 1, 3, 5
        for (i = knuckle_segs) knuckle(i);
    }

    // Pin hole through every knuckle
    for (i = knuckle_segs) pin_cut(i);
}
