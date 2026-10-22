// KNOWN-WRONG PART (must fail): the six outer holes are on a 60 mm circle instead of 54
// Water-bath float for seven 15 mL conical tubes (6 on a circle around 1 in the centre)
// Category: tools. A hexagonal plate with a thin sleeve around each hole and a hexagonal skirt set
// 3 mm in from the plate's edge. Printed upside down; flipped for use, the skirt and sleeves hang
// into the water and trap air under the plate, so it floats whatever the infill. Tubes hang by
// their caps.
// Print: PP or PETG, plate on the bed, 0.2 mm layers.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Float] */
af = 90;                  // plate: hexagon across the flats; two flats parallel to X
plate_t = 3;
height = 20;              // sleeves and skirt rise to z = 20
skirt_af = 84;            // skirt outside, across the flats (3 mm in from the plate edge)
skirt_t = 2;
hole_d = 17.5;            // 15 mL conical tube is ~17 mm across
sleeve_t = 2;             // sleeve outer diameter 21.5
ring_d = 60;              // six holes on this circle, first on +X

/* [Hidden] */
eps = 0.01;
pos = concat([[0, 0]], [for (k = [0 : 5]) [ring_d / 2 * cos(60 * k), ring_d / 2 * sin(60 * k)]]);

module hexagon(across_flats) circle(d = across_flats / cos(30), $fn = 6);  // vertices on +-X

difference() {
    union() {
        linear_extrude(plate_t) hexagon(af);
        linear_extrude(height) difference() { hexagon(skirt_af); hexagon(skirt_af - 2 * skirt_t); }
        for (p = pos) translate([p.x, p.y, 0]) cylinder(d = hole_d + 2 * sleeve_t, h = height, $fn = 96);
    }
    for (p = pos) translate([p.x, p.y, -1]) cylinder(d = hole_d, h = height + 2, $fn = 96);
}
