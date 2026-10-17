$fn = 128;

// --- Dimensions ---
// Handle
d_handle = 8;
h_handle = 45;
z_handle_start = 0;
z_handle_end = 45;

// Cone
d_cone_bottom = 8;
d_cone_top = 3;
h_cone = 17; // 62 - 45
z_cone_start = 45;
z_cone_end = 62;

// Tip (Sphere)
d_tip = 3;
z_tip_center = 62;

// Grooves
n_grooves = 4;
w_groove = 2; // Width in Z
d_groove = 1; // Depth
z_grooves = [10, 15, 20, 25]; // Center Z positions

// --- Main Body Construction ---
// We build the body as a union of the handle, cone, and tip.
// To ensure a smooth transition, we use linear_extrude with a polygon profile
// or rotate_extrude. Here, we construct the profile in the XZ plane and rotate it.

// Define the profile points (X, Z)
// Start at bottom center (0, 0)
// Go up to handle top (4, 45)
// Taper to cone top (1.5, 62)
// End at tip top (1.5, 62 + d_tip) -> Actually, the sphere is centered at 62.
// The sphere radius is 1.5. So it goes from Z=60.5 to Z=63.5.
// The cone ends at Z=62 with diameter 3 (radius 1.5). This matches the sphere radius perfectly.

// Let's define the profile polygon vertices:
// (0,0) -> (4,0) -> (4,45) -> (1.5,62) -> (1.5,63.5) -> (0,63.5) -> (0,0)
// Wait, the sphere is centered at 62. Radius 1.5.
// Top of sphere = 63.5. Bottom of sphere = 60.5.
// Cone ends at 62 with radius 1.5.
// So the profile should go from (1.5, 62) to (1.5, 63.5) then curve? 
// No, a sphere rotated around Z is a circle. 
// If we use rotate_extrude, we need a 2D profile.
// The profile for the sphere part (from Z=60.5 to 63.5) is a vertical line at X=1.5? 
// No, that makes a cylinder.
// To make a sphere, we need the profile to be a quarter circle or similar, but the cone meets the sphere.
// Actually, the simplest way to model a sphere on top of a cone in OpenSCAD without complex CSG is to just union a sphere.
// However, the prompt asks for a specific geometry flow.
// Let's stick to the simplest robust method: 
// 1. Create the Handle (Cylinder).
// 2. Create the Cone (Cylinder with scale or linear_extrude).
// 3. Create the Sphere (Sphere).
// 4. Union them.
// 5. Cut grooves.

// Re-evaluating the "Cone" requirement: "tapers from 8 mm diameter at z = 45 to 3 mm diameter at z = 62".
// This is a frustum.
// Re-evaluating the "Sphere": "3 mm diameter sphere centred at z = 62".
// This sphere has radius 1.5. It extends from Z=60.5 to Z=63.5.
// The cone at Z=62 has diameter 3 (radius 1.5).
// So the cone and sphere touch perfectly at Z=62.

// Strategy:
// 1. Build the main solid using linear_extrude of a polygon profile.
//    Profile points:
//    (0,0) -> (4,0) -> (4,45) -> (1.5,62) -> (1.5,63.5) -> (0,63.5) -> (0,0)
//    Wait, the segment from (1.5, 62) to (1.5, 63.5) creates a cylinder cap, not a sphere.
//    To get a sphere, we cannot use a simple linear_extrude of a polygon for the whole thing if we want a true sphere geometry, 
//    UNLESS we approximate the sphere with a polygon profile (which is messy) or use CSG.
//    Given the rules "Use only built-in OpenSCAD", CSG (union/difference) is allowed and preferred for complex shapes like spheres.
//    
//    Revised Strategy:
//    1. Handle: cylinder(d=8, h=45, center=false).
//    2. Cone: cylinder(d1=8, d2=3, h=17, center=false).
//    3. Tip: sphere(d=3, center=[0,0,62]).
//    4. Union these three.
//    5. Cut grooves.

// --- Groove Logic ---
// Grooves are circumferential. We can create one groove and rotate it 4 times.
// Groove shape: A rectangular prism cut into the cylinder.
// Dimensions: Width (Z) = 2, Depth (X) = 1.
// Position: Centered at specific Z values.
// Orientation: Rotated around Z axis.

// --- Code ---

// 1. Main Body
// Handle
handle = cylinder(d = d_handle, h = h_handle, center = false);

// Cone
cone = cylinder(d1 = d_cone_bottom, d2 = d_cone_top, h = h_cone, center = false);

// Tip
tip = sphere(d = d_tip, center = [0, 0, z_tip_center]);

// Union Body
body = union(
    handle,
    cone,
    tip
);

// 2. Grooves
// We will create a single groove shape and rotate it.
// The groove is a rectangular hole.
// To cut it, we translate the hole to the correct Z, then rotate around Z.
// Since we are cutting, we need to ensure the hole extends slightly past the body boundaries.
// Body Z range: 0 to 63.5.
// Groove Z centers: 10, 15, 20, 25.
// Groove width (Z): 2. So it spans 1 unit above and below center.
// We add 0.1mm clearance to Z and X.

groove_shape = difference() {
    // The material to be removed is a cylinder segment.
    // We define the hole as a cylinder with a flat top and bottom (to cut through).
    // Actually, simpler: A cylinder with a specific height, then we will rotate it.
    // But since we are rotating, the "height" of the cylinder in Z becomes the arc length? No.
    // We are rotating a 2D profile? No, we are rotating a 3D object around Z.
    // If we rotate a cylinder around its own axis, it stays a cylinder.
    // We need a "chisel" shape.
    // Let's define the groove as a cylinder with a flat face on the side?
    // No, standard way: 
    // Create a cylinder that represents the hole volume.
    // The hole is defined by:
    // - Radius = 0 (it's a hole in the center? No, circumferential).
    // - It's a cut on the surface.
    
    // Correct approach for circumferential groove:
    // Create a cylinder that is "flat" on the side? No.
    // Create a cylinder with a specific height (Z-depth of the groove) and radius (depth of the groove).
    // Then rotate it? No, rotating a cylinder around Z just makes a cylinder.
    // We need to rotate a "slice".
    // Let's create a cylinder that is the hole itself.
    // The hole is a cylinder of radius = d_groove, height = w_groove.
    // But it needs to be positioned on the surface.
    // We can't easily position a cylinder on the surface of another cylinder using simple rotation unless we use a "chisel" shape.
    
    // Alternative: Use a cylinder with a flat face?
    // Let's try this: 
    // Create a cylinder with radius = d_groove and height = w_groove.
    // This cylinder represents the "bit" that cuts the groove.
    // We place this bit at the surface of the main body.
    // How? We translate it to the surface.
    // But the surface is curved.
    // If we place a cylinder at (4, 0, z), it will cut