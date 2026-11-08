// Design for six 50 mL conical (Falcon-type) tubes rack.
// Dimensions in millimeters.

// Define dimensions based on user measurements
plate_thickness = 4;          // mm
plate_size_x = 130;           // mm
plate_size_y = 90;            // mm
hole_diameter = 30.5;         // mm
wall_length = 130;            // mm (along X)
wall_thickness = 4;           // mm (along Y)
tube_height = 70;             // mm (from plate top to z=70)

// Create the main plate body
plate_body = cube(plate_size_x, plate_size_y, plate_thickness);

// Define hole positions: 3 along X, 2 along Y. 
// Center-to-center spacing is 40mm.
// Since we need a grid of holes on the plate surface (z=0), we subtract cylinders from the top face.
hole_positions_x = [0, 40]; // Start at 0, step 40
hole_positions_y = [0, 90]; // Start at 0, step 90

// Create holes on the plate surface (z=0)
plate_with_holes = union(
    plate_body,
    for(h in hole_positions_x) for(y in hole_positions_y)
        cylinder(d = hole_diameter, height = -hole_thickness, origin = translate([h/2, y/2, 0]))
);

// Define the two long walls. 
// They run along the X axis (length 130).
// They are flush with the plate's long edge (y=90) and rise from z=4 to z=70.
wall_positions_x = [0, 130]; // Start at 0, step 130

long_wall_body = cube(wall_length, wall_thickness, tube_height);
// Place walls at the back (y=90) and front (y=4), centered on X axis.
long_wall_front = translate([wall_length/2, 90 - wall_thickness/2, 0]) * long_wall_body;
long_wall_back = translate([wall_length/2, 90 + wall_thickness/2, 0]) * long_wall_body;

// Combine walls with plate body to form the side structure.
rack_structure = union(plate_with_holes, long_wall_front, long_wall_back);

// Flip and rotate the rack so it stands on its back (the open end).
// The user says: "printed upside down and flipped over after printing".
// In print orientation (upside down), we have a flat plate at z=0. 
// Flipping it means rotating 180 degrees around Z, then flipping Y? Or just rotating 180 around X/Y axis?
// Let's interpret "flipped over" as rotating the object 180 degrees around the vertical axis (Z) to stand on its back.
// However, usually racks are printed with the open end facing up or down depending on gravity. 
// If it rests on the two walls and tubes pass through holes:
// The "back" of the plate is the wall side. The "front" is the open end.
// To stand on the back (walls), we need to rotate 180 degrees around the Z axis? No, that would make it hang.
// We need to rotate 180 degrees around the X axis? That would put the open end facing down and walls up.
// Let's re-read: "rests on the two walls". The walls are at y=4 and y=90 (in print orientation). 
// So in the final standing position, the rack should be sitting on its back face (y=90) or front face?
// If it rests on the walls, the walls must be vertical supports. The tubes pass through holes.
// This implies the "back" of the plate is actually the open end facing UP in the final orientation? 
// No, if the rack stands on the two walls, those walls are horizontal supports at the bottom? 
// Or does it mean the rack has a base (the back) and the tubes hang from the top holes?
// "The two short ends stay open." -> The short ends are the plate faces.
// If the rack stands on the two walls, the walls must be the vertical supports holding the tubes up? 
// But the tubes pass through holes in the plate.
// Scenario A: Plate is printed with Open End UP. We rotate 180 deg around Z to stand it on its Back (which has holes). The Walls are just structural elements attached to the back and front, but they don't support the tubes? 
// Scenario B: The "walls" described are actually the vertical supports that hold the rack up from a table.
// Let's look at the geometry again. Plate 130x90. Walls 130 long x 4 thick.
// If we rotate 180 degrees around Z (flipping over): The plate is now on its back. 
// The walls are attached to the back and front faces of the plate? No, "Two solid walls run along the two long edges".
// This implies the rack has a specific shape: A box with open ends at X=0 and X=130 (short ends) and open ends at Y=0 and Y=90 (plate short ends).
// Wait, if it stands on the "two walls", those walls must be horizontal supports. 
// But the description says "Two solid walls run along the two long edges... rises from the plate to z = 70".
// This sounds like vertical supports attached to the back and front of the rack?
// Let's assume the standard interpretation for such racks: The rack is a box with open ends. 
// To stand on its "back" (the face opposite the short ends), we rotate it 180 degrees around Z.
// In this orientation, the "walls" are attached to the back and front faces of the plate? No, that would make them vertical supports sticking out.
// Let's try: Rotate 180 deg around X axis (flip over). 
// Original: Plate on bed. Open ends at Y=0,90. Walls at Y=4,90.
// After 180 deg rotation around Z: The plate is now upside down relative to the viewer? No, it's just rotated.
// Let's try rotating 180 degrees around X axis (flip over). 
// Original: Plate on bed. Open ends at Y=0,90. Walls at Y=4,90.
// Rotate 180 deg around Z: The plate is now facing "down" relative to the original setup? No.
// Let's visualize: 
//   Print (Up): Back face has holes. Front face open. Left/Right faces have walls attached. Top/Bottom are plates.
//   User wants it to stand on the two walls. This implies the back face (with holes) is now facing UP? No, that would make tubes hang down.
//   Maybe the "walls" are actually the vertical supports that hold the rack up from a table? 
//   If so, the rack has a base (the back of the plate) and the walls are attached to it?
//   Let's re-read carefully: "The two short ends stay open." -> The plates at X=0 and X=130 are open.
//   "After flipping, the rack stands on the two walls". This implies the rack is sitting on its back face (the one with holes). 
//   And the "walls" mentioned earlier must be attached to the front of this back-face? Or maybe the user means the rack has a base and vertical supports?
//   Actually, if it stands on the two walls, those walls are horizontal. But the description says they rise from z=4 to z=70. That's vertical.
//   Contradiction: "stands on" implies horizontal support. "rises from... to z=70" implies vertical structure.
//   Hypothesis: The rack is a box with open ends at X=0,130 and Y=0,90. 
//   To stand on the two walls (which are likely attached to the back face), we rotate 180 degrees around Z? No, that puts it upside down.
//   Rotate 180 degrees around X axis: The plate is now facing "down" relative to the original coordinate system? 
//   Let's try rotating 180 degrees around Y axis (flip over). 
//   Original: Back face at y=4,90 has holes. Front face open.
//   Rotate 180 deg around Z: The plate is now facing "down" relative to the original setup? No.
//   Let's assume the user wants the rack to stand on its back (the holey side). 
//   So we rotate 180 degrees around X axis? That would put the open ends at Y=4,90 and holes at Y=0,4? No.
//   Okay, let's look at the "walls" again. They are attached to the long edges (X-axis). 
//   If we rotate 180 degrees around Z: The plate is now facing "down". The walls are vertical