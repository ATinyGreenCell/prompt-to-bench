// Snap-on tubing clip for a 12.7 mm (1/2 inch) lab stand rod
// Printed flat: a 10 mm tall extrusion (Z) of a 2-D profile in the XY plane.

// ---------------- Parameters ----------------
rod_d        = 12.7;   // stand rod inner diameter (ring 1)
rod_wall     = 3;      // stand rod ring wall thickness
ring1_od     = rod_d + 2 * rod_wall;  // outer diameter of rod ring (18.7 mm)

tube_d       = 6;      // tubing inner diameter (ring 2)
tube_wall    = 2;      // tubing ring wall thickness
ring2_od     = tube_d + 2 * tube_wall; // outer diameter of tubing ring (10 mm)

bridge_w     = 6;      // solid bridge width (Y)
bridge_x0    = 8;      // bridge start (X)
bridge_x1    = 12;     // bridge end (X)

opening1_w   = 10;     // rod ring opening width (-X side)
opening2_w   = 4.5;    // tubing ring opening width (+X side)

height       = 10;     // extrusion height (Z)

eps          = 0.5;    // cutter overshoot past faces

$fn = 96;              // smoothness of curved shapes

// ---------------- Profile ----------------
// 2-D profile drawn in the XY plane (Y = world Y, not extrusion height).
module profile() {
    union() {
        // Rod ring, centred at origin
        difference() {
            translate([0, 0])
                circle(d = ring1_od);
            // Opening cut out of -X side: x < 0 and -5 < y < 5
            translate([-ring1_od / 2 - eps, -opening1_w / 2, 0])
                cube([eps, opening1_w, height + 2 * eps]);
        }

        // Tubing ring, centred at x = 15, y = 0
        difference() {
            translate([15, 0])
                circle(d = ring2_od);
            // Opening cut out of +X side: x > 15 and -2.25 < y < 2.25
            translate([15, -opening2_w / 2, 0])
                cube([eps, opening2_w, height + 2 * eps]);
        }

        // Solid bridge between x = 8 and x = 12, width 6 (Y)
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, height]);
    }
}

// ---------------- Part ----------------
// Extrude the profile along +Z, resting on z = 0.
module clip() {
    rotate([90, 0, 0])
        linear_extrude(height = height)
            profile();
}

clip();