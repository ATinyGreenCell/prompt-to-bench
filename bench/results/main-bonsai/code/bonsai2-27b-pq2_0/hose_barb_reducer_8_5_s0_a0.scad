// Hose-barb reducer: 8 mm ID silicone -> 5 mm ID silicone
// Printed upright along +Z, resting on XY plane at z = 0.
// Rotationally symmetric about the Z axis.

// ---- Named dimensions (mm) ----
bore_d          = 3.0;   // straight through-bore diameter
L_total         = 41.0;  // total height of the part

// Lower section: two 8 mm-ID barbs, z = 0 .. 20
L_lower         = 20.0;
n_lower_barbs   = 2;
h_lower_barb    = 10.0;  // each lower barb is 10 mm tall
d_lower_bottom  = 7.5;   // OD at bottom of each lower barb
d_lower_top     = 9.5;   // OD at top of each lower barb

// Collar: z = 20 .. 25
L_collar        = 5.0;
d_collar        = 12.0;  // collar outer diameter

// Upper section: two 5 mm-ID barbs, z = 20 .. 41
L_upper         = 16.0;
n_upper_barbs   = 2;
h_upper_barb    = 8.0;   // each upper barb is 8 mm tall
d_upper_bottom  = 6.5;   // OD at bottom of each upper barb
d_upper_top     = 5.0;   // OD at top of each upper barb

// ---- Print settings ----
$fn = 64;

// ---- Helper: one sawtooth barb (linear OD profile + step back) ----
// z0 = bottom of the barb, h = barb height, d0 = OD at bottom, d1 = OD at top
module barb(z0, h, d0, d1) {
    // Sawtooth profile: OD grows linearly d0 -> d1 over height h,
    // then steps straight back to d0 at the top.
    // Build the profile in the XZ plane (Y = 0) and rotate about Z.
    rotate_extrude($fn = $fn) {
        // Polygon vertices (x, z) relative to z0:
        //   (d0/2, 0)  -> bottom of the bore-side wall
        //   (d1/2, h)  -> top of the sloped outer wall
        //   (d0/2, h)  -> step back to d0 at the top
        //   (d0/2, 0)  -> close back to start
        polygon(points = [[d0/2, 0], [d1/2, h], [d0/2, h], [d0/2, 0]]);
    }
    translate([0, 0, z0]);
}

// ---- Build the full reducer ----
union() {
    // Lower barbs (z = 0 .. 20)
    for (i = 0; i < n_lower_barbs; i++) {
        barb(z0 = i * h_lower_barb,
             h    = h_lower_barb,
             d0   = d_lower_bottom,
             d1   = d_lower_top);
    }

    // Collar (z = 20 .. 25)
    translate([0, 0, L_lower])
        cylinder(h = L_collar, d = d_collar);

    // Upper barbs (z = 20 .. 41)
    for (i = 0; i < n_upper_barbs; i++) {
        barb(z0 = L_lower + i * h_upper_barb,
             h    = h_upper_barb,
             d0   = d_upper_bottom,
             d1   = d_upper_top);
    }

    // Subtract the through-bore (extends 0.5 mm past top and bottom)
    difference() {
        // (union of barbs + collar is already above; re-state for clarity)
        union() {
            for (i = 0; i < n_lower_barbs; i++) {
                translate([0, 0, i * h_lower_barb])
                    rotate_extrude($fn = $fn) {
                        polygon(points = [[d_lower_bottom/2, 0],
                                          [d_lower_top/2, h_lower_barb],
                                          [d_lower_bottom/2, h_lower_barb],
                                          [d_lower_bottom/2, 0]]);
                    };
            }
            translate([0, 0, L_lower])
                cylinder(h = L_collar, d = d_collar);
            for (i = 0; i < n_upper_barbs; i++) {
                translate([0, 0, L_lower + i * h_upper_barb])
                    rotate_extrude($fn = $fn) {
                        polygon(points = [[d_upper_bottom/2, 0],
                                          [d_upper_top/2, h_upper_barb],
                                          [d_upper_bottom/2, h_upper_barb],
                                          [d_upper_bottom/2, 0]]);
                    };
        }
        cylinder(h = L_total + 1.0, d = bore_d, center = false);
    }
}