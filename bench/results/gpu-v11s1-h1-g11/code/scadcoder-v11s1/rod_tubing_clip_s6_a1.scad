// Snap-on tubing clip for a 12.7 mm lab stand rod
// Print orientation: flat on the bed, extrusion builds up in +Z

$fn = 96;

// ---- Dimensions (mm) ----
rod_d      = 12.7;   // stand rod diameter
ring_w     = 3;      // rod ring wall thickness
rod_r      = rod_d / 2 + ring_w;  // rod ring outer radius (18.7/2 = 9.35)
opening    = 10;     // rod ring opening width along -X
bracket_r  = 6 / 2 + 2;           // tubing ring outer radius (2 mm wall)
bracket_x  = 15;     // tubing ring centre X
bridge_w   = 6;      // bridge width in Y
bridge_x0  = 8;      // bridge start X
bridge_x1  = 12;     // bridge end X
eps        = 0.5;    // cutter overshoot past faces

// ---- Model ----
difference() {
    union() {
        // Rod ring
        cylinder(r = rod_r, h = 10);
        // Tubing ring
        translate([bracket_x, 0, 0])
            cylinder(r = bracket_r, h = 10);
        // Bridge between the rings
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, 10]);
    }
    // Rod ring opening (-X side)
    translate([-rod_r - eps, -opening / 2, 0])
        cube([rod_r + eps, opening, 10]);
    // Tubing ring opening (+X side)
    translate([bracket_x + eps, -6 / 2, 0])
        cube([bracket_r + eps, 6, 10]);
}