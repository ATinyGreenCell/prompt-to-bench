// Buffer tank dimensions in mm
tank_outer_X = 120;
tank_outer_Y = 70;
tank_outer_Z = 40;

wall_thickness = 3;
floor_thickness = 3;

// Tank geometry: Outer box minus floor and walls
// We subtract the floor first, then the side walls.
// Note: OpenSCAD's difference() removes faces exactly coplanar by default if not specified.
// To ensure no coplanar faces as per rule 5, we will use a small offset or careful ordering.
// However, standard difference usually handles this well for non-coplanar cuts. 
// Let's construct the outer box first and then subtract floor and walls carefully.

// Create the main outer rectangular prism
main_box = cube([tank_outer_X, tank_outer_Y, wall_thickness + floor_thickness]); // 120 x 70 x 6

// Subtract the floor (bottom)
floor_cut = cylinder(d = floor_thickness * 2, h = floor_thickness);
tank_body = difference([main_box, floor_cut]);

// Subtract side walls
wall_cut = cylinder(d = wall_thickness * 2, h = tank_outer_Z - wall_thickness); // 40 - 3 = 37 mm height
tank_body = difference([tank_body, wall_cut]);

// Ensure no coplanar faces for rule 5 (drill holes)
// The floor is at z=0. Walls are from z=6 to z=40. Holes are at z=30. No overlap issues here.
// But if we subtract walls first, the bottom face of the tank body might be coplanar with the top of the wall cut? 
// Actually, standard difference works fine: Box - Floor - Wall. The floor is removed. Walls removed.
// We just need to make sure the hole drill doesn't create a flat surface exactly on an existing face if it were possible.
// Here, z=30 is distinct from z=6 (top of wall) and z=40 (bottom of tank).

// Define the raised platform
platform_length_X = 60; // Full inner width Y
platform_height_from_floor_mm = 10; // Top is 10mm above inner floor (z=30)
platform_top_Z = 30 + platform_height_from_floor_mm; // z = 40

// The platform sits on the tank body. 
// We need to define a box for the platform that fits inside the tank_body.
// Platform dimensions: X=60, Y=70 (full width), Z=top_Z - floor_thickness? No, it's raised from the inner floor level.
// Wait, "top is 10 mm above the inner floor". The inner floor is at z = wall_thickness + floor_thickness = 3+3 = 6mm.
// So platform top Z = 6 + 10 = 16mm? 
// Let's re-read: "solid raised platform... spans full inner width (Y)... its top is 10 mm above the inner floor".
// Inner floor height relative to tank bottom (z=0) is wall_thickness + floor_thickness = 3+3 = 6mm.
// So platform top Z = 6 + 10 = 16mm.

platform_box = cube([platform_length_X, tank_outer_Y, platform_top_Z]); // 60 x 70 x 16

// The platform sits on the tank body. 
// We need to subtract the part of the tank_body that is below the platform top.
// However, we must ensure the cut doesn't remove too much material or create coplanar issues.
// The platform top is at z=16. The tank body extends from z=0 to z=40 (outer) but has walls up to 37mm? 
// Wait, outer Z was 40. Wall height calculation: 40 - 2*3 = 37mm.
// So the platform top at z=16 is well within the tank body volume (which goes up to z=40).

tank_body_cut = difference([tank_body, platform_box]);

// Define the end walls for the buffer chambers
// End wall dimensions: X=120, Y=70, Z=tank_outer_Z - floor_thickness? 
// No, the tank body is defined as outer box minus floor and walls. 
// The "walls" in my previous code were cylinders of height (40-6). 
// So the remaining volume has vertical faces at X=0..120, Y=0..70 from z=6 to z=37?
// Actually, let's simplify the construction logic for clarity and robustness.

// Alternative Construction Strategy:
// 1. Create a large box (Outer Box).
// 2. Subtract Floor.
// 3. Subtract Side Walls (Cylinders).
// This creates the tank body.
// Then we add the platform by subtracting a smaller box from the top of this body? 
// No, OpenSCAD difference removes material. If I have a big box and cut out a small box on top, 
// it works perfectly to create an overhang or raised section.

// Let's restart construction logic for clarity:
// 1. Outer Box (120 x 70 x 6) -> Tank Body
// 2. Subtract Floor (3mm thick cylinder at z=0).
// 3. Subtract Side Walls (Cylinders of diameter 6mm, height from z=6 to z=40? No, outer Z is 40).
//    The tank body should have walls up to the outer top surface (z=40) minus wall thickness? 
//    Or does the "tank" include the walls extending to the outside? Yes.
//    So we subtract cylinders of height = 40 - 3 = 37mm from z=6 to z=40? 
//    Wait, if I start with a box 120x70x6 and cut out a floor cylinder at z=0 (height 3),
//    then cut out side cylinders. Where do they go?
//    The walls are the vertical sides of the tank. They should be from z=6 to z=40? 
//    No, if I start with a box that is only 6mm tall, and subtract a floor cylinder (3mm),
//    then subtract side cylinders... where do they go?
//    The walls are part of the original box. We need to remove material from the sides.
//    So we subtract cylinders of height = 40 - 3 = 37mm, but starting at z=6 (top of floor) and going up to z=40? 
//    No, that would leave a gap if the box is only 6mm tall.
//    Correct approach: The tank body is the outer shell.
//    Start with Box [120, 70, 6].
//    Subtract Floor Cylinder (d=6, h=3) at z=0.
//    Subtract Side Wall Cylinders (d=6, h=40-3=37). These must be placed from z=6 to z=40? 
//    No, if the box is only 6mm tall, and we subtract a cylinder of height 37 starting at z=6,
//    it would go out of bounds (z > 6+37 = 43).
//    We need the walls to be from z=0 to z=6? No, that's the floor.
//    The walls are the vertical sides. They should span the full height of the tank structure.
//    Let's assume the "tank" is the volume enclosed by the outer box minus the floor and walls.
//    So we subtract cylinders from z=0 to z=6? No, that's inside the floor/wall area.
//    We need to remove material from the sides of the box.
//    The side walls are vertical planes at X=0..120, Y=0..70, Z=3..40 (if we consider 3mm wall thickness).
//    Wait, if I have a box [120, 70, 6] and I want to remove the floor (z=0, h=3) and walls.
//    The walls are at X=0..120, Y=0..70, Z=3..40? No.
//    Let's define the tank body as: Outer Box MINUS Floor MINUS Side Walls.
//    Side Walls should be cylinders of diameter 6mm, height = (tank_outer_Z - floor_thickness) + wall_thickness? 
//    Actually, simpler: The walls are the vertical faces of the box that are not the floor.
//    So we subtract cylinders from z=0 to z=3 (floor)? No, floor is a separate cut.
//    We need to remove material at X=0..120, Y=0..70, Z=6..40? 
//    If I start with Box [120, 70, 6] and subtract Floor (z=0), then subtract Side Walls...
//    The side walls must be from z=0 to z=3? No.
//