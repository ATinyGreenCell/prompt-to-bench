// Replacement knob for a hotplate stirrer with a 6 mm D-shaft
// Print orientation: bottom face (with shaft bore) on the bed, z = 0

$fn = 96;

// --- Knob dimensions ---
knob_d      = 30;    // knob diameter
knob_h      = 15;    // knob height

// --- Shaft bore ---
shaft_d     = 6.2;   // D-shaft bore diameter
shaft_depth = 12;    // blind bore depth from bottom face
flat_offset = 0.85;  // distance from flat side to circle centre (so flat-to-opposite side = 4.7)

// --- Grip grooves ---
groove_count = 18;   // number of vertical grip grooves
groove_d     = 2;    // groove diameter (half-cylinder)

// --- Pointer groove ---
pointer_w   = 1.5;   // pointer groove width
pointer_d   = 1;     // pointer groove depth

// --- Cutting overlap ---
eps = 0.5;           // extension past faces to avoid coplanar surfaces

difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore from bottom face
    translate([0, 0, -eps])
        linear_extrude(height = shaft_depth + eps)
            hull() {
                translate([flat_offset, 0, 0]) circle(d = shaft_d);
                translate([-flat_offset, 0, 0]) circle(d = shaft_d);
            }

    // Vertical grip grooves along full height, centred on outer surface
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 16);

    // Pointer groove from centre to outer edge on top face, same side as flat
    translate([flat_offset, 0, knob_h - pointer_d])
        cube([knob_d, pointer_w, pointer_d]);
}