// Two-part enclosure for small electronics board (e.g., Arduino-based temp logger)
// Print orientation: both parts flat on the bed, lid on the +X side of the box,
// so they print together with a uniform gap between them.

$fn = 64;

// ---------------- Parameters ----------------

// Box (Part 1)
box_outer_x = 70;    // outer size in X (mm)
box_outer_y = 50;    // outer size in Y (mm)
box_outer_z = 30;    // outer size in Z (mm)
box_wall     = 2;    // wall thickness (mm)
box_floor    = 2;    // floor thickness (mm)

// Lid (Part 2)
lip_outer_x   = 65.6; // lip outer size in X (mm)
lip_outer_y   = 45.6; // lip outer size in Y (mm)
lip_height    = 4;    // lip height above plate (mm)
plate_t       = 2;    // plate thickness (mm)
lip_wall      = 1.5;  // lip wall thickness (mm)
overlap       = 0.01; // small overlap so lid drops into the open top (mm)

// Placement
gap           = 10;   // gap between box and lid on the bed (mm)

// ---------------- Derived ----------------

lip_drop     = box_outer_x - lip_outer_x;   // 4 mm clearance on each side
lip_depth_y  = box_outer_y - lip_outer_y;   // 4 mm clearance on each side
lip_reach    = box_outer_z - plate_t + overlap; // lip top is above the top face

// ---------------- Modules ----------------

module box() {
    difference() {
        cube([box_outer_x, box_outer_y, box_outer_z]);
        // open-top cavity: extends past the top face because the top is open
        translate([box_wall, box_wall, box_floor])
            cube([box_outer_x - 2 * box_wall,
                  box_outer_y - 2 * box_wall,
                  box_outer_z - box_floor + overlap]);
    }
}

module lid() {
    // Plate lying on the bed
    plate = translate([0, 0, 0])
        cube([lip_outer_x, lip_outer_y, plate_t]);

    // Rectangular lip on top of the plate, sliding into the box opening
    lip   = translate([0, 0, plate_t - overlap])
        cube([lip_outer_x, lip_outer_y, lip_height]);

    // Wall that the lip rests on: extends down into the box cavity
    // with 0.2 mm clearance on each side (1.6 x 45.6 = 73.6 > 70)
    wall  = translate([-lip_drop - 0.4, -lip_depth_y - 0.4, plate_t - overlap])
        cube([lip_drop + 0.4 + 1.6,
              lip_depth_y + 0.4 + 1.6,
              overlap + 0.01]);

    union([plate, lip, wall]);
}

// ---------------- Assembly ----------------

union() {
    translate([-gap / 2, 0, 0])
        box();

    translate([gap / 2, 0, 0])
        lid();
}