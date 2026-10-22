// Lab funnel parameters
$fn = 64;

// Dimensions
spout_outer_diameter = 10;           // mm
spout_length = 20;                     // mm from z = 0 to z = 20
cone_base_diameter = 10;           // mm at z = 20 (top of spout)
cone_rim_diameter = 60;              // mm at z = 50 (top rim)
cone_height = 30;                  // mm from z = 20 to z = 50
wall_thickness = 1.6;              // mm everywhere

// Derived dimensions
spout_inner_radius = spout_outer_diameter / 2 - wall_thickness;
spout_outer_radius = spout_outer_diameter / 2;

// Cone parameters: linear taper from base to rim
cone_base_radius = cone_base_diameter / 2;
cone_rim_radius = cone_rim_diameter / 2;

// Create outer funnel body: spout + cone
spout = cylinder(h = spout_length, r = spout_outer_radius, center = false);

// Cone: tapers from base radius at z=20 to rim radius at z=50
// Use r1 = cone_rim_radius (top), r2 = cone_base_radius (bottom) to match orientation
cone = cylinder(h = cone_height, r1 = cone_rim_radius, r2 = cone_base_radius, center = false);

// Position cone so its base is at z = 20
cone_positioned = translate([0, 0, spout_length]) * cone;

// Outer funnel body
outer_body = union() {
    spout,
    cone_positioned;
};

// Create inner hole: hollow out the inside
// Spout inner hole: straight cylinder
inner_spout = cylinder(h = spout_length, r = spout_inner_radius, center = false);

// Inner cone: tapers from inner base radius to inner rim radius
cone_inner_base_radius = cone_base_radius - wall_thickness;
cone_inner_rim_radius = cone_rim_radius - wall_thickness;

// Inner cone: from z=20 to z=50, tapers from inner_base to inner_rim
inner_cone = cylinder(h = cone_height, r1 = cone_inner_rim_radius, r2 = cone_inner_base_radius, center = false);
inner_cone_positioned = translate([0, 0, spout_length]) * inner_cone;

// Combine inner hole
inner_hole = union() {
    inner_spout,
    inner_cone_positioned;
};

// Final funnel: outer body minus inner hole
funnel = difference() {
    outer_body,
    inner_hole;
};

// Render the funnel
funnel;