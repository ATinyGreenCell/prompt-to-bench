// Two-part enclosure for small electronics board (e.g. Arduino-based logger)
// Print orientation: box standing on the bed, lid on top (overhangs into box)

$fn = 64;

// ---- Box ----
box_x = 70;    // outer size in X
box_y = 50;    // outer size in Y
box_z = 30;    // outer size in Z
wall  = 2;     // wall thickness (sides and floor)

// ---- Lid ----
lip_x   = 65.6;          // outer size of lip in X
lip_y   = 45.6;          // outer size of lip in Y
lip_w   = 1.5;           // lip wall thickness
lip_h   = 4;             // lip height (slides into box opening)
clear   = 0.2;           // clearance on each side of the opening
gap     = 10;            // gap between box and lid on the bed

// ---- Derived ----
inner_x = box_x - 2*wall;   // opening width (66)
inner_y = box_y - 2*wall;   // opening depth (46)
lip_x2  = lip_x + 2*clear;  // lip outer size with clearance
lip_y2  = lip_y + 2*clear;

module box() {
    difference() {
        cube([box_x, box_y, box_z]);
        translate([wall, wall, wall])
            cube([inner_x, inner_y, box_z]);     // hollow, open top
    }
}

module lid() {
    // plate lying on the bed, with a rectangular lip on top
    union() {
        translate([0, 0, 0])
            cube([box_x, box_y, wall]);           // plate
        translate([-lip_x2/2, -lip_y2/2, wall])
            cube([lip_x2, lip_y2, lip_h]);       // lip
    }
}

translate([-box_x/2, -box_y/2, 0])
    box();

translate([box_x/2 - gap, -box_y/2, 0])
    lid();