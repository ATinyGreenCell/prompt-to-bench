// Dimensions
handle_diameter = 8;
handle_radius = handle_diameter / 2;
handle_height = 45;

cone_bottom_diameter = 8;
cone_bottom_radius = cone_bottom_diameter / 2;
cone_top_diameter = 3;
cone_top_radius = cone_top_diameter / 2;
cone_height = 62 - 45;

tip_diameter = 3;
tip_radius = tip_diameter / 2;
tip_center_z = 62;

groove_count = 4;
groove_width = 2;
groove_depth = 1;
groove_centers = [10, 15, 20, 25];

// Geometry Primitives
// Handle: Cylinder from z=0 to z=45
handle = cylinder(r=handle_radius, h=handle_height);

// Cone: Tapers from z=45 (r=4) to z=62 (r=1.5)
// OpenSCAD cylinder takes r and h. To make a cone, we use r1 and r2 arguments if supported,
// or we can use a single cylinder with r1 and r2.
// Standard cylinder(r, h) creates a cylinder.
// To create a cone, we can use cylinder(r1, r2, h) which is supported in OpenSCAD.
cone = cylinder(r1=cone_bottom_radius, r2=cone_top_radius, h=cone_height);

// Tip: Sphere centered at z=62
tip = sphere(r=tip_radius);

// Union of main parts
main_part = union() {
    translate([0, 0, 0]) handle;
    translate([0, 0, 45]) cone;
    translate([0, 0, tip_center_z]) tip;
};

// Groove Cutter: A hollow cylinder (ring) to cut into the handle
// Outer radius = handle_radius (4mm)
// Inner radius = handle_radius - groove_depth (3mm)
// Height = groove_width + small extension (2.1mm) to satisfy Rule 5
cutter_outer_r = handle_radius;
cutter_inner_r = handle_radius - groove_depth;
cutter_h = groove_width + 0.1;

cutter = difference() {
    cylinder(r=cutter_outer_r, h=cutter_h);
    cylinder(r=cutter_inner_r, h=cutter_h);
};

// Create all grooves
grooves = union() {
    for (z = groove_centers) {
        translate([0, 0, z]) cutter;
    }
};

// Final Part: Main part with grooves subtracted
final_part = difference() {
    main_part;
    grooves;
};

// Render
final_part;