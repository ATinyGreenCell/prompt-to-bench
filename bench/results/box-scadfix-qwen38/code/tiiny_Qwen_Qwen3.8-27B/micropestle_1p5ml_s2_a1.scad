// Pestle for 1.5 mL microcentrifuge tube, printed standing upright
// All dimensions in millimetres

// Handle
handle_d = 8;          // handle diameter
handle_r = handle_d / 2; // handle radius (4 mm)
handle_z0 = 0;         // handle bottom z
handle_z1 = 45;        // handle top z (cone starts here)

// Cone
cone_d_top = 8;        // cone diameter at z = 45
cone_d_bot = 3;        // cone diameter at z = 62
cone_z0 = 45;          // cone bottom z
cone_z1 = 62;          // cone top z

// Rounded tip
tip_d = 3;             // sphere diameter
tip_r = tip_d / 2;     // sphere radius (1.5 mm)
tip_z = 62;            // sphere centre z

// Grip grooves (cut into handle)
groove_w = 2;          // groove width in Z
groove_depth = 1;      // groove depth (radial)
groove_zs = [10, 15, 20, 25]; // groove centre z positions

// Curved-surface resolution
$fn = 64;

// ---- Base solid: handle + cone + tip sphere, unioned ----
module base() { union() {
    // Cylindrical handle
    translate([0, 0, handle_z0])
        cylinder(h = handle_z1 - handle_z0, r1 = handle_r, r2 = handle_r, $fn = $fn);

    // Tapered cone (8 mm dia at z=45 -> 3 mm dia at z=62)
    translate([0, 0, cone_z0])
        cylinder(h = cone_z1 - cone_z0, r1 = cone_d_top / 2, r2 = cone_d_bot / 2, $fn = $fn);

    // Rounded tip: sphere centred at z = 62
    translate([0, 0, tip_z])
        sphere(r = tip_r, $fn = $fn);
} }

// ---- Groove cutter: a short tube (annulus) 2 mm wide, 1 mm deep ----
// Outer radius = handle_r + 1 (extends past the handle surface),
// inner radius = handle_r - groove_depth (cuts 1 mm into the handle).
// The tube is 2 mm wide in Z, centred on each groove_z.
// Extending 1 mm past the outer face guarantees a clean cut with no coplanar faces.
module groove_cutter(gz) {
    translate([0, 0, gz - groove_w / 2])
        difference() {
            cylinder(h = groove_w, r1 = handle_r + 1, r2 = handle_r + 1, $fn = $fn);
            cylinder(h = groove_w + 0.02, r1 = handle_r - groove_depth, r2 = handle_r - groove_depth, $fn = $fn);
        }
}

// ---- Final part: base minus grooves ----
difference() {
    base();
    for (gz = groove_zs)
        groove_cutter(gz);
}