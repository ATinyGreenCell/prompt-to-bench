//---------------------------
// Parameters (mm)
//---------------------------
h_total      = 41;          // total height of the reducer (target)
h_barb8      = 10;          // height of each 8 mm tubing barb
h_barb5      = 8;           // height of each 5 mm tubing barb
h_collar     = 5;           // height of the cylindrical collar
d_inner      = 3;           // bore diameter (through the whole part)

d_barb8_bottom = 7.5;       // outer diameter at bottom of 8 mm barb
d_barb8_top    = 9.5;       // outer diameter at top of 8 mm barb

d_barb5_bottom = 6.5;       // outer diameter at bottom of 5 mm barb
d_barb5_top    = 5.0;       // outer diameter at top of 5 mm barb

d_collar      = 12;         // outer diameter of the collar

eps = 0.02;                 // tiny overlap / step‑back thickness (≥0.01 mm)
$fn = 128;                  // resolution for circles & rotate_extrude

//---------------------------
// Helper modules
//---------------------------
module barb8() {
    // conical frustum (8 mm tubing)
    cylinder(r1 = d_barb8_bottom/2, r2 = d_barb8_top/2, h = h_barb8);
    // step‑back disc (returns to bottom diameter)
    translate([0,0, h_barb8 - eps])
        cylinder(r = d_barb8_bottom/2, h = eps);
}

module barb5() {
    // conical frustum (5 mm tubing)
    cylinder(r1 = d_barb5_bottom/2, r2 = d_barb5_top/2, h = h_barb5);
    // step‑back disc
    translate([0,0, h_barb5 - eps])
        cylinder(r = d_barb5_bottom/2, h = eps);
}

//---------------------------
// Outer solid (single fused body)
//---------------------------
module outer_shape() {
    union() {
        // ---- 8 mm tubing barbs (two stacked) ----
        translate([0,0,0])                barb8();
        translate([0,0,h_barb8 - eps])    barb8();

        // ---- cylindrical collar (overlaps both sides) ----
        translate([0,0, 2*h_barb8 - eps])
            cylinder(r = d_collar/2, h = h_collar + eps);

        // ---- 5 mm tubing barbs (two stacked) ----
        translate([0,0, 2*h_barb8 + h_collar - eps])   barb5();
        translate([0,0, 2*h_barb8 + h_collar + h_barb5 - 2*eps]) barb5();
    }
}

//---------------------------
// Final part with through bore
//---------------------------
difference() {
    outer_shape();
    // bore cylinder (extends 0.5 mm beyond each end)
    translate([0,0,-0.5])
        cylinder(r = d_inner/2, h = h_total + 1);
}