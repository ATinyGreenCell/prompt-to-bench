// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: base plate on bed, vertical plate builds upward (+Z)

// ---------------- Parameters ----------------
plate_w      = 50;    // base plate length (X)
plate_h      = 45;    // base plate width (Y)
plate_t      = 5;     // base plate thickness (Z)

hole_x       = 17;    // M4 through-hole X offset (±)
hole_y       = 30;    // M4 through-hole Y position
hole_d       = 4.5;   // M4 through-hole diameter

plate_v_w    = 50;    // vertical motor plate length (X)
plate_v_h    = 5;     // vertical motor plate width (Y)
plate_v_z    = 50;    // vertical motor plate height (Z)

boss_d       = 23;    // motor centring boss hole diameter
boss_x       = 0;     // boss hole X centre
boss_z       = 28;    // boss hole Z centre

screw_d      = 3.4;   // M3 screw hole diameter
screw_pitch  = 31;    // square pattern side length

gusset_t     = 5;     // gusset thickness (X)
gusset_leg   = 20;    // right-triangle leg length (Y and Z)
gusset_x     = 25;    // gusset attachment X position

eps          = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([-plate_w/2, 0, 0])
            cube([plate_w, plate_h, plate_t]);

        // Vertical motor plate
        translate([-plate_v_w/2, 0, 0])
            cube([plate_v_w, plate_v_h, plate_v_z]);

        // Gussets (right and left)
        for (sx = [-1, 1])
            translate([sx > 0 ? gusset_x - gusset_t : -gusset_t, 0, 0])
                linear_extrude(height = gusset_t)
                    polygon(points = [
                        [0, gusset_leg],
                        [gusset_leg, gusset_leg],
                        [gusset_leg, 0]
                    ]);
    }

    // M4 through-holes in base plate
    for (x = [-hole_x, hole_x])
        translate([x, hole_y, -eps])
            cylinder(d = hole_d, h = plate_t + 2*eps);

    // Motor boss hole through vertical plate (along Y)
    translate([boss_x, 0, boss_z])
        rotate([90, 0, 0])
            cylinder(d = boss_d, h = plate_v_h + 2*eps);

    // M3 screw holes on square pattern around boss hole
    for (a = [0, 90, 180, 270])
        rotate([0, 0, a])
            translate([screw_pitch/2, screw_pitch/2, 0])
                cylinder(d = screw_d, h = plate_v_z + 2*eps);
}