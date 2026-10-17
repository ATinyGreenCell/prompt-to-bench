// 10-well agarose gel comb - printed lying flat
// Units: mm

$fn = 64;

// ---- Parameters ----
plate_t     = 1.5;   // plate thickness (Z)
spine_len   = 70;    // spine length (X)
spine_w     = 12;    // spine width (Y)
n_teeth     = 10;    // number of teeth / wells
tooth_w     = 5.0;   // tooth width (X)
tooth_len   = 12;    // tooth length (Y), hanging in -Y
tooth_gap   = 1.5;   // gap between neighbouring teeth (X)
overlap     = 0.5;   // tooth overlap into spine for a solid union

// ---- Derived ----
row_w   = n_teeth * tooth_w + (n_teeth - 1) * tooth_gap; // total width of tooth row
total_y = spine_w + tooth_len;                           // overall Y extent
y0      = -total_y / 2;                                  // bottom (tooth tips) Y
spine_y = y0 + tooth_len;                                // spine lower edge Y

// ---- Model ----
union() {
    // Spine (back bar)
    translate([-spine_len / 2, spine_y, 0])
        cube([spine_len, spine_w, plate_t]);

    // Teeth, centred on spine in X
    for (i = [0 : n_teeth - 1])
        translate([-row_w / 2 + i * (tooth_w + tooth_gap), y0, 0])
            cube([tooth_w, tooth_len + overlap, plate_t]);
}