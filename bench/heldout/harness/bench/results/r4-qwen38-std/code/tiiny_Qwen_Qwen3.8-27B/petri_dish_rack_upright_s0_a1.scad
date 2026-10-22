// 10-dish edge rack, printed as used (rests on XY plane, builds +Z)

// ---- Base block (centred on origin in X and Y) ----
base_L = 203;   // length along X
base_W = 80;    // width along Y
base_H = 20;    // height (z = 0 .. 20)

// ---- Curved cradle (cut through the base only, not the dividers) ----
cradle_R = 46;  // radius of the dish rim / cradle cylinder
cradle_cy  = 0; // cylinder axis y-position
cradle_cz  = 52;// cylinder axis z-position  (bottoms out at z = 6)

// ---- Divider plates (solid, cradle does NOT cut through them) ----
div_T  = 3;     // plate thickness along X
div_H  = 60;    // plate height (z = 0 .. 60)
div_W  = base_W; // plate width along Y (same as base)
div_xs = [-100, -80, -60, -40, -20, 0, 20, 40, 60, 80, 100]; // 11 plates, 20 mm apart

// ---- Curved cradle cutter (extends past the base in X and Y) ----
// Axis runs along X at (y = cradle_cy, z = cradle_cz); radius cradle_R.
// X extent and Y extent are made to overshoot the base so the cut is clean.
cut_X0 = -base_L/2 - 1;   // 1 mm past the -X face
cut_X1 =  base_L/2 + 1;   // 1 mm past the +X face
cut_Y0 = -base_W/2 - 1;   // 1 mm past the -Y face
cut_Y1 =  base_W/2 + 1;   // 1 mm past the +Y face

// ---- Build ----
$fn = 64;

// 1) Base block with the cradle pocket removed
base_with_cradle = difference() {
    cube([base_L, base_W, base_H], center = true);
    // Cylindrical cradle cutter (axis along X)
    translate([cut_X0, cradle_cy, cradle_cz])
        rotate([0, 90, 0])
        cylinder(h = (cut_X1 - cut_X0) + 2, r = cradle_R, center = false);
};

// 2) Eleven divider plates (solid; cradle is not cut through them)
dividers = for (x = div_xs)
    translate([x - div_T/2, -div_W/2, 0])
        cube([div_T, div_W, div_H]);

// 3) Union: cradled base + dividers
union() {
    base_with_cradle;
    dividers;
}