// L-bracket for a NEMA 17 stepper motor (syringe pumps, peristaltic pumps, shakers)
// Category: full hardware. Base plate with two M4 holes, vertical motor plate with
// the 22 mm boss hole + 31 mm M3 pattern, two gussets. Motor body mounts on the
// back (-Y) side, shaft pointing over the base - screw the base down before mounting
// the motor, or the bracket tips backwards.
// The boss hole has a 45 deg teardrop top so its crown prints without sagging onto
// the motor's centring boss; check that the boss fits before final assembly.
// Print: PETG, base on the bed, 0.2 mm layers, 5 perimeters, 30 % infill.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Bracket] */
base = [50, 45, 5];      // X, Y, Z: spans y = 0..45
plate = [50, 5, 50];     // vertical plate at y = 0..5
boss_d = 23;             // NEMA 17 centring boss is 22 mm
boss_z = 28;             // motor axis height
screw_d = 3.4;           // M3 clearance
screw_spacing = 31;      // NEMA 17 bolt pattern
mount_d = 4.5;           // M4 clearance
mount_pos = [[-17, 30], [17, 30]];
gusset_t = 5;
gusset_len = 20;

/* [Hidden] */
eps = 0.01;

difference() {
    union() {
        translate([-base.x / 2, 0, 0]) cube(base);
        translate([-plate.x / 2, 0, 0]) cube(plate);
        for (sx = [-1, 1])
            translate([sx * (base.x / 2 - gusset_t / 2) - gusset_t / 2, plate.y - eps, base.z - eps])
                rotate([90, 0, 90]) linear_extrude(gusset_t)
                    polygon([[0, 0], [gusset_len, 0], [0, gusset_len]]);
    }
    // teardrop: circle + 45 deg roof, extruded through the plate along Y
    translate([0, plate.y + 1, boss_z]) rotate([90, 0, 0])
        linear_extrude(plate.y + 2)
            hull() {
                circle(d = boss_d, $fn = 96);
                translate([0, boss_d / 2 * sqrt(2) - 0.01]) square(0.02, center = true);
            }
    for (sx = [-1, 1], sz = [-1, 1])
        translate([sx * screw_spacing / 2, -1, boss_z + sz * screw_spacing / 2])
            rotate([-90, 0, 0]) cylinder(d = screw_d, h = plate.y + 2, $fn = 32);
    for (p = mount_pos)
        translate([p.x, p.y, -1]) cylinder(d = mount_d, h = base.z + 2, $fn = 32);
}
