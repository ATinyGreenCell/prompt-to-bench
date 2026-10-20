// OpenSCAD file for hotplate stirrer knob
// Units: millimetres

$fn = 64;

// --- Dimensions ---
// Main knob dimensions
KNOB_DIA = 30;
KNOB_HEIGHT = 15;

// D-shaped bore dimensions
HOLE_DIA = 6.2;
HOLE_DEPTH = 12;
HOLE_FLAT_TO_OPPOSITE = 4.7;

// Grip grooves dimensions
GRIP_GROOVE_DIA = 2;
GRIP_GROOVE_COUNT = 18;

// Pointer groove dimensions
POINTER_WIDE = 1.5;
POINTER_DEPTH = 1;
POINTER_LENGTH = 15; // From center to outer edge

// --- Helper Variables ---
KNOB_RADIUS = KNOB_DIA / 2;
HOLE_RADIUS = HOLE_DIA / 2;
GRIP_GROOVE_RADIUS = GRIP_GROOVE_DIA / 2;
POINTER_RADIUS = POINTER_WIDE / 2;

// --- Geometry Construction ---

module hotplate_knob() {
    // Base cylinder
    base_cylinder = cylinder(d=KNOB_DIA, h=KNOB_HEIGHT, center=true);

    // Hole cylinder (D-shape base)
    hole_cylinder = cylinder(d=HOLE_DIA, h=HOLE_DEPTH, center=true);

    // Flat box to create D-shape
    // Flat position calculation:
    // Circle radius = 3.1. Opposite side at x = -3.1.
    // Flat distance from opposite side = 4.7.
    // Flat position x = -3.1 + 4.7 = 1.6.
    // To avoid coplanar faces, extend slightly past 1.6.
    FLAT_POS_X = 1.6;
    FLAT_BOX_WIDTH = 1.52; // 3.11 - 1.59 (extends past 1.6 and 3.1)
    FLAT_BOX_HEIGHT = 6.22; // Extends past -3.1 and 3.1
    FLAT_BOX_DEPTH = 12.01; // Extends past 12
    FLAT_BOX_X_CENTER = FLAT_POS_X + (FLAT_BOX_WIDTH / 2); // 1.59 + 0.76 = 2.35
    flat_box = translate([FLAT_BOX_X_CENTER, 0, HOLE_DEPTH/2]) 
               cube([FLAT_BOX_WIDTH, FLAT_BOX_HEIGHT, FLAT_BOX_DEPTH], center=true);

    // Pointer groove cylinder
    // Runs from center to edge (0 to 15) on positive X side
    POINTER_CYLINDER = translate([POINTER_LENGTH/2, 0, KNOB_HEIGHT/2])
                          cylinder(d=POINTER_WIDE, h=POINTER_DEPTH, center=true);

    // Grip grooves
    // 18 evenly spaced, centered on outer surface
    GRIP_ANGLE_STEP = 360 / GRIP_GROOVE_COUNT;
    GRIP_CYLINDER = cylinder(d=GRIP_GROOVE_DIA, h=KNOB_HEIGHT + 0.01, center=true);

    // Main construction
    difference() {
        base_cylinder;
        union() {
            hole_cylinder;
            flat_box;
            pointer_cylinder = POINTER_CYLINDER;
            
            // Grip grooves loop
            for (i = [0 : GRIP_GROOVE_COUNT - 1]) {
                rotate([0, 0, i * GRIP_ANGLE_STEP])
                    translate([KNOB_RADIUS, 0, 0])
                    GRIP_CYLINDER;
            }
        }
    }
}

hotplate_knob();