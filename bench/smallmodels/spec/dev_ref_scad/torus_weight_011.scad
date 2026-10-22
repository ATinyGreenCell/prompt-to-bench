// Ring weight for a flask neck in a water bath
// Torus lying flat on the bed, centred on the origin

tube_d     = 10;   // diameter of the round cross-section (mm)
ring_r     = 22;   // radius of the circle swept by the section centre (mm)
$fn        = 128;  // smoothness of curved shapes

tube_r = tube_d / 2;           // section radius
// Outer diameter = 2*(ring_r + tube_r) = 54 mm
// Inner diameter = 2*(ring_r - tube_r) = 34 mm

// Lift so the ring rests on z = 0 with its middle plane at z = tube_r (5 mm)
translate([0, 0, tube_r])
    rotate_extrude($fn = 128)
        translate([ring_r, 0, 0])
            circle(r = tube_r, $fn = 64);
