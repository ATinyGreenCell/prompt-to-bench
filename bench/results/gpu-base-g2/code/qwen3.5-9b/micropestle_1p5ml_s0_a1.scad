$fn = 128;

// --- Dimensions ---
// Handle
d_handle = 8;
h_handle = 45;

// Cone
d_cone_bottom = 8;
d_cone_top = 3;
h_cone = 17; // 62 - 45

// Tip
d_tip = 3;
z_tip_center = 62;

// Grooves
n_grooves = 4;
w_groove = 2; // Width in Z
d_groove = 1; // Depth
z_grooves = [10, 15, 20, 25];

// --- Main Body Construction ---
// We build the solid body first, then subtract the grooves.
// The body consists of the cylinder, the cone, and the sphere.

// 1. Handle Cylinder
// z=0 to z=45, d=8
handle = cylinder(h = h_handle, d = d_handle, center = [0, 0, h_handle/2]);

// 2. Cone
// Tapers from d=8 at z=45 to d=3 at z=62
// Base at z=45, Top at z=62
cone = linear_extrude(height = h_cone, center = true)
    polygon([
        [-d_cone_bottom/2, 0], [d_cone_bottom/2, 0], 
        [d_cone_top/2, h_cone], [-d_cone_top/2, h_cone]
    ]);
cone = translate([0, 0, 45]) * cone;

// 3. Tip Sphere
// d=3, centered at z=62
tip = sphere(r = d_tip/2);
tip = translate([0, 0, z_tip_center]) * tip;

// Union the body parts
body = union(
    handle,
    cone,
    tip
);

// --- Groove Cutting ---
// We use difference to cut the grooves.
// To ensure clean cuts, we extend the cutting shapes slightly past the intended boundaries.

grooves = union();
for (z = z_grooves) {
    // Create a rectangular prism for the groove
    // Width in Z = w_groove
    // Depth in X/Y = d_groove (radius cut)
    // Height in Z = w_groove + 0.1 (slightly past to ensure full depth)
    
    // The groove is centered at z.
    // It goes from z - w_groove/2 to z + w_groove/2.
    // We extend by 0.1mm on both sides.
    
    z_start = z - w_groove/2 - 0.1;
    z_end = z + w_groove/2 + 0.1;
    
    // The groove is a cylinder of radius d_groove/2, extruded in Z
    // But we need to cut it out of the handle.
    // Since the handle is a cylinder, a cylindrical hole works perfectly.
    
    groove = cylinder(
        h = (z_end - z_start), 
        d = d_groove, 
        center = [0, 0, z]
    );
    
    // Rotate around Z axis to place 4 grooves evenly
    // Angles: 0, 90, 180, 270
    for (i = [0:3]) {
        angle = i * 90;
        rotated_groove = rotate([0, 0, angle]) * groove;
        grooves = union(grooves, rotated_groove);
    }
}

// Final Assembly: Body minus Grooves
final_part = difference() {
    body;
    grooves;
}

// Display
final_part;