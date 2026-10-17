$fn = 128

// --- Base Plate Dimensions ---
// X range: -25 to 25 (Width = 50)
// Y range: 0 to 45 (Depth = 45)
// Z height: 0 to 5 (Thickness = 5)
BASE_X_MIN = -25;
BASE_X_MAX = 25;
BASE_Y_MIN = 0;
BASE_Y_MAX = 45;
BASE_Z_THICK = 5;

// --- Base Plate Holes (M4) ---
// Position: x = -17, y = 30 and x = 17, y = 30
// Diameter: 4.5 mm
BASE_HOLE_X_1 = -17;
BASE_HOLE_Y_1 = 30;
BASE_HOLE_X_2 = 17;
BASE_HOLE_Y_2 = 30;
BASE_HOLE_DIA = 4.5;

// --- Vertical Motor Plate Dimensions ---
// X range: -25 to 25 (Width = 50)
// Y range: 0 to 5 (Depth = 5)
// Z range: 0 to 50 (Height = 50)
// Stands on the back edge of the base (y=0 to y=5)
MOTOR_X_MIN = -25;
MOTOR_X_MAX = 25;
MOTOR_Y_THICK = 5;
MOTOR_Z_HEIGHT = 50;

// --- Motor Plate Boss Hole ---
// Diameter: 23 mm
// Centre: x = 0, z = 28
// Cut along Y axis (through the plate)
BOSS_HOLE_DIA = 23;
BOSS_HOLE_X = 0;
BOSS_HOLE_Z = 28;

// --- Motor Plate Screw Holes (M3) ---
// Diameter: 3.4 mm
// Pattern: 31 mm square, centred on boss hole
// 4 holes total
SCREW_HOLE_DIA = 3.4;
SCREW_PATTERN_SIZE = 31;
SCREW_HOLE_OFFSET = SCREW_PATTERN_SIZE / 2;

// --- Gusset Dimensions ---
// Thickness: 5 mm (same as base)
// Location: Left (x = -25 to -20) and Right (x = 20 to 25)
// Shape: Right triangle in YZ plane
// Legs: 20 mm along +Y and 20 mm along +Z
// Right-angle corner at y = 5, z = 5
GUSSET_THICK = 5;
GUSSET_Y_LEG = 20;
GUSSET_Z_LEG = 20;
GUSSET_CORNER_Y = 5;
GUSSET_CORNER_Z = 5;
GUSSET_LEFT_X_MIN = -25;
GUSSET_LEFT_X_MAX = -20;
GUSSET_RIGHT_X_MIN = 20;
GUSSET_RIGHT_X_MAX = 25;

