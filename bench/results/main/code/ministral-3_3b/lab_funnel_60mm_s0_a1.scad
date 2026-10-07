// Dimensions in millimetres
$fn = 256;
d_spout_outer = 10;      // Spout outer diameter
d_cone_top_inner = 10;   // Inner diameter of cone at spout top (matches spout)
h_spout = 20;            // Spout height
h_cone = 30;             // Cone height from z=20 to z=50
wall_thickness = 1.6;    // Wall thickness

// Create the funnel cone wall
cone_wall = difference(
    rotate([90, 0, 0]) * linear_extrude(height=h_cone) *
        polygon(points=[
            [0, -d_cone_top_inner/2],
            [-d_cone_top_inner/2, d_cone_top_inner/2],
            [d_cone_top_inner/2, d_cone_top_inner/2]
        ]),
    translate([0, 0, wall_thickness/2]) * rotate([90, 0, 0]) *
        linear_extrude(height=h_cone) *
        polygon(points=[
            [-wall_thickness/2, -wall_thickness/2],
            [-wall_thickness/2, wall_thickness/2],
            [wall_thickness/2, wall_thickness/2]
        ])
);

// Create the spout tube (cut-out)
spout_cut = cylinder(
    d=d_spout_outer - wall_thickness,
    h=h_spout + h_cone,
    center=true
);

// Create the funnel rim (top opening)
funnel_top = rotate([90, 0, 0]) * linear_extrude(height=wall_thickness) *
            polygon(points=[
                [0, -(d_cone_top_inner + wall_thickness)],
                [-(d_cone_top_inner + wall_thickness)/2, (d_cone_top_inner + wall_thickness)/2],
                [(d_cone_top_inner + wall_thickness)/2, (d_cone_top_inner + wall_thickness)/2]
            ]);

// Create the funnel bottom opening
funnel_bottom = cylinder(
    d=d_spout_outer - 2*wall_thickness,
    h=h_spout + h_cone + wall_thickness,
    center=true
);

// Combine all parts
final_funnel = difference(
    union(
        translate([0, 0, h_spout]) * cone_wall,
        translate([0, 0, h_spout + wall_thickness/2]) * spout_cut,
        translate([0, 0, h_cone - wall_thickness/2]) * funnel_top
    ),
    translate([0, 0, wall_thickness/2]) * funnel_bottom
);