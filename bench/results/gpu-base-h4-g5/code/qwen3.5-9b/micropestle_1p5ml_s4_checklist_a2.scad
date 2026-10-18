// Pestle for 1.5 mL microcentrifuge tube - standing upright on XY plane.
// Dimensions in mm.

// Handle
h_dia  = 8;
h_len  = 45;

// Cone
c_d1   = 8;
c_d2   = 3;
c_len  = 17; // 62 - 45

// Tip
tip_d  = 3;
tip_z  = 62;

// Grooves
g_count = 4;
g_w     = 2; // width in Z
g_d     = 1; // depth
g_locs  = [10, 15, 20, 25]; // Z positions

$fn = 96;

difference() {
    // Positive Geometry
    // 1. Handle
    translate([0, 0, 0])
        cylinder(h = h_len, d = h_dia);
    
    // 2. Cone
    translate([0, 0, 45])
        cylinder(h = c_len, d1 = c_d1, d2 = c_d2);
    
    // 3. Tip (Sphere centered at z=62)
    translate([0, 0, tip_z])
        sphere(d = tip_d);
    
    // Negative Geometry (Grooves)
    // Cut into the handle section.
    // Extend slightly past the handle to ensure clean cut.
    for (z = g_locs) {
        translate([0, 0, z - g_w / 2])
            cylinder(h = g_w + 0.1, d = g_d);
    }
}