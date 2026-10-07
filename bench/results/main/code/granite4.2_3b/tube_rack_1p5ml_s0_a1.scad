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

// Build the bench rack as a rectangular block centred on the origin in X and Y,
// resting on XY plane at z=0 and building upward (+Z). The block extends from z=0 to z=block_height.

// Create the main block (solid rectangle) centered on the origin.
main_block = cube([block_length, block_width, block_height], center=true);

// Define hole positions relative to centre of block.
// Each hole is a cylindrical cavity that starts at the top surface (z = block_height) and goes downward for depth = hole_depth.
// The cavity stops 5 mm above its deepest point? Actually we want:
//   - Cavity extends from z = block_height down to z = block_height - hole_depth.
//   - At the bottom of the cavity, there is a solid floor of thickness floor_thickness that caps the hole and prevents further penetration.
// So we carve out a cylindrical cavity with depth = hole_depth, but then add back a flat plate at the bottom to ensure 5 mm solid remains below the cavity bottom? Wait: "leaving a 5 mm solid floor" means after drilling the hole (which is open at top and closed at bottom), there should be a solid region of thickness 5 mm beneath the hole's opening.
// Interpretation: The hole is open at its top surface (the block's top) and closed at its bottom by a solid wall that is 5 mm thick, i.e., the cavity does not go all the way to the bottom; it stops 5 mm above the very bottom of the block? Or more precisely:
//   - The hole is cylindrical with depth = hole_depth (25 mm).
//   - At its deepest point, there remains a solid plate of thickness floor_thickness = 5 mm that caps the hole and prevents further drilling.
// So if we drill from top surface downward for hole_depth, then at z = block_height - hole_depth we reach the bottom of the cavity; but we want to stop carving before reaching the very bottom of the block? Actually "leaving a 5 mm solid floor" likely means that after the cavity is carved (which goes down to depth hole_depth), there should still be 5 mm of solid material beneath the cavity's opening, i.e., the cavity does not go all the way to z=0; instead it stops at z = block_height - hole_depth + floor_thickness? Let's define clearly:
//   Block occupies z in [0, block_height].
//   We drill a cylindrical hole that starts at the top surface (z = block_height) and goes downward.
//   The hole is open at its top surface (the opening on the top of the block).
//   At its bottom, we want a solid floor: meaning there is a flat plate of thickness floor_thickness sitting below the cavity's deepest point, so that the cavity does not penetrate into the block beyond that.
//   So if hole_depth = 25 mm, and we want the cavity to stop such that there remains 5 mm of solid material beneath it, then the cavity should extend only to z = block_height - (hole_depth - floor_thickness) ? Actually:
//      Let top surface be at z = block_height.
//      The cavity goes downward; after traveling hole_depth distance, we reach a point where if we continued drilling we would go beyond the desired solid floor.
//      We want that at the deepest point of the cavity, there is still 5 mm of solid material below it (i.e., the cavity does not go to z = block_height - hole_depth; instead it stops earlier so that from its bottom to the very bottom of the block there is a solid region of thickness floor_thickness).
//      So if we stop carving at z = block_height - hole_depth + floor_thickness? Let's derive:
//         Suppose we carve a cavity that goes down exactly hole_depth mm. Then the deepest point of the cavity is at z = block_height - hole_depth.
//         At that deepest point, if there were no solid floor, the cavity would continue into the block (which is solid). But we want to stop carving before reaching the bottom; instead we want a flat solid plate of thickness floor_thickness sitting below the cavity's opening.
//         So we should carve only down to z = block_height - hole_depth + floor_thickness? Actually if we carve until z = block_height - (hole_depth - floor_thickness), then from that point downward there is a solid region of thickness floor_thickness before the cavity would continue.
//         But typical modeling: we can model by carving out the cavity up to depth = hole_depth, and then adding back a flat plate at the bottom to represent the solid floor. However, if we carve all the way to z = block_height - hole_depth, then that point is already the deepest; there is no material below it (since we removed everything). To have 5 mm solid floor, we need to keep the material between z = block_height - hole_depth and z = block_height - hole_depth + floor_thickness? Wait:
//            Let’s define coordinate such that z increases upward. Block occupies [0, block_height].
//            Top surface is at z = block_height.
//            We drill downward; after traveling distance d (in mm) along Z decreasing direction, we reach a point where the remaining block thickness below that point should be floor_thickness.
//            So if we want the cavity to stop such that there remains 5 mm of solid material beneath it, then the deepest point of the cavity must be at z = block_height - (hole_depth - floor_thickness). Because from that deepest point down to z=0 is total remaining thickness; but we only carve until hole_depth distance traveled downward.
//            Actually: If we drill downward for hole_depth mm, then the deepest point of the cavity is at z = block_height - hole_depth.
//            At that deepest point, if there were no solid floor, the block would continue below (but it's already the bottom of the block? No, the block continues until z=0). So we want to stop carving before reaching z where only 5 mm of solid remains below the cavity opening.
//            More precisely: We want that after drilling, there is a flat solid region of thickness floor_thickness sitting directly beneath the cavity's opening (i.e., between the cavity bottom and the block's bottom surface). So if we drill downward for hole_depth mm, then at z = block_height - hole_depth we are at the cavity bottom; below that point there is still material until z = 0? But the block ends at z=0, so from z = block_height - hole_depth to z=0 is exactly (block_height - hole_depth) mm of solid. We want that remaining solid thickness to be floor_thickness = 5 mm.
//            Therefore we must drill only for distance such that the cavity bottom is at z = block_height - floor_thickness, i.e., hole_depth should be reduced so that the drilled depth equals block_height - floor_thickness? But requirement says hole depth is exactly 25 mm (hole_depth). So we cannot change hole_depth; it's fixed as 25 mm.
//            Therefore we must interpret differently: The "leaving a 5 mm solid floor" means that the cavity does not go all the way to the bottom of the block; instead, at its deepest point, there is still 5 mm of solid material beneath the cavity opening before the cavity would continue into the block. But since the block ends at z=0, we need to ensure that the cavity stops such that from its deepest point down to the very bottom (z=0) there is exactly floor_thickness = 5 mm of solid region between the cavity and the block's edge? Actually if the cavity goes all the way to z=0, then there is no solid floor; but we want a solid floor of thickness 5 mm, meaning that at the deepest point of the cavity, there should be a flat plate of thickness 5 mm sitting below it before reaching the bottom of the block.
//            This suggests that the block itself does not extend all the way to z=0; rather, the block has a recessed floor? But specification says block is solid rectangular block with height 30 mm, and holes are vertical with depth 25 mm, leaving a 5 mm solid floor. So likely:
//               The block's top surface is at z = block_height (30 mm).
//               We drill a hole that goes downward for 25 mm; so the cavity reaches z = block