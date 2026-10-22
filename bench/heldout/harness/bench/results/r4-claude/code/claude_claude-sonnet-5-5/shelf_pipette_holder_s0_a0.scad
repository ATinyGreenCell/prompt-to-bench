// Pipette holder: shelf-edge clamp with arm, printed on its side
// Profile in XY, extruded along Z. In use: +Y up, +X away from the shelf.

$fn = 64;

// --- Dimensions (mm) ---
length_z      = 105;    // extrusion length along Z
spine_x0      = 0;      // spine start X
spine_x1      = 5;      // spine end X
spine_y0      = 0;      // spine start Y
spine_y1      = 28.4;   // spine end Y
jaw_x0        = -25;    // jaw back end X
bot_jaw_y0    = 0;      // bottom jaw bottom Y
bot_jaw_y1    = 5;      // bottom jaw top Y
top_jaw_y0    = 23.4;   // top jaw/arm bottom Y
top_jaw_y1    = 28.4;   // top jaw/arm top Y
arm_x1        = 65;     // arm front end X
hole_d        = 20;     // pipette hole diameter
hole_x        = 42;     // hole centre X
hole_z        = [17.5, 52.5, 87.5]; // hole centre Z positions
cut_margin    = 1;      // cutter overshoot past faces

difference() {
    // Clamp profile extruded along Z
    linear_extrude(height = length_z)
        union() {
            // spine
            translate([spine_x0, spine_y0])
                square([spine_x1 - spine_x0, spine_y1 - spine_y0]);
            // bottom jaw
            translate([jaw_x0, bot_jaw_y0])
                square([spine_x1 - jaw_x0, bot_jaw_y1 - bot_jaw_y0]);
            // top jaw and arm
            translate([jaw_x0, top_jaw_y0])
                square([arm_x1 - jaw_x0, top_jaw_y1 - top_jaw_y0]);
        }

    // Pipette holes through the arm along Y
    for (z = hole_z)
        translate([hole_x, top_jaw_y0 - cut_margin, z])
            rotate([-90, 0, 0])
                cylinder(d = hole_d,
                         h = (top_jaw_y1 - top_jaw_y0) + 2 * cut_margin,
                         $fn = 96);
}