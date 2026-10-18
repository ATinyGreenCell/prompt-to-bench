$fn = 128;

// --- Base Plate Dimensions ---
// X range: -25 to 25 (Width = 50)
// Y range: 0 to 45 (Length = 45)
// Z range: 0 to 5 (Thickness = 5)
BASE_X_MIN = -25;
BASE_X_MAX = 25;
BASE_Y_MIN = 0;
BASE_Y_MAX = 45;
BASE_Z_MAX = 5;

// --- Base Plate Holes (M4) ---
// Position: x = -17, y = 30 and x = 17, y = 30
// Diameter: 4.5 mm
BASE_HOLE_X1 = -17;
BASE_HOLE_Y1 = 30;
BASE_HOLE_X2 = 17;
BASE_HOLE_Y2 = 30;
BASE_HOLE_DIA = 4.5;

// --- Vertical Motor Plate Dimensions ---
// X range: -25 to 25 (Width = 50)
// Y range: 0 to 5 (Thickness = 5)
// Z range: 0 to 50 (Height = 50)
// Stands on the back edge of the base (y=0 to y=5)
MOTOR_X_MIN = -25;
MOTOR_X_MAX = 25;
MOTOR_Y_MAX = 5;
MOTOR_Z_MAX = 50;

// --- Motor Plate Boss Hole ---
// Diameter: 23 mm
// Centre: x = 0, z = 28 (along Y axis)
// The hole runs along Y, so it is centered at Y = MOTOR_Y_MAX / 2
MOTOR_BOSS_DIA = 23;
MOTOR_BOSS_X = 0;
MOTOR_BOSS_Z = 28;

// --- Motor Plate Screw Holes (M3) ---
// Diameter: 3.4 mm
// Pattern: 31 mm square, centred on boss hole
// Boss hole is centered at Y = 2.5
MOTOR_SCREW_DIA = 3.4;
MOTOR_SCREW_PATTERN_SIZE = 31;
MOTOR_SCREW_Y_CENTER = MOTOR_Y_MAX / 2;

// --- Gusset Dimensions ---
// Thickness: 5 mm (matches base and motor plate)
// Location: Left (x = -25 to -20) and Right (x = 20 to 25)
// Shape: Right triangle in YZ plane
// Legs: 20 mm along +Y, 20 mm along +Z
// Right-angle corner: y = 5, z = 5
GUSSET_THICKNESS = 5;
GUSSET_LEG_Y = 20;
GUSSET_LEG_Z = 20;
GUSSET_CORNER_Y = 5;
GUSSET_CORNER_Z = 5;

// --- Main Module ---
module L_Bracket() {
    union() {
        // 1. Base Plate
        translate([0, 0, 0]) {
            cube([
                BASE_X_MAX - BASE_X_MIN,
                BASE_Y_MAX - BASE_Y_MIN,
                BASE_Z_MAX
            ]);
            
            // Cut Base Holes
            translate([BASE_HOLE_X1, BASE_HOLE_Y1, 0]) {
                cylinder(h = BASE_Z_MAX + 0.1, r = BASE_HOLE_DIA / 2);
            }
            translate([BASE_HOLE_X2, BASE_HOLE_Y2, 0]) {
                cylinder(h = BASE_Z_MAX + 0.1, r = BASE_HOLE_DIA / 2);
            }
        }

        // 2. Vertical Motor Plate
        translate([0, 0, 0]) {
            cube([
                MOTOR_X_MAX - MOTOR_X_MIN,
                MOTOR_Y_MAX,
                MOTOR_Z_MAX
            ]);

            // Cut Boss Hole
            // Center at X=0, Y=2.5, Z=28
            translate([MOTOR_BOSS_X, MOTOR_SCREW_Y_CENTER, MOTOR_BOSS_Z]) {
                cylinder(h = MOTOR_Y_MAX + 0.1, r = MOTOR_BOSS_DIA / 2);
            }

            // Cut Screw Holes (4 holes on 31mm square pattern)
            // Pattern centered at x=0, y=2.5, z=28
            for (i = [-1, 1]) {
                for (j = [-1, 1]) {
                    translate([
                        MOTOR_BOSS_X + (MOTOR_SCREW_PATTERN_SIZE / 2) * i,
                        MOTOR_SCREW_Y_CENTER,
                        MOTOR_BOSS_Z + (MOTOR_SCREW_PATTERN_SIZE / 2) * j
                    ]) {
                        cylinder(h = MOTOR_Y_MAX + 0.1, r = MOTOR_SCREW_DIA / 2);
                    }
                }
            }
        }

        // 3. Left Gusset
        // Right-angle corner at y=5, z=5. Extends +Y and +Z.
        // Thickness is in X direction from -25 to -20.
        // We create a 2D triangle and extrude it.
        translate([-25, 0, 0]) {
            // Define triangle vertices relative to the corner (0,0) in local YZ coords
            // Corner is at global Y=5, Z=5.
            // Leg Y: 20mm -> (20, 0) local
            // Leg Z: 20mm -> (0, 20) local
            // Extrude width: 5mm (GUSSET_THICKNESS)
            linear_extrude(height = GUSSET_THICKNESS, center = true) {
                polygon(
                    points = [
                        [0, 0],      // Corner (Y=5, Z=5)
                        [GUSSET_LEG_Y, 0], // (Y=25, Z=5)
                        [0, GUSSET_LEG_Z]  // (Y=5, Z=25)
                    ]
                );
            }
        }

        // 4. Right Gusset
        // Right-angle corner at y=5, z=5. Extends +Y and +Z.
        // Thickness is in X direction from 20 to 25.
        translate([20, 0, 0]) {
            linear_extrude(height = GUSSET_THICKNESS, center =