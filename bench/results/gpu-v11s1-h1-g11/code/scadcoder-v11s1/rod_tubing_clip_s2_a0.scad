// Tubing clip for 12.7 mm lab stand rod
// Print orientation: flat on bed, extrusion builds up in +Z

$fn = 96;

// ---- Dimensions (mm) ----
rod_d      = 12.7;   // rod diameter
ring_w     = 3;      // rod ring wall thickness
rod_r      = rod_d/2 + ring_w;  // rod ring outer radius (18.7/2)
opening    = 10;     // rod ring opening width along -X
t_ring_i   = 6;      // tubing ring inner diameter
t_ring_w   = 2;      // tubing ring wall thickness
t_ring_r   = t_ring_i/2 + t_ring_w;  // tubing ring outer radius
t_opening  = 4.5;    // tubing ring opening width along +X
bridge_x1  = 8;      // bridge start (X)
bridge_x2  = 12;     // bridge end (X)
bridge_w   = 6;      // bridge width (Y)
h          = 10;     // extrusion height (Z)
eps        = 0.5;    // cutter overshoot

difference() {
    union() {
        // Rod ring
        cylinder(r = rod_r, h = h);
        // Tubing ring
        translate([15, 0, 0])
            cylinder(r = t_ring_r, h = h);
        // Bridge
        translate([bridge_x1, -bridge_w/2, 0])
            cube([bridge_x2 - bridge_x1, bridge_w, h]);
    }
    // Rod ring opening (-X side)
    translate([-rod_r - eps, -opening/2, 0])
        cube([rod_r + eps, opening, h + 2*eps]);
    // Tubing ring opening (+X side)
    translate([15 + eps, -t_opening/2, 0])
        cube([rod_r + eps, t_opening, h + 2*eps]);
}