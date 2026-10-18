// L-shaped mounting bracket for a NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on the bed, vertical plate builds upward (+Z)

// ---------------- Parameters ----------------
plate_x       = 50;    // base plate length (x: -25 .. 25)
plate_y       = 45;    // base plate width (y: 0 .. 45)
plate_t       = 5;     // base plate thickness (z: 0 .. 5)

motor_h       = 50;    // vertical motor plate height (z: 0 .. 50)
hole_d        = 23;    // motor centring boss hole diameter
hole_x        = 0;     // boss hole centre X
hole_z        = 28;    // boss hole centre Z
screw_d       = 3.4;   // M3 screw hole diameter
screw_pitch   = 31;    // distance between opposite M3 screw holes (square)

gusset_t      = 5;     // gusset thickness (X)
gusset_leg    = 20;    // right-triangle leg length (Y and Z)

eps           = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
union() {
    // Base plate with two M4 through-holes at (x = -17, y = 30) and (x = 17, y = 30)
    difference() {
        translate([-plate_x/2, 0, 0])
            cube([plate_x, plate_y, plate_t]);

        for (sx = [-17, 17])
            translate([sx, y = 30, -eps])
                cylinder(d = 4.5, h = plate_t + 2*eps);
    }

    // Vertical motor plate, standing on the back edge of the base (y = 0)
    difference() {
        translate([-plate_x/2, plate_y - gusset_t, 0])   // x: -25 .. 25, y: 5 .. 40
            cube([plate_x, gusset_t, motor_h]);

        // Motor centring boss hole, along Y
        translate([hole_x, -eps, hole_z])
            rotate([-90, 0, 0])
                cylinder(d = hole_d, h = gusset_t + 2*eps);

        // Four M3 screw holes on a 31 mm square pattern, centred on the boss hole
        for (a = [0, 90, 180, 270])
            rotate([0, 0, a])
                translate([0, 0, hole_z])
                    cylinder(d = screw_d, h = gusset_t + 2*eps);
    }

    // Two triangular gussets, flush with the left and right edges:
    // right triangle in the YZ plane with legs 20 mm along +Y and 20 mm along +Z,
    // right-angle corner at (y = 5, z = 5), thickness 5 mm in X.
    for (sx = [-1, 1])
        translate([sx * (plate_x/2 - gusset_t), 0, 0])
            hull() {
                translate([0, gusset_t, 0])
                    cube([gusset_t, gusset_t, 0]);          // leg along +Y
                translate([0, 0, gusset_t])
                    cube([0, gusset_t, gusset_t]);          // leg along +Z
            }
}