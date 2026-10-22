// Ring weight for flask neck in a water bath
// Torus lying flat on the bed, centred on origin in X/Y

tube_d      = 16;   // cross-section circle diameter (mm)
ring_r      = 22;   // radius of the circle swept by the tube centre (mm)
tube_r      = tube_d / 2;          // cross-section radius (mm)
outer_d     = 2 * (ring_r + tube_r); // overall diameter = 60 mm
mid_z       = tube_r;              // middle plane height = 8 mm

$fn = 128;          // smoothness of curves

translate([0, 0, mid_z])
    rotate_extrude($fn = 128)
        translate([ring_r, 0, 0])
            circle(r = tube_r, $fn = 64);
