// KNOWN-WRONG PART (must fail): the pocket centres are at y = +-7 instead of +-6
// Magnetic bead separation rack for one 8-tube strip of 0.2 mL PCR tubes
// Category: tools. A block with a row of tube seats (cylinder + cone, closed below) and two
// pockets, open at the bottom face, for 60 x 10 x 3 mm N52 bar magnets beside the tubes.
// Print: PLA or PETG, standing on its bottom face, 0.2 mm layers; press the magnets in from
// below and secure each with a drop of glue.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Rack] */
block = [80, 24, 20];     // X, Y, Z [mm]
n_tubes = 8;
pitch = 9;                // PCR strip pitch [mm]
seat_d = 6.4;             // cylindrical part of the seat
seat_cyl_z = 12;          // the cylinder runs from here to the top face
tip_d = 3;                // the cone narrows to this diameter ...
tip_z = 2;                // ... at this height, where the seat ends (2 mm floor)
pocket = [60.4, 3.3, 10.2]; // magnet pocket X, Y, Z (60 x 3 x 10 mm magnet + clearance)
pocket_y = 7;             // pocket centre planes at y = -6 and y = +6

/* [Hidden] */
$fn = 64;
eps = 0.01;

difference() {
    translate([-block.x / 2, -block.y / 2, 0]) cube(block);
    for (i = [0 : n_tubes - 1])
        translate([(i - (n_tubes - 1) / 2) * pitch, 0, 0]) {
            translate([0, 0, seat_cyl_z]) cylinder(d = seat_d, h = block.z - seat_cyl_z + eps);
            translate([0, 0, tip_z]) cylinder(d1 = tip_d, d2 = seat_d, h = seat_cyl_z - tip_z + eps);
        }
    for (s = [-1, 1])
        translate([-pocket.x / 2, s * pocket_y - pocket.y / 2, -eps])
            cube([pocket.x, pocket.y, pocket.z + eps]);
}
