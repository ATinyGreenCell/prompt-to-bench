// Pestle for 1.5 mL microcentrifuge tube - printed standing upright.
// Corrected to ensure single body, correct positioning (z=0), and proper groove cutting.

// Handle
h_d   = 8;      // Handle diameter
h_z1  = 45;     // Handle end Z (top of handle)

// Cone
c_d1  = 8;      // Cone top diameter (matches handle)
c_d2  = 3;      // Cone bottom diameter
c_z1  = 45;     // Cone start Z
c_z2  = 62;     // Cone end Z

// Tip
tip_r = 1.5;    // Tip radius (3 mm diameter)
tip_z = 62;     // Tip center Z

// Grooves
g_n   = 4;      // Number of grooves
g_w   = 2;      // Groove width (Z)
g_d   = 1;      // Groove depth
g_zs  = [10, 15, 20, 25]; // Groove center Z positions

$fn = 64;

// Calculate the total height to translate the part up so the bottom is at z=0.
// The lowest point of the geometry (bottom of handle) is currently at z=0 in the profile.
// We will translate the final object up by the handle length to ensure it sits on the bed?
// Wait, the spec says "from z=0 to z=45". So the bottom of the handle is at z=0.
// In the profile below, we define the shape relative to the bottom of the handle.
// So we do NOT need to translate the whole thing up, we just need to make sure the profile starts at z=0.

// Main body construction using rotate_extrude for a single watertight volume.
// Profile points: [radius, z]
// Start at bottom of handle (z=0, r=4)
// Go up handle (z=45, r=4)
// Taper to cone (z=62, r=1.5)
// Tip is a sphere, so the profile needs to go from r=1.5 at z=62 to r=0 at z=62+1.5=63.5?
// No, the spec says "sphere centred at z=62".
// So the sphere goes from z=60.5 to z=63.5.
// The cone ends at z=62 with r=1.5.
// The sphere center is at z=62.
// So the profile should go from (1.5, 62) to (0, 63.5) and back to (1.5, 60.5)?
// Actually, rotate_extrude creates a solid of revolution.
// If we define the profile as:
// (4, 0) -> (4, 45) -> (1.5, 62) -> (0, 63.5) -> (0, 60.5) -> (1.5, 62) -> close?
// No, the sphere is centered at 62. The cone ends at 62.
// The cone surface meets the sphere surface at z=62?
// Cone: z=45 to 62. At z=62, r=1.5.
// Sphere: Center (0,0,62). Radius 1.5. Top at 63.5, bottom at 60.5.
// The cone and sphere touch at the equator of the sphere (z=62, r=1.5).
// So the profile is continuous:
// (4, 0) -> (4, 45) -> (1.5, 62) -> (0, 63.5) -> (0, 60.5) -> (1.5, 62) -> (4, 45) -> (4, 0).
// Wait, the profile must be a closed loop.
// (4,0) -> (4,45) -> (1.5,62) -> (0,63.5) -> (0,60.5) -> (1.5,62) -> (4,45) -> (4,0).
// This creates a shape where the cone meets the sphere at the equator.
// However, the sphere is a full sphere. The cone is a frustum.
// If we extrude the profile (4,0)->(4,45)->(1.5,62)->(0,63.5)->(0,60.5)->(1.5,62)->(4,45)->(4,0),
// we get a handle, a cone, and a sphere attached at the equator.
// This matches the description.

difference() {
    // Build the main body
    rotate_extrude($fn = 6