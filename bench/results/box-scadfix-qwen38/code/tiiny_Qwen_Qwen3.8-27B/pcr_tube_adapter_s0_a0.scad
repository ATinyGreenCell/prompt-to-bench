// Adapter sleeve: 0.2 mL PCR tube into a 1.5 mL tube rack hole
// Print orientation: collar (13 mm dia, 1.5 mm thick) on the bed (z = 0..1.5),
// sleeve body (10.8 mm OD) rising to z = 21.5, with a 6.2 mm bore through the full height.

// --- Dimensions (mm) ---
collar_dia   = 13.0;   // outer diameter of the bed-lying collar
collar_thk   = 1.5;    // thickness of the collar (z = 0 to 1.5)
body_od      = 10.8;   // outer diameter of the sleeve body
body_top_z   = 21.5;   // top of the sleeve body (z = 21.5)
bore_dia     = 6.2;    // straight through-bore diameter

// --- Derived radii ---
collar_r = collar_dia / 2;   // 6.5
body_r   = body_od   / 2;    // 5.4
bore_r   = bore_dia  / 2;    // 3.1

// --- Curvature resolution ---
$fn = 64;

// --- Build the solid, centred on the origin in X and Y, resting on z = 0 ---
union() {
    // Collar: 13 mm diameter, 1.5 mm thick, lying on the bed
    cylinder(h = collar_thk, d = collar_dia, $fn = $fn);

    // Sleeve body: 10.8 mm outer diameter, rising from the collar to z = 21.5
    cylinder(h = body_top_z, d = body_od, $fn = $fn);
}

// --- Cut the straight 6.2 mm bore through the full height ---
// The cutter extends 1 mm past each face (z = -1 to 22.5) so no faces are coplanar.
difference() {
    union() {
        cylinder(h = collar_thk, d = collar_dia, $fn = $fn);
        cylinder(h = body_top_z, d = body_od,   $fn = $fn);
    }
    translate([0, 0, -1])
        cylinder(h = body_top_z + 2, d = bore_dia, $fn = $fn);
}