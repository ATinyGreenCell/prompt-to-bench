$fn = 64; // smooth curves

// ---------- Dimensions (mm) ----------
outer      = 90;      // outer size X and Y
top_thick  = 2;       // top plate thickness
wall_thick= 2.5;     // wall thickness
box_height= 40;      // total height of the box
hole_dia   = 4.5;     // diameter of M4 screw holes
hole_pat   = 71.5;    // square pattern spacing
notch_w    = 12;      // notch width along wall
notch_depth= wall_thick; // notch depth into wall
notch_h    = 8;       // notch height (from z=32 to z=40)

// ---------- Top plate with four screw holes ----------
top_plate = difference() {
    cube([outer, outer, top_thick], center=false);
    for (x = [-hole_pat/2, hole_pat/2]) {
        for (y = [-hole_pat/2, hole_pat/2]) {
            translate([x, y, -0.01]) {
                cylinder(h=top_thick+0.01, r=hole_dia/2, center=false);
            }
        }
    }
}

// ---------- Walls (open at z=40) with cable notch ----------
walls = difference() {
    cube([outer, outer, box_height - top_thick], center=false);
    // inner cavity
    translate([wall_thick, wall_thick, 0]) {
        cube([outer - 2*wall_thick + 0.01, outer - 2*wall_thick + 0.01, box_height - top_thick], center=false);
    }
    // cable notch on the front wall (Y = 0)
    translate([outer/2 - notch_w/2 - 0.01, -0.01, 31.99]) {
        cube([notch_w + 0.01, notch_depth + 0.01, notch_h + 0.01], center=false);
    }
}

// ---------- Assemble ----------
union() {
    top_plate;
    translate([0, 0, top_thick]) walls;
}