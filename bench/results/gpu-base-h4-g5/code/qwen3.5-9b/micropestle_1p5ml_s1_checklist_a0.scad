// Pestle for 1.5 mL microcentrifuge tube - printed standing upright.
// Dimensions in mm.

// Handle
h_d   = 8;      // Handle diameter
h_z0  = 0;      // Handle start Z
h_z1  = 45;     // Handle end Z

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

// Main body construction
// We build the solid from bottom to top using a difference operation to cut grooves.
// The base shape is a cylinder for the handle, a cone for the taper, and a sphere for the tip.
// Since OpenSCAD primitives are centered or start at origin, we translate them to their correct positions.

difference() {
    union() {
        // 1. Handle: Cylinder from z=0 to z=45, diameter 8.
        // translate([-h_d/2, -h_d/2, 0]) cube([h_d, h_d, h_z1]); // Alternative using cube
        cylinder(h = h_z1, d = h_d, center = true);

        // 2. Cone: Tapers from d=8 at z=45 to d=3 at z=62.
        // We place the cone so its top (d=8) is at z=45 and bottom (d=3) is at z=62.
        // The cone height is 17. The top radius is 4, bottom radius is 1.5.
        // translate([0, 0, c_z1]) cylinder(h = c_z2 - c_z1, d1 = c_d1, d2 = c_d2);
        translate([0, 0, c_z1]) cylinder(h = c_z2 - c_z1, d1 = c_d1, d2 = c_d2);

        // 3. Tip: Sphere of radius 1.5 centered at z=62.
        translate([0, 0, tip_z]) sphere(r = tip_r);
    }

    // Cut grooves
    // Each groove is a cylinder cut into the handle.
    // To ensure clean cuts, we extend the cutting cylinder slightly past the handle boundaries.
    for (i = [0 : g_n - 1]) {
        z_pos = g_zs[i];
        // Groove cylinder: diameter = handle diameter + 2*depth (to cut fully through)
        // Actually, we just need to cut a hole of depth g_d.
        // The cutting cylinder should be tall enough to cover the handle height + a bit.
        // Diameter of cut = handle diameter + 2 * depth (to ensure full depth removal)
        cut_d = h_d + 2 * g_d;
        
        translate([0, 0, z_pos - g_w / 2]) {
            cylinder(h = g_w + 2, d = cut_d, center = true);
        }
    }
}