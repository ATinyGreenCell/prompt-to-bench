// Adapter sleeve: 0.2 mL PCR tube into a 1.5 mL rack hole
// Print orientation: collar (13 mm dia, 1.5 mm thick) on the bed (z = 0..1.5),
// sleeve body (10.8 mm OD) rising to z = 21.5, with a 6.2 mm bore through the full height.

$fn = 64;

// --- Dimensions (mm) ---
collar_dia   = 13.0;   // collar outer diameter
collar_thk   = 1.5;    // collar thickness (z = 0 to 1.5)
sleeve_od    = 10.8;   // sleeve body outer diameter
sleeve_top   = 21.5;   // top of sleeve body (z)
bore_dia     = 6.2;    // straight bore diameter, open at both ends

// --- Derived radii ---
collar_r = collar_dia / 2;   // 6.5
sleeve_r = sleeve_od  / 2;   // 5.4
bore_r   = bore_dia   / 2;   // 3.1

// --- Build the solid, centred on the origin in X and Y, resting on z = 0 ---
difference() {
    // Collar: 13 mm dia, 1.5 mm thick, sitting on the bed
    cylinder(h = collar_thk, d = collar_dia, $fn = $fn);

    // Sleeve body: 10.8 mm OD, from the top of the collar up to z = 21.5
    translate([0, 0, collar_thk])
        cylinder(h = sleeve_top - collar_thk, d = sleeve_od, $fn = $fn);

    // Bore: 6.2 mm dia, through the full height, open at both ends.
    // Extended 1 mm past each face so no faces are exactly coplanar.
    translate([0, 0, -1])
        cylinder(h = sleeve_top + 2, d = bore_dia, $fn = $fn);
}