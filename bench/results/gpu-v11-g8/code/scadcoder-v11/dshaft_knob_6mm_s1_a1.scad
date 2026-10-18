// Hotplate stirrer knob - D-shaft 6 mm
// Print orientation: bottom face (with D-bore opening) on the bed, z = 0

$fn = 96;

// ---- Dimensions (mm) ----
knob_d        = 30;    // knob outer diameter
knob_h        = 15;    // knob height
shaft_d       = 6;     // D-shaft diameter
bore_d        = 6.2;   // D-bore circle diameter
bore_depth    = 12;    // D-bore depth from bottom face
bore_flat     = (bore_d - 4.7) / 2;  // offset of circle centre from flat side
groove_d      = 2;     // grip groove half-cylinder diameter
groove_count  = 18;    // number of evenly spaced grip grooves
pointer_w     = 1.5;   // pointer groove width
pointer_depth = 1;     // pointer groove depth
eps           = 0.5;   // overcut for clean boolean differences

// ---- Model ----
difference() {
    // Main cylinder body
    translate([0, 0, 0])
        cylinder(d = knob_d, h = knob_h);

    // D-shaped blind bore in bottom face
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = bore_depth + eps);
    // flat on the -Y side
    translate([0, -bore_flat, -eps])
        rotate([90, 0, 0])
            cylinder(d = bore_d, h = bore_depth + eps);

    // Vertical grip grooves around the outside
    for (i = [0 : groove_count - 1])
        rotate([0, 0, i * 360 / groove_count])
            translate([knob_d / 2, 0, -eps])
                cylinder(d = groove_d, h = knob_h + 2 * eps, $fn = 64);

    // Pointer groove on top face, same side as the D-flat (-Y)
    translate([0, -pointer_w / 2, knob_h - pointer_depth])
        cube([knob_d, pointer_w, pointer_depth + eps]);
}