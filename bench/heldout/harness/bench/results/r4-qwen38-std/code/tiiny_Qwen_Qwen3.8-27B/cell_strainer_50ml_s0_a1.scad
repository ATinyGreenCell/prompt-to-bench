// Coarse cell strainer for a 50 mL conical tube
// Units: mm. Print upright, resting on the XY plane (z = 0), round about Z.

// ---- Dimensions (measured with calipers) ----
OD = 25.0;                 // cup outer diameter
wall = 1.2;                // cup wall thickness
bore = OD - 2*wall;        // 22.6 mm bore
H = 32.0;                  // cup height (z = 0 to 32)
floor_t = 1.2;             // floor thickness (z = 0 to 1.2)

// ---- Flare / collar (rests on the tube rim) ----
cone_z0 = 26.0;            // cone starts at z = 26
cone_z1 = 30.0;            // cone ends at z = 30
cone_d0 = 25.0;            // cone base diameter (matches cup OD)
cone_d1 = 33.0;            // cone top diameter
rim_d = 33.0;              // rim diameter (z = 30 to 32)

// ---- Floor perforation ----
hole_d = 1.0;              // hole diameter
grid = 2.0;                // square grid pitch
r_keep = 10.0;             // keep holes whose centre is within 10 mm of axis

// ---- Vent notches (air escape) ----
vent_w = 3.0;              // notch width
vent_r = 12.5;             // remove collar/rim beyond 12.5 mm from axis
vent_z0 = 25.0;            // notches start at z = 25

$fn = 64;

// ---- Solid cup: outer tube + floor, minus bore ----
cup = difference() {
    union() {
        cylinder(h = H, d = OD, $fn = $fn);
        cylinder(h = floor_t, d = bore, $fn = $fn);   // floor
    }
    translate([0, 0, floor_t])
        cylinder(h = H - floor_t + 0.5, d = bore, $fn = $fn);   // bore (extends past top)
};

// ---- Flare: 45-degree cone + rim (solid, then bored) ----
flare = difference() {
    union() {
        // 45-degree cone: 25 mm dia at z=26 -> 33 mm dia at z=30
        translate([0, 0, cone_z0])
            cylinder(h = cone_z1 - cone_z0, d1 = cone_d0, d2 = cone_d1, $fn = $fn);
        // rim: 33 mm dia from z=30 to z=32
        translate([0, 0, cone_z1])
            cylinder(h = H - cone_z1, d = rim_d, $fn = $fn);
    }
    // bore through the flare (extends past both ends)
    translate([0, 0, cone_z0 - 0.5])
        cylinder(h = (H - cone_z0) + 1.0, d = bore, $fn = $fn);
};

// ---- Floor holes: 1.0 mm on a 2 mm square grid, centred, within 10 mm ----
holes = for (i = [-10:10], j = [-10:10]) {
    x = i * grid;
    y = j * grid;
    if (sqrt(x*x + y*y) <= r_keep) {
        translate([x, y, -0.5])
            cylinder(h = floor_t + 1.0, d = hole_d, $fn = $fn);
    }
};

// ---- Vent notches: 3 mm wide, +X and -X, remove material beyond 12.5 mm ----
vents = for (s = [-1, 1]) {
    translate([s * vent_r, 0, vent_z0 - 0.5])
        cube([vent_w, 2 * vent_r + 1.0, (H - vent_z0) + 1.0], center = [false, true, false]);
};

// ---- Final part ----
difference() {
    union() {
        cup;
        flare;
    }
    union() { holes; }
    union() { vents; }
}