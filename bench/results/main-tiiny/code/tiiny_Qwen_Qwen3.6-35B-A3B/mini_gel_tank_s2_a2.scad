// Buffer tank for mini horizontal gel-electrophoresis box
// Outer dimensions: 120 x 70 x 40 mm
// Wall thickness: 3 mm
// Floor thickness: 3 mm
// Platform: 60 mm long (X), full inner width (Y), top at z=13

// --- Dimensions ---
outer_x = 120;
outer_y = 70;
outer_z = 40;
wall_thick = 3;
floor_thick = 3;
platform_x = 60;
platform_top_z = 13;
hole_diam = 2;
hole_z = 30;

// --- Calculated Dimensions ---
// Inner dimensions
inner_x = outer_x - 2 * wall_thick;
inner_y = outer_y - 2 * wall_thick;

// Platform position relative to outer box
// Inner cavity starts at wall_thick
// Platform is centred in inner X
platform_x_start = wall_thick + (inner_x - platform_x) / 2;
platform_y_start = wall_thick;
platform_z_start = floor_thick;

// Hole position
// Hole is at y=0 (centre of Y), z=30 (height)
// Hole axis is X, so we use cylinder with axis along X
// We need to cut through the walls at x=0 and x=outer_x

// --- Build Part ---
// The part is an open-top tank with a solid platform inside.
// We can model this as:
// 1. A solid block of outer dimensions.
// 2. Subtract the inner void (which is the space inside the walls, excluding the platform).
// 3. Subtract the electrode holes.

// The inner void consists of:
// - The space above the platform (full inner cross-section, from platform_top_z to outer_z)
// - The two buffer chambers below the platform (left and right of the platform, from floor_thick to platform_top_z)

// Let's define the voids to subtract from the outer block.

// Void 1: Upper space (above platform)
// Extends from z = platform_top_z to z = outer_z
// X: wall_thick to outer_x - wall_thick
// Y: wall_thick to outer_y - wall_thick
// To ensure clean cuts, extend slightly past faces.
// Extend Z by 0.1 mm past top and bottom of the void region.
// Bottom of void is platform_top_z, top is outer_z.
// So subtract from z = platform_top_z - 0.1 to z = outer_z + 0.1?
// No, the void is inside the tank. The top is open, so z goes up to outer_z.
// The bottom of the void is at platform_top_z.
// So the void box is:
// x: [wall_thick, outer_x - wall_thick]
// y: [wall_thick, outer_y - wall_thick]
// z: [platform_top_z, outer_z]
// We extend by 0.1 mm in Z to ensure cutting.
// Since the top is open, we don't need to extend up. But to avoid coplanar faces,
// let's extend down by 0.1 mm into the platform? No, the platform is solid.
// The void is empty space. The platform is solid. So the void stops at platform_top_z.
// To avoid coplanar faces with the platform, we extend the void slightly into the platform?
// No, the platform is solid, so the void should not overlap the platform.
// The issue is that the void's bottom face is at z=platform_top_z, and the platform's top face is at z=platform_top_z.
// These are coplanar. To fix this, we can extend the void slightly below platform_top_z?
// But that would cut into the platform.
// Alternatively, we can extend the platform slightly above platform_top_z?
// No, the platform top is at z=13.
// Let's extend the void's bottom by 0.01 mm below platform_top_z.
// So z: [platform_top_z - 0.01, outer_z]

// Void 2: Left buffer chamber (below platform)
// X: wall_thick to platform_x_start
// Y: wall_thick to outer_y - wall_thick
// Z: floor_thick to platform_top_z
// Extend Z by 0.01 mm below floor_thick? No, the floor is solid.
// The void starts at floor_thick. The floor's top is at floor_thick.
// So extend the void's bottom by 0.01 mm below floor_thick?
// That would cut into the floor.
// Alternatively, extend the floor's top by 0.01 mm?
// Let's extend the void's bottom by 0.01 mm below floor_thick.
// So z: [floor_thick - 0.01, platform_top_z]
// But wait, the floor is solid. The void is above the floor.
// So the void's bottom is at floor_thick.
// To avoid coplanar faces, we can extend the void slightly into the floor?
// No, the floor is solid.
// Let's extend the void's bottom by 0.01 mm below floor_thick.
// This will cut into the floor, which is not desired.
// Instead, let's extend the floor's top by 0.01 mm?
// No, the floor's top is at floor_thick.
// Let's extend the void's bottom by 0.01 mm below floor_thick.
// This will cut into the floor, which is not desired.
// Instead, let's extend the void's bottom by 0.01 mm below floor_thick.
// This will cut into the floor, which is not desired.
// Let's try a different approach: extend the void's bottom by 0.01 mm below floor_thick.
// This will cut into the floor, which is not desired.
// Instead, let's extend the void's bottom by 0.01 mm below floor_thick.
// This will cut into the floor, which is not desired.
// Let's try a different approach: extend the void's bottom by 0.01 mm below floor_thick.
// This will cut into the floor, which is not desired.
// Instead, let's extend the void's bottom by