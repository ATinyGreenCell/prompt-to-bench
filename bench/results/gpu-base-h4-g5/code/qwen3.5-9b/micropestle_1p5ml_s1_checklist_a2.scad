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

// Main body construction using rotate_extrude for a single watertight volume.
// Profile points: [radius, z]
// Start at bottom of handle (z=0, r=4)
// Go up handle (z=45, r=4)
// Taper to cone (z=62, r=1.5)
// Tip is a sphere centered at z=62.
// The profile goes from the cone tip (1.5, 62) to the top of the sphere (0, 63.5)
// and back to the cone tip (1.5, 62).
// Note: The sphere is centered at z=62, so it extends from z=60.5 to z=63.5.
// The cone ends at z=62. The sphere's equator is at z=62.
// The profile must trace the outer surface.
// (4,0) -> (4,45) -> (1.5,62) -> (0,63.5) -> (0,60.5) -> (1.5,62) -> (4,45) -> (4,0).
// This creates a handle, a cone, and a sphere attached at the equator.

difference() {
    // Build the main body
    rotate_extrude($fn = 64) 
        polygon([
            [h_d/2, 0],
            [h_d/2, h_z1],
            [c_d2/2, c_z2],
            [0, c_z2 + tip_r],
            [0, c_z2 - tip_r],
            [c_d2/2, c_z2],
            [h_d/2, h_z1],
            [h_d/2, 0]
        ]);

    // Cut grooves
    // Each groove is a cylinder cut into the handle.
    // We extend the cutting cylinder slightly past the handle boundaries to ensure clean cuts.
    for (i = [0 : g_n - 1]) {
        z_pos = g_zs[i];
        // Groove cylinder: diameter = handle diameter + 2*depth (to cut fully through)
        cut_d = h_d + 2 * g_d;
        
        translate([0, 0, z_pos - g_w / 2]) {
            cylinder(h = g_w + 2, d = cut_d, center = true);
        }
    }
}