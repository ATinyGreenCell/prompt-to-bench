// 96-well PCR tube rack (0.2 mL) - microplate footprint
// Print orientation: base on XY plane, holes through in Z

// ---- Dimensions (mm) ----
plate_length   = 127.76;  // X
plate_width    = 85.48;   // Y
plate_height   = 20;      // Z
hole_d         = 6.2;     // tube hole diameter
hole_pitch     = 9;       // centre-to-centre spacing
hole_count_x   = 12;      // columns along X
hole_count_y   = 8;       // rows along Y
chamfer_leg    = 5;       // 45-degree chamfer leg length
cut_extra      = 0.5;     // overshoot for clean cuts

$fn = 64;

difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-plate_length/2, -plate_width/2, 0])
        cube([plate_length, plate_width, plate_height]);

    // Tube holes, grid centred on block (A1 at 14.38, 11.24)
    for (i = [0 : hole_count_x - 1])
        for (j = [0 : hole_count_y - 1])
            translate([14.38 - i * hole_pitch, 11.24 - j * hole_pitch, -cut_extra])
                cylinder(d = hole_d, h = plate_height + 2 * cut_extra);

    // Chamfer at A1 corner (x min, y max), extends above top face
    translate([0, plate_width/2, plate_height - chamfer_leg])
        rotate([90, 0, 0])
            linear_extrude(h = chamfer_leg + cut_extra)
                polygon([
                    [0, 0],
                    [chamfer_leg, 0],
                    [chamfer_leg, chamfer_leg],
                    [0, chamfer_leg]
                ]);
}