// Snap-on tubing clip for 12.7 mm (1/2") lab stand rod
// Printed flat: 2-D profile extruded along Z

$fn = 96;

// ---------- Parameters ----------
clip_h        = 10;     // extrusion height (Z)

// Rod ring
rod_id        = 12.7;   // rod ring inner diameter
rod_wall      = 3;      // rod ring wall thickness
rod_od        = rod_id + 2*rod_wall; // 18.7 outer diameter
rod_open_w    = 10;     // opening width on -X side (Y extent)

// Tubing ring
tube_x        = 15;     // tubing ring centre X
tube_id       = 6;      // tubing ring inner diameter
tube_wall     = 2;      // tubing ring wall thickness
tube_od       = tube_id + 2*tube_wall; // 10 outer diameter
tube_open_w   = 4.5;    // opening width on +X side (Y extent)

// Bridge
bridge_x0     = 8;      // bridge start X
bridge_x1     = 12;     // bridge end X
bridge_w      = 6;      // bridge width (Y)

eps           = 0.5;    // overshoot for cutting shapes

// ---------- 2-D profile ----------
module profile() {
    difference() {
        // Solid material
        union() {
            circle(d = rod_od);
            translate([tube_x, 0]) circle(d = tube_od);
            translate([bridge_x0, -bridge_w/2])
                square([bridge_x1 - bridge_x0, bridge_w]);
        }
        // Rod bore
        circle(d = rod_id);
        // Tubing bore
        translate([tube_x, 0]) circle(d = tube_id);
        // Rod opening: x < 0, -5 < y < 5
        translate([-rod_od/2 - eps, -rod_open_w/2])
            square([rod_od/2 + eps, rod_open_w]);
        // Tubing opening: x > 15, -2.25 < y < 2.25
        translate([tube_x, -tube_open_w/2])
            square([tube_od/2 + eps, tube_open_w]);
    }
}

// ---------- 3-D part ----------
linear_extrude(height = clip_h)
    profile();