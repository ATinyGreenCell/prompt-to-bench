// 12-cuvette rack, printed standing on its base (z = 0 to 25)
// All dimensions in mm, measured with calipers.

// ---- Plate dimensions (base & deck are identical in plan) ----
plate_x   = 112;   // plate length along X
plate_y   =  44;   // plate depth  along Y
base_t    =   3;   // base plate thickness (z 0..3)
deck_z0   =  22;   // deck bottom z
deck_z1   =  25;   // deck top z
deck_t    = deck_z1 - deck_z0;   // deck thickness (3 mm)

// ---- Upright walls (full height, same plan depth as plates) ----
wall_h    = 25;    // wall height (z 0..25)
end_w     =   3;   // end-wall thickness (X)
rib_w     = 2.5;   // rib thickness (X)
rib_x     = [-36, -18, 0, 18, 36];  // rib centre X positions

// ---- Deck through-holes (13 x 13 mm square, sides parallel to edges) ----
hole_s    = 13;    // hole side length
pitch     = 18;    // centre-to-centre spacing in both X and Y
n_x       = 6;     // holes per row (along X)
n_y       = 2;     // number of rows (along Y)

// ---- Cuvette clearance (12.5 mm square cuvettes) ----
cuvette   = 12.5;  // cuvette square side (hole 13 mm gives 0.25 mm clearance)

$fn = 64;

// ------------------------------------------------------------------
// Base plate (z 0..3), centred on origin
// ------------------------------------------------------------------
base_plate =
    translate([0, 0, 0])
    cube([plate_x, plate_y, base_t], center = true);

// ------------------------------------------------------------------
// Deck plate (z 22..25) with 12 square through-holes
// ------------------------------------------------------------------
deck_plate =
    difference() {
        translate([0, 0, (deck_z0 + deck_z1) / 2])
        cube([plate_x, plate_y, deck_t], center = true);

        for (i = [0 : n_x - 1]) {
            for (j = [0 : n_y - 1]) {
                hx = (i - (n_x - 1) / 2) * pitch;
                hy = (j - (n_y - 1) / 2) * pitch;
                // Hole extends 1 mm past each deck face (z 21..26)
                translate([hx, hy, (deck_z0 + deck_z1) / 2])
                cube([hole_s, hole_s, deck_t + 2], center = true);
            }
        }
    };

// ------------------------------------------------------------------
// Upright walls: 2 end walls + 5 ribs, all z 0..25, full Y depth
// ------------------------------------------------------------------
walls =
    union() {
        // Two 3 mm end walls flush with the short (X) ends
        for (ex = [-plate_x / 2 + end_w / 2, plate_x / 2 - end_w / 2]) {
            translate([ex, 0, wall_h / 2])
            cube([end_w, plate_y, wall_h], center = true);
        }
        // Five 2.5 mm ribs at the given X centres
        for (rx = rib_x) {
            translate([rx, 0, wall_h / 2])
            cube([rib_w, plate_y, wall_h], center = true);
        }
    };

// ------------------------------------------------------------------
// Assemble the rack
// ------------------------------------------------------------------
union() {
    base_plate;
    deck_plate;
    walls;
}