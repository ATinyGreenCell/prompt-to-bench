// Buffer tank for a mini horizontal gel-electrophoresis box
// Print orientation: rests on XY plane at z = 0, builds upward (+Z), centred on origin in X and Y.

// ---- Tank outer dimensions (measured with calipers) ----
L = 120;   // outer length along X
W = 70;    // outer width  along Y
H = 40;    // outer height along Z

// ---- Wall / floor thickness ----
t = 3;     // uniform wall and floor thickness

// ---- Inner cavity dimensions ----
L_in = L - 2*t;   // 114 mm inner length (X)
W_in = W - 2*t;   //  64 mm inner width  (Y)
H_in = H - t;     //  37 mm inner height (Z)

// ---- Raised gel-tray platform ----
pL = 60;         // platform length along X (centred)
pH = 10;         // platform height above the inner floor (top at z = 13)

// ---- Electrode-wire holes (one in each X end wall) ----
d_hole = 2;      // hole diameter
z_hole = 30;     // hole centre height above z = 0
y_hole = 0;      // hole centre in Y (centred)

$fn = 64;        // round holes

// ---- 1. Solid outer block ----
outer = translate([-L/2, -W/2, 0]) cube([L, W, H]);

// ---- 2. Open-top inner cavity (extends 1 mm past the top so the top is open) ----
cavity = translate([-(L_in/2), -(W_in/2), t]) cube([L_in, W_in, H_in + 1]);

// ---- 3. Raised gel-tray platform (spans full inner width, centred in X) ----
platform = translate([-(pL/2), -(W_in/2), t]) cube([pL, W_in, pH]);

// ---- 4. Electrode-wire holes through both X end walls (extend 1 mm past each face) ----
hole = cylinder(h = L + 2, r = d_hole/2, $fn = $fn);

// ---- Assemble ----
difference() {
    union() {
        outer;
        platform;
    }
    cavity;
    hole;
}