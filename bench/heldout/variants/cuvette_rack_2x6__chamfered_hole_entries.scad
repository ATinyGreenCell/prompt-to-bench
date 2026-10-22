// KNOWN-RIGHT ALTERNATIVE (must pass): a correct rack whose deck holes have 0.5 mm lead-in chamfers at the top
// Open-sided rack for 12 standard 12.5 mm square cuvettes (2 rows of 6)
// Category: benchware. A base plate and a perforated deck joined by seven upright walls that run
// front to back; the long sides stay open, so the cuvettes can be seen and read in the rack.
// The deck bridges only 15.5 mm between walls, so it prints without supports.
// Print: PLA or PETG, base on the bed, 0.2 mm layers.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Rack] */
plate = [112, 44];        // X, Y of the base plate and the deck [mm]
base_t = 3;               // base plate z = 0 .. 3
deck_z = 22;              // deck from z = 22 ...
deck_t = 3;               // ... to z = 25
end_t = 3;                // end walls, flush with the short ends
rib_t = 2.5;              // inner ribs
rib_x = [-36, -18, 0, 18, 36];
cols = 6;                 // holes along X
rows = 2;                 // holes along Y
pitch = 18;               // centre-to-centre in X and Y
hole = 13;                // square hole for a 12.5 mm cuvette

/* [Hidden] */
eps = 0.01;
H = deck_z + deck_t;

difference() {
    union() {
        translate([-plate.x / 2, -plate.y / 2, 0]) cube([plate.x, plate.y, base_t]);
        translate([-plate.x / 2, -plate.y / 2, deck_z]) cube([plate.x, plate.y, deck_t]);
        for (s = [-1, 1])
            translate([s > 0 ? plate.x / 2 - end_t : -plate.x / 2, -plate.y / 2, 0]) cube([end_t, plate.y, H]);
        for (x = rib_x)
            translate([x - rib_t / 2, -plate.y / 2, 0]) cube([rib_t, plate.y, H]);
    }
    for (i = [0 : cols - 1], j = [0 : rows - 1])
        translate([(i - (cols - 1) / 2) * pitch - hole / 2, (j - (rows - 1) / 2) * pitch - hole / 2, deck_z - eps])
            cube([hole, hole, deck_t + 2 * eps]);
    for (i = [0 : cols - 1], j = [0 : rows - 1])
        translate([(i - (cols - 1) / 2) * pitch, (j - (rows - 1) / 2) * pitch, H - 0.5])
            linear_extrude(0.5 + eps, scale = (hole + 1 + 2 * eps) / hole) square(hole, center = true);
}
