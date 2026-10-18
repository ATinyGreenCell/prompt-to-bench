// 96-well PCR tube rack (0.2 mL) - ANSI/SLAS footprint
// Print orientation: base on XY plane, builds up +Z

// ---- Block dimensions ----
block_len   = 127.76;   // X length (mm)
block_wid   = 85.48;    // Y width (mm)
block_ht    = 20;       // Z height (mm)

// ---- Holes ----
hole_d      = 6.2;      // hole diameter (mm)
hole_nx     = 12;       // columns along X
hole_ny     = 8;        // rows along Y
hole_pitch  = 9.0;      // centre-to-centre spacing (mm)
hole_x0     = 14.38;    // first hole X from left edge (mm)
hole_y0     = 11.24;    // first hole Y from back edge (mm)

// ---- Chamfer (orientation mark at A1 corner) ----
chamf_leg   = 5;        // chamfer leg length (mm)
chamf_angle = 45;       // chamfer angle (deg)

// ---- Misc ----
eps         = 0.5;      // cutter overshoot past faces (mm)
$fn         = 64;

// Derived: grid centre offsets (so grid is centred on block)
grid_xc = (hole_nx - 1) * hole_pitch / 2;   // 99.0 mm
grid_yc = (hole_ny - 1) * hole_pitch / 2;   // 63.0 mm

module rack() {
    difference() {
        // Main block, centred in X/Y, sitting on z = 0
        translate([-block_len / 2, -block_wid / 2, 0])
            cube([block_len, block_wid, block_ht]);

        // 96 through-holes
        for (i = [0 : hole_nx - 1])
            for (j = [0 : hole_ny - 1])
                translate([hole_x0 + i * hole_pitch - grid_xc,
                           hole_y0 + j * hole_pitch - grid_yc,
                           -eps])
                    cylinder(d = hole_d, h = block_ht + 2 * eps);

        // 45-degree chamfer with 5 mm legs off the vertical edge at A1
        // (top-left corner in the plate's X/Y frame)
        translate([hole_x0 - chamf_leg, hole_y0 - chamf_leg,
                   block_ht - chamf_leg])
            linear_extrude(height = chamf_leg, angle = 45)
                polygon(points = [
                    [0, 0],
                    [chamf_leg, 0],
                    [0, chamf_leg]
                ]);
    }
}

rack();