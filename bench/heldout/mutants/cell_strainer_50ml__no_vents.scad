// KNOWN-WRONG PART (must fail): the vent notches are missing
// Coarse cell strainer that hangs in the mouth of a 50 mL conical tube
// Category: tools. A thin-walled cup with a perforated floor (81 x 1 mm holes on a 2 mm grid) and
// a 45-degree collar that rests on the tube's rim; two vent notches let air out of the tube.
// Print: PETG or PP, upright, 0.1-0.15 mm layers, 0.4 mm nozzle, 3 perimeters; check the holes
// are open after printing. For coarse filtration only (tissue debris), not a 40-100 um strainer.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Strainer] */
cup_od = 25;
wall = 1.2;               // bore 22.6
height = 32;
floor_t = 1.2;
collar = [26, 30];        // 45-degree cone from 25 mm at z = 26 to 33 mm at z = 30
rim_d = 33;               // rim from z = 30 to 32
hole_d = 1.0;
hole_pitch = 2;
hole_r_max = 10;          // keep holes whose centre is within 10 mm of the axis
vent_w = 3;
vent_r = 12.5;            // vents remove the collar beyond this radius ...
vent_z = 25;              // ... from this height up

/* [Hidden] */
eps = 0.01;
bore_r = cup_od / 2 - wall;
n = floor(hole_r_max / hole_pitch);

difference() {
    rotate_extrude($fn = 128) polygon([[0, 0], [cup_od / 2, 0], [cup_od / 2, collar[0]], [rim_d / 2, collar[1]],
                                       [rim_d / 2, height], [bore_r, height], [bore_r, floor_t], [0, floor_t]]);
    for (i = [-n : n], j = [-n : n])
        if (i * i + j * j <= (hole_r_max / hole_pitch) * (hole_r_max / hole_pitch))
            translate([i * hole_pitch, j * hole_pitch, -1]) cylinder(d = hole_d, h = floor_t + 2, $fn = 16);
}
