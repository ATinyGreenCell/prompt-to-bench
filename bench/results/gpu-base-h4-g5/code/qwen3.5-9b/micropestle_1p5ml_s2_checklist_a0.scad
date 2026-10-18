// Pestle for 1.5 mL microcentrifuge tube - standing upright on XY plane.
// Dimensions in mm.

// Handle
handle_d = 8;
handle_z_start = 0;
handle_z_end = 45;

// Cone
cone_z_start = 45;
cone_z_end = 62;
cone_d_top = 8;
cone_d_bot = 3;

// Tip
tip_d = 3;
tip_z_center = 62;

// Grooves
num_grooves = 4;
groove_w = 2;   // width in Z
groove_d = 1;   // depth
groove_zs = [10, 15, 20, 25]; // centers of grooves

$fn = 64;

// Main body: Handle + Cone + Tip
difference() {
    union() {
        // 1. Cylindrical Handle
        translate([0, 0, handle_z_start])
            cylinder(h = handle_z_end - handle_z_start, d = handle_d);

        // 2. Cone (tapering from top of handle to tip base)
        translate([0, 0, cone_z_start])
            cylinder(h = cone_z_end - cone_z_start, d1 = cone_d_top, d2 = cone_d_bot);

        // 3. Rounded Tip (Sphere centered at tip_z_center)
        translate([0, 0, tip_z_center - tip_d / 2])
            sphere(d = tip_d);
    }

    // 4. Grooves (cut into the handle)
    // We cut a cylinder through the handle at each specified Z center.
    // The cut cylinder must extend slightly past the handle in Z to ensure clean cuts.
    for (z = groove_zs) {
        translate([0, 0, z - groove_w / 2])
            cylinder(h = groove_w + 0.1, d = handle_d + groove_d + 0.1);
    }
}