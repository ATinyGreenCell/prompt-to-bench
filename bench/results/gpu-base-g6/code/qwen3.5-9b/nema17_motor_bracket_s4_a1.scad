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
// Stands on the back edge of the base (y=0)
MOTOR_X_MIN = -25;
MOTOR_X_MAX = 25;
MOTOR_Y_MAX = 5;
MOTOR_Z_MAX = 50;

// --- Motor Plate Boss Hole ---
// Diameter: 23 mm
// Centre: x = 0, z = 28 (along Y axis)
MOTOR_BOSS_DIAMETER = 23;
MOTOR_BOSS_X = 0;
MOTOR_BOSS_Z = 28;

// --- Motor Plate Screw Holes (M3) ---
// Diameter: 3.4 mm
// Pattern: 31 mm square centred on boss hole
MOTOR_SCREW_DIAMETER = 3.4;
MOTOR_SCREW_PATTERN_SIZE = 31;

// --- Gusset Dimensions ---
// Thickness: 5 mm (matches base)
// Location: Left (x = -25 to -20) and Right (x = 20 to 25)
// Shape: Right triangle in YZ plane
// Legs: 20 mm along +Y and 20 mm along +Z
// Right-angle corner: y = 5, z = 5
GUSSET_THICKNESS = 5;
GUSSET_LEG_Y = 20;
GUSSET_LEG_Z = 20;
GUSSET_CORNER_Y = 5;
GUSSET_CORNER_Z = 5;
GUSSET_LEFT_X_MIN = -25;
GUSSET_LEFT_X_MAX = -20;
GUSSET_RIGHT_X_MIN = 20;
GUSSET_RIGHT_X_MAX = 25;

// --- Build ---

module base_plate() {
    // Main block
    cube([
        BASE_X_MAX - BASE_X_MIN,
        BASE_Y_MAX - BASE_Y_MIN,
        BASE_Z_MAX
    ]);

    // Cut M4 holes
    for (i = [0, 1]) {
        translate([
            (i == 0) ? BASE_HOLE_X_1 : BASE_HOLE_X_2,
            (i == 0) ? BASE_HOLE_Y_1 : BASE_HOLE_Y_2,
            -BASE_HOLE_DIAMETER/2 - 0.1 // Extend past face
        ]) {
            cylinder(
                h = BASE_Z_MAX + 1,
                d = BASE_HOLE_DIAMETER,
                $fn = 64
            );
        }
    }
}

module motor_plate() {
    // Main block
    cube([
        MOTOR_X_MAX - MOTOR_X_MIN,
        MOTOR_Y_MAX,
        MOTOR_Z_MAX
    ]);

    // Cut Boss Hole
    translate([MOTOR_BOSS_X, 0, MOTOR_BOSS_Z]) {
        cylinder(
            h = MOTOR_Y_MAX + 1,
            d = MOTOR_BOSS_DIAMETER,
            $fn = 64
        );
    }

    // Cut Screw Holes (4 holes on 31mm square)
    // Pattern centred at (0, 2.5, 28)
    // Corners relative to center: +/- 15.5
    screw_offset = MOTOR_SCREW_PATTERN_SIZE / 2;
    
    for (i = [0, 1]) {
        for (j = [0, 1]) {
            translate([
                MOTOR_BOSS_X + (i == 0 ? -screw_offset : screw_offset),
                2.5 + (j == 0 ? -screw_offset : screw_offset), 
                MOTOR_BOSS_Z
            ]) {
                cylinder(
                    h = MOTOR_Y_MAX + 1,
                    d = MOTOR_SCREW_DIAMETER,
                    $fn = 64
                );
            }
        }
    }
}

module gusset() {
    // Right triangle in YZ plane, extruded along X
    // Right angle at (y=5, z=5).
    // Extends +Y to 25 (5+20) and +Z to 25 (5+20).
    // Thickness is along X.
    
    // Define vertices for the triangle in YZ plane
    // (y, z)
    // Corner: (5, 5)
    // Top: (5, 25)
    // Right: (25, 5)
    
    // We will use linear_extrude with polygon
    // Polygon points: (5,5), (25,5), (5,25), (5,5)
    // Note: OpenSCAD polygon expects (x, y) coordinates. 
    // Our local coords are Y, Z. So x->Y, y->Z.
    
    points = [
        [GUSSET_CORNER_Y, GUSSET_CORNER_Z],
        [GUSSET_CORNER_Y + GUSSET_LEG_Y, GUSSET_CORNER_Z],
        [GUSSET_CORNER_Y, GUSSET_CORNER_Z + GUSSET_LEG_Z]
    ];
    
    // Extrude thickness
    thickness = GUSSET_THICKNESS;
    
    // We need to place this at the correct X positions
    // Left Gusset: X from -25 to -20. Center X = -22.5.
    // Right Gusset: X from 20 to 25. Center X = 22.5.
    
    translate([GUSSET_LEFT_X_MIN, 0, 0]) {
        linear_extrude(thickness) {
            polygon(points);
        }
    }
    
    translate([GUSSET_RIGHT_X_MIN, 0, 0]) {
        linear_extrude(thickness) {
            polygon(points);
        }
    }
}

// Main Assembly
difference() {
    union() {
        base_plate();
        motor_plate();
        
        // Gussets are added as positive geometry
        // The gusset module creates two separate pieces (left and right)
        // We call it once.
        gusset();
    }
    
    // No additional cuts needed for the gussets as they are solid additions.
}