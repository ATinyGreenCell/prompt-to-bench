// Hose-barb reducer: joins 8 mm ID silicone tubing to 5 mm ID silicone tubing
// Print orientation: standing upright along +Z, base on XY plane (z = 0)
// Units: mm. Rotational symmetry about Z axis. One straight through-bore.

// ---------------- Parameters ----------------
// Tubing (8 mm ID) barbs
$fn = 64;

// Barb height for 8 mm tubing
h8 = 10;

// Outer diameter of 8 mm tubing (wall + ID)
d8_tube = 9;

// Barb outer diameter: 7.5 mm at bottom, 9.5 mm at top, then steps back to 7.5 mm
d8_b = 7.5;
d8_t = 9.5;

// Tubing (5 mm ID) barbs
// Barb height for 5 mm tubing
h5 = 8;

// Outer diameter of 5 mm tubing (wall + ID)
d5_tube = 6;

// Barb outer diameter: 6.5 mm at bottom, 5.0 mm at top, then steps back out to 6.5 mm
d5_b = 6.5;
d5_t = 5.0;

// Collar (z = 20 to z = 25)
d_collar = 12;

// Through-bore diameter
bore = 3;

// ---------------- Model ----------------
union() {
    // 8 mm tubing barbs: z = 0 to z = 20 (two stacked, identical)
    for (i = [0, 1]) {
        translate([0, 0, i * h8])
            difference() {
                // Sawtooth outer shape
                union() {
                    cylinder(h = h8, d1 = d8_b, d2 = d8_t);   // 7.5 -> 9.5
                    translate([0, 0, h8 / 2])
                        cylinder(h = h8 / 2, d1 = d8_t, d2 = d8_b); // 9.5 -> 7.5
                }
                // Through-bore
                translate([0, 0, -1])
                    cylinder(h = h8 + 2, d = bore);
            }
    }

    // Collar: z = 20 to z = 25
    translate([0, 0, 20])
        difference() {
            cylinder(h = 5, d = d_collar);
            translate([0, 0, -1])
                cylinder(h = 5 + 2, d = bore);   // bore through the collar
        }

    // 5 mm tubing barbs: z = 25 to z = 41 (two stacked, identical)
    for (i = [0, 1]) {
        translate([0, 0, 25 + i * h5])
            difference() {
                // Sawtooth outer shape: 6.5 mm at bottom, 5.0 mm at top, back to 6.5 mm
                union() {
                    cylinder(h = h5, d1 = d5_b, d2 = d5_t);   // 6.5 -> 5.0
                    translate([0, 0, h5 / 2])
                        cylinder(h = h5 / 2, d1 = d5_t, d2 = d5_b); // 5.0 -> 6.5
                }
                // Through-bore
                translate([0, 0, -1])
                    cylinder(h = h5 + 2, d = bore);
            }
    }
}