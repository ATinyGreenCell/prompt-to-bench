$fn = 128;

// --- Base Plate Dimensions ---
// X range: -25 to 25 (Width 50)
// Y range: 0 to 45 (Length 45)
// Z thickness: 5
BASE_X_MIN = -25;
BASE_X_MAX = 25;
BASE_Y_MIN = 0;
BASE_Y_MAX = 45;
BASE_Z_THICK = 5;

// --- Base Plate Mounting Holes (M4) ---
// Position: x = -17, y = 30 and x = 17, y = 30
// Diameter: 4.5 mm
BASE_HOLE_X1 = -17;
BASE_HOLE_Y1 = 30;
BASE_HOLE_X2 = 17;
BASE_HOLE_Y2 = 30;
BASE_HOLE_DIA = 4.5;

// --- Vertical Motor Plate Dimensions ---
// X range: -25 to 25 (Width 50)
// Y range: 0 to 5 (Thickness 5)
// Z height: 50
// Stands on the back edge of the base (y=0 to y=5)
MOTOR_X_MIN = -25;
MOTOR_X_MAX = 25;
MOTOR_Y_MIN = 0;
MOTOR_Y_MAX = 5;
MOTOR_Z_HEIGHT = 50;

// --- Motor Plate Boss Hole ---
// Diameter: 23 mm
// Centre: x = 0, z = 28
// Cut along Y axis
BOSS_HOLE_DIA = 23;
BOSS_HOLE_X = 0;
BOSS_HOLE_Z = 28;

// --- Motor Plate Screw Holes (M3) ---
// Diameter: 3.4 mm
// Pattern: 31 mm square centred on boss hole
// Boss hole is at x=0, z=28. Square is centred there.
// So square spans x: -15.5 to 15.5, z: 12.5 to 33.5
SCREW_HOLE_DIA = 3.4;
SCREW_PATTERN_SIZE = 31;
SCREW_PATTERN_HALF = SCREW_PATTERN_SIZE / 2;

// --- Gusset Dimensions ---
// Thickness: 5 mm (matches base and motor plate)
// Location: Left (x: -25 to -20) and Right (x: 20 to 25)
// Shape: Right triangle in YZ plane
// Legs: 20 mm along +Y and 20 mm along +Z
// Right-angle corner at y = 5, z = 5
// The triangle occupies Y from 5 to 25 and Z from 5 to 25.
GUSSET_X_WIDTH = 5;
GUSSET_Y_LEG = 20;
GUSSET_Z_LEG = 20;
GUSSET_Y_START = 5;
GUSSET_Z_START = 5;
GUSSET_THICK = 5;

// --- Main Body Construction ---
difference() {
    union() {
        // 1. Base Plate
        cube([
            BASE_X_MAX - BASE_X_MIN,
            BASE_Y_MAX - BASE_Y_MIN,
            BASE_Z_THICK
        ], center = false);

        // 2. Vertical Motor Plate
        translate([0, 0, 0]) {
            cube([
                MOTOR_X_MAX - MOTOR_X_MIN,
                MOTOR_Y_MAX - MOTOR_Y_MIN,
                MOTOR_Z_HEIGHT
            ], center = false);
        }

        // 3. Left Gusset
        // Right angle at y=5, z=5. Extends +Y and +Z.
        // X range: -25 to -20
        translate([-25, 5, 5]) {
            // Create a triangular prism using polygon extrusion
            // The polygon is in the XZ plane relative to the translation? 
            // No, we need to define the shape in the local coordinate system.
            // We want a triangle in the YZ plane (relative to the part) extruded along X.
            // Actually, simpler: define vertices in X, Y, Z.
            // Vertices: (-25, 5, 5), (-20, 5, 5), (-20, 25, 5), (-20, 5, 25), (-25, 5, 25), (-25, 5, 5)
            // Wait, the gusset is a right triangle in the YZ plane.
            // Leg 1 (Y): 5 to 25. Leg 2 (Z): 5 to 25.
            // Hypotenuse connects (y=25, z=5) and (y=5, z=25).
            // Extruded along X from -25 to -20.
            // Let's use linear_extrude on a polygon in the YZ plane, then rotate/translate.
            // Or just use polygon with 3D points.
            // Points: 
            // (-25, 5, 5) -> (-20, 5, 5) -> (-20, 25, 5) -> (-20, 5, 25) -> (-25, 5, 25) -> (-25, 5, 5)
            // This forms a triangular prism.
            polygon(
                points = [
                    [-25, 5, 5],
                    [-20, 5, 5],
                    [-20, 25, 5],
                    [-20, 5, 25],
                    [-25, 5, 25],
                    [-25, 5, 5]
                ]
            );
        }

        // 4. Right Gusset
        // X range: 20 to 25
        translate([20, 5, 5]) {
            polygon(
                points = [
                    [25, 5, 5],
                    [20, 5, 5],
                    [20, 25, 5],
                    [20, 5, 25],
                    [25, 5, 25],
                    [25, 5, 5]
                ]
            );
        }
    }

    // --- Cuts ---

    // 1. Base Plate Mounting Holes (M4)
    // Cut through Z (0 to 5)
    for (i = [0, 1]) {
        translate([
            (i == 0) ? BASE_HOLE_X1 : BASE_HOLE_X2,
            BASE_HOLE_Y1,
            0
        ]) {
            cylinder(
                h = BASE_Z_THICK + 0.1,
                d = BASE_HOLE_DIA,
                center = true
            );
        }
    }

    // 2. Motor Plate Boss Hole
    // Cut along Y axis (through the 5mm thick plate)
    // Center at x=0, z=28.
    translate([BOSS_HOLE_X, 0, BOSS_HOLE_Z]) {
        cylinder(
            h = MOTOR_Y_MAX - MOTOR_Y_MIN + 0.1,
            d = BOSS_HOLE_DIA,
            center = true
        );
    }

    // 3. Motor Plate Screw Holes (M3)
    // 4 holes on a 31mm square pattern centered on the boss hole.
    // Boss hole center: x=0, z=28.
    // Square center: x=0, z=28.
    // Square size: 31mm. Half-size: 15.5mm.
    // Corners: x = +/- 15.5, z = 28 +/- 15.5
    for (i = [0, 1, 2, 3]) {
        translate([
            (i == 0) ? -SCREW_PATTERN_HALF : (i == 1) ? SCREW_PATTERN_HALF : (i == 2) ? -SCREW_PATTERN_HALF : SCREW_PATTERN_HALF,
            0,
            (i == 0) ? 28 - SCREW_PATTERN_HALF : (i == 1) ? 28 - SCREW_PATTERN_HALF : (i == 2) ? 28 + SCREW_PATTERN_HALF : 28 + SCREW_PATTERN_HALF
        ]) {
            cylinder(
                h = MOTOR_Y_MAX - MOTOR_Y_MIN + 0.1,
                d = SCREW_HOLE_DIA,
                center = true
            );
        }
    }
}