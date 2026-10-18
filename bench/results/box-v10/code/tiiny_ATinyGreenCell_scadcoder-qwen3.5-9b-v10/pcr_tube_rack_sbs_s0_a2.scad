// 96-well PCR tube rack (0.2 mL) - microplate footprint
// Units: mm. Print orientation: base on XY plane, building up +Z.

// ---------- Parameters ----------
plate_length    = 127.76;   // block length along X
plate_width     = 85.48;    // block width along Y
plate_height    = 20;       // block height along Z

hole_count      = 96;       // number of tube holes
hole_diameter   = 6.2;      // hole diameter
hole_pitch_x    = 9.0;      // centre-to-centre spacing along X
hole_pitch_y    = 9.0;      // centre-to-centre spacing along Y
hole_rows       = 8;        // number of rows (along Y)
hole_columns    = 12;       // number of columns (along X)

hole_offset_x   = 14.38;    // X position of first hole (A1) from left edge
hole_offset_y   = 11.24;    // Y position of first hole (A1) from back edge

chamfer_leg     = 5;        // leg length of 45-degree chamfer (A1 corner)
chamfer_extra   = 0.5;      // overshoot so cuts pass beyond the faces

$fn = 64;                   // curve resolution

// ---------- Derived ----------
first_x = hole_offset_x - (hole_columns - 1) * hole_pitch_x / 2;   // grid centre X
first_y = hole_offset_y - (hole_rows - 1) * hole_pitch_y / 2;      // grid centre Y

// ---------- Model ----------
difference() {
    // Main block
    translate([-plate_length / 2, -plate_width / 2, 0])
        cube([plate_length, plate_width, plate_height]);

    // Tube holes
    for (i = [0 : hole_count - 1]) {
        translate([first_x + i * hole_pitch_x,
                   first_y + i * hole_pitch_y,
                   -chamfer_extra])
            cylinder(d = hole_diameter, h = plate_height + 2 * chamfer_extra);
    }

    // 45-degree chamfer at the A1 corner (top-left-rear), extended past the faces
    translate([hole_offset_x - chamfer_extra, hole_offset_y - chamfer_extra,
               plate_height - chamfer_extra])
        cube([chamfer_leg + chamfer_extra, chamfer_leg + chamfer_extra,
              chamfer_leg + chamfer_extra]);
}