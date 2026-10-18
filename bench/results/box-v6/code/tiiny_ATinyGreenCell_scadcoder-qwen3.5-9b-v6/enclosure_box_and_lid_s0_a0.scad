// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: box stands on its floor, lid rests on the bed upside down with a lip
// so the two parts fuse into one solid.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
wall       = 2;     // box wall thickness
floor      = 2;     // box floor thickness (separate from walls)

lip_t      = 1.5;   // lid wall thickness
lip_h      = 4;     // lid wall height (extends above the plate)
lip_x      = 65.6;  // lid outer length (X)
lip_y      = 45.6;  // lid outer width (Y)
clearance  = 0.2;   // clearance between lip inner size and box opening

eps        = 0.5;   // overlap / cut extension to avoid coplanar faces

// ---------------- Model ----------------
union() {
    // Box (Part 1)
    translate([-box_x/2, -box_y/2, 0])
        cube([box_x, box_y, box_z - floor]);

    // Lid (Part 2), printed upside down, placed on the +X side of the box
    translate([(box_x - lip_x)/2 + eps, -lip_y/2, 0])
        cube([lip_x, lip_y, lip_h]);
}