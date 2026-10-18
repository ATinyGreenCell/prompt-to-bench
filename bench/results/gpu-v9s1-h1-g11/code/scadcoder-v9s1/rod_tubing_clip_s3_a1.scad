// Snap-on clip: holds tubing next to a 12.7 mm lab stand rod
// Print orientation: flat on bed, extruded up in +Z

// ---------------- Parameters ----------------
clip_h      = 10;    // extrusion height (Z)
rod_id      = 12.7;  // stand rod inner diameter
rod_wall    = 3;     // stand rod ring wall thickness
ring_od     = rod_id + 2 * rod_wall;   // 18.7 mm outer diameter of rod ring

tubing_id   = 6;     // tubing inner diameter
tubing_wall = 2;     // tubing ring wall thickness
tubing_od   = tubing_id + 2 * tubing_wall; // 10 mm outer diameter of tubing ring
tubing_x    = 15;    // tubing ring centre X (Y = 0)

bridge_x1   = 8;     // bridge start X
bridge_x2   = 12;    // bridge end X
bridge_w    = 6;     // bridge width in Y

eps         = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------------- Profile (X, Y) ----------------
module clip_profile() {
    // Rod ring, centred at origin
    for (a = [0 : 180 : 360])
        if (a < 170 || a > 190)   // 10 mm wide opening on -X side
            point([ring_od * cos(a), ring_od * sin(a)]);

    // Tubing ring, centred at x = 15
    for (a = [0 : 180 : 360])
        if (a < 170 || a > 190)   // 4.5 mm wide opening on +X side
            point([tubing_x + tubing_od * cos(a), tubing_od * sin(a)]);

    // Solid bridge between the two rings
    for (y = [-bridge_w / 2 : bridge_w / 3, bridge_w / 2])
        point([bridge_x1, y], repeat = false);
    for (y = [-bridge_w / 2, bridge_x2 - bridge_x1, bridge_w / 2])
        point([bridge_x2, y], repeat = false);
}

// ---------------- Model ----------------
translate([-bridge_x2, -bridge_w / 2, 0])
    linear_extrude(height = clip_h)
        clip_profile();