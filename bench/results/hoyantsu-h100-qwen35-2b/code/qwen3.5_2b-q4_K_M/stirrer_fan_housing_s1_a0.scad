// Design for a DIY magnetic stirrer housing based on an 80mm PC case fan.
// Units: Millimeters (FDM compatible).

// Define dimensions exactly as measured with calipers
const mm = 1; // Scale factor in mm

// Top plate thickness and size
top_thickness = 2;
box_outer_size_x = 90;
box_outer_size_y = 90;

// Wall thickness (all walls are 2.5mm thick)
wall_thickness = 2.5;

// Fan mounting holes pattern: 71.5 mm square centered on the plate
fan_hole_spacing_x = 71.5;
fan_hole_spacing_y = 71.5;
fan_hole_radius = 4.5; // Diameter of M4 screws

// Notch for power cable in one wall (left side)
notch_width_mm = 12;
notch_reach_down_mm = 8; // From z=32 to z=40

// Model orientation: Upside down, resting on XY plane at z=0
// Top plate sits on bed. Walls rise from top plate up to z=40.
// Box is open at the top (z > 40).

// Create the main box structure using difference and intersection for clean geometry
// We will build a solid block of the correct size, then cut away the top and sides as needed.

// Step 1: Define the bounding box of the final part in mm
final_size_x = box_outer_size_x + wall_thickness * 2; // 90 + 5 = 95
final_size_y = box_outer_size_y + wall_thickness * 2;   // 90 + 5 = 95
final_size_z = top_thickness + (box_outer_size_y - fan_hole_spacing_x) + wall_thickness * 3; 
// Wait, let's calculate Z more carefully based on the description.
// Top plate is z=0 to 2.
// Walls rise from top plate. The box width at the bottom is 90mm.
// So the walls extend horizontally for (90 - fan_hole_spacing_x) mm? 
// No, the holes are drilled through the top plate. The walls connect to the sides of the top plate.
// The "box" is open at the top. The vertical walls rise from the perimeter of the top plate.

// Let's build it step-by-step using union/difference for clarity and control.

// 1. Create the Top Plate (z=0 to z=top_thickness)
plate = cube([box_outer_size_x, box_outer_size_y, top_thickness]);
translate([0, 0, -top_thickness/2]) rotate(90) plate; // Rotate so it lies flat on XY plane

// 2. Create the four vertical walls (z=2 to z=40)
// We need to create a box that is open at the top and has holes drilled through the top plate.
// The "box" of the housing includes the top plate thickness + wall height.
// Height = 40 - 2 = 38 mm.

// Create a solid block representing the full volume including the top plate, then cut it out.
// This is tricky with simple difference because we need to remove the top and sides.
// Better approach: Build the walls first, then add the top plate on top of them? 
// No, the top plate sits ON TOP of the walls (z=0). The walls rise UP from z=2.

// Let's build the "box" volume that includes the top plate and the four vertical walls.
// Dimensions: X = 95, Y = 95, Z = 40.
full_box = cube([final_size_x, final_size_y, final_size_z]);
translate([0, 0, -top_thickness/2]) rotate(90) full_box; // Rotate to lie flat

// Now we need to remove:
// A. The top part (z > 40). This is a slab of height 38mm centered at z=40.
cut_top = box([final_size_x, final_size_y, 38]);
translate([0, 0, -top_thickness/2]) rotate(90) cut_top;

// B. The four side walls (z > 2). These are the vertical faces of the full_box above z=2.
// We can remove these by rotating the full_box around Z and cutting it off at z=2? 
// Or simpler: Remove the top slab, then remove the sides that stick out from z=2 to z=40.

// Let's try a different construction method for robustness:
// 1. Create the four vertical walls as separate extrusions.
//    Wall height = 38mm. Width of wall at bottom (z=2) is determined by the top plate size minus hole spacing? 
//    Actually, the walls connect to the sides of the top plate. The holes are in the top plate.
//    So the vertical walls extend from z=2 up to z=40. Their width varies along Z.

// Let's construct the four walls explicitly using for loops and extrude.
// Wall 1 (Front): x = -box_outer_size_x/2, y = -wall_thickness/2 ... 
// Actually, let's define the geometry of each wall based on the top plate perimeter.

// Define the corners of the top plate to know where walls start
corner_x = box_outer_size_x / 2;
corner_y = box_outer_size_y / 2;

// Wall 1: Front (y < -wall_thickness/2)
front_wall_start_z = 2;
front_wall_end_z = 40;
front_wall_width_bottom = corner_x + wall_thickness * 3; // From left edge of plate to right edge of plate? 
// Wait, the holes are in the top plate. The walls connect to the sides of the top plate.
// So the vertical face of the front wall starts at z=2 and goes up. Its width is constant along Z (it's a flat vertical face).
// Width = box_outer_size_x - fan_hole_spacing_x? No, that would be if it was a single block.
// The walls are open on top. So the "box" of the housing has an opening at z=40.
// The vertical faces of this "open box" connect to the sides of the top plate.

// Let's build the four vertical walls as separate extrusions, then union them? 
// No, they are connected at the bottom (z=2). A simple difference or intersection might work better if we define the cutouts correctly.
// Actually, let's just create a solid block of the "open box" dimensions and remove the top slab and the four vertical sides that stick out from z=2 to 40.

// Revised Strategy:
// 1. Create the full volume of the open box (95x95x40).
// 2. Remove the top slab (z > 40).
// 3. Remove the four vertical sides that extend from z=2 to z=40.

// Dimensions for removal:
removal_height = 40 - 2; // 38mm
removal_width = box_outer_size_x + wall_thickness * 2; // 95mm (width of the full block at bottom)
removal_depth = final_size_z - top_thickness - removal_height; 
// Wait, let's recalculate Z.
// Top plate: z=0 to 2.
// Walls rise from z=2. The box is open at z=40.
// So the walls go from z=2 to z=40. Height = 38mm.
// The full block we create has height 40. We remove the top part (z > 40).
// Then we need to remove the vertical sides of this full block that are above z=2? 
// No, if we remove the top slab, the remaining solid is a box from z=0 to z=40 with holes in the top.
// But the walls themselves (z > 2) are part of the original box. We need to cut them off at z=2.

// Let's build the four vertical walls explicitly using for loops, then union them? 
// No, they form a continuous wall around the perimeter. A difference operation on the full block works best if we define the cuts precisely.
// Cutout 1: Top slab (z > 40).
// Cutout 2: Four vertical sides of the full box from z=2 to z=40.

// Let's create the four walls as separate extrusions first, then union them? 
// No, they are connected at the bottom. Union is fine if we define the geometry correctly.
// Actually, let's just build the "open box" volume directly using a combination of cubes and holes.

// Method: Create the full block (95x95x40), then remove top slab, then remove four vertical sides.
full_block = cube([final_size_x, final_size_y, final_size_z]);
translate([0, 0, -top_thickness/2]) rotate(90) full_block;

// Remove Top Slab (z > 40)
cut_top = box([final_size_x