// 12-cuvette rack, printed standing on its base (z = 0 to 25)
// All dimensions in mm, measured with calipers.

// --- Plate dimensions (base & deck) ---
plate_x = 112;   // X extent of base and deck plates
plate_y = 44;    // Y extent of base and deck plates
base_t  = 3;     // base plate thickness (z 0..3)
deck_t  = 3;     // deck plate thickness (z 22..25)
deck_z  = 22;    // bottom of deck plate
total_h = 25;    // overall height of the rack

// --- Wall / rib dimensions ---
end_wall_t  = 3;    // thickness of the two end walls (along X)
rib_t       = 2.5;  // thickness of the five internal ribs (along X)
rib_x       = [-36, -18, 0, 18, 36]; // X centres of the five ribs

// --- Cuvette through-holes in the deck ---
hole_size = 13;    // 13 x 13 mm square through-holes
hole_pitch = 18;   // 18 mm centre-to-centre in both X and Y
hole_rows  = 2;    // rows along Y
hole_cols  = 6;    // columns along X

$fn = 64;

// ---------------------------------------------------------------------------
// Base plate (z 0..3), centred on origin in X and Y
// ---------------------------------------------------------------------------
module base_plate() {
    translate([0, 0, 0])
        cube([plate_x, plate_y, base_t], center = [true, true, false]);
}

// ---------------------------------------------------------------------------
// Deck plate (z 22..25), centred on origin in X and Y
// ---------------------------------------------------------------------------
module deck_plate() {
    translate([0, 0, deck_z])
        cube([plate_x, plate_y, deck_t], center = [true, true, false]);
}

// ---------------------------------------------------------------------------
// Seven upright walls, full height (z 0..25), full Y depth, centred in X and Y
// ---------------------------------------------------------------------------
module walls() { union() {
    // Two 3 mm end walls flush with the short ends
    for (sx = [-1, 1]) {
        x_c = sx * (plate_x / 2 - end_wall_t / 2);
        translate([x_c, 0, total_h / 2])
            cube([end_wall_t, plate_y, total_h], center = true);
    }
    // Five 2.5 mm internal ribs at the given X centres
    for (x_c = rib_x) {
        translate([x_c, 0, total_h / 2])
            cube([rib_t, plate_y, total_h], center = true);
    }
} }

// ---------------------------------------------------------------------------
// 12 square through-holes in the deck (2 rows x 6 cols, 18 mm pitch)
// Each cutter extends 1 mm past the top and bottom faces of the deck.
// ---------------------------------------------------------------------------
module hole_cutters() { union() {
    for (i = [0 : hole_rows - 1]) {
        y_c = (i - (hole_rows - 1) / 2) * hole_pitch;
        for (j = [0 : hole_cols - 1]) {
            x_c = (j - (hole_cols - 1) / 2) * hole_pitch;
            translate([x_c, y_c, deck_z - 1])
                cube([hole_size, hole_size, deck_t + 2], center = [true, true, false]);
        }
    }
} }

// ---------------------------------------------------------------------------
// Assemble the rack
// ---------------------------------------------------------------------------
difference() {
    union() {
        base_plate();
        deck_plate();
        walls();
    }
    hole_cutters();
}