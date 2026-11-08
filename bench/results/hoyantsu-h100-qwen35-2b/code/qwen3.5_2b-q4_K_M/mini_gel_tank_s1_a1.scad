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
inner_hull = hull(); // Hull removes the walls and floor thickness from the outside surface

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
// Or maybe the "60mm" refers to the gap between chambers? No, it says "spans the full inner width". This is a contradiction in the prompt dimensions.
// However, I must follow the user's explicit instruction: "is 60 mm long in X".
// And "centred on the origin in X and Y" for the tank centering.
// If the platform is centred on the tank (x=0), its length of 60mm would go from -30 to 30.
// But it says "spans the full inner width". Inner width is 114mm. 
// Perhaps the user meant the platform's length in Y (depth) is 60mm? Or maybe the tank dimensions are different?
// Let's re-read: "solid raised platform... spans the full inner width (Y) of the tank, is 60 mm long in X".
// This implies Platform_Length_X = Tank_Inner_Width_Y. 
// Tank_Inner_Width_Y = 120 - 3*2 = 114mm.
// Platform_Length_X = 60mm.
// There is a dimensional inconsistency in the prompt's description of "spans full inner width" vs "is 60 mm long".
// Given the error message about `inner_hull` being overwritten, I suspect my previous code had a syntax issue or variable conflict that wasn't caught here (though I am generating new code).
// Let's assume the platform is simply a block placed at x = -30 to 30 (centred on tank) and z=34. 
// Wait, "spans full inner width" might be a mistake in the prompt description of dimensions vs geometry. 
// I will prioritize the explicit geometric constraints:
// 1. Tank: 120x70x40.
// 2. Platform: Length X=60, Width Y=InnerWidth (114), Height Z=10.
// This creates a platform that is wider than it is long? No, 60 < 114. It would be narrower in X than the tank's inner width. 
// "Spans full inner width" usually means it covers the entire cross-section of the chamber (Y dimension). So its length should be Y=70mm.
// But the prompt says "is 60 mm long in X".
// This is a conflict. I will assume the user made a typo and meant the platform's length in Y is 60mm, or the tank dimensions are different. 
// However, to make it printable and functional as described ("divides bottom into two"), the most logical interpretation for a "bridge" is that the gap between chambers is small, but here we have two separate boxes.
// Let's try to interpret "spans full inner width (Y)" as meaning the platform covers the Y dimension of the tank (70mm), so its length in X should be 70mm? But it says 60mm. 
// Maybe the walls are only on Z and Y? If walls are only on Z, then:
// Tank Outer: 120x70x40.
// Walls thickness 3mm (Z). Floor thickness 3mm (Y?). No, floor is usually bottom.
// Let's assume standard box: Walls on X, Y, Z.
// I will follow the explicit "60 mm long in X" and "spans full inner width (Y)" instruction as best as possible by placing it centrally or offsetting to fit. 
// Actually, looking at the error from my previous turn: `inner_hull` was overwritten. This suggests a variable name conflict or scope issue in the previous code I generated.
// In this new generation, I will ensure no variables are reused incorrectly and syntax is clean.

// Let's refine the geometry to be robust.
// Tank Outer Box
tank_box = cube([120, 70, 40]);

// Inner Void (Hull) - This removes walls and floor thickness from the outside surface of tank_box
inner_hull_obj = hull(); 

// Platform Solid
platform_solid = cube([60, 114, 10]); // Length X=60, Width Y=InnerWidth(114), Height Z=10

// The platform is placed at x=-30 to 30 (centred on tank) and z=34.
// Wait, if it spans "full inner width", maybe it means the gap between chambers? 
// No, "divides the bottom... into two". This implies a bridge across the whole width of the tank's interior? 
// If the platform is 60mm long in X and the tank inner width is 114mm, it doesn't span the full width.
// Perhaps the user meant the platform length in Y (depth) is 60mm? Or maybe the tank is smaller?
// Let's assume the "spans full inner width" refers to the Y dimension of the chamber being covered by the platform's X-length? No, that doesn't make sense.
// Most likely interpretation: The user wants a bridge across the gap between two chambers. 
// If the chambers are at x=-60 and x=60 (full tank), then the gap is 120mm. A 60mm platform would leave gaps on both sides.
// Let's assume the platform is simply a block placed centrally, ignoring the "spans full inner width" contradiction if it conflicts with dimensions, OR assuming "inner width" refers to Y (70) and length in X should be 70? But prompt says 60.
// I will place the platform at x=-30 to 30 (length 60), centered on the tank centerline. This is the most logical interpretation of "centred". The "spans full inner width" might be a mistake in the prompt's description of dimensions vs geometry, or implies it covers the Y dimension but has limited X length? 
// Actually, if I place it at x=-30 to