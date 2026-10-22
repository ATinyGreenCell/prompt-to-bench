// Star-shaped indexing wheel
// 5-pointed star plate with a centre through-hole

// ---------- Parameters ----------
n_points     = 5;     // number of star points
r_outer      = 35;    // radius of outer (tip) points [mm]
r_inner      = 17.5;  // radius of inner (valley) points [mm]
plate_t      = 4;     // plate thickness [mm]
hole_d       = 8;     // centre hole diameter [mm]
cut_overlap  = 0.5;   // extra length on cutting shapes past faces [mm]
$fn          = 96;    // resolution for curved shapes

// ---------- Derived ----------
step = 360 / (2 * n_points);   // angle between successive vertices

// Star outline: alternates outer and inner points, first outer point on +X
star_pts = [
    for (i = [0 : 2 * n_points - 1])
        let (r = (i % 2 == 0) ? r_outer : r_inner,
             a = i * step)
        [r * cos(a), r * sin(a)]
];

// ---------- Model ----------
difference() {
    // Star plate resting on the bed
    linear_extrude(height = plate_t)
        polygon(points = star_pts);

    // Centre through-hole, extending past top and bottom faces
    translate([0, 0, -cut_overlap])
        cylinder(d = hole_d, h = plate_t + 2 * cut_overlap, $fn = 96);
}
