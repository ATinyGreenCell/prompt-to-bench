// Two-part enclosure for small electronics board
// Print orientation: box standing on bed, lid flat on bed to the +X side

$fn = 64;

// ---- Box ----
box_outer_x = 70;      // outer length (X)
box_outer_y = 50;      // outer width (Y)
box_outer_z = 30;      // outer height (Z)
wall        = 2;       // wall thickness
floor       = 2;       // floor thickness

// ---- Lid ----
lip_outer_x   = 65.6;  // outer length of lip
lip_outer_y   = 45.6;  // outer width of lip
lip_thickness = 1.5;   // lip wall thickness
lip_height    = 4;     // lip height above plate
plate_t       = 2;     // plate thickness
clearance     = 0.2;   // gap between lip inner edge and box opening

// ---- Layout ----
gap      = 10;         // gap between box and lid
lip_over = 0.2;        // lip extends past box opening in X and Y

module box() {
    difference() {
        cube([box_outer_x, box_outer_y, box_outer_z]);
        // Open top - cut extends above the top face
        translate([-box_outer_x/2, -box_outer_y/2, floor])
            cube([box_outer_x, box_outer_y, box_outer_z - floor + 0.01]);
    }
}

module lid() {
    union() {
        // Base plate
        translate([0, 0, 0])
            cube([lip_outer_x, lip_outer_y, plate_t]);
        // Rectangular lip on top
        translate([-lip_outer_x/2, -lip_outer_y/2, plate_t])
            cube([lip_outer_x, lip_outer_y, lip_height]);
    }
}

difference() {
    union() {
        translate([0, 0, 0])
            box();
        // Lid placed on the +X side of the box
        translate([box_outer_x + gap, 0, 0])
            lid();
    }
    // Box opening (extends above top face to avoid coplanar faces)
    translate([-box_outer_x/2, -box_outer_y/2, floor])
        cube([box_outer_x, box_outer_y, box_outer_z - floor + 0.01]);
}