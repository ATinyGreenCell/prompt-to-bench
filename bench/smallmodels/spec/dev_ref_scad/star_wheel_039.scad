// 8-pointed star indexing wheel
// Print orientation: flat on the bed, building up +Z

// ---- Parameters ----
n_points   = 8;    // number of star points
r_outer    = 40;   // radius of outer (tip) points [mm]
r_inner    = 20;   // radius of inner (valley) points [mm]
thickness  = 4;    // plate thickness [mm]
hole_d     = 8;    // centre hole diameter [mm]
eps        = 0.5;  // cutter overshoot past faces [mm]
$fn        = 96;   // curve resolution

// ---- Star outline points ----
// Alternates outer/inner, first outer point on +X axis
star_pts = [
    for (i = [0 : 2 * n_points - 1])
        let (r = (i % 2 == 0) ? r_outer : r_inner,
             a = i * 180 / n_points)
        [r * cos(a), r * sin(a)]
];

// ---- Part ----
difference() {
    linear_extrude(height = thickness)
        polygon(star_pts);

    // centre through-hole
    translate([0, 0, -eps])
        cylinder(d = hole_d, h = thickness + 2 * eps, $fn = 96);
}
