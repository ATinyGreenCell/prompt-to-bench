// Dimensions for 1.5 mL microcentrifuge tube pestle
// Handle diameter
handle_d = 8;
// Handle length
handle_h = 45;
// Cone base diameter (matches handle)
cone_base_d = 8;
// Cone tip diameter
cone_tip_d = 3;
// Cone height (from z=45 to z=62)
cone_h = 17;
// Tip sphere diameter
tip_d = 3;
// Groove width (Z-direction)
groove_w = 2;
// Groove depth
groove_d = 1;
// Groove center positions
groove_z1 = 10;
groove_z2 = 15;
groove_z3 = 20;
groove_z4 = 25;

// Calculate groove radius (Handle radius - Groove depth)
// Handle radius = 4, Groove depth = 1 -> Groove radius = 3
groove_radius = (handle_d / 2) - groove_d;

// Main Body Construction
// 1. Handle Cylinder (z=0 to z=45)
handle_cyl = cylinder(r = handle_d / 2, h = handle_h, center = false);

// 2. Cone Part (z=45 to z=62)
// Using a cylinder with r1=4, r2=1.5 to taper from 8mm to 3mm diameter
cone_cyl = cylinder(r1 = handle_d / 2, r2 = cone_tip_d / 2, h = cone_h, center = false);

// 3. Tip Sphere (centered at z=62)
// The sphere radius is 1.5mm.
tip_sphere = sphere(r = tip_d / 2, center = false);

// Combine main body parts
main_body = union() {
    translate([0, 0, 0]) handle_cyl;
    translate([0, 0, handle_h]) cone_cyl;
    translate([0, 0, handle_h + cone_h]) tip_sphere;
};

// Grooves Construction
// We create cylinders that are slightly larger in Z (by 0.02mm) to ensure they extend past the handle faces
// to avoid coplanar face errors, as per rule 5.
// The intended groove width is 2mm. We make the cutter 2.02mm wide.
groove_cut_h = groove_w + 0.02;

groove1 = translate([0, 0, groove_z1]) cylinder(r = groove_radius, h = groove_cut_h, center = false);
groove2 = translate([0, 0, groove_z2]) cylinder(r = groove_radius, h = groove_cut_h, center = false);
groove3 = translate([0, 0, groove_z3]) cylinder(r = groove_radius, h = groove_cut_h, center = false);
groove4 = translate([0, 0, groove_z4]) cylinder(r = groove_radius, h = groove_cut_h, center = false);

// Final Part: Main body minus grooves
pestle = difference() {
    main_body;
    groove1;
    groove2;
    groove3;
    groove4;
};

// Render the final part
render();