// 96-well PCR tube rack (0.2 mL, standard microplate footprint)
// Units: mm. Print orientation: base on XY plane, building +Z.

// ---- Block ----
plate_length   = 127.76;   // X dimension (A1 to H12)
plate_width    = 85.48;    // Y dimension (1 to 12)
plate_height   = 20;       // Z dimension

// ---- Holes ----
hole_count     = 96;       // 8 rows x 12 columns
hole_d         = 6.2;      // through-hole diameter
hole_pitch_x   = 9.0;      // centre-to-centre spacing along X
hole_pitch_y   = 9.0;      // centre-to-centre spacing along Y
hole_start_x   = 14.38;    // A1 centre distance from left edge
hole_start_y   = 11.24;    // A1 centre distance from back edge

// ---- Chamfer (orientation mark at A1 corner) ----
chamfer_angle  = 45;       // degrees from vertical
chamfer_leg    = 5;        // length of each leg

// ---- Misc ----
eps            = 0.5;      // cutter overshoot past faces
$fn            = 64;

difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-plate_length/2, -plate_width/2, 0])
        cube([plate_length, plate_width, plate_height]);

    // Through-holes in a centred grid
    for (i = [0 : hole_count - 1]) {
        x = hole_start_x + i % 12 * hole_pitch_x;
        y = hole_start_y + floor(i / 12) * hole_pitch_y;
        translate([x - hole_d/2, y - hole_d/2, -eps])
            cylinder(d = hole_d, h = plate_height + 2*eps);
    }

    // 45-degree chamfer with 5 mm legs off the vertical edge at A1
    translate([hole_start_x - 1, hole_start_y - 1, 0])
        linear_extrude(height = plate_height + 1, angle = chamfer_angle)
            polygon([[-chamfer_leg, chamfer_leg], [chamfer_leg, chamfer_leg]]);
}