// DIY magnetic stirrer housing - print orientation (upside down)
// Units: mm

$fn = 64;

// --- Dimensions ---
top_t       = 2;     // top plate thickness
wall_t      = 2.5;   // wall thickness
box_h       = 40;    // total height (top plate + walls)
outer_x     = 90;    // outer size in X
outer_y     = 90;    // outer size in Y
screw_h     = 4.5;   // M4 screw hole diameter
screw_n     = 4;     // number of screw holes
screw_pitch = 71.5;  // square pattern diagonal (side = 71.5 / sqrt(2))
notch_w     = 12;    // cable notch width
notch_d     = 8;     // notch depth from open edge
eps         = 0.5;   // cutter overshoot

// Derived
screw_side = screw_pitch / sqrt(2);

difference() {
    // Box body
    union() {
        cube([outer_x, outer_y, top_t]);               // top plate
        for (z = [top_t : wall_t : box_h])
            translate([0, 0, z])
                cube([outer_x, outer_y, wall_t]);      // walls
    }

    // Screw holes through top plate
    for (i = [0 : screw_n - 1])
        rotate([0, 0, i * 90])
            translate([screw_side / 2, screw_side / 2, -eps])
                cylinder(d = screw_h, h = top_t + 2 * eps);

    // Cable notch in one wall (z = 32 to 40)
    translate([outer_x / 2 - notch_w / 2, outer_y / 2, box_h - notch_d])
        cube([notch_w, outer_y, notch_d + eps]);
}