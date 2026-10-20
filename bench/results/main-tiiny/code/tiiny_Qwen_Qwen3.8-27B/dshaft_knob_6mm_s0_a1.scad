// Replacement knob for a 6 mm D-shaft hotplate stirrer
// Print orientation: hotplate-facing side down on the bed (z = 0), builds +Z.
// Centred on the origin in X and Y.

$fn = 64;

// ---- Overall knob ----
knob_dia   = 30;   // outer cylinder diameter (mm)
knob_h     = 15;   // knob height (mm)
knob_r     = knob_dia / 2;   // outer radius (15 mm)

// ---- D-shaped blind bore (6 mm D-shaft, clearance fit) ----
bore_dia   = 6.2;  // circular part of the D bore (mm)
bore_r     = bore_dia / 2;   // 3.1 mm
bore_flat  = 4.7;  // distance from the flat face to the far side of the circle (mm)
bore_depth = 12;   // how far the bore goes up into the knob (mm)
// flat is offset from the centre by (bore_r - bore_flat) = 3.1 - 4.7 = -1.6 mm
// (i.e. 1.6 mm on the -X side, so the flat is on the -X side of the bore)
bore_flat_off = bore_r - bore_flat;   // -1.6 mm

// ---- Vertical grip grooves (18, full height) ----
n_grooves  = 18;
groove_dia = 2;    // half-cylinder groove diameter (mm)
groove_r   = groove_dia / 2;   // 1 mm
// groove centre sits on the outer surface (radius = knob_r)

// ---- Top pointer groove (radial, on the flat side of the D) ----
ptr_w      = 1.5;  // pointer groove width (mm)
ptr_d      = 1;    // pointer groove depth (mm)
// runs from the centre to the outer edge on the -X side (same side as the D flat)

// =====================================================================
// 1. Knob body
// =====================================================================
body = cylinder(h = knob_h, r = knob_r, $fn = $fn);

// =====================================================================
// 2. D-shaped blind bore (cut from the bottom face, 12 mm deep)
//    = 6.2 mm circle with one side cut flat (flat on the -X side)
// =====================================================================
d_bore = difference(
    cylinder(h = bore_depth, r = bore_r, $fn = $fn),
    // flat cutter: a slab that removes the -X portion of the circle,
    // leaving the flat at x = bore_flat_off and the far side at x = +bore_r
    translate([bore_flat_off - 0.01, -bore_r - 1, -1])
        cube([bore_r - bore_flat_off + 0.01, 2 * bore_r + 2, bore_depth + 2])
);

// =====================================================================
// 3. 18 vertical grip grooves (2 mm half-cylinders on the outer surface)
// =====================================================================
grooves = for (i = [0 : n_grooves - 1])
    rotate([0, 0, i * 360 / n_grooves])
        translate([knob_r, 0, 0])
            cylinder(h = knob_h, r = groove_r, $fn = $fn);

// =====================================================================
// 4. Top pointer groove (1.5 mm wide, 1 mm deep, centre -> outer edge, -X side)
//    A radial slot cut 1 mm into the top face.
// =====================================================================
pointer = translate([-knob_r - 1, -ptr_w / 2, knob_h - ptr_d])
    cube([knob_r + 1, ptr_w, ptr_d + 1]);

// =====================================================================
// Final part
// =====================================================================
difference(
    body,
    d_bore,
    grooves,
    pointer
);