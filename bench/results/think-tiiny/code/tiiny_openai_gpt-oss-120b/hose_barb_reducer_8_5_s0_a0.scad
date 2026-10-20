//---------------------------
// Dimensions (mm)
//---------------------------
h_total = 41;                 // total height of the part
h_barb8 = 10;                 // height of each 8 mm tubing barb
h_barb5 = 8;                  // height of each 5 mm tubing barb
h_collar = 5;                 // height of the cylindrical collar
d_inner = 3;                  // bore diameter (through the whole part)

d_barb8_bottom = 7.5;          // outer diameter at bottom of 8 mm barb
d_barb8_top = 9.5;            // outer diameter at top of 8 mm barb

d_barb5_bottom = 6.5;         // outer diameter at bottom of 5 mm barb
d_barb5_top = 5.0;            // outer diameter at top of 5 mm barb

d_collar = 12;                // outer diameter of the collar

$fn = 64;                     // resolution for circles and rotate_extrude

//---------------------------
// Helper module: single barb
//---------------------------
module barb(bottom_dia, top_dia, height) {
    // 2‑D profile (radius, height) rotated around Z
    rotate_extrude(angle = 360)
        polygon(points = [
            [bottom_dia/2, 0],          // bottom radius
            [top_dia/2, height],       // top radius
            [bottom_dia/2, height],    // step back to bottom radius
            [bottom_dia/2, 0]          // close the loop
        ]);
}

//---------------------------
// Build the outer solid
//---------------------------
module outer_shape() {
    union() {
        // 8 mm tubing barbs (two stacked)
        translate([0,0,0])   barb(d_barb8_bottom, d_barb8_top, h_barb8);
        translate([0,0,h_barb8]) barb(d_barb8_bottom, d_barb8_top, h_barb8);

        // cylindrical collar (z = 20 … 25)
        translate([0,0,20]) cylinder(r = d_collar/2, h = h_collar);

        // 5 mm tubing barbs (two stacked)
        translate([0,0,25]) barb(d_barb5_bottom, d_barb5_top, h_barb5);
        translate([0,0,33]) barb(d_barb5_bottom, d_barb5_top, h_barb5);
    }
}

//---------------------------
// Final part with through bore
//---------------------------
difference() {
    outer_shape();
    // bore cylinder extends 0.5 mm beyond each end (0.5 mm > 0.01 mm)
    translate([0,0,-0.5])
        cylinder(r = d_inner/2, h = h_total + 1);
}