// 10-dish rack: 203 x 80 x 20 base, 11 dividers, 10 slots, X-axis cradle
$fn = 64;

// Base block dimensions
base_L = 203;   // length along X
base_W = 80;    // width along Y
base_H = 20;    // height along Z

// Divider plates
div_t   = 3;    // thickness along X
div_H   = 60;   // height above z = 0
div_W   = 80;   // full base width along Y
div_xs  = [-100, -80, -60, -40, -20, 0, 20, 40, 60, 80, 100];

// Curved cradle (dish rim) cutter
crad_R  = 46;   // radius of the dish rim
crad_cy = 0;    // axis Y position
crad_cz = 52;   // axis Z position  (bottoms out at z = 6)
crad_L  = 203;  // full length along X

// Build the solid: base + 11 divider plates, then remove the cradle
// (the cradle is NOT cut through the dividers, so it is subtracted
//  from the base only)
module base_and_dividers() { union() {
    // Base block, centred on origin in X and Y, resting on z = 0
    translate([-base_L/2, -base_W/2, 0])
        cube([base_L, base_W, base_H]);

    // Eleven divider plates rising from z = 0 to z = 60
    for (dx = div_xs)
        translate([dx - div_t/2, -div_W/2, 0])
            cube([div_t, div_W, div_H]);
} }

// Cradle cutter: a cylinder of radius 46 whose axis runs along X
// (rotate 90 about Y to align the cylinder axis with X), centred at
// y = 0, z = 52, spanning the full base length.
module cradle_cutter() { rotate([90, 0, 0])
    translate([0, crad_cy, crad_cz])
    cylinder(h = crad_L, r = crad_R, $fn = $fn); }

// Final part: cradle cut from the base only (dividers stay solid)
difference() {
    base_and_dividers();
    cradle_cutter();
}