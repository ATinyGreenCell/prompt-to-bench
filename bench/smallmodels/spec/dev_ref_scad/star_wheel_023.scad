// Star-shaped indexing wheel (6-pointed star plate)

// ---- Parameters ----
n_points   = 6;    // number of star points
r_outer    = 40;   // radius of outer (tip) points, mm
r_inner    = 20;   // radius of inner (valley) points, mm
thickness  = 4;    // plate thickness, mm
hole_d     = 6;    // centre through-hole diameter, mm
cut_extra  = 0.5;  // overshoot for cutting shapes, mm
$fn        = 96;   // facet count for curved shapes

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

    translate([0, 0, -cut_extra])
        cylinder(d = hole_d, h = thickness + 2 * cut_extra);
}
