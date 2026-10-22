// Coarse Cell Strainer for 50 mL Conical Tube

// --- Global Settings ---
$fn = 64;

// --- Dimensions (in mm) ---
OD_TUBE = 25.0;      // Outer diameter of the main tube body
WALL_THICKNESS = 1.2; // Wall thickness of the main tube body
ID_BORE = OD_TUBE - 2 * WALL_THICKNESS; // Inner bore diameter (22.6 mm)
HEIGHT_BODY = 32.0;  // Height of the cylindrical body section (z=0 to z=32)
HEIGHT_FLOOR = 1.2;  // Thickness of the floor at z=0
FLARE_START_Z = 26.0; // Z where flare starts
FLARE_END_Z = 30.0;   // Z where flare ends (max diameter reached)
COLLAR_DIAMETER = 33.0; // Diameter of the top rim/collar
RIM_HEIGHT = 2.0;     // Height difference from flare end to collar top (32 - 30)

// Floor Hole Parameters
HOLE_SIZE = 1.0;      // Diameter of each hole
GRID_SPACING = 2.0;   // Spacing between holes in X and Y
MAX_RADIUS_FOR_HOLES = 10.0; // Max distance from center for a hole to be included

// Vent Notch Parameters
NOTCH_WIDTH = 3.0;    // Width of the vent notch
NOTCH_DEPTH_START = 25.0; // Z level where notches start cutting into collar/rim
NOTCH_CUTOUT_RADIUS = 12.5; // Radius from axis beyond which notches cut

// --- Derived Values ---
ID_BORE_HALF = ID_BORE / 2;
OD_TUBE_HALF = OD_TUBE / 2;
COLLAR_DIAMETER_HALF = COLLAR_DIAMETER / 2;
FLARE_START_RADIUS = OD_TUBE_HALF; // Radius at z=26 (25mm diameter)
FLARE_END_RADIUS = COLLAR_DIAMETER_HALF; // Radius at z=30 (33mm diameter)

// --- Module Definitions ---

// Cylinder for the main body wall section (z=1.2 to z=33.2 if we stack them correctly, but here it defines the shape)
module tube_body() {
    cylinder(h = HEIGHT_BODY + 0.2, r1 = OD_TUBE_HALF, r2 = ID_BORE_HALF); // Extend slightly for clean union/difference
}

// Floor plate with holes (at z=0)
module floor_plate() {
    difference() {
        // Solid base disc (slightly larger than outer diameter to ensure clean cut)
        cylinder(h = HEIGHT_FLOOR + 0.2, r = OD_TUBE_HALF + 0.1);

        // Cutouts for holes
        for (y = -MAX_RADIUS_FOR_HOLES; y <= MAX_RADIUS_FOR_HOLES; y = GRID_SPACING) {
            for (x = -MAX_RADIUS_FOR_HOLES; x <= MAX_RADIUS_FOR_HOLES; x = GRID_SPACING) {
                // Check if the center of the hole is within the specified radius
                if ((x*x + y*y) <= MAX_RADIUS_FOR_HOLES*MAX_RADIUS_FOR_HOLES) {
                    translate([x, y, -0.1]) { // Start slightly below Z=0 for clean cut
                        cylinder(h = HEIGHT_FLOOR + 0.2, r = HOLE_SIZE / 2);
                    }
                }
            }
        }
    }
}

// Flare section (Cone from z=26 to z=30)
module flare() {
    // Using hull to create the conical transition between two circles
    hull() {
        translate([0, 0, FLARE_START_Z]) sphere(r = FLARE_START_RADIUS);
        translate([0, 0, FLARE_END_Z]) sphere(r = FLARE_END_RADIUS);
    }
}

// Top Collar/Rim section (Cylinder from z=30 to z=32)
module collar() {
    cylinder(h = RIM_HEIGHT + 0.2, r = COLLAR_DIAMETER_HALF); // Extend slightly for clean union/difference
}

// Vent Notch Cutout
module vent_notch(x_offset) {
    // The notch starts cutting into the structure from z=25 upwards.
    // It cuts a rectangular slot through the collar/rim area.
    translate([x_offset, 0, NOTCH_DEPTH_START - 0.1]) { // Start slightly below Z=25 for clean cut
        cube([NOTCH_WIDTH + 0.2, OD_TUBE / 2 + 0.2, RIM_HEIGHT + 0.5]); // Ensure it cuts through the whole structure above z=25
    }
}


// --- Assembly ---

difference() {
    // 1. Main Structure (Body + Floor + Flare + Collar) - This is the solid object we start with
    union() {
        // A. Base Cylinder (Wall shape, extending slightly beyond Z boundaries for union robustness)
        translate([0, 0, HEIGHT_FLOOR]) {
            tube_body(); // Defines the main cylindrical volume
        }

        // B. Floor Plate (Solid base with holes)
        floor_plate();

        // C. Flare Section (z=26 to z=30)
        translate([0, 0, FLARE_START_Z]) {
            flare();
        }

        // D. Collar/Rim (z=30 to z=32)
        translate([0, 0, FLARE_END_Z]) {
            collar();
        }
    }

    // 2. Cutting Operations (Holes and Notches)

    // A. Inner Bore Cutout (To hollow out the main tube body)
    // We cut a cylinder through the entire height of the structure, centered on Z=0.
    translate([0, 0, -0.1]) {
        cylinder(h = HEIGHT_BODY + RIM_HEIGHT + 0.2, r = ID_BORE_HALF + 0.1);
    }

    // B. Vent Notches (Cutting through the collar/rim)
    // Notch on +X side (at radius NOTCH_CUTOUT_RADIUS)
    vent_notch(NOTCH_CUTOUT_RADIUS);
    // Notch on -X side (at radius -NOTCH_CUTOUT_RADIUS)
    vent_notch(-NOTCH_CUTOUT_RADIUS);

}