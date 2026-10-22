// 12-cuvette rack, printed standing on its base (z = 0 to 25)
// All dimensions in mm, taken from the user's caliper measurements.

$fn = 64;

// Base & deck plates
base_x = 112;   // X length of base plate
base_y = 44;    // Y depth of base plate
base_t = 3;     // base plate thickness (z 0..3)
deck_t = 3;     // deck plate thickness (z 22..25)
deck_z = 22;    // bottom of deck plate

// Upright walls (z 0..25, full Y depth)
wall_h = 25;    // total wall height
end_w  = 3;     // end-wall thickness (X)
rib_w  = 2.5;   // rib thickness (X)
rib_x  = [-36, -18, 0, 18, 36]; // rib centre X positions

// Deck through-holes
hole_s = 13;    // square hole side (13 x 13)
pitch  = 18;    // centre-to-centre spacing in both X and Y
rows_y = 2;     // rows along Y
cols_x = 6;     // columns along X

// ---- Base plate (z 0..3) ----
module base() {
    translate([-base_x / 2, -base_y / 2, 0])
        cube([base_x, base_y, base_t]);
}

// ---- Deck plate (z 22..25) with 12 square through-holes ----
module deck() {
    difference() {
        translate([-base_x / 2, -base_y / 2, deck_z])
            cube([base_x, base_y, deck_t]);
        for (i = [0 : cols_x - 1]) {
            for (j = [0 : rows_y - 1]) {
                hx = (i - (cols_x - 1) / 2) * pitch;
                hy = (j - (rows_y - 1) / 2) * pitch;
                translate([hx - hole_s / 2, hy - hole_s / 2, deck_z - 1])
                    cube([hole_s, hole_s, deck_t + 2]);
            }
        }
    }
}

// ---- Upright walls (z 0..25, full Y depth) ----
module walls() {
    union() {
        // Two 3 mm end walls flush with the short ends (x = ±56)
        for (ex = [-base_x / 2, base_x / 2]) {
            translate([ex - end_w / 2, -base_y / 2, 0])
                cube([end_w, base_y, wall_h]);
        }
        // Five 2.5 mm ribs at the given X centres
        for (rx = rib_x) {
            translate([rx - rib_w / 2, -base_y / 2, 0])
                cube([rib_w, base_y, wall_h]);
        }
    }
}

// ---- Assemble the rack ----
union() {
    base();
    deck();
    walls();
}