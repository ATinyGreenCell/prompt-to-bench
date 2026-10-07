// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: Base plate on XY plane (z=0), building upward (+Z)
// Centered in X and Y at origin

$fn = 64; // Polygon resolution for smooth holes/edges

// --- Dimensions & Positions (measured with calipers, units in mm) ---

// Base Plate Geometry
base_plate_x_min = -25;     // Left edge of base plate
base_plate_x_max = 25;      // Right edge of base plate (back edge where motor plate stands)
base_plate_y_min = 0;       // Front edge of base plate
base_plate_y_max = 45;      // Back edge of base plate

// Base Plate Thickness & Features
base_thickness = 5;         // Height from z=0 to z=5
m4_hole_diameter = 4.5;    // Diameter for M4 mounting holes (through-hole)
m4_hole_x1 = -17;          // X position of first through hole
m4_hole_y_pos = 30;        // Y position of both through holes

// Motor Plate Geometry & Positioning
motor_plate_thickness = 5; // Height from z=0 to z=5 (same as base, stacked)
motor_plate_z_max = 50;    // Top edge height
motor_centre_x = 0;        // X position of motor centring boss hole centre

// Motor Plate Holes
motor_boss_hole_diameter = 23; // Diameter for NEMA 17 centring boss
m3_screw_hole_diameter = 3.4;   // Diameter for M3 screw holes (through-hole along Y)
m3_pattern_side = 31;          // Side length of square pattern

// Gusset Geometry & Positioning
gusset_thickness_x = 5;        // Thickness of triangular gussets in X direction (-25 to -20 is 5mm wide? No, user said x from -25 to -20. That's a width of 5mm.)

// Gusset Corner Positioning (Right-angle corner)
gusset_corner_y = 5;           // Y coordinate of right angle corner on the intersection line
gusset_corner_z = 5;           // Z coordinate of right angle corner at base level? No, user said "y=5, z=5".

// Gusset Edge Positions (Flush with edges)
left_gusset_x_min = -25;       // Left edge flush with left side (-25 to -20 is 5mm wide?) Wait: User says x from -25 to -20. That's a width of 5mm? No, user said gusset is triangular in YZ plane... 
// Re-reading gusset description carefully: "each is a right triangle in the YZ plane with legs 20 mm along +Y and 20 mm along +Z"
// And position: "right-angle corner at y = 5, z = 5 (where plates meet)"
// And flush edges: x from -25 to -20? That implies a width of 5mm. But user said gusset is triangular in YZ plane... 
// Wait, if it's a triangle in the YZ plane, its extent in X should be constant (thickness).
// User says "flush with left and right edges". Left edge at x=-25? Right edge (inner) at x=20 to 25? That implies thickness is 5mm. 
// But user said gusset is triangular in YZ plane... So the triangle lies flat against the side wall (YZ plane).
// The "legs" are along +Y and +Z directions from the corner.

// Gusset Dimensions Correction based on description:
gusset_leg_y_length = 20;      // Length of leg along +Y from corner
gusset_leg_z_length = 20;      // Length of leg along +Z from corner


// --- Model Definition ---

module base_plate() {
    translate([base_plate_x_min, base_plate_y_min, 0]) 
        cube([base_plate_x_max - base_plate_x_min, base_plate_y_max - base_plate_y_min, base_thickness]);
    
    // Cut two M4 through-holes at (x = -17, y = 30) and (x = 17, y = 30)
    difference() {
        translate([m4_hole_x1, m4_hole_y_pos, base_thickness/2]) cylinder(r = m4_hole_diameter/2 + 0.05, h = base_thickness); // Extend slightly past faces
        
        // Second hole: x = 17, y = 30
        translate([m4_hole_x1 + 34, m4_hole_y_pos, base_thickness/2]) cylinder(r = m4_hole_diameter/2 + 0.05, h = base_thickness); 
    }
}

module motor_plate() {
    // Base plate is at z=0 to z=base_thickness (which is 5)
    // Motor plate stands on back edge of base: x from -25 to -25? No, user said "standing on the back edge". 
    // Back edge of base is at y = 45. But motor plate Y range is 0 to 5. 
    // Wait, re-read: "Vertical motor plate... standing on the back edge of the base."
    // Base plate X: -25 to 25. Motor Plate X: -25 to 25? No, user said x from -25 to 25 for both plates in description lines but then says "standing on back edge". 
    // Usually "back edge" means the end of the base plate along Y (y=45). But motor plate is described as y from 0 to 5.
    // If it stands on the back edge, does it mean its bottom face rests against the top surface of the base at x=-25? 
    // Or does it mean it's attached to the vertical plane at x=25 (right side)? 
    // "Back edge" usually implies the far end. Given Y ranges: Base 0-45, Motor 0-5.
    // If motor is y=0..5 and base is y=0..45, they overlap in Y by 0..5.
    // The only way to "stand on" something with these dimensions without complex brackets is if the motor plate sits ON TOP of the base along their shared X face? 
    // No, user says "Vertical". Base is horizontal (z=0). Vertical means Z-axis alignment.
    // Likely interpretation: Motor plate is a vertical block attached to the side or top edge of the base.
    // Given "standing on the back edge", and motor Y is 0-5... maybe it stands against the face at x=-25? 
    // Let's assume the motor plate sits vertically along the plane x = -25 (the left/back edge if viewed from front, but usually 'back' in CAD context for a block might be max X or min Y).
    // However, standard NEMA mounts often have a vertical fin.
    // Let's interpret "standing on the back edge" as resting against the plane x = -25 (the left-most face of the base plate if we consider the layout). 
    // Actually, looking at Gusset description: "flush with left and right edges". Left gusset is at x=-25. Right gusset at x=20-25?
    // If motor stands on back edge (x=-25), then it shares that face.
    
    // Motor Plate Dimensions based on user description: 
    // "Vertical motor plate: x from -25 to 25, y from