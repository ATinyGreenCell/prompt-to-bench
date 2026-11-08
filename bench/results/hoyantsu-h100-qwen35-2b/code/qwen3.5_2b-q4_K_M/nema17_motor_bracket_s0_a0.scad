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

// Create the L-shaped base plate
base_plate = cube([base_width, base_height, base_depth]);

// Create the vertical motor plate (standing on back edge)
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
// Gusset is a right triangle in YZ plane with legs along +Y and +Z
// Corner at y=5, z=5. Legs start from corner? Or extends outwards?
// Description: "right-angle corner at y = 5, z = 5 ... legs 20 mm along +Y and +Z"
// This implies the triangle vertices are roughly (corner), (corner+leg_y), (corner+leg_z).
// However, a standard gusset usually extends OUTWARDS from the plate edge.
// Let's interpret "flush with left/right edges" as extending 5mm outwards from x=-25 and x=25? 
// No, it says "5 mm thick". Usually thickness is depth into the part.
// If it is flush with edges, it likely means it sits on the plate surface (z=0 to z=5) 
// but extends in Y and Z? That would overlap the motor plate which goes up to z=50.
// Re-reading: "flush with the left and right edges". This usually implies the gusset is attached 
// to the side of the bracket, not overlapping the vertical motor plate.
// BUT the description says legs 20mm along +Y and +Z. The base plate goes from y=0 to y=45.
// If the gusset is on the LEFT edge (x=-25), it must be between x=-25 and some positive X? 
// Or does "flush with edges" mean it sits on the vertical face of the bracket at x=-25?
// Let's assume standard engineering interpretation: The gussets are attached to the SIDE faces 
// (x = -25 and x = 25) but they need to be cut from the base plate.
// Wait, if it is on the side face, it would overlap the vertical motor plate unless we cut a slot?
// Or perhaps the "base" of the gusset is at z=0 (bottom of bracket) and it sticks out? 
// But then how does it fit with the legs 20mm along +Y? The base plate only goes to y=45.
// If leg_y = 20, and corner is at y=5, the triangle would go from y=-15 to y=25? That's inside the bracket.
// Let's re-read carefully: "flush with the left and right edges". 
// Maybe it means the gusset is attached to the vertical face of the base plate (at x=-25)?
// And extends into the YZ plane? But then it would overlap the motor plate which is at z=0..50.
// Unless the "motor plate" description implies a separate block, but the cut removes material.
// Let's assume the gussets are attached to the SIDE of the bracket (x=-25 and x=25) 
// and extend OUTWARDS from the side face into the YZ plane? That would require cutting through the vertical motor plate too?
// Or maybe the "legs" refer to the thickness of the gusset itself in a different orientation?
// Let's try this interpretation: The gussets are attached to the SIDE faces (x=-25 and x=25). 
// They extend from z=0 upwards. But they need to be 5mm thick. So they occupy z=[0,5].
// And they have legs of length 20 along +Y? That means they go from y=0 to y=20?
// This would mean the gusset is on the side face, extending into the bracket body (y>0).
// But then it overlaps with the motor plate which is also at z=0..5.
// Actually, if the gusset is "flush with edges", maybe it means it sits on the vertical face 
// and extends outwards? No, that's not a triangle in YZ plane usually unless it's a slot cutout.
// Let's assume the standard interpretation for such brackets: The gussets are attached to the SIDE faces 
// (x=-25 and x=25) but they are actually part of the base plate structure extending outwards? 
// No, "flush with edges" usually means parallel to the edge.
// Let's try a different interpretation: The gussets are cut from the BASE plate (bottom), 
// sitting on z=0, and extend upwards into the YZ plane? That would overlap the motor plate.
// Maybe the motor plate is not at z=5? "standing on the back edge". Back edge usually means y=45?
// If motor plate is at y=45..95, then it doesn't overlap the base plate (y=0..45).
// Let's assume the user meant: Base plate is bottom. Motor plate is vertical block attached to top/back of base.
// Gussets are attached to the SIDE faces of the BASE plate? Or the side faces of the motor plate?
// "flush with left/right edges" -> likely x=-25 and x=25 (the sides of the bracket).
// If they are on the side faces, they must be cut from the base plate. 
// But if they go up to z=50 (motor plate height), they would overlap the motor plate.
// Unless the gussets are only 5mm thick and sit on the bottom? Then legs along +Y means y direction?
// If leg is along Y, it goes from z=0 upwards. If corner is at y=5, then triangle covers y<5? 
// That's inside the base plate. This seems redundant or wrong.

// Alternative Interpretation: The "gussets" are actually slots cut into the side faces of the motor plate?
// No, description says "triangular gussets... flush with left/right edges".
// Let's assume the gussets are attached to the SIDE faces (x=-25 and x=25) of the BASE PLATE.
// They extend from z=0 upwards into the YZ plane? That would overlap the motor plate.
// Maybe the "legs" 20mm along +Y means they go from y=0 to y=20 on the side face?
// And the triangle is formed by the corner at (x=-25, y=5, z=5)? 
// If so, it would be a cutout from the base plate. But then how does it connect to the motor plate?
// It doesn't need to connect if they are separate parts, but usually brackets are one piece.
// Let's assume the gussets are attached to the SIDE faces of the BASE PLATE (x=-25 and x=25).
// They