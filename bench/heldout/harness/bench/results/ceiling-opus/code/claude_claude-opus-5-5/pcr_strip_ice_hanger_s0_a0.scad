// PCR 8-strip holder that hooks over a 12 mm ice-bucket wall
// Printed as used: profile in YZ, extruded along X, centred on x = 0

$fn = 64;

// ---- Overall ----
length        = 84;     // extrusion length along X

// ---- Hook (upside-down U) ----
leg_t         = 4;      // thickness of each leg (Y)
inner_leg_y0  = 0;      // inner leg start (Y)
outer_leg_y0  = 16.5;   // outer leg start (Y) -> 12.5 mm wall gap
hook_h        = 50;     // leg height (Z)
bridge_t      = 4;      // bridge thickness (z = 46..50)

// ---- Ledge ----
ledge_t       = 6;      // ledge thickness (z = 0..6)
ledge_reach   = 30;     // ledge extends from y = 0 to y = -30

// ---- Tube holes ----
hole_d        = 6.4;    // through-hole diameter
hole_n        = 8;      // number of tubes
hole_pitch    = 9;      // spacing along X
hole_y        = -15;    // hole centre Y

eps           = 0.5;    // cutter overshoot

difference() {
    union() {
        // inner leg
        translate([-length/2, inner_leg_y0, 0])
            cube([length, leg_t, hook_h]);
        // outer leg
        translate([-length/2, outer_leg_y0, 0])
            cube([length, leg_t, hook_h]);
        // bridge
        translate([-length/2, inner_leg_y0, hook_h - bridge_t])
            cube([length, outer_leg_y0 + leg_t - inner_leg_y0, bridge_t]);
        // ledge
        translate([-length/2, -ledge_reach, 0])
            cube([length, ledge_reach + leg_t, ledge_t]);
    }
    // tube holes
    for (i = [0 : hole_n - 1])
        translate([(i - (hole_n - 1) / 2) * hole_pitch, hole_y, -eps])
            cylinder(d = hole_d, h = ledge_t + 2 * eps);
}