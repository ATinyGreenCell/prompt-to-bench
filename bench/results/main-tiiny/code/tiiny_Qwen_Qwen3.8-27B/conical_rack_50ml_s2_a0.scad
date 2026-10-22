// 50 mL conical tube rack – printed upside-down, flipped after printing.
// Print orientation: flat plate on the bed (z = 0..4), walls rising in +Z.
// After flipping: rack stands on the two walls; tubes pass through the holes.

// ---- Dimensions (mm, measured with calipers) ----
plate_X   = 130;   // plate length along X
plate_Y   = 90;    // plate width  along Y
plate_T   = 4;     // plate thickness (z = 0 to 4)

hole_D    = 30.5;  // through-hole diameter
hole_R    = hole_D / 2;

rows      = 2;     // rows along Y
cols      = 3;     // columns along X
pitch_X   = 40;    // centre-to-centre spacing along X
pitch_Y   = 40;    // centre-to-centre spacing along Y

wall_T    = 4;     // wall thickness (Y)
wall_H    = 70;    // wall height (z = 0 to 70)

$fn = 64;          // round holes

// ---- Base plate, centred on origin in X and Y ----
plate = translate([-plate_X/2, -plate_Y/2, 0])
        cube([plate_X, plate_Y, plate_T]);

// ---- Six through-holes (2 rows x 3 cols), centred on the plate ----
holes = for (i = [0:rows-1], j = [0:cols-1])
        translate([
            (j - (cols-1)/2) * pitch_X,   // X centre
            (i - (rows-1)/2) * pitch_Y,   // Y centre
            -1                          // extend 1 mm below z=0
        ])
        cylinder(h = plate_T + 2, r = hole_R, $fn = $fn);

// ---- Two solid walls along the long (X) edges, flush with the plate ----
// Each wall is 130 mm long (X), 4 mm thick (Y), rising from z = 0 to z = 70.
walls = union()
    // +Y edge wall: Y from  plate_Y/2 - wall_T  to  plate_Y/2
    translate([-plate_X/2,  plate_Y/2 - wall_T, 0])
        cube([plate_X, wall_T, wall_H]),
    // -Y edge wall: Y from -plate_Y/2  to  -plate_Y/2 + wall_T
    translate([-plate_X/2, -plate_Y/2, 0])
        cube([plate_X, wall_T, wall_H]);

// ---- Final solid: plate + walls, with the six holes cut through ----
difference() {
    union() {
        plate;
        walls;
    }
    holes;
}