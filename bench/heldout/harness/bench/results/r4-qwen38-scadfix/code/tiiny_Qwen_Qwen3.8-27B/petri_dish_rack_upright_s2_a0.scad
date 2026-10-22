// 10-dish Petri rack, printed as used (base flat on XY, z=0)

// ---- Base block ----
base_L = 203;   // length along X
base_W = 80;    // width along Y
base_H = 20;    // height of base block

// ---- Curved cradle (cut from base only) ----
cradle_R = 46;  // radius of cradle cylinder
cradle_cy = 0;  // Y of cradle axis
cradle_cz = 52; // Z of cradle axis  -> cradle bottoms at 52-46 = 6

// ---- Divider plates (solid, cradle does NOT cut them) ----
div_T  = 3;     // plate thickness (X)
div_H  = 60;    // plate height (z=0..60)
div_W  = 80;    // plate width (Y, same as base)
div_xs = [-100, -80, -60, -40, -20, 0, 20, 40, 60, 80, 100]; // 11 plates, 20 mm apart

$fn = 64;

// Base block with the cradle pocket cut along its full length
module base() { difference(
    cube([base_L, base_W, base_H], center = true),
    // cradle cutter: cylinder axis along X, extended 1 mm past each end
    translate([-base_L/2 - 1, cradle_cy, cradle_cz])
        rotate([90, 0, 0])
            cylinder(h = base_L + 2, r = cradle_R, center = true)
); }

// Eleven solid divider plates (cradle is not cut through them)
module dividers() { union()
    for (x = div_xs)
        translate([x, 0, 0])
            cube([div_T, div_W, div_H], center = [true, true, false]); }

// Final part: base + dividers
union() {
    base();
    dividers();
}