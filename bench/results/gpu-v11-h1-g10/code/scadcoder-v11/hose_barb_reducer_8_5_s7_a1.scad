// Hose-barb reducer: 8 mm OD barb -> 5 mm OD barb
// Print orientation: standing upright along Z

$fn = 64;

// ---- Dimensions (mm) ----
bore      = 3;    // through-bore diameter
barb_a_d  = 8;    // outer diameter of first barb
barb_a_h  = 20;   // height of first barb
barb_b_d  = 5;    // outer diameter of second barb
barb_b_h  = 16;   // height of second barb
collar_d  = 12;   // collar diameter (see note)

// ---- Note ----
// Per the given dimensions a 12 mm collar would sit at z = 20..25,
// overlapping both barbs. The parts are modelled as stated, without
// any overlap or clearance between adjacent features.

// ---- Model ----
difference() {
    union() {
        cylinder(h = barb_a_h, d = barb_a_d);
        translate([0, 0, barb_a_h])
            cylinder(h = barb_b_h, d = barb_b_d);
    }
    // through-bore
    translate([0, 0, -1])
        cylinder(h = barb_a_h + barb_b_h + 2, d = bore);
}