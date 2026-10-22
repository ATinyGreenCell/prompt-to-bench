// Replacement knob for a 6 mm D-shaft hotplate stirrer
// Print orientation: hotplate-facing side down (z = 0), builds upward (+Z)

// ---- Dimensions (mm) ----
knob_dia      = 30;   // outer cylinder diameter
knob_h        = 15;   // knob height
knob_r        = knob_dia / 2;

// D-bore (blind, from bottom face)
bore_dia      = 6.2;  // circular part of the D
bore_flat     = 4.7;  // distance from flat to opposite side of circle
bore_depth    = 12;   // depth of the blind bore
bore_r        = bore_dia / 2;
bore_flat_off = bore_r - bore_flat; // flat is offset this far from the circle centre

// Grip grooves (vertical, full height, on the outside)
groove_n      = 18;   // number of evenly spaced grooves
groove_dia    = 2;    // half-cylinder groove diameter
groove_r      = groove_dia / 2;

// Pointer groove (top face, radial, on the flat side of the D)
ptr_w         = 1.5;  // width
ptr_d         = 1;    // depth
ptr_len       = knob_r + 1; // extend past the rim so it reaches the edge

$fn = 64;

// ---- Body ----
body = cylinder(h = knob_h, r = knob_r);

// ---- D-bore cutter (extends 1 mm below z = 0 to avoid coplanar faces) ----
d_cutter = difference(
    cylinder(h = bore_depth + 1, r = bore_r),
    translate([0, -bore_flat_off, -1])
        cube([bore_dia + 2, bore_flat_off + 1, bore_depth + 2])
);

// ---- Grip grooves (18 half-cylinders centred on the outer surface) ----
grooves = for (i = [0:groove_n - 1])
    rotate([0, 0, i * 360 / groove_n])
        translate([knob_r, 0, 0])
            cylinder(h = knob_h + 2, r = groove_r);

// ---- Pointer groove (radial slot on the top face, on the flat side of the D) ----
ptr_cutter = translate([0, -ptr_len, knob_h - ptr_d])
    cube([ptr_w, ptr_len + 1, ptr_d + 1]);

// ---- Final part ----
difference(
    body,
    d_cutter,
    grooves,
    ptr_cutter
);