// --- Main Body Construction ---
difference() {
    union() {
        // 1. Base Plate
        translate([0, 0, 0]) {
            cube([
                BASE_X_MAX - BASE_X_MIN,
                BASE_Y_MAX - BASE_Y_MIN,
                BASE_Z_THICK
            ]);
        }

        // 2. Vertical Motor Plate
        translate([0, 0, 0]) {
            cube([
                MOTOR_X_MAX - MOTOR_X_MIN,
                MOTOR_Y_THICK,
                MOTOR_Z_HEIGHT
            ]);
        }

        // 3. Left Gusset
        // Right triangle in YZ plane, extruded along X
        // Vertices relative to corner (y=5, z=5): (0,0), (20,0), (0,20)
        // We need to position it so the right angle is at y=5, z=5
        // The triangle extends from y=5 to y=25 and z=5 to z=25
        translate([
            (GUSSET_LEFT_X_MIN + GUSSET_LEFT_X_MAX) / 2, // Center X
            GUSSET_CORNER_Y, // Start Y
            GUSSET_CORNER_Z  // Start Z
        ]) {
            // Define the triangle path
            path = [
                [0, 0], // Corner (y=5, z=5)
                [GUSSET_Y_LEG, 0], // Top Y (y=25, z=5)
                [0, GUSSET_Z_LEG]  // Top Z (y=5, z=25)
            ];
            
            // Extrude the triangle along X with thickness
            // We use linear_extrude with path to create the specific shape
            // Actually, simpler to use polygon or just define the bounding box and cut?
            // Let's use a polygon extrusion for the triangular profile.
            // The profile is in the YZ plane.
            
            // Create the triangle profile
            triangle_profile = polygon([
                [0, 0],
                [GUSSET_Y_LEG, 0],
                [0, GUSSET_Z_LEG]
            ]);
            
            // Extrude along X direction
            // We need to translate the profile to the correct X position first
            // The gusset spans from GUSSET_LEFT_X_MIN to GUSSET_LEFT_X_MAX
            // Center X for extrusion
            x_center = (GUSSET_LEFT_X_MIN + GUSSET_LEFT_X_MAX) / 2;
            x_half_width = (GUSSET_LEFT_X_MAX - GUSSET_LEFT_X_MIN) / 2;
            
            translate([x_center, 0, 0]) {
                // Rotate to align profile with YZ plane if necessary (it is already)
                // Extrude along X axis
                linear_extrude(height = GUSSET_LEFT_X_MAX - GUSSET_LEFT_X_MIN, center = true) {
                    polygon([
                        [0, 0],
                        [GUSSET_Y_LEG, 0],
                        [0, GUSSET_Z_LEG]
                    ]);
                }
            }
        }

        // 4. Right Gusset
        translate([
            (GUSSET_RIGHT_X_MIN + GUSSET_RIGHT_X_MAX) / 2, // Center X
            GUSSET_CORNER_Y, // Start Y
            GUSSET_CORNER_Z  // Start Z
        ]) {
            x_center = (GUSSET_RIGHT_X_MIN + GUSSET_RIGHT_X_MAX) / 2;
            x_half_width = (GUSSET_RIGHT_X_MAX - GUSSET_RIGHT_X_MIN) / 2;
            
            translate([x_center, 0, 0]) {
                linear_extrude(height = GUSSET_RIGHT_X_MAX - GUSSET_RIGHT_X_MIN, center = true) {
                    polygon([
                        [0, 0],
                        [GUSSET_Y_LEG, 0],
                        [0, GUSSET_Z_LEG]
                    ]);
                }
            }
        }
    }

    // --- Cutouts ---

    // 1. Base Plate Holes (M4)
    // Extend slightly past the base thickness (5mm) to ensure clean cut
    for (i = [0, 1]) {
        translate([
            i == 0 ? BASE_HOLE_X_1 : BASE_HOLE_X_2,
            BASE_HOLE_Y_1, // Both at same Y
            -0.05 // Extend slightly below z=0
        ]) {
            cylinder(
                h = BASE_Z_THICK + 1,
                d = BASE_HOLE_DIA,
                $fn = 64
            );
        }
    }

    // 2. Boss Hole (23mm)
    // Cut along Y axis. Extend past Y=0 and Y=5.
    translate([BOSS_HOLE_X, -0.05, BOSS_HOLE_Z]) {
        cylinder(
            h = MOTOR_Y_THICK + 1,
            d = BOSS_HOLE_DIA,
            $fn = 64
        );
    }

    // 3. Screw Holes (M3)
    // 4 holes on a 31mm square pattern centered on the boss hole
    for (dx = [-SCREW_HOLE_OFFSET, SCREW_HOLE_OFFSET]) {
        for (dz = [-SCREW_HOLE_OFFSET, SCREW_HOLE_OFFSET]) {
            translate([
                BOSS_HOLE_X + dx,
                0, // Centered in Y relative to plate? No, pattern is usually centered on the hole.
                BOSS_HOLE_Z + dz
            ]) {
                cylinder(
                    h = MOTOR_Y_THICK + 1,
                    d = SCREW_HOLE_DIA,
                    $fn = 64
                );
            }
        }
    }
}