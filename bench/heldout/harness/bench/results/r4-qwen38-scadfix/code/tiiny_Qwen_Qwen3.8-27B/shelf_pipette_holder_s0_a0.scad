// Dimensions (mm)
shelf_thickness = 18;      // thickness of the shelf being clamped
arm_length      = 65;      // x-extent of the top jaw + arm
spine_x0        = 0;       // left x of the vertical spine
spine_x1        = 5;       // right x of the vertical spine
spine_y0        = 0;       // bottom y of the spine
spine_y1        = 28.4;    // top y of the spine
jaw_x0          = -25;     // left x of both jaws
jaw_x1          = 5;       // right x of the bottom jaw
topjaw_y0       = 23.4;    // bottom y of the top jaw (leaves 18.4 mm gap)
topjaw_y1       = 28.4;    // top y of the top jaw
extrude_len     = 105;     // print length along Z (in use: +Y is up)
hole_d          = 20;      // pipette hole diameter
hole_cx         = 42;      // x-centre of the three holes
hole_cz         = [17.5, 52.5, 87.5];  // z-centres of the three holes

$fn = 64;

// C-shaped clamp profile in the XY plane (2-D)
module profile() { union() {
    // vertical spine
    translate([spine_x0, spine_y0])
        square([spine_x1 - spine_x0, spine_y1 - spine_y0]);
    // bottom jaw
    translate([jaw_x0, 0])
        square([jaw_x1 - jaw_x0, topjaw_y0]);
    // top jaw + forward arm
    translate([jaw_x0, topjaw_y0])
        square([arm_length - jaw_x0, topjaw_y1 - topjaw_y0]);
} }

// Three 20 mm holes through the arm, axes along Y (vertical in use)
module holes() { for (z = hole_cz)
    translate([hole_cx, -1, z])
        rotate([90, 0, 0])
            cylinder(h = extrude_len + 2, r = hole_d / 2, $fn = 64); }

// Final part: extrude the profile 105 mm along Z, then cut the holes
difference() {
    linear_extrude(height = extrude_len)
        profile();
    holes();
}