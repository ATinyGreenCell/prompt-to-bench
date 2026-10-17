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
HOLE_M4_X_1 = -17;
HOLE_M4_Y_1 = 30;
HOLE_M4_X_2 = 17;
HOLE_M4_Y_2 = 30;
HOLE_M4_DIAMETER = 4.5;

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
// Centre: x = 0, z = 28
BOSS_DIAMETER = 23;
BOSS_X = 0;
BOSS_Z = 28;

// --- Motor Plate Screw Holes (M3) ---
// Diameter: 3.4 mm
// Pattern: 31 mm square, centred on boss hole
HOLE_M3_DIAMETER = 3.4;
HOLE_M3_PATTERN_SIZE = 31;
HOLE_M3_COUNT = 4;

// --- Gusset Dimensions ---
// Thickness: 5 mm (matches base and motor plate)
// Position: Left (x=-25 to -20) and Right (x=20 to 25)
// Shape: Right triangle in YZ plane
// Legs: 20 mm along +Y and 20 mm along +Z
// Right-angle corner at y = 5, z = 5
GUSSET_THICKNESS = 5;
GUSSET_LEG_Y = 20;
GUSSET_LEG_Z = 20;
GUSSET_CORNER_Y = 5;
GUSSET_CORNER_Z = 5;
GUSSET_LEFT_X_MIN = -25;
GUSSET_LEFT_X_MAX = -20;
GUSSET_RIGHT_X_MIN = 20;
GUSSET_RIGHT_X_MAX = 25;

// --- Construction ---

// 1. Base Plate
base = cube([
    BASE_X_MAX - BASE_X_MIN,
    BASE_Y_MAX - BASE_Y_MIN,
    BASE_Z_MAX
], center = false);

// 2. Motor Plate
motor_plate = translate([0, 0, 0],
    cube([
        MOTOR_X_MAX - MOTOR_X_MIN,
        MOTOR_Y_MAX,
        MOTOR_Z_MAX
    ])
);

// 3. Boss Hole
boss_hole = translate([BOSS_X, 0, BOSS_Z],
    cylinder(h = MOTOR_Y_MAX + 1, r = BOSS_DIAMETER / 2, $fn = 64)
);

// 4. M3 Screw Holes (4 holes on 31mm square)
// Pattern is centred on boss hole (0, 0, 28)
// Square side = 31mm, so offset from center = 15.5mm
m3_offset = HOLE_M3_PATTERN_SIZE / 2;
m3_holes = for (i = [0:3]) {
    // Determine coordinates for the 4 corners of the square
    if (i == 0) { tx = -m3_offset; ty = -m3_offset; }
    else if (i == 1) { tx = m3_offset; ty = -m3_offset; }
    else if (i == 2) { tx = -m3_offset; ty = m3_offset; }
    else { tx = m3_offset; ty = m3_offset; }
    
    translate([BOSS_X + tx, 0, BOSS_Z + ty],
        cylinder(h = MOTOR_Y_MAX + 1, r = HOLE_M3_DIAMETER / 2, $fn = 64)
    )
};

// 5. Gussets (Left and Right)
// Right angle corner at y=5, z=5. Legs go +Y and +Z.
// Triangle vertices relative to corner (5,5): (0,0), (20,0), (0,20)
// In global coords: (5,5), (25,5), (5,25)
gusset_shape = polygon([
    [0, 0],      // Relative: Corner (y=5, z=5)
    [GUSSET_LEG_Y, 0], // Relative: End of Y leg (y=25, z=5)
    [0, GUSSET_LEG_Z]  // Relative: End of Z leg (y=5, z=25)
]);

gusset_left = translate([
    (GUSSET_LEFT_X_MIN + GUSSET_LEFT_X_MAX) / 2, // Center X
    GUSSET_CORNER_Y, // Start Y
    GUSSET_CORNER_Z // Start Z
], rotate([0, 0, 90]), // Rotate to lie in YZ plane
    linear_extrude(height = GUSSET_THICKNESS, center = true) {
        gusset_shape
    }
);

gusset_right = translate([
    (GUSSET_RIGHT_X_MIN + GUSSET_RIGHT_X_MAX) / 2, // Center X
    GUSSET_CORNER_Y, // Start Y
    GUSSET_CORNER_Z // Start Z
], rotate([0, 0, 90]), // Rotate to lie in YZ plane
    linear_extrude(height = GUSSET_THICKNESS, center = true) {
        gusset_shape
    }
);

// Final Assembly
difference() {
    union() {
        base;
        motor_plate;
        gusset_left;
        gusset_right;
    }
    
    // Cut Base Holes (extend slightly past faces)
    translate([HOLE_M4_X_1, HOLE_M4_Y_1, -0.1])
        cylinder(h = BASE_Z_MAX + 1, r = HOLE_M4_DIAMETER / 2, $fn = 64);
    
    translate([HOLE_M4_X_2, HOLE_M4_Y_2, -0.1])
        cylinder(h = BASE_Z_MAX + 1, r = HOLE_M4_DIAMETER / 2, $fn = 64);
    
    // Cut Boss Hole (extend slightly past faces)
    translate([BOSS_X, 0, BOSS_Z - 0.1])
        cylinder(h = MOTOR_Y_MAX + 1, r = BOSS_DIAMETER / 2, $fn = 64);
    
    // Cut M3 Holes (extend slightly past faces)
    for (h = m3_holes) {
        h;
    }
}