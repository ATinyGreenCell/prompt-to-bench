// Two-part enclosure for a small electronics board (e.g. Arduino-based logger)
// Print orientation: box on the bed (z = 0), lid on top (+Z), side by side.

$fn = 64;

// ---- Box (Part 1) ----
box_x      = 70;    // outer length in X
box_y      = 50;    // outer width in Y
box_z      = 30;    // outer height in Z
box_wall   = 2;     // wall thickness (sides and top)
box_floor  = 2;     // floor thickness (bottom)

// ---- Lid (Part 2) ----
lip_x      = 65.6;  // outer length of lip in X
lip_y      = 45.6;  // outer width of lip in Y
lip_h      = 4;     // lip height above plate
lip_t      = 1.5;   // lip wall thickness
plate_t    = 2;     // lid plate thickness
overlap    = 0.1;   // lip sinks into plate for a clean union

// ---- Layout ----
gap        = 10;    // gap between the two parts along X

// ---- Model ----
union() {
    // Box: hollow rectangle, open top
    difference() {
        cube([box_x, box_y, box_z]);
        translate([box_wall, box_wall, box_floor])
            cube([box_x - 2 * box_wall, box_y - 2 * box_wall, box_z - box_floor]);
    }

    // Lid: base plate with a rectangular lip on top
    union() {
        translate([box_x + gap, 0, 0])
            cube([lip_x + 2 * (box_wall + overlap), lip_y + 2 * (box_wall + overlap), plate_t]);
        translate([box_x + gap - lip_x / 2, lip_y / 2 - lip_t, plate_t])
            cube([lip_x, lip_y + 2 * lip_t, lip_h - overlap]);
    }
}