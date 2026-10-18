// Snap-on clip: holds a piece of tubing next to a 12.7 mm lab stand rod
// Print orientation: flat on the bed, 10 mm tall extrusion of a 2-D profile

// ---------------- Parameters ----------------
clip_height      = 10;    // extrusion height (Z)
rod_d            = 12.7;  // stand rod diameter (1/2 inch)
ring_wall        = 3;     // rod ring wall thickness
ring_open        = 10;    // rod ring opening width (along -X)

tube_d           = 6;     // tubing inner diameter
tube_wall        = 2;     // tubing ring wall thickness
tube_open        = 4.5;   // tubing opening width (along +X)

bridge_x0        = 8;     // bridge start (X)
bridge_x1        = 12;    // bridge end (X)
bridge_width     = 6;     // bridge width (Y)

eps              = 0.5;   // cutter overshoot past faces
$fn              = 96;    // circle resolution

// ---------------- Derived ----------------
rod_ring_od = rod_d + 2 * ring_wall;   // 18.7 mm
tube_ring_od = tube_d + 2 * tube_wall; // 10 mm

// ---------------- Profile ----------------
profile = union() {
    // Rod ring, centred at origin, opening on -X
    difference() {
        cylinder(h = clip_height, d = rod_ring_od);
        translate([0, -ring_open / 2, -eps])
            cube([rod_ring_od / 2 + eps, ring_open, clip_height + 2 * eps]);
    }

    // Tubing ring, centred at x = 15, y = 0, opening on +X
    translate([15, 0, 0])
        difference() {
            cylinder(h = clip_height, d = tube_ring_od);
            translate([0, -tube_open / 2, -eps])
                cube([tube_ring_od / 2 + eps, tube_open, clip_height + 2 * eps]);
        }

    // Solid bridge between x = 8 and x = 12
    translate([bridge_x0, -bridge_width / 2, 0])
        cube([bridge_x1 - bridge_x0, bridge_width, clip_height]);
};

// ---------------- Output ----------------
translate([0, 0, 0])
    rotate([90, 0, 0])
        linear_extrude(height = clip_height)
            profile;