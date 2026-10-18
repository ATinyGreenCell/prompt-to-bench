// DIY magnetic stirrer housing - upside-down open box over a 80 mm PC fan
// Print orientation: top plate on bed (z = 0), walls rise to open top (z = 40)

$fn = 64;

// ---- Dimensions (mm) ----
plate_t      = 2;     // top plate thickness
wall_t       = 2.5;   // wall thickness
box_h        = 40;    // total height (open top at z = 40)
outer        = 90;    // outer size in X and Y
screw_pat    = 71.5;  // square pitch of M4 screw holes
screw_d      = 4.5;   // M4 screw hole diameter
cable_notch_w = 12;   // cable notch width
cable_notch_d = 8;    // cable notch depth from open edge (z = 32 to 40)
eps          = 0.5;   // cutter overshoot past faces

// ---- Model ----
difference() {
    // Outer box: outer size x x y, height h, open top (h = box_h - plate_t)
    cube([outer, outer, box_h - plate_t]);

    // Closed top plate, z = 0..plate_t, with M4 screw holes on square pattern
    translate([0, 0, 0])
        difference() {
            cube([outer, outer, plate_t]);
            for (i = [-1, 1])
                for (j = [-1, 1])
                    translate([i * screw_pat / 2, j * screw_pat / 2, -eps])
                        cylinder(d = screw_d, h = plate_t + 2 * eps);
        }

    // Cable notch in one wall: width w, depth d from open edge, centred along wall
    translate([0, outer / 2 - cable_notch_w / 2, box_h - cable_notch_d])
        cube([outer, cable_notch_w, cable_notch_d + eps]);
}