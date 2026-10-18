// DIY magnetic stirrer housing for 80 mm PC case fan
// Print orientation: top plate down on bed (z = 0), open top at z = 40

// ---------- Parameters ----------
outer_size   = 90;    // outer size of top plate (X x Y), mm
plate_t      = 2;     // top plate thickness, mm
wall_t       = 2.5;   // wall thickness, mm
box_h        = 40;    // overall height, mm
hole_d       = 4.5;   // M4 screw hole diameter, mm
hole_pitch   = 71.5;  // square pattern centre-to-centre spacing, mm
notch_w      = 12;    // power cable notch width, mm
notch_depth  = 8;     // notch depth from open edge, mm
eps          = 0.5;   // cutter overshoot past faces, mm
$fn          = 64;    // curve resolution

// ---------- Derived ----------
inner_r = (outer_size - 2 * wall_t) / 2;   // inner radius (42.5 mm)

// ---------- Model ----------
difference() {
    union() {
        // Top plate (print bed side)
        translate([-outer_size / 2, -outer_size / 2, 0])
            cube([outer_size, outer_size, plate_t]);

        // Walls rising to open top
        hull() {
            for (r = [inner_r, outer_size / 2 - eps])
                translate([r * cos(45), r * sin(45), plate_t])
                    cylinder(r = eps, h = box_h - plate_t);
        }
    }

    // Screw holes through top plate
    for (i = [0 : 3]) {
        a = 90 * i;
        translate([hole_pitch / 2 * cos(a), hole_pitch / 2 * sin(a), -eps])
            cylinder(d = hole_d, h = plate_t + 2 * eps);
    }

    // Power cable notch in one wall (z = 32 to 40)
    translate([-inner_r, -inner_r, box_h - notch_depth])
        cube([notch_w, notch_w, notch_depth + eps]);
}