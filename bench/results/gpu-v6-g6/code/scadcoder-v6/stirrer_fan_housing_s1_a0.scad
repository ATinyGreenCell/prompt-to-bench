// DIY magnetic stirrer housing - printed upside down (open box)
// Units: mm

// ---------- Parameters ----------
box_outer_x     = 90;    // outer size in X
box_outer_y     = 90;    // outer size in Y
plate_thickness = 2;     // top plate thickness (z = 0 to 2)
wall_thickness  = 2.5;   // wall thickness
box_height      = 40;    // total height of box (open at z = 37.5 to 40)
hole_d          = 4.5;   // M4 screw hole diameter
hole_count      = 4;     // number of screw holes
hole_pitch      = 71.5;  // square pattern side length for holes
notch_width     = 12;    // cable notch width
notch_depth     = 8;     // cable notch depth from open edge (z = 32 to 40)
eps             = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------- Model ----------
difference() {
    // Solid block of the housing
    translate([-box_outer_x/2, -box_outer_y/2, 0])
        cube([box_outer_x, box_outer_y, box_height]);

    // Open top (from z = box_height - notch_depth to box_height)
    translate([-box_outer_x/2 - eps, -box_outer_y/2 - eps, box_height - notch_depth])
        cube([box_outer_x + 2*eps, box_outer_y + 2*eps, notch_depth + eps]);

    // Screw holes through the top plate, centred on the plate
    for (i = [0 : hole_count - 1]) {
        a = (i % hole_count) * hole_pitch;   // x position
        b = (i / hole_count) * hole_pitch;   // y position
        translate([a - hole_d/2, b - hole_d/2, -eps])
            cube([hole_d, hole_d, plate_thickness + 2*eps]);
    }

    // Cable notch in one wall (along Y, centred)
    translate([-box_outer_x/2 - eps, -box_outer_y/2 - eps/2, box_height - notch_depth])
        cube([box_outer_x + 2*eps, notch_width + eps, notch_depth + eps]);
}