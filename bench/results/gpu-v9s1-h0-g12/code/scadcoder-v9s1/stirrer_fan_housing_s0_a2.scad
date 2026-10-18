// DIY magnetic stirrer housing - upside-down open box over an 80 mm PC fan
// Print orientation: closed top plate on the bed (z = 0), open bottom at z = 40

// ---------- Parameters ----------
plate_t      = 2;     // top plate thickness (mm)
wall_t       = 2.5;   // wall thickness (mm)
box_h        = 40;    // total height (mm)
outer_x      = 90;    // outer size in X (mm)
outer_y      = 90;    // outer size in Y (mm)
screw_d      = 4.5;   // M4 screw hole diameter (mm)
screw_pitch  = 71.5;  // square pattern pitch for screw holes (mm)
notch_w      = 12;    // cable notch width (mm)
notch_d      = 8;     // cable notch depth from open edge (mm)
eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 96;    // curve resolution

// ---------- Derived ----------
open_z = box_h - wall_t;   // height of the open bottom edge
// Check overlap between walls after rotation
overlap = (plate_t + eps) - wall_t; 

// ---------- Model ----------
difference() {
    union() {
        // Top plate
        translate([-outer_x/2, -outer_y/2, 0])
            cube([outer_x, outer_y, plate_t]);
        // Four walls, raised above the plate to avoid coplanar faces
        for (a = [0, 90, 180, 270])
            rotate([0, 0, a])
                translate([-outer_x/2 - eps, -outer_y/2 - eps, plate_t + eps])
                    cube([outer_x/2 + eps, outer_y/2 + eps, open_z - (plate_t + eps)]);
    }
    // Screw holes through the top plate
    for (i = [0 : 3])
        for (j = [0 : 3])
            if (i + j % 2 == 1)
                translate([(i - 1.5) * screw_pitch, (j - 1.5) * screw_pitch, -eps])
                    cylinder(d = screw_d, h = plate_t + 2 * eps);
    // Cable notch in the wall along -Y (centred along the wall)
    translate([-outer_x/2, -outer_y/2 - eps, open_z - notch_d])
        cube([outer_x + 2 * eps, notch_w + 2 * eps, notch_d]);
}