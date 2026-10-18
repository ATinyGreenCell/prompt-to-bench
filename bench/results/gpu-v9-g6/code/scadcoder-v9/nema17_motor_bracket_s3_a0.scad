// L-shaped mounting bracket for a NEMA 17 stepper motor (e.g. syringe pump)
// Print orientation: base plate on the bed, vertical plate builds upward (+Z)

// ---------------- Parameters ----------------
plate_w      = 50;    // base plate length (X), also vertical plate width (X)
plate_h      = 45;    // base plate depth (Y)
plate_t      = 5;     // base plate thickness (Z)

hole_m4_x    = -17;   // M4 through-hole X position (base plate)
hole_m4_y    = 30;    // M4 through-hole Y position (base plate)
hole_m4_d    = 4.5;   // M4 through-hole diameter

motor_h      = 50;    // vertical motor plate height (Z)
motor_d      = 23;    // motor centring boss hole diameter
motor_z      = 28;    // motor boss hole centre height (Z)

screw_d      = 3.4;   // M3 screw hole diameter
screw_pitch  = 31;    // M3 screw hole square pattern size (X and Y)

gusset_t     = 5;     // triangular gusset thickness (Y)
gusset_l     = 20;    // gusset leg length along +Y and +Z
gusset_x0    = -25;   // gusset start X (left edge)
gusset_x1    = 20;    // gusset start X (right edge)

eps          = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
union() {
    // Base plate with M4 through-holes
    difference() {
        translate([-plate_w/2, 0, 0])
            cube([plate_w, plate_h, plate_t]);
        for (sx = [-1, 1])
            translate([sx * hole_m4_x, hole_m4_y, -eps])
                cylinder(d = hole_m4_d, h = plate_t + 2*eps);
    }

    // Vertical motor plate with boss hole and M3 screw holes
    translate([-plate_w/2, plate_h - gusset_t, 0])
        difference() {
            cube([plate_w, gusset_t, motor_h]);
            translate([0, 0, -eps])
                cylinder(d = motor_d, h = motor_h + 2*eps);
            for (a = [0, 90, 180, 270])
                rotate([0, 0, a])
                    translate([-screw_pitch/2, 0, -eps])
                        cylinder(d = screw_d, h = gusset_t + 2*eps);
        }

    // Triangular gussets, flush with the outer X edges
    for (sx = [-1, 1])
        translate([sx * gusset_x0, 0, 0])
            rotate([90, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon(points = [
                        [0, 0],
                        [0, gusset_l],
                        [gusset_l, gusset_l]
                    ]);
}