// 96-well PCR tube (0.2 mL) rack - microplate footprint
// Print orientation: base on XY plane, builds up +Z

// ---- Block ----
plate_len   = 127.76;   // X length
plate_wid   = 85.48;    // Y width
plate_ht    = 20;       // Z height

// ---- Holes ----
hole_d      = 6.2;      // hole diameter
row         = 8;        // rows along Y
col         = 12;       // columns along X
pitch       = 9.0;      // centre-to-centre spacing
x0          = 14.38;    // first hole X offset from left
y0          = 11.24;    // first hole Y offset from back

// ---- Chamfer ----
cham_d      = 5;        // leg length of 45-degree chamfer at A1 corner

// ---- Misc ----
eps         = 0.5;      // cutter overshoot past faces
$fn         = 96;       // curve resolution

difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-plate_len/2, -plate_wid/2, 0])
        cube([plate_len, plate_wid, plate_ht]);

    // Hole grid
    for (i = [0 : col - 1])
        for (j = [0 : row - 1])
            translate([x0 + i * pitch - plate_len/2,
                       y0 + j * pitch - plate_wid/2,
                       -eps])
                cylinder(d = hole_d, h = plate_ht + 2 * eps);

    // Orientation mark: 45-degree chamfer off the vertical edge at A1
    translate([-plate_len/2 - eps, -plate_wid/2 - eps, 0])
        linear_extrude(height = plate_ht + 2 * eps)
            polygon([[-plate_len/2 - eps, -plate_wid/2 - eps],
                     [-plate_len/2 - eps, plate_wid/2 + eps],
                     [plate_len/2 + eps, -plate_wid/2 - eps]]);
}