// Parameters (mm)
top_thick   = 2;          // thickness of the top plate
wall_thick  = 2.5;        // thickness of each wall
height      = 40;         // total height from bed to open edge
outer_size  = 90;         // outer X and Y dimensions
inner_size  = outer_size - 2*wall_thick; // inner cavity size
hole_dia    = 4.5;        // diameter of the M4 screw holes
hole_spacing = 71.5;     // centre‑to‑centre spacing of the four holes (square pattern)
notch_w     = 12;         // width of the cable notch (X direction)
notch_h     = 8;          // depth of the notch from the open edge (Z direction)
extra_cut   = 0.5;        // extra material removed beyond each face (for clean cuts)

$fn = 64;

// ---------- Top plate ----------
top_plate = translate([-outer_size/2, -outer_size/2, 0])
            cube([outer_size, outer_size, top_thick]);

// ---------- Walls ----------
outer_box = translate([-outer_size/2, -outer_size/2, top_thick])
            cube([outer_size, outer_size, height - top_thick]);

inner_cavity = translate([-(inner_size/2), -(inner_size/2), top_thick])
               cube([inner_size, inner_size, height - top_thick]);

walls = difference() {
            outer_box;
            // extend inner cavity a little beyond the wall faces
            translate([0,0,-extra_cut]) inner_cavity;
            translate([0,0, extra_cut]) inner_cavity;
        };

// ---------- Screw holes (through top plate) ----------
hole_radius = hole_dia/2;
hole_offset = hole_spacing/2; // distance from centre to each hole

holes = union() {
    for (dx = [-hole_offset, hole_offset], dy = [-hole_offset, hole_offset])
        translate([dx, dy, -extra_cut])
            cylinder(h = top_thick + 2*extra_cut, r = hole_radius);
};

// ---------- Cable notch (front wall) ----------
notch = translate([
            -notch_w/2,                     // centre the notch in X
            -(outer_size/2) - extra_cut,   // start just outside the front wall
            height - notch_h - extra_cut    // lower edge of the notch (extend a bit below)
        ])
        cube([notch_w, wall_thick + 2*extra_cut, notch_h + extra_cut]);

// ---------- Final part ----------
difference() {
    union() {
        top_plate;
        walls;
    }
    holes;
    notch;
}