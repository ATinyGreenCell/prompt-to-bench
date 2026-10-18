// Two-part enclosure for small electronics board
// Print orientation: box standing on bed (z = 0), lid on top, printed upside down

// ---------------- Parameters ----------------
box_x      = 70;    // box outer size in X (mm)
box_y      = 50;    // box outer size in Y (mm)
box_z      = 30;    // box outer size in Z (mm)
box_wall   = 2;     // box wall thickness (mm)
box_floor  = 2;     // box floor thickness (mm)

gap        = 10;    // gap between box and lid (mm)

lip_wall   = 1.5;   // lid lip wall thickness (mm)
lip_h      = 4;     // lid lip height (mm)
lip_x      = 65.6;  // lid lip outer size in X (mm)
lip_y      = 45.6;  // lid lip outer size in Y (mm)

eps        = 0.5;   // cutter overshoot past faces (mm)

$fn = 64;

// ---------------- Modules ----------------
module box() {
    difference() {
        cube([box_x, box_y, box_z]);
        // open-top cavity, extends past top face
        translate([box_wall, box_wall, box_floor])
            cube([box_x - 2*box_wall, box_y - 2*box_wall, box_z - box_floor]);
    }
}

module lid() {
    // plate with a rectangular lip on top, centred
    union() {
        translate([0, 0, -eps])
            cube([box_x, box_y, lip_wall]);   // plate (slightly below z = 0)
        translate([-(lip_x/2), -(lip_y/2), 0])
            cube([lip_x, lip_y, lip_h]);      // lip
    }
}

// ---------------- Layout ----------------
difference() {
    union() {
        // box at origin
        translate([-box_x/2, -box_y/2, 0])
            box();
        // lid on +X side, centred on box
        translate([box_x/2 - gap, -box_y/2, 0])
            lid();
    }
    // keep the gap clean between the two parts
    translate([-box_x/2 - eps, -box_y/2 - eps, -eps])
        cube([(box_x/2 + gap + eps) - (-box_x/2),
              (box_y/2 + eps) - (-box_y/2),
              lip_wall + eps]);
}