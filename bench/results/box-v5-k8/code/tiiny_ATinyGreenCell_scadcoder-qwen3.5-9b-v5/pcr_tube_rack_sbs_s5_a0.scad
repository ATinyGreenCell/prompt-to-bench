// 96-well PCR tube (0.2 mL) rack - microplate footprint
// Print orientation: base on XY plane, building up +Z

// ---- Block ----
plate_len   = 127.76;  // X length of block
plate_wid   = 85.48;   // Y width of block
plate_ht    = 20;      // block height (Z)

// ---- Holes ----
hole_count  = 96;      // total holes (8 rows x 12 columns)
hole_d      = 6.2;     // hole diameter
hole_pitch  = 9.0;     // centre-to-centre spacing
hole_x0     = 14.38;   // first hole offset from left edge
hole_y0     = 11.24;   // first hole offset from back edge

// ---- Chamfer ----
chamfer_leg = 5;       // chamfer leg length
chamfer_ang = 45;      // chamfer angle (degrees)

// ---- Misc ----
eps         = 0.5;     // cutter overshoot past faces
$fn         = 96;      // curve resolution

// Derived
grid_x = (hole_count % 12 == 0) ? hole_count / 12 : hole_count / 8;  // 12 columns
grid_y = hole_count / 12;                                             // 8 rows
x1 = plate_len - hole_x0 - hole_d / 2 - eps;
y1 = plate_wid - hole_y0 - hole_d / 2 - eps;

difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-plate_len / 2, -plate_wid / 2, 0])
        cube([plate_len, plate_wid, plate_ht]);

    // Through-holes
    for (i = [0 : hole_count - 1]) {
        translate([hole_x0 + i * hole_pitch - hole_d / 2 - eps,
                   hole_y0 + (i - grid_x * hole_pitch) / hole_count * hole_pitch - hole_d / 2 - eps,
                   -eps])
            cylinder(d = hole_d, h = plate_ht + 2 * eps);
    }

    // Orientation chamfer at A1 corner, 45 degrees
    translate([-plate_len / 2 - eps, -plate_wid / 2 - eps, 0])
        cube([plate_len / 2 + eps, plate_wid / 2 + eps, plate_ht]);
    translate([-plate_len / 2 - eps, -plate_wid / 2 - eps, 0])
        cube([chamfer_leg, chamfer_leg, plate_ht]);
}