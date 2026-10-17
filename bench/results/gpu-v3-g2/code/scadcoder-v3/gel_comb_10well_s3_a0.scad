// 10-well agarose gel comb - printed flat on the bed
// Units: mm

$fn = 64;

// ---- Parameters ----
plate_t      = 1.5;   // comb thickness (Z)
spine_len    = 70;    // spine length (X)
spine_w      = 12;    // spine width (Y)
n_teeth      = 10;    // number of teeth / wells
tooth_w      = 5.0;   // tooth width (X)
tooth_len    = 12;    // tooth length (Y), hanging in -Y
tooth_gap    = 1.5;   // gap between neighbouring teeth (X)
overlap      = 0.01;  // small overlap so teeth fuse into spine

// ---- Derived ----
row_w     = n_teeth * tooth_w + (n_teeth - 1) * tooth_gap; // total width of tooth row
total_y   = spine_w + tooth_len;                           // overall Y extent
y_min     = -total_y / 2;                                  // centre part in Y
spine_y0  = y_min + tooth_len;                             // spine starts after teeth
tooth_x0  = -row_w / 2;                                    // first tooth left edge
pitch     = tooth_w + tooth_gap;                           // tooth pitch

// ---- Model ----
union() {
    // Spine (back bar)
    translate([-spine_len / 2, spine_y0, 0])
        cube([spine_len, spine_w, plate_t]);

    // Teeth
    for (i = [0 : n_teeth - 1])
        translate([tooth_x0 + i * pitch, y_min, 0])
            cube([tooth_w, tooth_len + overlap, plate_t]);
}