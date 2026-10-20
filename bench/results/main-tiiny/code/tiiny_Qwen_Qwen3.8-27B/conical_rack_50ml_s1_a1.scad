// ---------------------------------------------------------------------------
// 50 mL conical (Falcon) tube rack – 6 tubes (2 rows x 3 columns)
//
// PRINT ORIENTATION (as modelled below, z = 0 is the build-plate side):
//   * A flat plate 130 (X) x 90 (Y) x 4 (Z) rests on the bed.
//   * Six 30.5 mm through-holes in a 2 x 3 grid, 40 mm pitch, centred on plate.
//   * Two solid walls along the long (X) edges, 4 mm thick (Y), rising to z = 70.
//   * After printing, flip the part over: it stands on the two walls and the
//     tubes pass through the holes.
// ---------------------------------------------------------------------------

// --- Named dimensions (mm) --------------------------------------------------
plate_L   = 130;   // plate length along X
plate_W   = 90;    // plate width  along Y
plate_T   = 4;     // plate thickness (Z)

hole_D    = 30.5;  // tube-hole diameter
hole_R    = hole_D / 2;

pitch_X   = 40;    // centre-to-centre spacing along X
pitch_Y   = 40;    // centre-to-centre spacing along Y

cols      = 3;     // number of holes along X
rows      = 2;     // number of holes along Y

wall_T    = 4;     // wall thickness (Y)
wall_H    = 70;    // wall height above z = 0 (top of wall)

// --- Derived values ---------------------------------------------------------
// Hole centre coordinates (centred on the plate origin in X and Y)
hole_cx   = [ for (i = [0 : cols - 1]) (i - (cols - 1) / 2) * pitch_X ];
hole_cy   = [ for (j = [0 : rows - 1]) (j - (rows - 1) / 2) * pitch_Y ];

// Wall Y positions: flush with the plate's long edges (Y = +/- plate_W/2)
wall_y    = [ -plate_W / 2 + wall_T / 2,
               plate_W / 2 - wall_T / 2 ];

// --- Model ------------------------------------------------------------------
$fn = 64;

module rack() {
    // 1. Base plate
    plate = translate([0, 0, 0])
            cube([plate_L, plate_W, plate_T], center = [true, true, false]);

    // 2. Two side walls (long edges, flush with plate)
    walls = for (wy = wall_y)
            translate([0, wy, 0])
            cube([plate_L, wall_T, wall_H], center = [true, true, false]);

    // 3. Six through-holes (extend 1 mm past each face to avoid coplanar cuts)
    holes = for (cx = hole_cx, cy = hole_cy)
            translate([cx, cy, -1])
            cylinder(h = plate_T + 2, r = hole_R, $fn = $fn);

    union() {
        plate;
        walls;
    }
    difference() {
        union() {
            plate;
            walls;
        }
        holes;
    }
}

rack();