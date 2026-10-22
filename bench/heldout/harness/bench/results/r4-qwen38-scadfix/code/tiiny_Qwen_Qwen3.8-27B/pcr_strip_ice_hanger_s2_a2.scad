// 8-tube PCR strip holder that hooks over a 12 mm ice-bucket wall.
// Printed as used: rests on the XY plane at z = 0, builds upward (+Z), centred on x = 0.
// The part is a profile in the YZ plane extruded 84 mm along X.
// We build the profile in the XY plane (x = Y, y = Z) and extrude along Z,
// then rotate 90 deg about Y so the extrusion axis becomes X and Z stays Z.

$fn = 64;

// ---- Dimensions (mm) ----
extrude_x   = 84;    // length of the part along X

// Upside-down U profile (Y = horizontal, Z = vertical)
inner_leg_y0 = 0;    // inner face of inner leg
inner_leg_y1 = 4;    // outer face of inner leg (wall 12 mm -> 12.5 mm gap)
outer_leg_y0 = 16.5; // inner face of outer leg
outer_leg_y1 = 20.5; // outer face of outer leg
leg_z0       = 0;    // bottom of both legs
leg_z1       = 50;   // top of both legs
bridge_z0    = 46;   // bottom of top bridge
bridge_z1    = 50;   // top of top bridge
// gap between inner and outer legs = 16.5 - 4 = 12.5 mm (clears 12 mm wall)

// Flat ledge reaching into the ice
ledge_y0     = -30;  // far end of ledge (toward -Y)
ledge_y1     = 0;    // meets the foot of the inner leg
ledge_z0     = 0;    // bottom of ledge
ledge_z1     = 6;    // top of ledge (6 mm thick)

// Tube holes
hole_d       = 6.4;  // through-hole diameter
hole_pitch   = 9;    // spacing along X
hole_y       = -15;  // hole centre in Y
hole_z0      = -1;   // extend below z = 0
hole_z1      = 7;    // extend above ledge top (6)

// ---- Build the part ----
module part() {
    rotate([0, 90, 0]) {   // extrusion axis (Z) -> X ; profile y (Z) -> Z
        difference() {
            union() {
                // Inner leg (profile in XY: x = Y, y = Z)
                linear_extrude(height = extrude_x, center = true) {
                    polygon(points = [
                        [inner_leg_y0, leg_z0],
                        [inner_leg_y1, leg_z0],
                        [inner_leg_y1, leg_z1],
                        [inner_leg_y0, leg_z1]
                    ]);
                }
                // Outer leg
                linear_extrude(height = extrude_x, center = true) {
                    polygon(points = [
                        [outer_leg_y0, leg_z0],
                        [outer_leg_y1, leg_z0],
                        [outer_leg_y1, leg_z1],
                        [outer_leg_y0, leg_z1]
                    ]);
                }
                // Top bridge spanning the 12.5 mm gap
                linear_extrude(height = extrude_x, center = true) {
                    polygon(points = [
                        [inner_leg_y1, bridge_z0],
                        [outer_leg_y0, bridge_z0],
                        [outer_leg_y0, bridge_z1],
                        [inner_leg_y1, bridge_z1]
                    ]);
                }
                // Flat ledge reaching toward -Y from the foot of the inner leg
                linear_extrude(height = extrude_x, center = true) {
                    polygon(points = [
                        [ledge_y0, ledge_z0],
                        [ledge_y1, ledge_z0],
                        [ledge_y1, ledge_z1],
                        [ledge_y0, ledge_z1]
                    ]);
                }
            }

            // Eight vertical 6.4 mm through-holes in the ledge, 9 mm apart along X, centred
            for (i = [-3, -2, -1, 0, 1, 2, 3, 4]) {
                x_pos = -31.5 + i * hole_pitch;   // -31.5 .. +31.5, centred on x = 0
                translate([x_pos, hole_y, 0]) {
                    cylinder(h = hole_z1 - hole_z0, r = hole_d / 2, center = false);
                }
            }
        }
    }
}

part();