// Bead-beating tube holder: 8 x 2 mL round-bottom tubes
// Print orientation: flat bottom on bed, seats open upward

$fn = 96;

// --- Puck ---
puck_d      = 80;    // puck diameter
puck_h      = 26;    // puck height
flat_x      = 34;    // label flat: everything beyond x = flat_x removed

// --- Seats ---
n_seats     = 8;     // number of tube seats
seat_circle = 50;    // diameter of the circle the seat centres lie on
seat_d      = 11.2;  // seat (tube) diameter
seat_bottom = 6;     // z of lowest point of the hemispherical seat bottom

// --- Derived ---
seat_r      = seat_d / 2;
sphere_z    = seat_bottom + seat_r;   // centre of hemisphere
eps         = 0.5;                    // cutter overrun

difference() {
    // Puck with flat label side
    intersection() {
        cylinder(d = puck_d, h = puck_h);
        translate([-puck_d, -puck_d, -eps])
            cube([puck_d + flat_x, 2 * puck_d, puck_h + 2 * eps]);
    }

    // Tube seats
    for (i = [0 : n_seats - 1]) {
        a = i * 360 / n_seats;
        translate([seat_circle / 2 * cos(a), seat_circle / 2 * sin(a), 0]) {
            translate([0, 0, sphere_z])
                sphere(r = seat_r);
            translate([0, 0, sphere_z])
                cylinder(r = seat_r, h = puck_h - sphere_z + eps);
        }
    }
}