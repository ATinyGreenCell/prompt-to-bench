// Ring weight for flask neck in a water bath
// Torus lying flat on the bed, printed in this orientation

// ---- Parameters ----
tube_d      = 8;    // diameter of the round cross-section (mm)
ring_r      = 30;   // radius of the circle the cross-section centre sweeps along (mm)
z_mid       = 4;    // height of the torus middle plane (= tube_d/2, so it rests on z = 0)

fn_tube     = 64;   // facets for the cross-section circle
fn_ring     = 128;  // facets around the Z axis

// Derived (for reference)
outer_d = 2 * ring_r + tube_d;   // 68 mm overall diameter
inner_d = 2 * ring_r - tube_d;   // 52 mm inner opening

// ---- Model ----
translate([0, 0, z_mid])
    rotate_extrude($fn = fn_ring)
        translate([ring_r, 0])
            circle(d = tube_d, $fn = fn_tube);
