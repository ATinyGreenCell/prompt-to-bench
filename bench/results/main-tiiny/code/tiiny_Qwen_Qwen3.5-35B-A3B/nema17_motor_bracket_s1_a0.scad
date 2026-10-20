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
motor_plate_thickness = 5; // Y extent: 0 to 5 (standing on base)

// --- Motor Plate Features ---
motor_boss_dia = 23;    // Diameter of centring boss hole
motor_boss_x = 0;       // X center of boss hole
motor_boss_z = 28;      // Z center of boss hole

// M3 Screw Pattern
screw_pattern_size = 31; // Square pattern size for M3 holes
screw_dia = 3.4;       // Diameter for M3 holes
screw_offset = screw_pattern_size / 2; // Distance from center to hole

// --- Gusset Dimensions ---
gusset_thickness = 5;   // Thickness of gussets
gusset_leg_y = 20;      // Length of leg along Y
gusset_leg_z = 20;      // Length of leg along Z
gusset_corner_y = 5;    // Y position of right-angle corner
gusset_corner_z = 5;    // Z position of right-angle corner

// --- Helper Variables ---
// Ensure holes extend past faces for clean cuts
hole_extend = 1;        // Extra length for through-holes

// --- Main Assembly ---

module base_plate() {
    // Main base block
    difference() {
        cube([base_width, base_depth, base_thickness], center = false);
        
        // Two M4 holes
        for (i = [-1, 1]) {
            translate([i * hole_m4_x, hole_m4_y, 0])
                cylinder(d = hole_m4_dia, h = base_thickness + hole_extend, center = false);
        }
    }
}

module motor_plate() {
    // Main vertical block
    difference() {
        cube([motor_plate_width, motor_plate_thickness, motor_plate_height], center = false);
        
        // Centering boss hole (23mm)
        translate([motor_boss_x, motor_plate_thickness/2, motor_boss_z])
            cylinder(d = motor_boss_dia, h = motor_plate_thickness + hole_extend, center = false);
        
        // Four M3 screw holes on 31mm square pattern
        for (i = [-1, 1]) {
            for (j = [-1, 1]) {
                translate([i * screw_offset, motor_plate_thickness/2, motor_boss_z + j * screw_offset])
                    cylinder(d = screw_dia, h = motor_plate_thickness + hole_extend, center = false);
            }
        }
    }
}

module gusset(side) {
    // side = -1 for left, 1 for right
    // Right triangle in YZ plane
    // Legs: 20mm along Y, 20mm along Z
    // Right angle at (y=5, z=5)
    // Hypotenuse connects (y=25, z=5) to (y=5, z=25)
    
    translate([side * 25, 0, 0]) // Position at edge of base (x = -25 or 25)
        linear_extrude(height = gusset_thickness)
            polygon([
                [0, 0],
                [0, gusset_leg_y],
                [gusset_leg_z, gusset_leg_y], // Wait, let's re-verify geometry
                // Right angle at y=5, z=5.
                // Leg 1: y from 5 to 25 (length 20).
                // Leg 2: z from 5 to 25 (length 20).
                // Triangle vertices: (5,5), (25,5), (5,25).
                // In 2D polygon (y, z):
                [5, 5],
                [25, 5],
                [5, 25]
            ]);
}

// --- Construction ---

union() {
    // Base plate
    base_plate();
    
    // Vertical motor plate (placed on back edge of base)
    // Base is at z=0, motor plate stands on it.
    // Motor plate Y range: 0 to 5. Base Y range: 0 to 45.
    // "Standing on the back edge of the base" implies Y=0 of motor plate aligns with Y=0 of base?
    // Or does it mean the back edge of the base (Y=45)?
    // Re-reading: "standing on the back edge of the base".
    // Usually, an L-bracket has the vertical part at the back.
    // If base is Y 0..45, back edge is Y=45.
    // If motor plate is Y 0..5, and stands on back edge, its Y=0 should be at base Y=45.
    // Let's align motor plate Y=0 with base Y=45.
    translate([0, 45, 0])
        motor_plate();
    
    // Gussets
    // Left gusset: x from -25 to -20.
    // Right gusset: x from 20 to 25.
    // "flush with the left and right edges (x = -25 to -20 and x = 20 to 25)"
    // This implies the gusset is a triangular prism.
    // The previous module `gusset` used a polygon in YZ plane extruded in X.
    // Let's adjust the gusset module to be a solid block with triangular cross-section.
    
    // Left Gusset
    translate([-25, 0, 0])
        linear_extrude(height = 5) // Thickness in X? No, thickness is 5mm.
            // Wait, "5 mm thick, flush with left and right edges".
            // If it's flush with x=-25 to -20, the thickness is 5mm in X.
            // The triangle is in YZ plane.
            // So we extrude the triangle along X from -25 to -20.
            polygon([
                [0, 0], // y=5, z=5 (corner)
                [20, 0], // y=25, z=5 (end of leg Y)
                [0, 20]  // y=5, z=25 (end of leg Z)
            ]);
            
    // Right Gusset
    translate([20, 0, 0])
        linear_extrude(height = 5)
            polygon([
                [0, 0], // y=5, z=5
                [20, 0], // y=25, z=5
                [0, 20]  // y=5, z=25
            ]);
}