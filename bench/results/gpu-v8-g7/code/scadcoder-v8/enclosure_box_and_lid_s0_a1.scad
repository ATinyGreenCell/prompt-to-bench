// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: both parts rest on the bed (z = 0), build upward, side by side.
// The lid is printed upside down: a flat plate on the bed with a lip that drops into the box.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
box_wall   = 2;     // box wall thickness (sides and floor)
box_floor  = 2;     // box floor thickness (separate from side walls per the given dimensions)

lip_t      = 1.5;   // lip wall thickness
lip_h      = 4;     // lip height (wall standing on the plate)
lip_x      = 65.6;  // lip outer length (X)
lip_y      = 45.6;  // lip outer width (Y)
lip_clear  = 0.2;   // clearance between lip inner size and box opening on each side

gap        = 10;    // gap between the two parts on the bed
overlap    = 0.01;  // small overlap so the lid sinks into the box opening in the union

$fn = 64;

// Derived: box opening size (inner X and Y)
opening_x = box_x - 2 * box_wall;
opening_y = box_y - 2 * box_wall;

// Check: lip inner size minus opening size, divided by two, gives the clearance
assert(abs((lip_x - opening_x) / 2 - lip_clear) < 0.001, "X clearance not met");
assert(abs((lip_y - opening_y) / 2 - lip_clear) < 0.001, "Y clearance not met");

// ---------------- Part 1: Box ----------------
module box() {
    difference() {
        cube([box_x, box_y, box_z + box_floor]);  // solid block (floor + side walls)
        translate([box_wall, box_wall, box_floor])
            cube([opening_x, opening_y, box_z + 1]);  // open top, cutter extends past the top face
    }
}

// ---------------- Part 2: Lid ----------------
module lid() {
    union() {
        // Base plate, lying flat on the bed
        translate([-box_x / 2, -box_y / 2, 0])
            cube([box_x, box_y, 2]);

        // Lip: wall on top of the plate, extending past the box opening
        translate([-lip_x / 2, -lip_y / 2, 2])
            cube([lip_x, lip_y, lip_t]);

        // Rigidiser: block under the lip so the cutter has material to pass through
        translate([-lip_x / 2, -lip_y / 2, 2 - overlap])
            cube([lip_x, lip_y, overlap]);
    }
}

// ---------------- Assembly ----------------
union() {
    box();                                    // box on the bed
    translate([box_x / 2 + gap, 0, 0])        // lid on the +X side, with a 10 mm gap
        lid();
}