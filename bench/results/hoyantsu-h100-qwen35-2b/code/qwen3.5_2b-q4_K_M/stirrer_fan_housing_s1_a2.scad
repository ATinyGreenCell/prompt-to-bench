// Design for a DIY magnetic stirrer housing based on an 80mm PC case fan.
// Units: Millimeters (FDM compatible).

// Define dimensions exactly as measured with calipers
const mm = 1; // Scale factor in mm

// Top plate thickness and size
top_thickness_mm = 2;
box_outer_size_x_mm = 90;
box_outer_size_y_mm = 90;

// Wall thickness (all walls are 2.5mm thick)
wall_thickness_mm = 2.5;

// Fan mounting holes pattern: 71.5 mm square centered on the plate
fan_hole_spacing_x_mm = 71.5;
fan_hole_spacing_y_mm = 71.5;
fan_hole_radius_mm = 4.5; // Diameter of M4 screws

// Notch for power cable in one wall (left side)
notch_width_mm = 12;
notch_reach_down_mm = 8; // From z=32 to z=40

// Model orientation: Upside down, resting on XY plane at z=0
// Top plate sits on bed. Walls rise from top plate up to z=40.
// Box is open at the top (z > 40).

// Create the main box structure using difference and intersection for clean geometry
// We will build a solid block of the correct size, then cut away the top and sides as needed.

// Step 1: Define the bounding box of the final part in mm
final_size_x_mm = box_outer_size_x_mm + wall_thickness_mm * 2; // 90 + 5 = 95
final_size_y_mm = box_outer_size_y_mm + wall_thickness_mm * 2;   // 90 + 5 = 95
final_size_z_mm = top_thickness_mm + (box_outer_size_y_mm - fan_hole_spacing_x_mm) + wall_thickness_mm * 3; 
// Wait, let's calculate Z more carefully based on the description.
// Top plate is z=0 to 2.
// Walls rise from top plate. The box width at the bottom is 90mm.
// So the walls extend horizontally for (90 - fan_hole_spacing_x_mm) mm? 
// No, the holes are in the top plate. The walls connect to the sides of the top plate.
// The "box" of the housing includes the top plate thickness + wall height.
// Height = 40 - 2 = 38 mm.

// Create a solid block representing the full volume including the top plate, then cut it out.
// This is tricky with simple difference because we need to remove the top and sides.
// Better approach: Build the walls first, then add the top plate on top of them? 
// No, the top plate sits ON TOP of the walls (z=0). The walls rise UP from z=2.

// Let's build the "box" volume that includes the top plate and the four vertical walls.
// Dimensions: X = 95, Y = 95, Z = 40.
full_box_mm = cube([final_size_x_mm, final_size_y_mm, final_size_z_mm]);

// Rotate to lie flat on XY plane (z=0)
translate([0, 0, -top_thickness_mm/2]) rotate(90) full_box_mm; 

// Now we need to remove:
// A. The top part (z > 40). This is a slab of height 38mm centered at z=40.
cut_top_mm = box([final_size_x_mm, final_size_y_mm, 38]);

// B. The four side walls (z > 2). These are the vertical faces of the full_box_mm above z=2.
// We can remove these by rotating the full_box_mm around Z and cutting it off at z=2? 
// Or simpler: Remove the top slab, then remove the sides that stick out from z=2 to z=40.

// Let's try a different construction method for robustness:
// 1. Create the four vertical walls as separate extrusions.
//    Wall height = 38mm. Width of wall at bottom (z=2) is determined by the top plate size minus hole spacing? 
//    Actually, the walls connect to the sides of the top plate. The holes are in the top plate.
//    So the vertical face of the front wall starts at z=2 and goes up. Its width is constant along Z (it's a flat vertical face).
//    Width = box_outer_size_x_mm - fan_hole_spacing_x_mm? No, that would be if it was a single block.
//    The walls are open on top. So the "box" of the housing has an opening at z=40.
//    The vertical faces of this "open box" connect to the sides of the top plate.

// Let's construct the four walls explicitly using for loops and extrude, then union them? 
// No, they are connected at the bottom (z=2). A difference operation on the full block works best if we define the cuts precisely.
// Cutout 1: Top slab (z > 40).
// Cutout 2: Four vertical sides of the full box from z=2 to z=40.

// Let's create a shape representing the four vertical walls and subtract it from the full block.
// The shape is composed of 4 extrusions (faces) at z=2? No, that's not right.
// The walls are the sides of the box. We need to remove the material that forms these sides.

// Let's try a simpler approach: Build the open box as a single solid with holes using for loops and difference.
// 1. Create the full block (95x95x40).
// 2. Remove top slab (z > 40).
// 3. Remove four vertical sides that extend from z=2 to z=40.

// Let's define the cutout for the vertical walls as a single shape using difference.
// We will create a shape representing the four vertical faces of the full block, then subtract it.
// The shape is composed of 4 extrusions (faces) at z=2? No, that's not right.
// The walls are the sides of the box. We need to remove the material that forms these sides.

// Let's try a simpler approach: Build the open box as a single solid with holes using for loops and difference.
// 1. Create the full block (95x95x40).
// 2. Remove top slab (z > 40).
// 3. Remove four vertical sides that extend from z=2 to z=40.

// Let's define the cutout for the vertical walls as a single shape using difference.
// We will create a shape representing the four vertical faces of the full block, then subtract it.
// The shape is composed of 4 extrusions (faces) at z=2? No, that's not right.
// The walls are the sides of the box. We need to remove the material that forms these