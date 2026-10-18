$fn = 128;

// --- Base Plate Dimensions ---
// X range: -25 to 25 (Width = 50)
// Y range: 0 to 45 (Depth = 45)
// Z range: 0 to 5 (Thickness = 5)
BASE_X_MIN = -25;
BASE_X_MAX = 25;
BASE_Y_MIN = 0;
BASE_Y_MAX = 45;
BASE_Z_MAX = 5;

// --- Base Plate Holes (M4) ---
// Position: x = -17, y = 30 and x = 17, y = 30
// Diameter: 4.5 mm
BASE_HOLE_X_1 = -17;
BASE_HOLE_Y_1 = 30;
BASE_HOLE_X_2 = 17;
BASE_HOLE_Y_2 = 30;
BASE_HOLE_DIAMETER = 4.5;

// --- Vertical Motor Plate Dimensions ---
// X range: -25 to 25 (Width = 50)
// Y range: 0 to 5 (Depth = 5)
// Z range: 0 to 50 (Height = 50)
// Stands on the back edge of the base (y=0 to y=5)
MOTOR_X_MIN = -25;
MOTOR_X_MAX = 25;
MOTOR_Y_MAX = 5;
MOTOR_Z_MAX = 50;

// --- Motor Plate Boss Hole ---
// Diameter: 23 mm
// Centre: x = 0, z = 28
// Cut along Y axis (through the plate)
BOSS_HOLE_DIAMETER = 23;
BOSS_HOLE_X = 0;
BOSS_HOLE_Z = 28;

// --- Motor Plate Screw Holes (M3) ---
// Diameter: 3.4 mm
// Pattern: 31 mm square, centred on boss hole (x=0, z=28)
// 4 holes total
SCREW_HOLE_DIAMETER = 3.4;
SCREW_PATTERN_SIZE = 31;

// --- Gusset Dimensions ---
// Thickness: 5 mm (same as base)
// Location: Left (x=-25 to -20) and Right (x=20 to 25)
// Shape: Right triangle in YZ plane
// Legs: 20 mm along +Y, 20 mm along +Z
// Right-angle corner at y=5, z=5
GUSSET_THICKNESS = 5;
GUSSET_Y_LEG = 20;
GUSSET_Z_LEG = 20;
GUSSET_CORNER_Y = 5;
GUSSET_CORNER_Z = 5;
GUSSET_LEFT_X_MIN = -25;
GUSSET_LEFT_X_MAX = -20;
GUSSET_RIGHT_X_MIN = 20;
GUSSET_RIGHT_X_MAX = 25;

// --- Construction ---

difference() {
    union() {
        // 1. Base Plate
        translate([0, 0, 0]) {
            cube([
                BASE_X_MAX - BASE_X_MIN,
                BASE_Y_MAX - BASE_Y_MIN,
                BASE_Z_MAX
            ]);
        }

        // 2. Vertical Motor Plate
        translate([0, 0, 0]) {
            cube([
                MOTOR_X_MAX - MOTOR_X_MIN,
                MOTOR_Y_MAX,
                MOTOR_Z_MAX
            ]);
        }

        // 3. Left Gusset
        // Right triangle in YZ plane, extruded along X
        // Vertices relative to corner (5,5): (0,0), (20,0), (0,20)
        // Extruded from x = -25 to -20
        translate([GUSSET_LEFT_X_MIN, 0, 0]) {
            linear_extrude(height = GUSSET_THICKNESS) {
                polygon([
                    [0, 0],
                    [GUSSET_Y_LEG, 0],
                    [0, GUSSET_Z_LEG]
                ]);
            }
        }

        // 4. Right Gusset
        // Extruded from x = 20 to 25
        translate([GUSSET_RIGHT_X_MIN, 0, 0]) {
            linear_extrude(height = GUSSET_THICKNESS) {
                polygon([
                    [0, 0],
                    [GUSSET_Y_LEG, 0],
                    [0, GUSSET_Z_LEG]
                ]);
            }
        }
    }

    // Cut Holes (Base Plate)
    // Hole 1 at x = -17
    translate([BASE_HOLE_X_1, BASE_HOLE_Y_1, 0]) {
        cylinder(h = BASE_Z_MAX + 0.1, d = BASE_HOLE_DIAMETER);
    }
    // Hole 2 at x = 17
    translate([BASE_HOLE_X_2, BASE_HOLE_Y_2, 0]) {
        cylinder(h = BASE_Z_MAX + 0.1, d = BASE_HOLE_DIAMETER);
    }

    // Cut Boss Hole (Motor Plate)
    // Centre at x=0, z=28. Extends through the plate (y=0 to y=5).
    translate([BOSS_HOLE_X, 0, BOSS_HOLE_Z]) {
        cylinder(h = MOTOR_Y_MAX + 0.1, d = BOSS_HOLE_DIAMETER);
    }

    // Cut Screw Holes (Motor Plate)
    // 4 holes on 31mm square pattern centred at (0, 28)
    // Square side = 31, so half-side = 15.5
    // Coordinates: x = +/- 15.5, z = 28 +/- 15.5
    for (i = [-1, 1]) {
        for (j = [-1, 1]) {
            translate([
                i * (SCREW_PATTERN_SIZE / 2),
                0,
                BOSS_HOLE_Z + j * (SCREW_PATTERN_SIZE / 2)
            ]) {
                cylinder(h = MOTOR_Y_MAX + 0.1, d = SCREW_HOLE_DIAMETER);
            }
        }
    }
}