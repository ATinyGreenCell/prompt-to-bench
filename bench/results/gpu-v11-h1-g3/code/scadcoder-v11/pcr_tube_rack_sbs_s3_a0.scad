// 96-well PCR tube rack (0.2 mL) - microplate footprint
// Print orientation: base on XY plane, holes through the full height

// ---------------- Parameters ----------------
plate_x      = 127.76;   // block length along X (mm)
plate_y      = 85.48;    // block width along Y (mm)
plate_h      = 20;       // block height along Z (mm)

hole_d       = 6.2;      // tube hole diameter (mm)
hole_nx      = 12;       // number of columns along X
hole_ny      = 8;        // number of rows along Y
hole_pitch   = 9.0;      // centre-to-centre spacing (mm)

chamfer_leg  = 5;        // 45-degree chamfer leg length (mm)
chamfer_z0   = 11.24;    // Z height of the A1 corner (cut starts here)

eps          = 0.5;      // overshoot for clean boolean cuts (mm)
$fn          = 96;       // circle resolution

// ---------------- Derived ----------------
x0 = 14.38;              // first hole offset from left edge (mm)
y0 = 11.24;              // first hole offset from back edge (mm)

// ---------------- Model ----------------
difference() {
    // Main block, centred in X/Y, sitting on z = 0
    translate([-plate_x / 2, -plate_y / 2, 0])
        cube([plate_x, plate_y, plate_h]);

    // 96 vertical through-holes
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([x0 + i * hole_pitch - hole_d / 2,
                       y0 + j * hole_pitch - hole_d / 2,
                       -eps])
                cylinder(d = hole_d, h = plate_h + 2 * eps);

    // 45-degree chamfer at the A1 corner (orientation mark)
    // solid is trimmed up to z = chamfer_z0 - eps, then the chamfer is cut
    translate([x0 - eps, y0 - eps, 0])
        difference() {
            cube([eps + (chamfer_leg + eps) * 2,
                  eps + (chamfer_leg + eps) * 2,
                  chamfer_z0 - eps]);
            translate([chamfer_leg, 0, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = chamfer_leg)
                        polygon([
                            [0, 0],
                            [chamfer_leg, 0],
                            [0, chamfer_leg]
                        ]);
        }
}