// Dimensions (in mm)
block_length = 106;   // X: length of bench rack
block_width = 72;    // Y: width of bench rack
block_height = 30;   // Z: height of bench rack
hole_spacing = 16;   // centre-to-centre distance between holes (mm)
hole_diameter = 11.2; // diameter of each hole (mm)
hole_depth = 25;     // depth of each hole (mm)
floor_thickness = 5;  // thickness of solid floor (mm)
num_holes_per_row = 6;
rows = 4;            // number of rows of holes

// Build the bench rack as a rectangular block with vertical holes.
// The block is centred on the origin in X and Y, resting on XY plane at z=0.

// Create the main block (solid rectangle).
block = cube([block_length, block_width, block_height], center=true);

// Define hole positions relative to centre of block.
// Each hole is a cylinder with diameter hole_diameter and depth hole_depth.
// Holes are placed in 4 rows (along Y), each row has num_holes_per_row holes along X.
// Grid spacing: holes are spaced horizontally by hole_spacing/2 on each side of centre.
hole_x = -block_length / 2 + (hole_spacing / 2) * (num_holes_per_row - 1); // start x position for first hole in row
for (i = [0 : rows]) {
    y_offset = i * block_width / (rows * num_holes_per_row); // vertical spacing between rows

    // For each row, place holes along X direction.
    for (j = [0 : num_holes_per_row - 1]) {
        x_pos = hole_x + j * hole_spacing;
        y_pos = y_offset;

        // Create a cylindrical hole: cylinder with radius = hole_diameter/2, height = hole_depth.
        // The cylinder is centered at (x_pos, y_pos, 0) and extends along Z axis downward from the top of block? 
        // Actually, holes are vertical openings in the block; they start at the bottom of the block and go up to depth hole_depth.
        // Since block sits on XY plane with z=0 upward, the hole is a cylinder that goes from z = 0 (bottom) to z = block_height - hole_depth? 
        // But requirement: holes are open at top and closed at bottom, leaving a 5 mm solid floor.
        // Interpretation: The block has height 30 mm; we want the top of the hole to be at z = block_height - hole_depth? 
        // Actually "open at the top" means the hole extends upward from the block's interior surface until it reaches the top edge, but not beyond.
        // And "closed at the bottom" means the hole is closed below by a solid floor of thickness 5 mm.

        // So we have:
        // - The block occupies z in [0, block_height].
        // - We want holes that are cylinders extending downward from the top surface? Wait: typical microcentrifuge tube rack has holes drilled vertically upward into the block, so the hole is a cavity inside the block.

        // Let's clarify geometry based on description:
        // "24 vertical holes ... Each hole is 11.2 mm in diameter and 25 mm deep, open at the top and closed at the bottom, leaving a 5 mm solid floor."
        // Means: The hole is a cylindrical cavity inside the block that goes from the top surface downward? Or upward?

        // Standard interpretation for bench rack with microcentrifuge tubes:
        // The block is like a shelf; holes are vertical slots where tubes sit, so the hole is an opening in the top surface of the block.
        // But here it says "vertical holes" and "open at the top and closed at the bottom".

        // Likely meaning:
        // - The block has thickness 30 mm measured from its base (z=0) to its top surface.
        // - Each hole is a cylindrical cavity that starts at the top surface of the block and goes downward for depth = 25 mm.
        // - So the hole's bottom is at z = block_height - hole_depth.
        // - The hole is closed below by a solid floor of thickness 5 mm, meaning there is a flat plate (or part of the block) that caps the hole from going further down? Actually "leaving a 5 mm solid floor" suggests that after drilling the hole to depth 25 mm, we want a remaining solid wall of height 5 mm at the bottom of the cavity.

        // Better: The block is solid except for holes.
        // For each hole:
        //   - A cylindrical cavity (hole) with diameter = 11.2 mm, depth = 25 mm, extending downward from the top surface of the block.
        //   - At the bottom of the cavity, there should be a flat solid region of thickness 5 mm that caps the hole and prevents it from going through completely.

        // So we can model as:
        //   - The block is initially solid (cube).
        //   - For each hole, carve out a cylindrical cavity that goes down to depth = hole_depth, but stop at z = block_height - hole_depth? Actually if the block top surface is at z = block_height, and we drill downward from there, then the cavity extends from z = block_height (top) down to z = block_height - hole_depth.
        //   - At z = block_height - hole_depth + 5? Wait: "leaving a 5 mm solid floor" means that after the cavity reaches its deepest point, there is still 5 mm of solid material below before it would be open to the bottom.

        // Let's define clearly:
        // Block occupies z in [0, block_height].
        // We want holes such that:
        //   - The hole starts at the top surface (z = block_height) and goes downward for depth = 25 mm.
        //   - So the cavity extends from z = block_height down to z = block_height - hole_depth.
        //   - At the bottom of the cavity, we want a solid wall that prevents further drilling; i.e., the cavity stops at z = block_height - hole_depth + 5? No: if the cavity depth is exactly 25 mm, then it reaches z = block_height - 25.
        //   - But requirement says "leaving a 5 mm solid floor", meaning that after the cavity goes down to its deepest point (which should be at least 25 mm deep), there remains a flat solid region of thickness 5 mm below the cavity bottom before it would open further? Actually typical bench rack: you have a hole that is 25 mm deep, and the block has total height 30 mm. So if we drill from top surface downward for 25 mm, then at z = block_height - 25, the cavity ends; but there is still material below (from z = block_height - 25 to z = block_height) that is solid? Wait:

        // Let's set coordinate system clearly:
        //   - The block rests on XY plane with its bottom face at z=0.
        //   - Its top surface is at z = block_height (30 mm).
        //   - We drill holes vertically downward from the top surface into the block, so the hole cavity extends from z = block_height down to z = block_height - hole_depth.

        // So if block_height = 30, hole_depth = 25, then the cavity reaches z = 30 - 25 = 5 mm above the bottom? Actually at z=0 is bottom surface; top surface is at z=30.
        // The cavity starts at z = 30 (top surface) and goes down to z = 30 - 25 = 5 mm from the bottom? Wait: if we are at coordinate where block occupies [z=0, z=30], then the top surface is at z=30.
        // Drilling downward means decreasing z. So cavity extends from z = 30 (top) down to z = 30 - hole_depth = 5 mm above bottom? Actually if we go down by 25 mm, we reach z = 30 - 25 = 5 mm.

        // But the requirement says "leaving a 5 mm solid floor". That likely means that after drilling the cavity to its deepest point (which is at z = block_height - hole_depth), there should still be 5 mm of solid material below that point before the cavity would continue? However, if we stop carving at z = block_height - hole_depth, then from z = block_height - hole_depth to z = block_height is solid (the top part of the block remains). But in our model, the block originally includes all material; we are carving holes.

        // So procedure:
        //   Start with a solid rectangular block (cube) centered on origin? Actually we centre