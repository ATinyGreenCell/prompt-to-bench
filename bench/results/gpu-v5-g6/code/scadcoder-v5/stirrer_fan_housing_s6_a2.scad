// DIY magnetic stirrer housing - print orientation (upside down)
// Units: mm. Walls 2.5 mm thick. Open box, closed top = stirring surface.

// ---------- Parameters ----------
fan_d          = 80;     // fan diameter
outer_x        = 90;     // outer size in X
outer_y        = 90;     // outer size in Y
top_t          = 2;      // top plate thickness (z = 0 to 2)
wall_t         = 2.5;    // wall thickness
box_h          = 40;     // total height of box (open at top)
screw_d        = 4.5;    // M4 screw hole diameter
screw_pitch    = 1.5;    // M4 screw pitch (for clearance)
screw_pattern  = 71.5;   // square pitch of screw holes
notch_w        = 12;     // cable notch width
notch_depth    = 8;      // cable notch depth from open edge
eps            = 0.5;    // cutter overshoot past faces

$fn = 96;

// ---------- Model ----------
difference() {
    union() {
        // Top plate (lies on bed in print orientation)
        translate([-outer_x/2, -outer_y/2, 0])
            cube([outer_x, outer_y, top_t]);

        // Four walls rising from the plate to the open top
        for (dx = [-outer_x/2, outer_x/2])
            for (dy = [-outer_y/2, outer_y/2])
                translate([dx, dy, 0])
                    cube([wall_t, outer_y - dy + (dx < 0 ? outer_x - dx + dy : outer_x - dx - dy), box_h]);
    }

    // Four M4 screw holes through the top plate on a centred square pattern
    for (sx = [-screw_pattern/2, screw_pattern/2],
         sy = [-screw_pattern/2, screw_pattern/2])
        translate([sx, sy, -eps])
            cylinder(d = screw_d + 2*screw_pitch, h = top_t + 2*eps);

    // Cable notch in one wall: 12 mm wide, centred along the wall,
    // reaching 8 mm down from the open edge (z = 32 to z = 40)
    translate([-outer_x/2 + wall_t, 0, box_h - notch_depth])
        cube([notch_w, outer_y - wall_t, notch_depth]);
}