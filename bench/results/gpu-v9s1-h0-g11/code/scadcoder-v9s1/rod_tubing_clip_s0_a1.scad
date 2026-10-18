// Snap-on clip holding tubing next to a 12.7 mm lab stand rod
// Print orientation: flat on bed, extruded upward in +Z

// ---------- Parameters ----------
stand_d      = 12.7;   // stand rod diameter
wall         = 3;      // stand rod ring wall thickness
bridge_w     = 6;      // bridge width (Y) between rings
tub_d        = 6;      // tubing hole diameter
tub_x        = 15;     // tubing hole centre X
eps          = 0.5;    // cutter overshoot past faces
h            = 10;     // extrusion height (Z)

$fn = 96;

// ---------- Model ----------
difference() {
    union() {
        // Stand rod ring
        cylinder(d = stand_d + 2 * wall, h = h);
        // Bridge (overlaps ring solid, does not block the hole)
        translate([stand_d / 2 - bridge_w / 2, -bridge_w / 2, 0])
            cube([bridge_w, bridge_w, h]);
        // Tubing hole ring
        translate([tub_x, 0, 0])
            cylinder(d = tub_d + 2 * wall, h = h);
    }
    // Stand rod opening (x < 0, -5 < y < 5)
    translate([-stand_d / 2 - eps, -5, 0])
        cube([stand_d / 2 + eps, 10, h + 2 * eps]);
    // Tubing hole opening (x > 15, -2.25 < y < 2.25)
    translate([tub_x - eps, -2.25, 0])
        cube([eps + (tub_d + 2 * wall) / 2, 4.5, h + 2 * eps]);
}