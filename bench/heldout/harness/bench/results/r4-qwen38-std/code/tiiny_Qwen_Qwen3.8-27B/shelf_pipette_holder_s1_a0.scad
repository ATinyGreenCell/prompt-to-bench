// ---------------------------------------------------------------------------
// 3-pipette shelf clamp, printed on its side.
// Print orientation: 2-D profile in XY, extruded 105 mm along Z.
// In use: +Y is up, +X points away from the shelf, Z is the long axis.
// ---------------------------------------------------------------------------

// --- named dimensions (mm) ---
shelf_t   = 18;    // shelf thickness the clamp grips
gap       = 18.4;  // vertical gap between jaws (shelf + clearance)
spine_x0  = 0;     // spine left edge
spine_x1  = 5;     // spine right edge
spine_y0  = 0;     // spine bottom edge
spine_y1  = 28.4;  // spine top edge
jaw_x0    = -25;   // jaw left edge (both jaws)
jaw_x1    = 5;     // jaw right edge (bottom jaw)
topjaw_x1 = 65;    // top jaw / arm right edge
botjaw_y0 = 0;     // bottom jaw bottom edge
botjaw_y1 = 5;     // bottom jaw top edge
topjaw_y0 = 23.4;  // top jaw bottom edge
topjaw_y1 = 28.4;  // top jaw top edge
extrude   = 105;   // length of the clamp along Z

// pipette holes: 20 mm dia, through the arm along Y (vertical in use)
hole_d    = 20;
hole_x    = 42;    // hole centre in X (profile)
hole_z    = [17.5, 52.5, 87.5];  // hole centres along Z

$fn = 64;

// --- 2-D C-shaped profile in the XY plane (union of three rectangles) ---
profile = union() {
    // spine: x 0..5, y 0..28.4
    translate([spine_x0, spine_y0])
        square([spine_x1 - spine_x0, spine_y1 - spine_y0]);
    // bottom jaw: x -25..5, y 0..5
    translate([jaw_x0, botjaw_y0])
        square([jaw_x1 - jaw_x0, botjaw_y1 - botjaw_y0]);
    // top jaw + arm: x -25..65, y 23.4..28.4
    translate([jaw_x0, topjaw_y0])
        square([topjaw_x1 - jaw_x0, topjaw_y1 - topjaw_y0]);
};

// --- extrude the profile 105 mm along Z, then drill the three holes ---
difference() {
    linear_extrude(height = extrude)
        profile;

    for (hz = hole_z) {
        // cylinder axis along Y, centred at (x = hole_x, z = hz)
        translate([hole_x, -hole_d / 2 - 1, hz])
            rotate([90, 0, 0])
                cylinder(h = hole_d + 2, r = hole_d / 2, $fn = $fn);
    }
}