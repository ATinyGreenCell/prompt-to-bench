// 96-well PCR tube rack (0.2 mL) - microplate footprint
// Units: mm. Print orientation: base on XY plane, builds up +Z.

// ---------- Parameters ----------
plate_length    = 127.76;   // block length along X
plate_width     = 85.48;    // block width along Y
plate_height    = 20;       // block height along Z

hole_count      = 96;       // number of tube holes
hole_d          = 6.2;      // hole diameter
hole_pitch_x    = 9.0;      // centre-to-centre spacing along X
hole_pitch_y    = 9.0;      // centre-to-centre spacing along Y
hole_columns    = 12;       // holes along X
hole_rows       = 8;        // holes along Y

hole_offset_x   = 14.38;    // distance of A1 from left edge
hole_offset_y   = 11.24;    // distance of A1 from back edge

chamfer_leg     = 5;        // 45-degree chamfer leg length at A1 corner
chamfer_overcut = 0.5;      // extra cutter length past the face

$fn = 64;

// ---------- Model ----------
difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-plate_length/2, -plate_width/2, 0])
        cube([plate_length, plate_width, plate_height]);

    // Tube holes, grid centred on the block
    for (i = [0 : hole_columns - 1])
        for (j = [0 : hole_rows - 1])
            translate([hole_offset_x + i * hole_pitch_x - hole_pitch_x/2,
                       hole_offset_y + j * hole_pitch_y - hole_pitch_y/2,
                       -1])
                cylinder(d = hole_d, h = plate_height + 2);

    // 45-degree chamfer at the A1 corner (top-left-rear), extended above the face
    translate([-plate_length/2, -plate_width/2, plate_height])
        rotate([90, 0, 0])
            linear_extrude(height = chamfer_overcut)
                polygon([
                    [0, 0],
                    [chamfer_leg, 0],
                    [chamfer_leg, chamfer_leg],
                    [0, chamfer_leg]
                ]);
}