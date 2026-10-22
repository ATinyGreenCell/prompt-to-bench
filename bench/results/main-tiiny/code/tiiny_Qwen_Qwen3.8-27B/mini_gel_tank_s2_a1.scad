// Buffer tank for a mini horizontal gel-electrophoresis box
// Print orientation: rests on XY plane at z = 0, builds upward (+Z), centred on origin in X and Y.

// ---- Tank outer dimensions (measured with calipers) ----
L = 120;   // outer length along X
W = 70;    // outer width  along Y
H = 40;    // outer height along Z

// ---- Wall / floor thickness ----
t = 3;     // uniform wall and floor thickness

// ---- Inner cavity dimensions ----
Li = L - 2*t;   // inner length  = 114
Wi = W - 2*t;   // inner width   = 64
Hi = H - t;     // inner height  = 37  (open top)

// ---- Raised gel-tray platform ----
pl = 60;    // platform length along X (centred)
pt = 10;    // platform height above the inner floor (top at z = 13)

// ---- Electrode-wire holes (through the two X end walls) ----
hr = 1;     // hole radius (2 mm diameter)
hz = 30;    // hole centre height above z = 0

$fn = 64;   // round holes / curved faces

// ---- Build the tank ----
// 1. Outer solid block
// 2. Subtract the open-top inner cavity (extended 1 mm past the top so the rim is open)
// 3. Union the solid raised platform (sits on the inner floor, spans full inner width)
// 4. Subtract the two horizontal electrode holes (extended 1 mm past each end wall)
difference() {
    // 1. Outer block
    translate([-L/2, -W/2, 0])
        cube([L, W, H]);

    // 2. Inner cavity (open top)
    translate([-(L/2 - t), -(W/2 - t), 0])
        cube([Li, Wi, Hi + 1]);

    // 3. Raised gel-tray platform
    translate([0, 0, t])
        cube([pl, Wi, pt]);

    // 4. Electrode holes through the two X end walls
    for (sx = [-1, 1]) {
        translate([sx * (L/2 - t), 0, hz])
            rotate([0, 90, 0])
                cylinder(h = t + 2, r = hr, $fn = 64);
    }
}