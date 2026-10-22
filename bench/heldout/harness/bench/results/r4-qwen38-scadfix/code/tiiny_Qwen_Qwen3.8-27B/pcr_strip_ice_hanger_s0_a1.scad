// 8-tube PCR strip holder that hooks over a 12 mm bucket wall
// Printed as used: rests on XY plane (z=0), builds up +Z, centred on x=0.

$fn = 64;

// ---- Wall / hook dimensions (YZ profile) ----
wall_thick   = 12;    // bucket wall thickness (gap the hook spans)
leg_thick    = 4;     // thickness of each hook leg
hook_height  = 50;    // z=0..50 for both legs
bridge_thick = 4;     // z=46..50 top bridge
// inner leg  : y = 0 .. 4
// outer leg  : y = 16.5 .. 20.5  (gap 4..16.5 = 12.5 mm, clears 12 mm wall)

// ---- Ledge (tube platform) dimensions ----
ledge_thick  = 6;     // z=0..6
ledge_len    = 30;    // reaches y=0 .. y=-30 into the ice

// ---- Tube holes ----
n_tubes      = 8;
hole_diam    = 6.4;   // through-hole diameter
hole_pitch   = 9;     // spacing along X
hole_y       = -15;   // hole centre in Y

// ---- Extrusion ----
extrude_len  = 84;    // extruded along X, centred on x=0

// ---- Build the YZ profile (x=0 plane) and extrude along X ----
module profile() {
    linear_extrude(extrude_len, center = true) {
        // inner leg
        square([leg_thick, hook_height], start = [0, 0]);
        // outer leg
        square([leg_thick, hook_height], start = [wall_thick + 0.5, 0]);
        // top bridge joining the legs
        square([wall_thick + 0.5 + leg_thick, bridge_thick], start = [0, hook_height - bridge_thick]);
        // flat ledge extending toward -Y from the inner-leg foot
        square([ledge_len, ledge_thick], start = [-ledge_len, 0]);
    }
}

// ---- Tube holes (through the ledge, along Z) ----
module holes() {
    for (i = [0 : n_tubes - 1]) {
        x = (i - (n_tubes - 1) / 2) * hole_pitch;   // centred on x=0
        translate([x, hole_y, -1]) {
            cylinder(h = ledge_thick + 2, r = hole_diam / 2, $fn = $fn);
        }
    }
}

// ---- Final solid: profile minus holes ----
difference() {
    profile();
    holes();
}