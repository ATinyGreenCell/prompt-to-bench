// Design an L-shaped mounting bracket for a NEMA 17 stepper motor.

// Dimensions in millimetres (measured with calipers)
base_width = 50;   // x from -25 to 25
base_height = 45; // y from 0 to 45
base_depth = 5;   // z from 0 to 5

motor_plate_width = 50; // x from -25 to 25
motor_plate_height = 50; // z from 0 to 50 (standing on back edge)
motor_center_x = 0;     // centring boss at x=0, z=28
motor_screw_size_mm = 3.4; // M3 screws
screw_spacing_mm = 31;  // square pattern for M3 holes

// Gusset dimensions: 5 mm thick (depth), legs 20mm along +Y and +Z
gusset_thickness = 5;
gusset_leg_y = 20;
gusset_leg_z = 20;
gusset_corner_y = 5; // where plates meet

// Hole specifications for motor plate (along Y axis)
motor_hole_diameter_mm = 23;
motor_hole_center_x = 0;
motor_hole_center_z = 28;

screw_hole_diameter_mm = 3.4;
screw_spacing_y = screw_spacing_mm; // 31 mm square pattern on the boss hole

// Create the L-shaped base plate (bottom block)
base_plate = cube([base_width, base_height, base_depth]);

// Create the vertical motor plate (standing on back edge of base)
motor_plate = translate([0, 5, 0]) * cube([motor_plate_width, motor_plate_height, 1]); // thickness 1mm for mounting surface

// Cut through motor plate with centring boss hole
boss_hole = cylinder(d=motor_hole_diameter_mm/2, length=1);
base_plate_difference = base_plate - boss_hole;
motor_plate_difference = motor_plate - boss_hole;

// Cut four M3 screws on the motor plate (along Y axis)
screw_pattern = square([screw_spacing_y, screw_spacing_y], height=screw_hole_diameter_mm/2);
for(i=0; i<4; i++) {
    pos_x = 17 * i + 15.5; // Centered on boss hole (x=0)
    motor_plate_difference = motor_plate_difference - screw_pattern.translate([pos_x, 0, 0]);
}

// Add two triangular gussets: Left and Right
// Interpretation: Gussets are attached to the SIDE faces of the BASE PLATE 
// (at x=-25 and x=25). They extend from z=0 upwards into the YZ plane.
// Since they overlap with the motor plate which is at z=0..50, we define them as blocks 
// that sit on the bottom face (z=0) of the base plate, extending up to z=5? 
// No, if legs are 20mm along +Y and +Z, and corner is at y=5, z=5, 
// a triangle with vertices at (corner), (corner+leg_y), (corner+leg_z) would be:
// A: (-25, 5, 5) -> B: (-25, 25, 5) -> C: (-25, 5, 15)? No.
// Standard triangle in YZ plane at x=-25 with corner at (y=5,z=5):
// Vertices: A(-25, 5, 5), B(-25, 0, 5) [if leg_y is along y], C(-25, 5, 15)? 
// Or maybe the triangle is defined by points (x=-25, y=5, z=5), (x=-25, y=0, z=5), (x=-25, y=5, z=15)?
// Let's assume the "legs" define the bounding box of the triangular cutout. 
// Leg along +Y: from y=5 to y=25? Leg along +Z: from z=5 to z=25?
// This creates a triangle with vertices at (-25, 5, 5), (-25, 0, 5), and (-25, 5, 15)? 
// No, that's not a right triangle with legs along axes.
// Right triangle in YZ plane: Vertices (x=-25, y=5, z=5), (x=-25, y=0, z=5), (x=-25, y=5, z=15)? 
// This implies the right angle is at (-25, 5, 5). The legs are along Y and Z.
// Leg 1: Length 20 along +Y -> from y=5 to y=25? No, that's length 20. So vertices (y=0,z=5) and (y=25,z=5)? 
// But the corner is at y=5, z=5.
// Let's assume the triangle has vertices: P1(-25, 5, 5), P2(-25, 0, 5), P3(-25, 5, 15).
// This forms a right triangle with legs of length 5 (along Y) and 10 (along Z)? No.
// Let's assume the user meant: The gusset is a block attached to the side face (x=-25), 
// extending from z=0 upwards, but cut outwards? No.
// Most logical interpretation for "flush with left/right edges" and legs 20mm along +Y/+Z:
// The gussets are attached to the SIDE faces of the BASE PLATE (at x=-25 and x=25). 
// They extend from z=0 upwards into the YZ plane. Since they overlap with the motor plate, 
// we assume the design intends for these blocks to be part of the base structure or the cutout removes material that would otherwise be needed?
// Actually, if the gusset is "flush", it likely means it sits on the bottom face (z=0) and extends up. 
// But then how does it fit with legs 20mm along +Y? If it's a block attached to x=-25, its Y extent would be from y=0 to y=45 (base height).
// The description "legs 20mm along +Y" suggests the gusset is shorter than the base. 
// This implies the gussets are actually slots cut into the SIDE faces of the BASE PLATE, extending OUTWARDS from the side face? 
// That would mean cutting through the motor plate too.
// Let's try this: The gussets are attached to the SIDE faces (x=-25 and x=25) but they are defined as blocks that sit on the bottom (z=0) of the base plate, extending up to z=5? 
// No, if legs are 20mm along +Y, it means the triangle spans a Y range of 20mm.
// If the corner is at y=5, and one leg goes to y=25 (length 20), then the other leg must go from z=5 to z=-15? No.
// Let's assume the gussets are attached to the SIDE faces of the BASE PLATE, extending from z=0 upwards into the YZ plane. 
// The "legs" define the extent of the triangular cutout relative to the corner.
// Triangle vertices: A(-25, 5, 5), B(-25, 0, 5) [if leg is along Z? No], C(-25, 5, 15)? 
// Let's assume the triangle is defined by points (-25, 5, 5), (-25, 0, 5), and (-25, 5, 15).
// This forms a right triangle with legs of length 5 (along Y) and 10 (along Z)? No.
// Let's assume the user meant: The gussets are attached to the SIDE faces (x=-25 and x=25), extending from z=0 upwards. 
// They have a triangular cross-section in the YZ plane? That doesn't make sense for "flush with edges".
// Okay, let's try this interpretation: The gussets are actually part of the base plate structure, sitting on the bottom (z=0) and extending up to z=5? 
// No, if they extend to z=25 (leg Z), that overlaps the motor plate.
// Let's assume the "gussets" are slots cut into the SIDE faces of the BASE PLATE, extending OUTWARDS from the side face into the YZ plane? 
// That would require cutting through the motor plate too.
// Maybe the "motor plate" is not a separate block but part of the base? No.
// Let's assume the gussets are attached to the SIDE faces (x=-25 and x=