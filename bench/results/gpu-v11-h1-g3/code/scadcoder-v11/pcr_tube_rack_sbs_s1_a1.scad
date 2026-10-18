// 96-well PCR tube rack (0.2 mL) - microplate footprint
// Print orientation: base on XY plane, holes through full height

// ---------- Parameters ----------
plate_length   = 127.76;  // X size of block
plate_width    = 85.48;   // Y size of block
plate_height   = 20;      // Z height of block

hole_d         = 6.2;     // through-hole diameter
hole_pitch     = 9.0;     // centre-to-centre spacing (X and Y)
hole_count_x   = 12;      // number of columns along X
hole_count_y   = 8;       // number of rows along Y

chamfer_leg    = 5;       // 45-degree chamfer leg length at A1 corner

a1_offset_x    = 14.38;   // centre of A1 from left edge
a1_offset_y    = 11.24;   // centre of A1 from back edge

eps            = 0.5;     // cutter overshoot past faces

$fn = 64;

// ---------- Derived ----------
x0 = a1_offset_x - (hole_count_x - 1) * hole_pitch / 2;
y0 = a1_offset_y - (hole_count_y - 1) * hole_pitch / 2;

// ---------- Model ----------
difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-plate_length / 2, -plate_width / 2, 0])
        cube([plate_length, plate_width, plate_height]);

    // 96 through-holes
    for (i = [0 : hole_count_x - 1])
        for (j = [0 : hole_count_y - 1])
            translate([x0 + i * hole_pitch, y0 + j * hole_pitch, -eps])
                cylinder(d = hole_d, h = plate_height + 2 * eps);

    // Chamfer at A1 corner (positive X, positive Y)
    translate([plate_length / 2 - chamfer_leg,
               plate_width / 2 - chamfer_leg,
               chamfer_leg])
        cube([chamfer_leg, chamfer_leg, chamfer_leg]);
}