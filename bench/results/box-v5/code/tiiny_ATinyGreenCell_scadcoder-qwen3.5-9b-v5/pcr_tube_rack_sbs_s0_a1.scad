// 96 PCR tube (0.2 mL) rack - microplate footprint
// Print orientation: base on XY plane, builds up +Z

// ---- Block ----
plate_L = 127.76;   // length along X
plate_W = 85.48;    // width along Y
plate_H = 20;       // height along Z

// ---- Holes ----
hole_N     = 96;    // number of holes
hole_D     = 6.2;   // hole diameter
hole_R      = hole_D/2;
hole_pitch = 9.0;   // centre-to-centre spacing
hole_X0    = 14.38; // first hole offset from left edge
hole_Y0    = 11.24; // first hole offset from back edge
eps        = 0.5;   // cutter overshoot past faces

// ---- Chamfer ----
chamf_L = 5;        // chamfer leg length (45 deg)

// ---- Resolution ----
$fn = 64;

// Grid check
row = floor(hole_N/12);   // 8 rows
col = floor(hole_N/8);    // 12 columns
assert(abs(row - hole_N/12) < 0.001, "hole grid not 8 x 12");
assert(abs(col - hole_N/8)  < 0.001, "hole grid not 8 x 12");

difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-plate_L/2, -plate_W/2, 0])
        cube([plate_L, plate_W, plate_H]);

    // Through-holes
    for (i = [0 : hole_N - 1]) {
        x = hole_X0 + i % col * hole_pitch;
        y = hole_Y0 + floor(i/col) * hole_pitch;
        translate([x - eps, y - eps, -eps])
            cylinder(h = plate_H + 2*eps, d = hole_D);
    }

    // Orientation chamfer at A1 corner (lower-left-back)
    translate([-plate_L/2 - eps, -plate_W/2 - eps, 0])
        cube([chamf_L, chamf_L, plate_H]);
}