// Buffer tank for a mini horizontal gel-electrophoresis box
// Print orientation: rests on XY plane at z = 0, builds upward (+Z), centred on origin in X and Y.

// ---- Tank outer dimensions (measured with calipers) ----
L = 120;   // outer length along X
W = 70;    // outer width  along Y
H = 40;    // outer height along Z

// ---- Wall / floor thickness ----
t = 3;     // uniform wall and floor thickness

// ---- Inner cavity dimensions (derived) ----
Li = L - 2*t;   // inner length along X  = 114
Wi = W - 2*t;   // inner width  along Y  = 64
Hi = H - t;     // inner height along Z  = 37

// ---- Raised gel-tray platform ----
pl = 60;   // platform length along X (centred)
ph = 10;   // platform height above the inner floor (top at z = 13)

// ---- Electrode-wire holes (through each X end wall) ----
hr = 1;    // hole radius (2 mm diameter)
hz = 30;   // hole centre height above z = 0

$fn = 64;  // smooth circular holes

// ---- Build the tank ----
difference() {
    // Outer solid block
    translate([-L/2, -W/2, 0])
        cube([L, W, H]);

    // Open-top inner cavity (extends 1 mm past the top face so the top is fully open)
    translate([-Li/2, -Wi/2, t])
        cube([Li, Wi, Hi + 1]);

    // Raised gel-tray platform (solid, spans full inner width, centred in X)
    translate([-pl/2, -Wi/2, t])
        cube([pl, Wi, ph]);

    // Horizontal electrode-wire holes through both X end walls
    for (sx = [-1, 1]) {
        translate([sx * (L/2 + 1), 0, hz])
            rotate([0, 90, 0])
                cylinder(h = 2, r = hr, $fn = $fn);
    }
}