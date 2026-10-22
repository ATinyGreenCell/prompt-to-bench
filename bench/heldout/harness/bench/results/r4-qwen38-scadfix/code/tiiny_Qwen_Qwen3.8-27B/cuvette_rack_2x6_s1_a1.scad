// 12-cuvette rack, printed standing on its base (z = 0 to 25)
// All dimensions in mm, measured with calipers.

// Base / deck plates
base_x = 112;   // base plate length along X
base_y = 44;    // base plate depth along Y
base_t = 3;     // base plate thickness (z 0..3)
deck_t = 3;     // deck plate thickness (z 22..25)
deck_z = 22;    // bottom of deck plate

// Upright walls (full height, as deep as the plates)
wall_h = 25;    // total height of walls (z 0..25)
end_w = 3;      // thickness of the two end walls (along X)
rib_w = 2.5;    // thickness of the five internal ribs (along X)
rib_x = [-36, -18, 0, 18, 36];  // centre X positions of the five ribs

// Deck through-holes for 12.5 mm square cuvettes
hole_s = 13;    // square hole side length
pitch = 18;     // centre-to-centre spacing in both X and Y
n_rows = 2;     // rows along Y
n_cols = 6;     // columns along X

$fn = 64;

// ---- Base plate (z 0..3), centred on origin ----
module base() {
    translate([0, 0, 0])
        cube([base_x, base_y, base_t], center = true);
}

// ---- Deck plate (z 22..25), centred on origin ----
module deck() {
    translate([0, 0, deck_z + deck_t / 2])
        cube([base_x, base_y, deck_t], center = true);
}

// ---- 12 square through-holes in the deck ----
// 2 rows (Y) x 6 columns (X), 18 mm pitch, centred on the deck.
module hole_cutters() {
    for (i = [0 : n_cols - 1], j = [0 : n_rows - 1])
        translate([
            (i - (n_cols - 1) / 2) * pitch,   // X
            (j - (n_rows - 1) / 2) * pitch,   // Y
            deck_z - 1                        // extend 1 mm below deck bottom
        ])
        cube([hole_s, hole_s, deck_t + 2], center = true);
}

// ---- Seven upright walls, z 0..25, full Y depth ----
// Two 3 mm end walls flush with the short ends (x = ±56)
module end_walls() {
    translate([-base_x / 2, 0, 0])
        cube([end_w, base_y, wall_h], center = true);
    translate([ base_x / 2, 0, 0])
        cube([end_w, base_y, wall_h], center = true);
}

// Five 2.5 mm ribs centred at x = -36, -18, 0, 18, 36
module ribs() {
    for (x = rib_x)
        translate([x, 0, 0])
            cube([rib_w, base_y, wall_h], center = true);
}

// ---- Assemble ----
union() {
    base();
    difference() {
        deck();
        hole_cutters();
    }
    end_walls();
    ribs();
}