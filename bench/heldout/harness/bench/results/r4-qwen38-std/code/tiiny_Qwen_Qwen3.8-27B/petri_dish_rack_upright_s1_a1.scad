// 10-dish Petri rack, printed as used (base on XY plane, +Z up)

// ---- dimensions (mm) ----
base_L = 203;   // base length along X
base_W = 80;    // base width along Y
base_H = 20;    // base height

cradle_R = 46;  // radius of the rim cradle (inside of the cutting cylinder)
cradle_cy = 0;  // cradle axis Y position
cradle_cz = 52; // cradle axis Z position  -> cradle bottoms at z = 6

div_T  = 3;    // divider plate thickness (X)
div_H  = 60;   // divider height (z = 0 .. 60)
div_W  = 80;   // divider width (Y, same as base)

div_xs = [-100, -80, -60, -40, -20, 0, 20, 40, 60, 80, 100]; // 11 plates, 20 mm apart

$fn = 64;

// ---- base block, centred on origin in X and Y ----
base = translate([-base_L/2, -base_W/2, 0])
    cube([base_L, base_W, base_H]);

// ---- cradle cutter: cylinder axis along X, extended 1 mm past each end ----
cradle_cut = translate([-base_L/2 - 1, cradle_cy, cradle_cz])
    rotate([0, 90, 0])
    cylinder(h = base_L + 2, r = cradle_R, center = true);

// ---- divider plates (cradle is NOT cut through them) ----
dividers = for (x = div_xs)
    translate([x - div_T/2, -div_W/2, 0])
        cube([div_T, div_W, div_H]);

// ---- final solid ----
difference() {
    union() {
        base;
        dividers;
    }
    cradle_cut;
}