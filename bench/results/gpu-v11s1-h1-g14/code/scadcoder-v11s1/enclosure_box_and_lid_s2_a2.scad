// Two-part enclosure for small electronics board
// Print orientation: box standing on bed, lid flat on bed to the right

$fn = 64;

// ---- Box ----
box_x = 70;      // outer length (X)
box_y = 50;      // outer width (Y)
box_z = 30;      // outer height (Z)
wall  = 2;       // wall thickness
floor = 2;       // floor thickness

// ---- Lid ----
lip_x      = 65.6;   // outer length of lip
lip_y      = 45.6;   // outer width of lip
lip_h      = 4;      // lip height
lip_t      = 1.5;    // lip wall thickness
clearance = 0.2;    // gap between lip inner edge and box opening
overlap    = 0.01;   // small overlap to fuse lid to plate

// Derived
opening_x = box_x - 2*wall;
opening_y = box_y - 2*wall;
plate_t   = 2;

module box() {
    difference() {
        cube([box_x, box_y, box_z]);
        translate([wall, wall, floor])
            cube([opening_x, opening_y, box_z - floor + 0.01]);
    }
}

module lid() {
    union() {
        // Base plate
        translate([0, 0, -overlap])
            cube([box_x, box_y, plate_t + overlap]);
        // Lip
        translate([box_x - lip_x, box_y - lip_y, 0])
            cube([lip_x, lip_y, lip_h]);
        // Lip wall
        translate([box_x - lip_x, box_y - lip_y, -lip_t])
            cube([lip_x, lip_y, lip_t + overlap]);
    }
}

difference() {
    union() {
        box();
        translate([box_x + 10, 0, 0])
            lid();
    }
    // Fuse the two parts
    translate([box_x + 5, box_y / 2, box_z / 2])
        cube([10, box_y, box_z]);
}