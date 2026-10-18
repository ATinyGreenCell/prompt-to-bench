// Replacement knob for hotplate stirrer (D-shaft: 6 mm)
// Print orientation: side facing hotplate down on bed (z = 0)

// ---------------- Parameters ----------------
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
bore_depth    = 12;    // D-bore depth from bottom face
shaft_d       = 6.2;   // D-shaft diameter
flat_to_arc   = 4.7;   // flat-to-opposite-side distance of D-bore
groove_count  = 18;    // number of vertical grip grooves
groove_d      = 2;     // groove diameter (half-cylinder)
pointer_w     = 1.5;   // pointer groove width
pointer_d     = 1;     // pointer groove depth
eps           = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------------- Model ----------------
difference() {
    // Main cylinder
    cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore (circle + flat cut)
    translate([0, 0, knob_h - bore_depth])
        union() {
            cylinder(d = shaft_d, h = bore_depth + eps);
            // flatten one side of the cylinder to make the D
            translate([shaft_d / 2, 0, 0])
                cube([bore_depth + eps, flat_to_arc, 1]);
        }

    // Vertical grip grooves: half-cylinders centred on outer surface
    for (i = [0 : groove_count - 1]) {
        a = (i / groove_count) * 360;
        translate([knob_d / 2, 0, 0])
            rotate([0, 0, a])
                cylinder(d = groove_d, h = knob_h, center = true);
    }

    // Pointer groove on top face, same side as the D flat
    translate([0, 0, knob_h - pointer_d])
        cube([pointer_w, knob_d / 2 + eps, pointer_d]);
}