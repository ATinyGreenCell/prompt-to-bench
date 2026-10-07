// L-shaped Mounting Bracket for NEMA 17 Stepper Motor

// --- Global Settings ---
$fn = 64; // High resolution for curves

// --- Dimensions ---

// Base Plate Dimensions
base_plate_x_min = -25;    // X min of base plate (mm)
base_plate_x_max = 25;     // X max of base plate (mm)
base_plate_y_min = 0;      // Y min of base plate (mm)
base_plate_y_max = 45;     // Y max of base plate (mm)
base_plate_z_height = 5;   // Z height of base plate (mm)

// Base Plate Holes (M4)
hole_diameter_m4 = 4.5;    // Diameter for M4 holes (mm)
hole_offset_x1 = -17;      // X position of first hole (mm)
hole_offset_y = 30;        // Y position of both holes (mm)
hole_diameter_cut_extension = 1.0; // Extension for cutting operation

// Motor Plate Dimensions
motor_plate_x_min = -25;   // X min of motor plate (mm)
motor_plate_x_max = 25;    // X max of motor plate (mm)
motor_plate_y_min = 0;     // Y min of motor plate (mm)
motor_plate_y_max = 5;     // Y max of motor plate (mm)
motor_plate_z_height = 50; // Z height of motor plate (mm)

// Motor Boss Hole (Centring)
boss_hole_diameter = 23;   // Diameter for central boss hole (mm)
boss_hole_center_x = 0;    // X center of boss hole (mm)
boss_hole_center_z = 28;   // Z center of boss hole (mm)
boss_hole_cut_extension = 1.0; // Extension for cutting operation

// M3 Screw Holes Pattern
screw_hole_diameter_m3 = 3.4; // Diameter for M3 holes (mm)
screw_pattern_size = 31;     // Side length of the square pattern (mm)
screw_pattern_center_x = 0;  // X center of screw pattern (mm)
screw_pattern_center_z = boss_hole_center_z; // Z center of screw pattern (mm)

// Gusset Dimensions
gusset_thickness = 5;        // Thickness of gussets (mm)
gusset_x1_min = -25;         // X min for left gusset (mm)
gusset_x1_max = -20;         // X max for left gusset (mm)
gusset_x2_min = 20;          // X min for right gusset (mm)
gusset_x2_max = 25;          // X max for right gusset (mm)

// Gusset Triangle Legs (in YZ plane, relative to corner at y=5, z=5)
gusset_leg_y = 20;           // Length along +Y from corner (mm)
gusset_leg_z = 20;           // Length along +Z from corner (mm)

// --- Modules ---

// Module to create a simple rectangular block
module block(x_min, x_max, y_min, y_max, z_min, z_max) {
    translate([x_min, y_min, z_min])
    cube([x_max - x_min, y_max - y_min, z_max - z_min]);
}

// Module to create a circular hole cutter (slightly oversized for clean cutting)
module round_cutter(diameter, center_x, center_y, center_z, extension) {
    translate([center_x, center_y, center_z])
    cylinder(h = 100, r = diameter / 2 + extension, $fn = 64);
}

// Module to create a right triangle shape in the YZ plane (for gussets)
module triangular_gusset(x_start, x_end, y_leg, z_leg, corner_y, corner_z) {
    difference() {
        // Base rectangle covering the area where the triangle will be cut from
        cube([x_end - x_start, y_leg + 1, z_leg + 1]);

        // Cut out the triangular shape using a polygon extrusion in YZ plane
        linear_extrude(height = x_end - x_start)
        polygon(points=[[0, 0], [y_leg, 0], [0, z_leg]]); // Triangle defined in local XY (which is YZ for the gusset)
    }
}


// --- Geometry Construction ---

// 1. Base Plate (Lying on XY plane)
base_plate = block(
    base_plate_x_min, base_plate_x_max,
    base_plate_y_min, base_plate_y_max,
    0, base_plate_z_height
);

// 2. Motor Plate (Standing on the back edge of the base plate)
motor_plate = block(
    motor_plate_x_min, motor_plate_x_max,
    motor_plate_y_min, motor_plate_y_max,
    0, motor_plate_z_height
);

// 3. Base Plate Holes (M4) - Cutouts from the base plate
base_holes = union();
// Hole 1: (-17, 30)
base_holes = union() union() {
    round_cutter(hole_diameter_m4, hole_offset_x1, hole_offset_y, base_plate_z_height/2, hole_diameter_cut_extension);
}
// Hole 2: (17, 30)
base_holes = union() union() {
    round_cutter(hole_diameter_m4, -hole_offset_x1, hole_offset_y, base_plate_z_height/2, hole_diameter_cut_extension);
}


// 4. Motor Plate Cutouts

// A. Central Boss Hole (Cut from motor plate)
boss_cutter = round_cutter(
    boss_hole_diameter,
    boss_hole_center_x,
    motor_plate_y_min + boss_hole_diameter/2, // Center Y position for the hole through the thin plate
    boss_hole_center_z,
    boss_hole_cut_extension
);

// B. M3 Screw Holes (Cut from motor plate) - 4 holes in a 31x31 pattern centered at (0, Z=28)
screw_holes = union();
// X positions: -7.75, 7.75
// Z positions: 28 - 15.5, 28 + 15.5

// Bottom row (Z = 28 - 15.5 = 12.5)
screw_holes = union() union() {
    round_cutter(screw_hole_diameter_m3, -screw_pattern_size/2 + screw_hole_diameter_m3/2, motor_plate_y_min + screw_hole_diameter_m3/2, boss_hole_center_z - (screw_pattern_size/2) + screw_hole_diameter_m3/2, hole_diameter_cut_extension);
    round_cutter(screw_hole_diameter_m3, screw_pattern_size/2 - screw_hole_diameter_m3/2, motor_plate_y_min + screw_hole_diameter_m3/2, boss_hole_center_z - (screw_pattern_size/2) + screw_hole_diameter_m3/2, hole_diameter_cut_extension);
}

// Top row (Z = 28 + 15.5 = 43.5)
screw_holes = union() union() {
    round_cutter(screw_hole_diameter_m3, -screw_pattern_size/2 + screw_hole_diameter_m3/2, motor_plate_y_min + screw_hole_diameter_m3/2, boss_hole_center_z + (screw_pattern_size/2) - hole_diameter_cut_extension, hole_diameter_cut_extension);
    round_cutter(screw_hole_diameter_m3, screw_pattern_size/2 - screw_hole_diameter_m3/2, motor_plate_y_min + screw_hole_diameter_m3/2, boss_hole_center_z + (screw_pattern_size/2) - hole_diameter_cut_extension, hole_diameter_cut_extension);
}


// 5. Gussets (Triangular supports)
// The