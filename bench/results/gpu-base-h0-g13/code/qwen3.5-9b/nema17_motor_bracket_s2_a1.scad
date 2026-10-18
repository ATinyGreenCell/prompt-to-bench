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
// Stands on the back edge of the base (y=0)
MOTOR_X_MIN = -25;
MOTOR_X_MAX = 25;
MOTOR_Y_MIN = 0;
MOTOR_Y_MAX = 5;
MOTOR_Z_HEIGHT = 50;

// --- Motor Plate Boss Hole ---
// Diameter: 23 mm
// Centre: x = 0, z = 28 (along the plate)
// Orientation: Through the plate along Y axis
MOTOR_BOSS_DIA = 23;
MOTOR_BOSS_X = 0;
MOTOR_BOSS_Z = 28;

// --- Motor Plate Screw Holes (M3) ---
// Diameter: 3.4 mm
// Pattern: 31 mm square, centred on the boss hole
MOTOR_SCREW_DIA = 3.4;
MOTOR_SQUARE_SIZE = 31;

// --- Gusset Dimensions ---
// Thickness: 5 mm (matches base and motor plate)
// Location: Left (x=-25 to -20) and Right (x=20 to 25)
// Shape: Right triangle in YZ plane
// Legs: 20 mm along +Y and 20 mm along +Z
// Right-angle corner at y=5, z=5
GUSSET_THICK = 5;
GUSSET_Y_LEG = 20;
GUSSET_Z_LEG = 20;
GUSSET_X_LEFT_MIN = -25;
GUSSET_X_LEFT_MAX = -20;
GUSSET_X_RIGHT_MIN = 20;
GUSSET_X_RIGHT_MAX = 25;

// --- Construction ---

difference() {
    // 1. Main Body (Union of Base, Motor Plate, and Gussets)
    union() {
        // Base Plate
        translate([0, 0, 0], cube([
            BASE_X_MAX - BASE_X_MIN,
            BASE_Y_MAX - BASE_Y_MIN,
            BASE_Z_THICK
        ]));
        
        // Vertical Motor Plate
        translate([0, 0, 0], cube([
            MOTOR_X_MAX - MOTOR_X_MIN,
            MOTOR_Y_MAX - MOTOR_Y_MIN,
            MOTOR_Z_HEIGHT
        ]));
        
        // Left Gusset
        // Positioned at x = -25 to -20. 
        // Rotated 90 deg around Z to stand up in YZ plane.
        // The cube is [width, height, depth] = [5, 20, 20].
        // After rotation, it occupies x: -25 to -20, y: 0 to 20, z: 0 to 20.
        // We need the right angle at y=5, z=5.
        // The triangle vertices in local space (before rotation) should be:
        // (0,0,0) -> (5,0,0) -> (5,20,0) -> (0,20,0) ? No.
        // Let's define the triangle explicitly to ensure the corner is at (5,5).
        // Local coords: x from 0 to 5. y from 0 to 20. z from 0 to 20.
        // Right angle at (5, 5).
        // Vertices: (5,5,0), (5,25,0), (5,5,25).
        // Wait, the gusset is 5mm thick (x).
        // Let's use polygon for the face at x=-25 and x=-20.
        
        // Left Gusset Face (at x = -25)
        // Vertices: (-25, 5, 0), (-25, 25, 0), (-25, 5, 25)
        // This forms a triangle with legs 20 along Y and 20 along Z.
        // Right angle at (-25, 5, 5).
        // We need to extrude this along X from -25 to -20.
        
        // Define the triangle path
        path_left = [
            [-25, 5, 0],
            [-25, 25, 0],
            [-25, 5, 25]
        ];
        
        // Extrude along X
        translate([-25, 0, 0], linear_extrude(height = 5, center = false) polygon(points = path_left));
        
        // Right Gusset Face (at x = 25)
        // Vertices: (25, 5, 0), (25, 25, 0), (25, 5, 25)
        path_right = [
            [25, 5, 0],
            [25, 25, 0],
            [25, 5, 25]
        ];
        
        translate([25, 0, 0], linear_extrude(height = 5, center = false) polygon(points = path_right));
    }
    
    // 2. Cutouts (Holes)
    
    // Base Plate Holes (M4)
    // Cut through Z (0 to 5)
    translate([BASE_HOLE_X1, BASE_HOLE_Y1, 0], cylinder(h = BASE_Z_THICK + 1, r = BASE_HOLE_DIA/2));
    translate([BASE_HOLE_X2, BASE_HOLE_Y2, 0], cylinder(h = BASE_Z_THICK + 1, r = BASE_HOLE_DIA/2));
    
    // Motor Plate Boss Hole
    // Cut through Y (0 to 5)
    translate([MOTOR_BOSS_X, 0, MOTOR_BOSS_Z], cylinder(h = MOTOR_Y_MAX - MOTOR_Y_MIN + 1, r = MOTOR_BOSS_DIA/2));
    
    // Motor Plate Screw Holes (M3)
    // Pattern: 31mm square centered on boss hole (0, 0, 28)
    // Corners at +/- 15.5mm
    translate([MOTOR_BOSS_X - MOTOR_SQUARE_SIZE/2, 0, MOTOR_BOSS_Z - MOTOR_SQUARE_SIZE/2], cylinder(h = MOTOR_Y_MAX - MOTOR_Y_MIN + 1, r = MOTOR_SCREW_DIA/2));
    translate([MOTOR_BOSS_X + MOTOR_SQUARE_SIZE/2, 0, MOTOR_BOSS_Z - MOTOR_SQUARE_SIZE/2], cylinder(h = MOTOR_Y_MAX - MOTOR_Y_MIN + 1, r = MOTOR_SCREW_DIA/2));
    translate([MOTOR_BOSS_X - MOTOR_SQUARE_SIZE/2, 0, MOTOR_BOSS_Z + MOTOR_SQUARE_SIZE/2], cylinder(h = MOTOR_Y_MAX - MOTOR_Y_MIN + 1, r = MOTOR_SCREW_DIA/2));
    translate([MOTOR_BOSS_X + MOTOR_SQUARE_SIZE/2, 0, MOTOR_BOSS_Z + MOTOR_SQUARE_SIZE/2], cylinder(h = MOTOR_Y_MAX - MOTOR_Y_MIN + 1, r = MOTOR_SCREW_DIA/2));
}