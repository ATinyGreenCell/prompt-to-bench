// Buffer tank for a mini horizontal gel-electrophoresis box
// Category: full hardware. Raised gel platform between two buffer chambers; 84 mm
// inside, so standard 7 cm trays fit. The library's 80 mm comb needs a tray with side
// walls or comb slots to rest on (not included).
// Electrodes: a wire runs across the floor of each chamber along Y, held in the floor
// groove, and climbs the end wall in the vertical groove to the rim. That keeps it under
// a normal buffer level (2-6 mm over the gel) and spans the whole chamber for straight
// bands. Use platinum (or graphite) for the anode; stainless steel only as the cathode.
// The end walls are engraved "+" (+X, anode, red) and "-" (-X, cathode, black): load the
// wells at the - end; DNA runs towards +. Reversed leads corrode a steel anode.
// There are no holes below the buffer line, so nothing can leak.
// SAFETY: electrophoresis runs at ~50-150 V DC. The LID AND INTERLOCK ARE NOT INCLUDED
// IN THIS FILE. Do not connect a power supply until a lid carries shrouded connectors so
// that lifting it breaks the circuit, and no bare wire is reachable outside the tank.
// Print: PETG, 0.2 mm layers, 4+ perimeters; leak-test with water before use.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Tank] */
// X, Y, Z
outer = [130, 90, 40];
wall = 3;
floor_t = 3;
// along X, centred; fits a 7 cm tray with room to lift it
platform_len = 75;
// above the inner floor
platform_h = 10;
// electrode-wire groove width, depth (0.25-0.5 mm wire)
groove = [1.2, 1.0];

/* [Hidden] */
eps = 0.01;
inner = [outer.x - 2 * wall, outer.y - 2 * wall];
chamber_x = (platform_len / 2 + inner.x / 2) / 2;   // middle of each buffer chamber

// parameter checks: stop with a message instead of building a broken part
assert(wall >= 2 && floor_t >= 2, "a tank that holds buffer needs walls and floor of at least 2 mm");
assert(groove[1] <= floor_t - 1.2 && groove[1] <= wall - 1.2, "the electrode groove leaves less than 1.2 mm of floor or wall: it may leak");
assert(platform_len <= inner.x - 20, "the platform leaves less than 10 mm for each buffer chamber");

difference() {
    translate([-outer.x / 2, -outer.y / 2, 0]) cube(outer);
    difference() {
        translate([-inner.x / 2, -inner.y / 2, floor_t]) cube([inner.x, inner.y, outer.z]);
        translate([-platform_len / 2, -outer.y / 2, 0]) cube([platform_len, outer.y, floor_t + platform_h]);
    }
    for (sx = [-1, 1]) {
        // floor groove across each chamber (along Y)
        translate([sx * chamber_x - groove[0] / 2, -inner.y / 2 - eps, floor_t - groove[1]])
            cube([groove[0], inner.y + 2 * eps, groove[1] + eps]);
        // vertical groove up the side wall at the end of the floor groove, to the rim
        translate([sx * chamber_x - groove[0] / 2, inner.y / 2 - eps, floor_t - groove[1]])
            cube([groove[0], groove[1] + eps, outer.z]);
    }
    // polarity marks, 0.6 mm deep, on the outside of the end walls
    for (sx = [-1, 1])
        translate([sx * (outer.x / 2 - 0.3), 0, outer.z - 12]) {
            cube([0.6 + 2 * eps, 10, 2], center = true);
            if (sx > 0) cube([0.6 + 2 * eps, 2, 10], center = true);
        }
}
