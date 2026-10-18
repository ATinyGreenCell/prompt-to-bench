// Two-part enclosure for a small electronics board (e.g. Arduino-based temperature logger)
// Print orientation: both parts rest on the bed (z = 0), build upward, side by side on the bed.
// The lid is printed upside down: a flat plate on the bed with a lip that drops into the box.

// ---------------- Parameters ----------------
box_x      = 70;    // box outer length (X)
box_y      = 50;    // box outer width (Y)
box_z      = 30;    // box outer height (Z)
box_wall   = 2;     // box wall thickness (sides and floor)
box_floor  = 2;     // box floor thickness (separate from side walls per the given dimensions)

lip_t      = 1.5;   // lip wall thickness
lip_h      = 4;     // lip height above the plate it crowns
lip_x      = 65.6;  // outer lip size in X
lip_y      = 45.6;  // outer lip size in Y
lip_clear  = 0.2;   // clearance between lip inner size and box opening (each side)

plate_t    = 2;     // lid plate thickness (lying flat on the bed)

gap        = 10;    // bed gap between the two parts

eps        = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------------- Derived ----------------
box_in_x   = box_x - 2 * box_wall;          // 66 mm
box_in_y   = box_y - 2 * box_wall;          // 46 mm
box_vol    = (box_x - box_wall) * box_y * box_z; // 10200 mm^3 (outer block minus top face)

lip_in_x   = lip_x - 2 * lip_clear;         // 65.2 mm
lip_in_y   = lip_y - 2 * lip_clear;         // 45.2 mm
lip_vol    = lip_x * lip_y * lip_t;         // 4483.2 mm^3

// ---------------- Model ----------------
union() {
    // Part 1: open-top box
    translate([-box_x / 2, -box_y / 2, 0])
        cube([box_x - box_wall, box_y, box_z]);   // outer block
    translate([-box_in_x / 2, -box_in_y / 2, box_floor])
        cube([box_in_x, box_in_y, box_z - box_floor]);  // open-top cavity
    // Remove a thin top face slab so the cavity has no coplanar face at the top
    translate([-box_in_x / 2, -box_in_y / 2, box_z - eps])
        cube([box_in_x, box_in_y, eps]);

    // Part 2: lid, printed upside down, on the +X side of the box
    translate([box_x / 2 + gap, -box_y / 2, 0])
        union() {
            // base plate lying flat on the bed
            cube([box_x, box_y, plate_t]);
            // lip: solid block up to the top of the lip, then cut the inner pocket
            translate([0, 0, plate_t])
                cube([lip_x, lip_y, plate_t + lip_h]);
            translate([-lip_in_x / 2, -lip_in_y / 2, plate_t])
                cube([lip_in_x, lip_in_y, plate_t + lip_h]);  // pocket from bed up to lip top
        }
}