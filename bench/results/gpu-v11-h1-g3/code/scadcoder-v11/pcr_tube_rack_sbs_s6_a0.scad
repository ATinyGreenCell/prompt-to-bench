// 96-well PCR tube rack (0.2 mL) - microplate footprint
// Print orientation: base on XY plane, holes through full height

// ---- Dimensions (mm) ----
plate_length   = 127.76;  // X
plate_width    = 85.48;   // Y
plate_height   = 20;      // Z
hole_d         = 6.2;     // tube hole diameter
hole_pitch     = 9.0;     // centre-to-centre spacing
hole_x0        = 14.38;   // A1 offset from left edge
hole_y0        = 11.24;   // A1 offset from back edge
chamfer_leg    = 5;       // 45-degree chamfer leg length
eps            = 0.5;     // cutter overshoot

$fn = 64;

difference() {
    // Main block, centred in X/Y, sitting on z = 0
    translate([-plate_length/2, -plate_width/2, 0])
        cube([plate_length, plate_width, plate_height]);

    // Tube holes
    for (i = [0 : 11])
        for (j = [0 : 7])
            translate([(i - 5.5) * hole_pitch + hole_x0,
                       (j - 3.5) * hole_pitch + hole_y0,
                       -eps])
                cylinder(d = hole_d, h = plate_height + 2*eps);

    // Chamfer at A1 corner (x = hole_x0, y = hole_y0)
    translate([hole_x0 - chamfer_leg, hole_y0 - chamfer_leg, 0])
        rotate([45, 0, 0])
            cube([chamfer_leg, chamfer_leg, plate_height]);
}