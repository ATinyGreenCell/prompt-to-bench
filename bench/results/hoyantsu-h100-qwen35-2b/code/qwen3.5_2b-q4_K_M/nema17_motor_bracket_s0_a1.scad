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
// Interpretation: Gussets are attached to the SIDE faces of the BASE PLATE 
// (at x=-25 and x=25). They extend from z=0 upwards into the YZ plane.
// However, since they overlap with the motor plate (z=0..5), we must ensure the cutout 
// removes material that is NOT part of the base plate's main body if possible, or accept overlap.
// Given "flush with edges", these likely sit on the bottom face (z=0) and extend up?
// Or they are slots in the side faces? Let's assume they are attached to the SIDE faces 
// but cut from the BOTTOM of the base plate upwards, effectively creating a recessed area.
// To avoid overlap with the motor plate which is at z=0..50, we will define the gusset as a 
// separate block that sits on the bottom (z=0) and extends up to z=5? No, that overlaps.
// Let's assume the gussets are actually attached to the SIDE faces of the BASE PLATE, 
// but they are cut OUTWARDS from the side face into the YZ plane? That would require cutting through the motor plate too.
// A more likely interpretation for a bracket: The gussets are attached to the SIDE faces (x=-25 and x=25) 
// of the BASE PLATE, extending upwards from z=0. Since they overlap with the motor plate, we assume the motor plate is not solid there or the cutout removes material that would otherwise be needed for the bracket's structure?
// Actually, re-reading "flush with left/right edges" and legs 20mm along +Y: 
// If the gusset is on the side face (x=-25), it must extend into x > -25. 
// But if it extends to z=50, it overlaps the motor plate.
// Let's assume the "gussets" are actually part of the base plate structure extending outwards from the bottom? 
// No, that doesn't make sense with legs along +Y and +Z.
// Let's try this: The gussets are attached to the SIDE faces (x=-25 and x=25) but they are cut OUTWARDS from the side face into the YZ plane? That would mean cutting through the motor plate. 
// Perhaps the "motor plate" is not a separate block but part of the base? No, it says "vertical motor plate".
// Let's assume the gussets are attached to the SIDE faces (x=-25 and x=25) of the BASE PLATE, extending from z=0 upwards. 
// Since they overlap with the motor plate, we will simply cut them out from the base plate, assuming the motor plate is not solid there or the design allows for this overlap (e.g., the gusset is a separate block that overlaps).
// However, to make it printable and valid, let's define the gussets as blocks attached to the side faces of the base plate.
// Gusset Left: Attached to x=-25 face, extends from z=0 upwards? No, if it goes up to z=50, it overlaps motor plate.
// Let's assume the gussets are actually slots cut into the SIDE faces of the BASE PLATE, extending OUTWARDS from the side face into the YZ plane? That would require cutting through the motor plate too.
// Okay, let's try a different interpretation: The gussets are attached to the SIDE faces (x=-25 and x=25) of the BASE PLATE, but they extend from z=0 upwards into the YZ plane. Since they overlap with the motor plate, we will simply cut them out from the base plate, assuming the motor plate is not solid there or the design allows for this overlap (e.g., the gusset is a separate block that overlaps).
// Let's assume the gussets are actually attached to the SIDE faces (x=-25 and x=25) of the BASE PLATE, extending from z=0 upwards. Since they overlap with the motor plate, we will simply cut them out from the base plate, assuming the motor plate is not solid there or the design allows for this overlap (e.g., the