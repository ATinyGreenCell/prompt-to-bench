// NEMA 17 Stepper Motor Mounting Bracket for Syringe Pump
// Units: millimetres

// --- Base Plate Dimensions ---
base_width = 50;       // X extent: -25 to 25
base_depth = 45;      // Y extent: 0 to 45
base_thickness = 5;    // Z extent: 0 to 5

// --- Base Plate Hole Locations ---
hole_m4_x = 17;        // X position of M4 holes (symmetric)
hole_m4_y = 30;        // Y position of M4 holes
hole_m4_dia = 4.5;     // Diameter for M4 threaded holes

// --- Vertical Motor Plate Dimensions ---
motor_plate_width = 50; // X extent: -25 to 25
motor_plate_height = 50; // Z extent: 0 to 50
motor_plate_thickness = 5; // Y extent: 0 to 5

// --- Motor Plate Features ---
motor_boss_dia = 23;    // Diameter of centring boss hole
motor_boss_x = 0;       // X center of boss hole
motor_boss_z = 28;      // Z center of boss hole

// M3 Screw Pattern
screw_pattern_size = 31; // Square pattern size for M3 holes
screw_dia = 3.4;        // Diameter for M3 holes
screw_offset = screw_pattern_size / 2; // Distance from center to hole

// --- Gusset Dimensions ---
gusset_thickness = 5;   // Thickness of gussets (X direction)
gusset_leg_y = 20;      // Length of leg along Y
gusset_leg_z = 20;      // Length of leg along Z
gusset_corner_y = 5;    // Y position of right-angle corner
gusset_corner_z = 5;    // Z position of right-angle corner

// --- Helper Variables ---
hole_extend = 1;        // Extra length for through-holes to ensure clean cuts

// --- Modules ---

module base_plate() {
    // Main base block: X -25 to 25, Y 0 to 45, Z 0 to 5
    difference() {
        // Translate to position the cube from -25 to 25 in X, 0 to 45 in Y
        translate([-25, 0, 0])
            cube([base_width, base_depth, base_thickness], center = false);
        
        // Two M4 holes
        for (i = [-1, 1]) {
            translate([i * hole_m4_x, hole_m4_y, 0])
                cylinder(d = hole_m4_dia, h = base_thickness + hole_extend, center = false);
        }
    }
}

module motor_plate() {
    // Main vertical block: X -25 to 25, Y 0 to 5, Z 0 to 50
    // Placed on top of base at Y=45
    difference() {
        // Translate to position the cube from -25 to 25 in X, 45 to 50 in Y
        translate([-25, 45, 0])
            cube([motor_plate_width, motor_plate_thickness, motor_plate_height], center = false);
        
        // Centering boss hole (23mm)
        // Center at X=0, Z=28. Y is centered in the plate thickness (2.5)
        translate([motor_boss_x, 45 + motor_plate_thickness/2, motor_boss_z])
            cylinder(d = motor_boss_dia, h = motor_plate_thickness + hole_extend, center = false);
        
        // Four M3 screw holes on 31mm square pattern
        // Pattern centered at X=0, Z=28.
        for (i = [-1, 1]) {
            for (j = [-1, 1]) {
                translate([i * screw_offset, 45 + motor_plate_thickness/2, motor_boss_z + j * screw_offset])
                    cylinder(d = screw_dia, h = motor_plate_thickness + hole_extend, center = false);
            }
        }
    }
}

module gusset(side) {
    // side = -1 for left, 1 for right
    // Right triangle in YZ plane.
    // Legs: 20mm along +Y, 20mm along +Z.
    // Right-angle corner at Y=5, Z=5.
    // Vertices: (5,5), (25,5), (5,25).
    
    // Extrude along X from side*25 to side*20 (thickness 5)
    // Wait, spec says "flush with left and right edges (x = -25 to -20 and x = 20 to 25)".
    // So left gusset is X -25 to -20. Right gusset is X 20 to 25.
    
    if (side == -1) {
        translate([-25, 0, 0])
            linear_extrude(height = 5)
                polygon([
                    [5, 5],
                    [25, 5],
                    [5, 25]
                ]);
    } else {
        translate([20, 0, 0])
            linear_extrude(height = 5)
                polygon([
                    [5, 5],
                    [25, 5],
                    [5, 25]
                ]);
    }
}

// --- Main Assembly ---

union() {
    // Base plate
    base_plate();
    
    // Vertical motor plate
    motor_plate();
    
    // Gussets
    gusset(-1);
    gusset(1);
}