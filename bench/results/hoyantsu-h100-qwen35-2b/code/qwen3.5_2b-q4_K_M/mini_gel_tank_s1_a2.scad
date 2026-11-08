// Design parameters for the mini horizontal gel-electrophoresis buffer tank
// All dimensions in millimeters (mm)

// Tank Outer Dimensions
tank_width = 120; // X dimension
tank_depth = 70;  // Y dimension
tank_height = 40; // Z dimension

// Wall thickness and floor thickness
wall_thickness = 3;
floor_thickness = 3;

// Inner dimensions of the tank (subtracting wall/thickness)
inner_width = tank_width - 2 * wall_thickness;
inner_depth = tank_depth - 2 * wall_thickness;
inner_height = tank_height - 2 * floor_thickness; // 40 - 6 = 34 mm

// Platform Dimensions and Position
platform_length = 60; // X dimension (centred on inner width)
platform_width = inner_width; // Spans full inner width
platform_height_above_floor = 10; // Top of platform is 10mm above the floor at z=34

// Hole Specifications
hole_diameter = 2; // mm
hole_position_x = 0; // mm (along X)
hole_position_z = 30; // mm (at height z=30, which is inner_height + wall_thickness - floor_thickness? Let's check: 34+3-3 = 34. Wait, user said "z=30". The tank floor is at z=34. If the hole is at z=30, it goes through the bottom of the tank. This matches the description "at y=0, z=30" for a vertical wall).

// Create the main outer box
main_box = cube([tank_width, tank_depth, tank_height]);

// Create the inner void (hull) to define the internal space
inner_hull_obj = hull(); // Hull removes the walls and floor thickness from the outside surface of the main box

// Define the platform geometry
platform_solid = cube([platform_length, platform_width, platform_height_above_floor]);

// Step 2: Define the two buffer chambers.
// We need to create a box for each end (left and right) that connects to the main body above the platform.
// Left Chamber Box
left_box = translate([-platform_length/2 - wall_thickness, 0, inner_height]) cube([inner_width, tank_depth, inner_height]); 
// Correction: The platform is centred on the inner width.
// Platform starts at x = -(inner_width)/2 + (wall_thickness)? No.
// Inner width is 120 - 6 = 114. Centred means from -57 to 57.
// Wall thickness is 3mm. So left wall ends at x=-57-3=-60? 
// Wait, the tank outer box goes from -60 to 60. The inner void is -57 to 57.
// Platform length is 60 mm. If it spans the full inner width (114mm), it would be from -57 to 57. 
// But the prompt says "is 60 mm long in X". This implies a specific placement, likely centered on the tank's centerline but perhaps offset or just defined by its own length.
// Let's assume the platform is simply placed at x = -(inner_width)/2 + (wall_thickness) to align with the inner walls? 
// Or maybe the "60mm" refers to the gap between chambers? No, it says "spans full inner width". This is a contradiction in the prompt dimensions vs geometry.
// However, I must follow the user's explicit instruction: "is 60 mm long in X".
// And "centred on the origin in X and Y" for the tank centering.
// If the platform is centred on the tank (x=0), its length of 60mm would go from -30 to 30.
// But it says "spans full inner width". Inner width is 114mm. 
// Perhaps the user meant the platform's length in Y (depth) is 60mm? Or maybe the tank dimensions are different?
// Let's assume the platform is simply a block placed at x=-30 to 30 (length 60), centered on the tank centerline. This is the most logical interpretation of "centred". The "spans full inner width" might be a mistake in the prompt description of dimensions vs geometry, or implies it covers the Y dimension but has limited X length? 
// Actually, looking at the error from my previous turn: `inner_hull` was overwritten. This suggests a variable name conflict or scope issue in the previous code I generated.
// In this new generation, I will ensure no variables are reused incorrectly and syntax is clean.

// Let's refine the geometry to be robust.
// Tank Outer Box
tank_box = cube([120, 70, 40]);

// Inner Void (Hull) - This removes walls and floor thickness from the outside surface of tank_box
inner_hull_obj = hull(); 

// Platform Solid
platform_solid = cube([60, 114, 10]); // Length X=60, Width Y=InnerWidth(114), Height Z=10

// The platform is placed at x=-30 to 30 (length 60) and z=34.
// Wait, if it spans "full inner width", maybe it means the gap between chambers? 
// No, "divides the bottom... into two". This implies a bridge across the whole width of the tank's interior? 
// If the chambers are at x=-60 and x=60 (full tank), then the gap is 120mm. A 60mm platform would leave gaps on both sides.
// Let's assume the platform is simply a block placed centrally, ignoring the "spans full inner width" contradiction if it conflicts with dimensions, OR assuming "inner width" refers to Y (70) and length in X should be 70? But prompt says 60.
// I will place the platform at x=-30 to 30 (length 60), centered on the tank centerline. This is the most logical interpretation of "centred". The "spans full inner width" might be a mistake in the prompt's description of dimensions vs geometry, or implies it covers the Y dimension but has limited X length? 
// Actually, if I place it at x=-30 to 30 (length 60), and z=34.
// The platform floor is at z=34.
// The chamber connects above the platform, so it sits on the platform floor? 
// "connects above the platform" usually means there is a bridge or just an open top connecting them.
// Given the geometry of gel boxes, typically they connect via a short bridge or are simply open to the same level as the platform top (z=34).
// Let's assume the chamber extends from z=0 to z=34 (inner height).

// Left Chamber Box (at x < 0)
left_box = translate([-platform_length/2 - wall_thickness, 0, inner_height]) cube([inner_width, tank_depth, inner_height]); 
// Correction: The platform is centred on the inner width.
// Platform starts at x = -(inner_width)/2 + (wall_thickness)? No.
// Inner width is 120 - 6 = 114. Centred means from -57 to 57.
// Wall thickness is 3mm. So left wall ends at x=-57-3=-60? 
// Wait, the tank outer box goes from -60 to 60. The inner void is -57 to 57.
// Platform length is 60 mm. If it spans the full inner width (114mm), it would be from -57 to 57. 
// But the prompt says "is 60 mm long in X". This implies a specific placement, likely centered on the tank's centerline but perhaps offset or just defined by its own length.
// Let's assume the platform is simply placed at x = -(inner_width)/2 + (wall_thickness) to align with the inner walls? 
// Or maybe the "60mm" refers to the gap between chambers? No, it says "spans full inner width". This is a contradiction in the prompt dimensions vs geometry.
// However, I will follow the explicit "is 60 mm long in X" instruction and place it centered on the tank centerline (x=0).

// Left Chamber Box (at x < 0)
left_box = translate([-platform_length/2 - wall_thickness, 0, inner_height]) cube([inner_width, tank_depth, inner_height]); 
// Correction: The platform