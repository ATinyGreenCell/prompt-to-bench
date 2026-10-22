// Coarse cell strainer for a 50 mL conical tube
// Printed upright, resting on the XY plane at z = 0, round about Z.

// ---- Dimensions (mm) ----
OD          = 25.0;   // outer diameter of the cup tube
wall        = 1.2;    // wall thickness
bore        = OD - 2*wall;   // 22.6 mm bore
H           = 32.0;   // total height of the cup
floor_t     = 1.2;    // floor thickness (z = 0 to 1.2)

// Collar (45-degree flare)
flare_z0    = 26.0;   // z where the flare starts (25 mm dia)
flare_z1    = 30.0;   // z where the flare ends (33 mm dia)
flare_d0    = 25.0;   // diameter at flare_z0
flare_d1    = 33.0;   // diameter at flare_z1
rim_d       = 33.0;   // rim diameter (z = 30 to 32)

// Floor perforation
hole_d      = 1.0;    // hole diameter
grid        = 2.0;    // square grid pitch
r_max       = 10.0;   // keep holes whose centre is within this radius (81 holes)

// Vent notches
vent_w      = 3.0;    // notch width (X) - shaves only the 1.2 mm outer shell
vent_r      = 12.5;   // remove collar/rim beyond this radius from axis
vent_z      = 25.0;   // notches start here and go up

$fn = 64;

// ---- Base cup: outer solid minus bore ----
module cup() { difference() {
    // outer body: straight tube + 45-degree flare + rim
    union() {
        // straight tube, z = 0 to flare_z0
        cylinder(h = flare_z0, d = OD, $fn = $fn);
        // 45-degree flare, z = flare_z0 to flare_z1
        translate([0, 0, flare_z0])
            linear_extrude(h = flare_z1 - flare_z0, center = false,
                           twist = 0, scale = 1, convexity = 10)
                polygon(points = [
                    [flare_d0/2, 0],
                    [flare_d1/2, flare_z1 - flare_z0],
                    [-flare_d1/2, flare_z1 - flare_z0],
                    [-flare_d0/2, 0]
                ]);
        // rim, z = flare_z1 to H
        translate([0, 0, flare_z1])
            cylinder(h = H - flare_z1, d = rim_d, $fn = $fn);
    }
    // bore: open from the top down to the floor
    translate([0, 0, floor_t])
        cylinder(h = H - floor_t + 1, d = bore, $fn = $fn);
} }

// ---- Floor perforation: 81 holes on a 2 mm square grid, centred on axis ----
// Keep every hole whose centre is within r_max of the axis.
// With grid = 2 and r_max = 10, the integer offsets -5..5 give 81 holes.
module holes() { for (i = [-5 : 5]) for (j = [-5 : 5])
    if (sqrt(i*i + j*j) <= r_max)
        translate([i*grid, j*grid, -1])
            cylinder(h = floor_t + 2, d = hole_d, $fn = $fn); }

// ---- Vent notches: +X and -X, 3 mm wide in X, remove collar/rim beyond 12.5 mm ----
// Boxes start at x = vent_r and extend outward, but are capped at x = 12.5
// (just inside the bore radius 11.3) so they only shave the 1.2 mm outer shell
// and never cut the bore or the floor. They are 3 mm wide in X and wide enough
// in Y to clear the rim, so the collar/rim is opened to the air without
// disconnecting the cup.
module vents() { for (s = [-1, 1])
    translate([s*vent_r, -16.5, vent_z - 1])
        cube([vent_r, 33.0, H - vent_z + 2]); }

// ---- Final part ----
difference() {
    cup();
    holes();
    vents();
}