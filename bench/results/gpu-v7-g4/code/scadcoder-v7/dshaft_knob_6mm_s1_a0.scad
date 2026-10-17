// Replacement knob for hotplate stirrer (D-shaft)
// Print orientation: side facing hotplate down on bed (z = 0)

// ---------------- Parameters ----------------
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
shaft_d       = 6.2;   // D-shaft diameter
bore_depth    = 12;    // blind bore depth from bottom face
bore_flat     = 4.7;   // D-bore flat-to-flat distance
groove_count  = 18;    // number of grip grooves
groove_d      = 2;     // grip groove diameter (half-cylinder)
pointer_w     = 1.5;   // pointer groove width
pointer_d    = pointer_w; // pointer groove depth (same as width)
eps           = 0.5;   // cutter overshoot past faces

$fn = 96;

// Derived
bore_r = shaft_d / 2;
pitch  = 360 / groove_count;

// ---------------- Model ----------------
difference() {
    // Main body
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore, centred on origin, flat on +X side
    translate([0, 0, -eps])
        linear_extrude(height = bore_depth + 2 * eps)
            circle(r = bore_r, $fn = 64);
    translate([bore_flat / 2, 0, -eps])
        linear_extrude(height = bore_depth + 2 * eps)
            translate([bore_r / 2, 0, 0]) rotate([0, 90, 0])
                cube([bore_r / 2, bore_depth + 2 * eps, 1]);

    // Grip grooves: vertical half-cylinders centred on outer surface
    for (i = [0 : groove_count - 1]) {
        a = i * pitch;
        translate([knob_d / 2 * cos(a), knob_d / 2 * sin(a), 0])
            rotate([0, 90, a])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 16);
    }

    // Pointer groove: radial slot from centre to edge, on +X side
    translate([0, 0, -eps])
        linear_extrude(height = knob_h + 2 * eps)
            translate([0, -pointer_w / 2, 0]) rotate([0, 90, 0])
                cube([pointer_d, knob_d / 2 + 1, eps + pointer_d]);
}