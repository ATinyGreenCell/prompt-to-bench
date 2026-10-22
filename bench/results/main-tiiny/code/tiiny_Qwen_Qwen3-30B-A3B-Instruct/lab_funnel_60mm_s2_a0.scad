// Lab funnel parameters
$fn = 64;

// Dimensions
spout_outer_diameter = 10;           // mm
spout_length = 20;                     // mm from z = 0 to z = 20
cone_base_diameter = 10;             // mm at z = 20 (top of spout)
cone_rim_diameter = 60;              // mm at z = 50 (top rim)
cone_height = 30;                      // mm from z = 20 to z = 50
wall_thickness = 1.6;                      // mm everywhere

// Derived dimensions
spout_inner_diameter = spout_outer_diameter - 2 * wall_thickness;
spout_inner_radius = spout_inner_diameter / 2;
spout_outer_radius = spout_outer_diameter / 2;

// Cone parameters: linear taper from base to rim
cone_base_radius = cone_base_diameter / 2;
cone_rim_radius = cone_rim_diameter / 2;

// Build funnel as union of spout and cone, with internal hole
// Use difference to hollow out the inside

// Start with outer shape: spout + cone
spout = cylinder(h = spout_length, r = spout_outer_radius, center = false);
cone = cylinder(h = cone_height, r1 = cone_rim_radius, r2 = cone_base_radius, center = false);

// Position cone so it starts at z = 20
cone_positioned = translate([0, 0, spout_length]) * cone;

// Outer funnel body (spout + cone)
outer_body = union() {
    spout,
    cone_positioned;
};

// Inner hole: hollow out the inside with a smaller cylinder that tapers from spout to cone
// The inner hole must be 1.6 mm thick wall, so inner radius = outer radius - wall_thickness

// Spout inner cylinder
inner_spout = cylinder(h = spout_length, r = spout_inner_radius, center = false);

// Cone inner hole: tapers from spout inner radius at z=20 to cone inner radius at z=50
// Cone inner radius at base (z=20): cone_base_radius - wall_thickness
// Cone inner radius at rim (z=50): cone_rim_radius - wall_thickness
cone_inner_base_radius = cone_base_radius - wall_thickness;
cone_inner_rim_radius = cone_rim_radius - wall_thickness;

// Create inner cone using a tapering cylinder
inner_cone = cylinder(h = cone_height, r1 = cone_inner_rim_radius, r2 = cone_inner_base_radius, center = false);
inner_cone_positioned = translate([0, 0, spout_length]) * inner_cone;

// Combine inner hole parts
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