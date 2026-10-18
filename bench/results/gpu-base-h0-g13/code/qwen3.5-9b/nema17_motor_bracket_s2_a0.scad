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

// 1. Base Plate
base = cube([
    BASE_X_MAX - BASE_X_MIN,
    BASE_Y_MAX - BASE_Y_MIN,
    BASE_Z_THICK
], center = false);

// 2. Vertical Motor Plate
motor_plate = translate([0, 0, 0], base) 
    // Shift to match motor plate coords relative to base origin
    // Base is centered at 0,0. Motor plate is at y=0 to 5.
    // We need to position the motor plate block correctly.
    // The block defined above is 50x45x5.
    // We want it to be 50 wide (x), 5 thick (y), 50 high (z).
    // Let's redefine the motor plate primitive specifically.
    translate([0, 0, 0], cube([50, 5, 50]));

// 3. Gussets
// Left Gusset
gusset_left = translate([
    (GUSSET_X_LEFT_MIN + GUSSET_X_LEFT_MAX)/2,
    0, // Will be rotated
    0
], rotate([0, 0, 90], cube([
    GUSSET_X_LEFT_MAX - GUSSET_X_LEFT_MIN,
    GUSSET_Y_LEG,
    GUSSET_Z_LEG
])));

// Right Gusset
gusset_right = translate([
    (GUSSET_X_RIGHT_MIN + GUSSET_X_RIGHT_MAX)/2,
    0,
    0
], rotate([0, 0, 90], cube([
    GUSSET_X_RIGHT_MAX - GUSSET_X_RIGHT_MIN,
    GUSSET_Y_LEG,
    GUSSET_Z_LEG
])));

// 4. Holes in Base Plate (M4)
// Cut holes at specified coordinates
hole_base_1 = translate([BASE_HOLE_X1, BASE_HOLE_Y1, 0], cylinder(h = BASE_Z_THICK + 1, r = BASE_HOLE_DIA/2));
hole_base_2 = translate([BASE_HOLE_X2, BASE_HOLE_Y2, 0], cylinder(h = BASE_Z_THICK + 1, r = BASE_HOLE_DIA/2));

// 5. Holes in Motor Plate
// Boss Hole (23mm, along Y)
hole_boss = translate([MOTOR_BOSS_X, 0, MOTOR_BOSS_Z], cylinder(h = MOTOR_Y_MAX - MOTOR_Y_MIN + 1, r = MOTOR_BOSS_DIA/2));

// Screw Holes (3.4mm, 31mm square pattern)
// Pattern centered at (0, 0, 28) in the plate's local coords
// Square size 31mm -> half size 15.5mm
// Corners at +/- 15.5mm from center
hole_screw_1 = translate([MOTOR_BOSS_X - MOTOR_SQUARE_SIZE/2, 0, MOTOR_BOSS_Z - MOTOR_SQUARE_SIZE/2], cylinder(h = MOTOR_Y_MAX - MOTOR_Y_MIN + 1, r = MOTOR_SCREW_DIA/2));
hole_screw_2 = translate([MOTOR_BOSS_X + MOTOR_SQUARE_SIZE/2, 0, MOTOR_BOSS_Z - MOTOR_SQUARE_SIZE/2], cylinder(h = MOTOR_Y_MAX - MOTOR_Y_MIN + 1, r = MOTOR_SCREW_DIA/2));
hole_screw_3 = translate([MOTOR_BOSS_X - MOTOR_SQUARE_SIZE/2, 0, MOTOR_BOSS_Z + MOTOR_SQUARE_SIZE/2], cylinder(h = MOTOR_Y_MAX - MOTOR_Y_MIN + 1, r = MOTOR_SCREW_DIA/2));
hole_screw_4 = translate([MOTOR_BOSS_X + MOTOR_SQUARE_SIZE/2, 0, MOTOR_BOSS_Z + MOTOR_SQUARE_SIZE/2], cylinder(h = MOTOR_Y_MAX - MOTOR_Y_MIN + 1, r = MOTOR_SCREW_DIA/2));

// Combine everything
union() {
    // Main Body
    union() {
        translate([0, 0, 0], base);
        translate([0, 0, 0], cube([50, 5, 50])); // Motor plate
        translate([
            (GUSSET_X_LEFT_MIN + GUSSET_X_LEFT_MAX)/2,
            0,
            0
        ], rotate([0, 0, 90], cube([
            GUSSET_X_LEFT_MAX - GUSSET_X_LEFT_MIN,
            GUSSET_Y_LEG,
            GUSSET_Z_LEG
        ])));
        translate([
            (GUSSET_X_RIGHT_MIN + GUSSET_X_RIGHT_MAX)/2,
            0,
            0
        ], rotate([0, 0, 90], cube([
            GUSSET_X_RIGHT_MAX - GUSSET_X_RIGHT_MIN,
            GUSSET_Y_LEG,
            GUSSET_Z_LEG
        ])));
    }
    
    // Cutouts
    difference() {
        // We need to subtract from the union. 
        // Since we are inside a union(), we can't directly subtract from the union result here.
        // Strategy: Create the solid, then subtract the holes in a separate difference block.
    }
}

// Correct approach: Build solid, then subtract holes
difference() {
    union() {
        // Base Plate
        translate([0, 0, 0], cube([
            BASE_X_MAX - BASE_X_MIN,
            BASE_Y_MAX - BASE_Y_MIN,
            BASE_Z_THICK
        ]));
        
        // Motor Plate
        translate([0, 0, 0], cube([
            MOTOR_X_MAX - MOTOR_X_MIN,
            MOTOR_Y_MAX - MOTOR_Y_MIN,
            MOTOR_Z_HEIGHT
        ]));
        
        // Left Gusset
        translate([
            (GUSSET_X_LEFT_MIN + GUSSET_X_LEFT_MAX)/2,
            0,
            0
        ], rotate([0, 0, 90], cube([
            GUSSET_X_LEFT_MAX - GUSSET_X_LEFT_MIN,
            GUSSET_Y_LEG,
            GUSSET_Z_LEG
        ])));
        
        // Right Gusset
        translate([
            (GUSSET_X_RIGHT_MIN + G