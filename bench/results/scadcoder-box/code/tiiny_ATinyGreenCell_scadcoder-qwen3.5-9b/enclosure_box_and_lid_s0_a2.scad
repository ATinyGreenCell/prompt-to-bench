// Two-part enclosure for a small electronics board (e.g. an Arduino-based temperature logger).
// The file models both parts side by side with a 10 mm gap so they print in one go.
// Part 1: the box - an open-top box with a solid floor, walls and a top rim (open top).
// Part 2: the lid, printed upside down - a plate with a rectangular lip on its top surface that
// slides into the box opening with a small clearance. The two parts are laid next to each other
// on the build bed with a 10 mm gap between them.

box_d  = 70;
box_y  = 50;
box_h  = 30;
wall   = 2;
floor  = 2;

lip_d  = 65.6;
lip_y  = 45.6;
lip_h  = 4;
clear  = 0.2;

$fn = 48;

ol     = box_d + 2 * wall + 2 * floor;
oy     = box_y + 2 * wall;
ol_h   = box_h - floor;

// Rigidly position the two parts with a 10 mm gap between them, both resting on the bed (z = 0).
gap    = 10;

translate([0, 0, 0]) {
    difference() {
        cube([ol, oy, ol_h]);                 // box body, open top
        translate([0, 0, ol_h - floor]) cube([ol, oy, floor]);          // solid floor
        for (x = [-1, 1])
            translate([x * (ol / 2 - lip_d / 2 - clear), 0, ol_h - floor])
                cube([lip_d + 2 * clear, lip_y + 2 * clear, lip_h]);    // two lips, open downward
    }
}

translate([ol + gap, 0, 0]) {
    union() {
        cube([ol, oy, 2]);                   // base plate
        for (x = [-1, 1])
            translate([x * (ol / 2 - lip_d / 2 - clear), 0, 0])
                cube([lip_d + 2 * clear, lip_y + 2 * clear, lip_h]);    // two lips upward
    }
}