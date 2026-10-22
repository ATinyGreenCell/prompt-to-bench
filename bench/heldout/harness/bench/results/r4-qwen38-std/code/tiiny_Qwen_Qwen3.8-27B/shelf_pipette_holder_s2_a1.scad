// ---- Dimensions (mm) ----
shelf_thk   = 18;    // shelf thickness the clamp grips
gap         = 18.4;  // vertical gap between jaws for the shelf
spine_x0    = 0;     // spine starts at x = 0
spine_x1    = 5;     // spine ends at x = 5
spine_y0    = 0;     // spine bottom edge
spine_y1    = 28.4;  // spine top edge
jaw_x0      = -25;   // both jaws start at x = -25
jaw_x1      = 5;     // bottom jaw ends at x = 5
bot_y0      = 0;     // bottom jaw bottom edge
bot_y1      = 5;     // bottom jaw top edge
top_y0      = 23.4;  // top jaw bottom edge
top_y1      = 28.4;  // top jaw top edge
arm_x1      = 65;    // top jaw / arm extends to x = 65
extrude_len = 105;   // extrusion along Z (length of holder in use)
hole_d      = 20;    // pipette bore diameter
hole_cx     = 42;    // bore centre in X (profile)
hole_cz     = [17.5, 52.5, 87.5]; // bore centres along Z (in use)

$fn = 64;

// ---- 2-D C-shaped clamp profile in the XY plane ----
profile = union() {
    // spine: x 0..5, y 0..28.4
    translate([spine_x0, spine_y0])
        square([spine_x1 - spine_x0, spine_y1 - spine_y0]);
    // bottom jaw: x -25..5, y 0..5
    translate([jaw_x0, bot_y0])
        square([jaw_x1 - jaw_x0, bot_y1 - bot_y0]);
    // top jaw + forward arm: x -25..65, y 23.4..28.4
    translate([jaw_x0, top_y0])
        square([arm_x1 - jaw_x0, top_y1 - top_y0]);
};

// ---- Extrude the profile 105 mm along Z ----
body = linear_extrude(extrude_len) profile;

// ---- Three 20 mm bores through the arm, along Z ----
bores = for (z = hole_cz)
    translate([hole_cx, 0, z - 1])          // 1 mm past each end face
        cylinder(h = extrude_len + 2, r = hole_d / 2);

// ---- Final solid ----
difference() {
    body;
    bores;
}