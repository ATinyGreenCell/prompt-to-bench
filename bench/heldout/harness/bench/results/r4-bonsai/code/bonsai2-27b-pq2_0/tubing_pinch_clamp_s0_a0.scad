$fn = 64;

// ---- Lower jaw: main bar + tongue ----
lower_jaw = union(
    cube([LJ_X1 - LJ_X0, LJ_Y1 - LJ_Y0, H], center = [false, false, false]),
    translate([TONGUE_X0, TONGUE_Y0, 0])
        cube([TONGUE_X1 - TONGUE_X0, TONGUE_Y1 - TONGUE_Y0, H])
);

// ---- Upper jaw: main bar ----
upper_jaw = translate([UJ_X0, UJ_Y0, 0])
    cube([UJ_X1 - UJ_X0, UJ_Y1 - UJ_Y0, H]);

// ---- Living hinge: half-ring on x < 0 side ----
hinge = difference(
    translate([HINGE_CX, HINGE_CY, 0])
        cylinder(d = HINGE_R_OUT * 2, h = H, $fn = 64),
    translate([HINGE_CX, HINGE_CY, 0])
        cylinder(d = HINGE_R_IN * 2, h = H, $fn = 64)
);
// Keep only the x < 0 half (left side)
hinge = intersection(
    hinge,
    translate([-100, 0, -100])
        cube([200, 200, H + 2])
);

// ---- Pinch ridges (half-round on inner faces) ----
// Lower jaw ridge: half-circle bulging into the gap (toward +Y)
ridge_lj = translate([RIDGE_X - RIDGE_R, RIDGE_Y_LJ, 0])
    cylinder(d = RIDGE_R * 2, h = H, $fn = 64);
// Upper jaw ridge: half-circle bulging into the gap (toward -Y)
ridge_uj = translate([RIDGE_X - RIDGE_R, RIDGE_Y_UJ, 0])
    cylinder(d = RIDGE_R * 2, h = H, $fn = 64);

// ---- Snap latch: leg + nose ----
latch_leg = translate([LEG_X0, LEG_Y0, 0])
    cube([LEG_X1 - LEG_X0, LEG_Y1 - LEG_Y0, H]);
latch_nose = translate([NOSE_X0, NOSE_Y0, 0])
    cube([NOSE_X1 - NOSE_X0, NOSE_Y1 - NOSE_Y0, H]);

// ---- Assemble ----
model = union(
    lower_jaw,
    upper_jaw,
    hinge,
    ridge_lj,
    ridge_uj,
    latch_leg,
    latch_nose
);

// ---- Snap latch clearance cut in the tongue ----
// The nose (x 54.5-57, y 4.5-5.5) must snap under the tongue (x 50-56, y 2.5-4).
// Cut a pocket in the tongue so the nose can slide under it when squeezed.
// Pocket: x 54.5-57 (nose width), y 2.5-4 (tongue height), full Z.
// Overhang 0.5 mm past tongue faces for clean cut.
tongue_pocket = translate([NOSE_X0 - CUT_OVER, TONGUE_Y0 - CUT_OVER, -CUT_OVER])
    cube([NOSE_X1 - NOSE_X0 + 2 * CUT_OVER, TONGUE_Y1 - TONGUE_Y0 + 2 * CUT_OVER, H + 2 * CUT_OVER]);

model = difference(model, tongue_pocket);

// ---- Print orientation: rests on XY plane at z = 0, builds upward ----
// Already built from z = 0 to z = H. Centre on origin in X and Y.
// Current X range: -8 (hinge) to 60 (upper jaw) -> width 68, centre x = 26
// Current Y range: 0 to 16 -> height 16, centre y = 8
// Shift so centre is at origin:
translate([-26, -8, 0])
    model;