// Ring weight (torus) for a flask neck in a water bath
// Prints flat on the bed; the cross-section circle touches z = 0.

tube_d     = 12;            // cross-section circle diameter (mm)
ring_r     = 30;            // radius of the circle swept by the cross-section centre (mm)
tube_r     = tube_d / 2;    // cross-section radius (mm)
mid_z      = tube_r;        // middle plane height (mm) -> 6
fn_sweep   = 128;           // facets around the Z axis
fn_section = 64;            // facets around the cross-section

// Derived: outer diameter = 2*(ring_r + tube_r) = 72 mm
//          inner diameter = 2*(ring_r - tube_r) = 48 mm

translate([0, 0, mid_z])
    rotate_extrude($fn = fn_sweep)
        translate([ring_r, 0, 0])
            circle(r = tube_r, $fn = fn_section);
