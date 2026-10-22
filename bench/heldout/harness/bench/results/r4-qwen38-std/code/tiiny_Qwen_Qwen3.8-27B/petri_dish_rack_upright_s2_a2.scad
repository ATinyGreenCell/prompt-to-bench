// 10-dish rack, printed as used (rests on XY plane, builds +Z)

// ---- Base block ----
base_L = 203;   // length along X
base_W = 80;    // width along Y
base_H = 20;    // height along Z

// ---- Cradle (cut) ----
cradle_R = 46;  // radius of the cylindrical cradle
cradle_cy  = 0; // cylinder axis y-coordinate
cradle_cz  = 52;// cylinder axis z-coordinate  (bottoms out at z = 6)

// ---- Divider plates ----
div_T  = 3;    // plate thickness along X
div_H  = 60;   // plate height (z = 0 to 60)
div_W  = 80;   // plate width along Y (same as base)
div_xs = [-100, -80, -60, -40, -20, 0, 20, 40, 60, 80, 100]; // 11 plates, 20 mm apart

$fn = 64;

// Base block, centred on origin in X and Y, resting on z = 0
base = translate([-base_L/2, -base_W/2, 0])
    cube([base_L, base_W, base_H]);

// Cylindrical cradle cutter, axis along X at (y=0, z=52), extended past both ends
cradle = translate([-base_L/2 - 1, cradle_cy, cradle_cz])
    rotate([0, 90, 0])
    cylinder(h = base_L + 2, r = cradle_R, center = true);

// Eleven divider plates, centred on their x positions
dividers = for (x = div_xs)
    translate([x - div_T/2, -div_W/2, 0])
        cube([div_T, div_W, div_H]);

// Final part: base with cradle removed, then divider plates added back (cradle not cut through them)
union() {
    difference() {
        base;
        cradle;
    }
    dividers;
}