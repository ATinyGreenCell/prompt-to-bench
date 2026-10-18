// Lab funnel - printed upright, open top and bottom
// Spout: 10 mm outer diameter, z = 0 to 20
// Cone: widens from 10 mm (z = 20) to 60 mm (z = 50)
// Wall: 1.6 mm everywhere

// ---------- Parameters ----------
spout_d        = 10;     // spout outer diameter
spout_h        = 20;     // spout height
cone_d_top     = 60;     // cone rim outer diameter
cone_d_bottom  = 10;     // cone base outer diameter (at z = spout_h)
cone_h         = 30;     // cone height (z = 20 to z = 50)
wall           = 1.6;    // wall thickness
eps            = 0.5;    // cutter overshoot past faces

$fn = 96;

// Bore diameter of spout and cone
bore = spout_d - 2 * wall;

// ---------- Model ----------
difference() {
    union() {
        // Spout: cylinder from z = 0 to z = 20
        translate([0, 0, 0])
            cylinder(d = spout_d, h = spout_h);

        // Cone: linear_extrude of a trapezoid (10 mm to 60 mm) over 30 mm
        translate([0, 0, spout_h])
            linear_extrude(height = cone_h)
                polygon([[-cone_d_bottom / 2, 0],
                        [ cone_d_bottom / 2, 0],
                        [ cone_d_top    / 2, cone_h],
                        [-cone_d_top    / 2, cone_h]]);
    }

    // Bottom cutter: cylinder through z = 0 to z = -eps
    translate([0, 0, -eps])
        cylinder(d = bore, h = spout_h + 2 * eps);

    // Top cutter: cylinder through z = spout_h + cone_h to z = spout_h + cone_h + eps
    translate([0, 0, spout_h + cone_h - eps])
        cylinder(d = bore, h = cone_h + 2 * eps);
}