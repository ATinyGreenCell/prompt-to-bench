$fn = 64;

// User Dimensions
wall_thickness = 1.6;
spout_outer_diameter = 10;
spout_height = 20;
cone_start_z = 20;
cone_end_z = 50;
cone_outer_diameter = 60;

// Derived Dimensions
spout_outer_radius = spout_outer_diameter / 2;
spout_inner_radius = spout_outer_radius - wall_thickness;
cone_outer_radius = cone_outer_diameter / 2;
cone_inner_radius = cone_outer_radius - wall_thickness;

// Solid Block (The material)
// Tapered cylinder from z=0 to z=50
solid_block = cylinder(
    h = cone_end_z,
    r1 = spout_outer_radius,
    r2 = cone_outer_radius,
    center = false
);

// Hole (The empty space)
// Tapered cylinder from z=0 to z=50
// Extended by 0.02mm to ensure clean cuts at top and bottom faces
hole = cylinder(
    h = cone_end_z + 0.02,
    r1 = spout_inner_radius,
    r2 = cone_inner_radius,
    center = false
);

// Construct the part
difference() {
    solid_block;
    hole;
}