// L-shaped mounting bracket for NEMA 17 stepper motor.
// Base plate: 50 x 45 x 5 mm. Motor plate: 50 x 5 x 50 mm.
// Includes M4 mounting holes, motor boss hole, M3 screw holes, and triangular gussets.

// Base dimensions
base_x = 50;
base_y = 45;
base_z = 5;

// Motor plate dimensions
motor_x = 50;
motor_y = 5;
motor_z = 50;

// Hole dimensions
m4_diameter = 4.5;
m3_diameter = 3.4;
boss_diameter = 23;

// Gusset dimensions
gusset_thickness = 5;
gusset_leg = 20;

// Hole positions
hole1_x = -17;
hole1_y = 30;
hole2_x = 17;
hole2_y = 30;

// Boss hole position
boss_x = 0;
boss_z = 28;

// Gusset positions (flush with edges)
gusset_left_x_start = -25;
gusset_left_x_end = -20;
gusset_right_x_start = 20;
gusset_right_x_end = 25;

$fn = 64;

// Build the main L-shape by unioning the base and the motor plate
union() {
    // Base plate
    translate([-base_x / 2, 0, 0]) cube([base_x, base_y, base_z]);

    // Motor plate (standing on the back edge of the base at y=0)
    translate([-motor_x / 2, 0, 0]) cube([motor_x, motor_y, motor_z]);

    // Gussets (triangular prisms in the YZ plane, extruded along X)
    // Left Gusset
    translate([gusset_left_x_start, 0, 0]) {
        // Define the triangle vertices in the YZ plane relative to the gusset start
        // Right angle at (y=5, z=5) relative to the global origin? 
        // The prompt says: "right-angle corner at y = 5, z = 5 (where the plates meet)".
        // The plates meet at y=0 to y=5. The gusset is flush with x=-25 to -20.
        // Let's define the triangle vertices relative to the gusset's local origin at x=-25, y=0, z=0.
        // The prompt says legs are 20mm along +Y and 20mm along +Z.
        // Corner at y=5, z=5.
        // So the triangle spans y from 0 to 20? No, "legs 20 mm along +Y".
        // If the corner is at y=5, and the leg is 20mm along +Y, the other end is at y=25.
        // If the corner is at z=5, and the leg is 20mm along +Z, the other end is at z=25.
        // The gusset is "flush with the left and right edges (x = -25 to -20)".
        // So the extrusion length is 5mm.
        
        // Vertices:
        // A: (y=0, z=0) -> Bottom left of the gusset footprint? 
        // Wait, the prompt says "right-angle corner at y = 5, z = 5".
        // And "legs 20 mm along +Y and 20 mm along +Z".
        // This implies the triangle covers y from 5 to 25 and z from 5 to 25?
        // Or does it mean the legs extend 20mm from the corner?
        // "each is a right triangle ... with legs 20 mm along +Y and 20 mm along +Z, its right-angle corner at y = 5, z = 5".
        // This usually means the corner is the vertex where the two legs meet.
        // So the legs go from (5,5) to (5+20, 5) = (25, 5) and (5, 5+20) = (5, 25).
        // The third vertex would be (25, 25).
        // However, the gusset is "flush with the left and right edges".
        // If the gusset is at x=-25 to -20, it is attached to the side of the motor plate.
        // The motor plate is y=0 to 5.
        // If the gusset starts at y=5, it sits on top of the motor plate?
        // Or is it attached to the side face (x=-25)?
        // "flush with the left and right edges (x = -25 to -20)". This implies the gusset occupies the space x in [-25, -20].
        // The motor plate is x in [-25, 25], y in [0, 5].
        // The gusset is likely attached to the side face at x=-25 (or -20) and extends inwards?
        // Or it is a triangular plate filling the corner between the base and the motor plate?
        // "standing on the back edge of the base". Back edge is y=0.
        // So the motor plate is at y=0 to 5.
        // The gusset is "flush with the left and right edges".
        // If it's a triangular gusset, it usually reinforces the corner.
        // Let's assume the gusset is a triangular prism extruded along X from -25 to -20.
        // The triangle is in the YZ plane.
        // The prompt specifies the right-angle corner is at y=5, z=5.
        // Legs are 20mm along +Y and 20mm along +Z.
        // This defines the triangle vertices:
        // V1: (y=5, z=5) [Right Angle]
        // V2: (y=25, z=5) [End of Y leg]
        // V3: (y=5, z=25) [End of Z leg]
        // This triangle sits "above" the motor plate (y>5) and "behind" the base (z>5)?
        // But the base is only 5mm thick (z=0 to 5).
        // If the gusset is at z=5 to 25, it is floating above the base?
        // Maybe the "legs" are measured from the intersection of the plates?
        // Intersection is y=0 to 5, z=0 to 5.
        // If the corner is at y=5, z=5, that is the top-front corner of the motor plate.
        // Legs along +Y (away from base) and +Z (away from base).
        // This makes sense for a gusset that reinforces the top corner.
        // So the triangle is in the region y >= 5, z >= 5.
        // Vertices: (5,5), (25,5), (5,25).
        
        polygon([
            [0, 0],      // y=5, z=5 (relative to gusset origin at y=0, z=0? No, let's use absolute coords for clarity in polygon)
            // Actually, let's define the polygon in the YZ plane relative to the gusset's local origin at x=-25, y=0, z=0.
            // But the vertices are at y=5, z=5 etc.
            // So relative to (0,0), the points are (5,5), (25,5), (5,25).
            // Wait, the gusset is extruded from x=-25 to -20.
            // So the polygon is in the YZ plane.
            // Let's define the polygon points as [y, z].
            [5, 5],
            [25, 5],
            [5, 25]
        ]);
        linear_extrude(height = 5, center = true) polygon([
            [5, 5],
            [25, 5],
            [5, 25]
        ]);
        // Correction: linear_extrude extrudes along Z by default.
        // We need to extrude along X.
        // So we rotate the polygon 90 deg around Y, then extrude along Z?
        // Or use rotate_extrude? No, that's for revolution.
        // Standard way: 
        // 1. Create the 2D shape in XY plane.
        // 2. Rotate 90 deg around Y to lay it flat in XZ? No.
        // Let's stick to the prompt's orientation: "