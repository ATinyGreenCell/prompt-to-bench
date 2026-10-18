// Magnetic stirrer housing for 80 mm PC case fan
// Print orientation: top plate on bed (z = 0), open top at z = 40

// ---- Dimensions (mm) ----
top_t       = 2;     // top plate thickness
wall_t      = 2.5;   // wall thickness
box_h       = 40;    // total height of box (open top)
outer_w     = 90;    // outer size in X
outer_d     = 90;    // outer size in Y
hole        = 4.5;   // M4 screw hole diameter
hole_pitch  = 71.5;  // square pattern size for screw holes
notch_w     = 12;    // cable notch width
notch_bottom = 8;    // notch depth from open edge (z = 32)
eps         = 0.5;   // cutter overshoot

$fn = 64;

difference() {
    // Main box body
    union() {
        // Top plate
        translate([-outer_w/2, -outer_d/2, 0])
            cube([outer_w, outer_d, top_t]);
        // Walls
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx > 0 ? outer_w/2 - wall_t : -outer_w/2,
                       sy > 0 ? outer_d/2 - wall_t : -outer_d/2,
                       top_t])
                cube([wall_t, wall_t, box_h - top_t]);
    }

    // Screw holes through top plate
    for (i = [0:3])
        rotate([0, 0, i * 90])
            translate([0, 0, -eps])
                cylinder(d = hole, h = top_t + 2 * eps);

    // Cable notch in one wall (z = 32 to 40)
    translate([outer_w/2 - wall_t, -notch_w/2, notch_bottom])
        cube([wall_t + eps, notch_w, notch_bottom + eps]);
}