// Adapter sleeve: 0.2 mL PCR tube into a 1.5 mL tube rack hole
// Print orientation: collar (13 mm dia, 1.5 mm thick) on the bed, sleeve body rising to z = 21.5

// ---- Dimensions (mm) ----
collar_dia   = 13.0;   // outer diameter of the base collar
collar_thk   = 1.5;    // thickness of the base collar (z = 0 to 1.5)
sleeve_od    = 10.8;   // outer diameter of the sleeve body
sleeve_top   = 21.5;   // top z of the sleeve body (full part height)
bore_dia     = 6.2;    // straight through-bore diameter

// ---- Derived values ----
collar_r     = collar_dia / 2;   // 6.5
sleeve_r     = sleeve_od  / 2;   // 5.4
bore_r       = bore_dia / 2;     // 3.1

// ---- Curvature resolution ----
$fn = 64;

// ---- Build the solid ----
// Outer profile: collar (z 0..1.5) + sleeve body (z 1.5..21.5)
// Bore: straight 6.2 mm hole through the full height, open at both ends.
// The bore cutter is extended 1 mm past each face so no faces are coplanar.

difference() {
    union() {
        // Base collar
        cylinder(h = collar_thk, d = collar_dia, $fn = $fn);

        // Sleeve body, rising from the top of the collar to z = 21.5
        translate([0, 0, collar_thk])
            cylinder(h = sleeve_top - collar_thk, d = sleeve_od, $fn = $fn);
    }

    // Through-bore, extended 1 mm past the bottom (z = -1) and top (z = 22.5)
    translate([0, 0, -1])
        cylinder(h = sleeve_top + 2, d = bore_dia, $fn = $fn);
}