// 50 mL conical tube rack – printed upside-down, then flipped over.
// Print orientation: flat plate on the bed (z = 0..4), walls rising in +Z.
// After flipping: rack stands on the two walls; tubes pass through the holes.

// ---- Plate ----
plate_x   = 130;   // plate length along X (mm)
plate_y   = 90;    // plate width  along Y (mm)
plate_t   = 4;     // plate thickness (mm)

// ---- Tube holes ----
hole_d    = 30.5;  // through-hole diameter (mm)
hole_r    = hole_d / 2;
pitch     = 40;    // centre-to-centre spacing in both X and Y (mm)

// ---- Side walls (run along the two long edges, flush with the plate) ----
wall_len  = 130;   // wall length along X (mm)
wall_t    = 4;     // wall thickness along Y (mm)
wall_h    = 70;    // wall height above the bed (mm)

$fn = 64;

// Hole centres: 2 rows (Y) x 3 columns (X), centred on the plate.
// X offsets: -40, 0, +40   (3 columns, 40 mm pitch)
// Y offsets: -20, +20       (2 rows,    40 mm pitch)
hole_x = [-pitch, 0, pitch];
hole_y = [-pitch / 2, pitch / 2];

// ---- Base plate with six through-holes (sits on the bed, z = 0..4) ----
module plate() { difference() {
    translate([-plate_x / 2, -plate_y / 2, 0]) {
        cube([plate_x, plate_y, plate_t]);
    }
    for (hx = hole_x) {
        for (hy = hole_y) {
            translate([hx, hy, -0.5]) {
                cylinder(h = plate_t + 1, r = hole_r, $fn = $fn);
            }
        }
    }
} }

// ---- Two solid walls along the long edges, flush with the plate ----
// Each wall: 130 mm (X) x 4 mm (Y) x 70 mm (Z), centred on the plate in X,
// centred on the plate's long edge in Y (so it spans Y = ±45..±49),
// rising from z = 0 to z = 70.
module walls() { union() {
    // Wall on the +Y edge
    translate([-wall_len / 2,  plate_y / 2 - wall_t / 2, 0]) {
        cube([wall_len, wall_t, wall_h]);
    }
    // Wall on the -Y edge
    translate([-wall_len / 2, -plate_y / 2 - wall_t / 2, 0]) {
        cube([wall_len, wall_t, wall_h]);
    }
} }

// ---- Assemble the rack in print orientation (single solid, centred on origin) ----
union() {
    plate();
    walls();
}