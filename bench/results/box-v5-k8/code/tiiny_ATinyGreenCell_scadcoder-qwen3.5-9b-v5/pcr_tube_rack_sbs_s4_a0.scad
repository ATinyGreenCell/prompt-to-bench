// 96 PCR tube (0.2 mL) rack - microplate footprint
// Print orientation: base on XY plane, builds up +Z

// ---- Block ----
plate_len   = 127.76;  // X length
plate_wid   = 85.48;   // Y width
plate_ht    = 20;      // Z height

// ---- Holes ----
hole_d      = 6.2;     // hole diameter
hole_pitch  = 9.0;      // centre-to-centre spacing
hole_rows   = 8;        // rows along Y
hole_cols   = 12;       // columns along X
hole_x0     = 14.38;    // first hole X from left edge
hole_y0     = 11.24;    // first hole Y from back edge

// ---- Chamfer ----
chamfer_leg = 5;       // 45-degree chamfer leg length
chamfer_x   = hole_x0 + hole_d/2 + 0.01;  // face to be chamfered (A1 corner)
chamfer_y   = plate_wid - hole_y0 - hole_d/2 - 0.01;  // opposite face

// ---- Render ----
$fn = 64;

difference() {
    // Main block, centred in X/Y, sitting on z = 0
    translate([-plate_len/2, -plate_wid/2, 0])
        cube([plate_len, plate_wid, plate_ht]);

    // Through-holes
    for (i = [0 : hole_rows - 1])
        for (j = [0 : hole_cols - 1])
            translate([hole_x0 + j * hole_pitch,
                       hole_y0 + i * hole_pitch,
                       -1])
                cylinder(d = hole_d, h = plate_ht + 2);

    // 45-degree chamfer off the A1 corner vertical edge
    translate([chamfer_x, 0, 0])
        linear_extrude(height = chamfer_y)
            polygon([[(0, 0), (chamfer_leg, 0), (chamfer_leg, chamfer_leg), (0, chamfer_leg)]]);
}