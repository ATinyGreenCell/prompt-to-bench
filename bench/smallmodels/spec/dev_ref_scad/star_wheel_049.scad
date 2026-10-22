// Star-shaped indexing wheel (6-pointed star plate)

n_points   = 6;    // number of star points
r_outer    = 40;   // radius of outer points (mm)
r_inner    = 20;   // radius of inner points (mm)
thickness  = 4;    // plate thickness (mm)
hole_d     = 8;    // central through-hole diameter (mm)
cut_extra  = 0.5;  // extra length for cutting shapes past faces (mm)

$fn = 96;

// Star outline: alternating outer/inner vertices, first outer point on +X
star_pts = [
    for (i = [0 : 2 * n_points - 1])
        let (r = (i % 2 == 0) ? r_outer : r_inner,
             a = i * 180 / n_points)
        [r * cos(a), r * sin(a)]
];

difference() {
    linear_extrude(height = thickness)
        polygon(star_pts);

    translate([0, 0, -cut_extra])
        cylinder(d = hole_d, h = thickness + 2 * cut_extra);
}
