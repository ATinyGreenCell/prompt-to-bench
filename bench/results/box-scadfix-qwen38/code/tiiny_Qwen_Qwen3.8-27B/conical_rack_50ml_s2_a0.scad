// 50 mL conical tube rack – printed upside-down, then flipped over.
// Print orientation: flat plate on the bed (z = 0..4), walls rising in +Z.
// After flipping, the rack stands on the two walls and tubes pass through the holes.

// ---- Dimensions (mm) ----
plate_X   = 130;   // plate length along X
plate_Y   = 90;    // plate width along Y
plate_T   = 4;     // plate thickness (z = 0 to 4)

wall_T    = 4;     // wall thickness (Y)
wall_H    = 70;    // wall height above the bed (z = 0 to 70)

hole_D    = 30.5;  // through-hole diameter
hole_R    = hole_D / 2;

pitch_X   = 40;    // hole centre spacing along X
pitch_Y   = 40;    // hole centre spacing along Y

$fn = 64;          // roundness for holes

// Hole centre coordinates: 2 rows (Y) x 3 columns (X), centred on the plate.
hole_X = [-pitch_X, 0, pitch_X];
hole_Y = [-pitch_Y / 2, pitch_Y / 2];

// ---- Base plate (z = 0 to plate_T) ----
module plate() { translate([0, 0, 0])
    cube([plate_X, plate_Y, plate_T], center = true); }

// ---- Two long-edge walls (z = 0 to wall_H), flush with the plate's long edges ----
// Wall 1: along +Y edge (y = +plate_Y/2)
module wall_1() { translate([0,  plate_Y / 2 - wall_T / 2, 0])
    cube([plate_X, wall_T, wall_H], center = true); }

// Wall 2: along -Y edge (y = -plate_Y/2)
module wall_2() { translate([0, -plate_Y / 2 + wall_T / 2, 0])
    cube([plate_X, wall_T, wall_H], center = true); }

// ---- Six through-holes (extend 1 mm past each face to avoid coplanar cuts) ----
module holes() { for (hx = hole_X, hy = hole_Y)
    translate([hx, hy, -1])
        cylinder(h = plate_T + 2, r = hole_R, $fn = $fn); }

// ---- Final solid ----
difference() {
    union() {
        plate();
        wall_1();
        wall_2();
    }
    holes();
}