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
// Each groove is a cylinder cut through the handle.
// To ensure clean cuts, we extend the cutting cylinder slightly past the handle boundaries.

grooves = union();
for (z_c = z_grooves) {
    // Create a cylinder for the groove
    // Centered at z_c, width w_groove, depth d_groove
    // We extend Z by 0.1mm to ensure it cuts through the exact face if needed, 
    // though the handle is solid here.
    groove_c = cylinder(
        h = w_groove + 0.1, 
        d = d_groove, 
        center = [0, 0, z_c]
    );
    grooves = union(grooves, groove_c);
}

// Rotate grooves to be circumferential (around the Z axis)
// The grooves are currently vertical cylinders along Z.
// We need to rotate them 90 degrees around X and Y to make them horizontal rings?
// No, the prompt says "circumferential grooves... centred at z = ...".
// This implies the grooves are rings around the handle at specific Z heights.
// My previous logic created vertical cylinders. I need to create horizontal cylinders (rings).

// Let's rebuild the cutting logic for circumferential grooves.
// A circumferential groove at a specific Z is a cylinder lying in the XY plane.
// It has a diameter equal to the handle diameter (to cut all the way through) 
// minus the depth, or simply a cylinder of diameter (d_handle - d_groove) centered on the axis?
// Actually, a groove is a hole. 
// If the handle is 8mm, and the groove is 1mm deep, the remaining material is 7mm.
// So the cutting shape is a cylinder of diameter 7mm, centered on the Z axis, 
// with height (width) = 2mm, located at the specific Z.

cutting_grooves = union();
for (z_c = z_grooves) {
    // Cylinder representing the material removed
    // Diameter = Handle Diameter - Groove Depth
    // Height = Groove Width
    // Position: Centered at z_c
    cut_shape = cylinder(
        h = w_groove + 0.1, // +0.1 to ensure full cut
        d = d_handle - d_groove,
        center = [0, 0, z_c]
    );
    cutting_grooves = union(cutting_grooves, cut_shape);
}

// Final Part
final_part = difference() {
    body;
    cutting_grooves;
}

// Display
final_part;