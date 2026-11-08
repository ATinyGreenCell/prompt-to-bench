// Part 1: The Box Enclosure
// Dimensions in mm (measured with calipers)
box_width = 70.0; // X dimension
box_depth = 50.0; // Y dimension
box_height = 30.0; // Z dimension

// Wall thickness and floor thickness
wall_thickness = 2.0;
floor_thickness = 2.0;

// Floor dimensions (same as box)
floor_width = box_width;
floor_depth = box_depth;

// Create the box body using a large cube with holes cut out of it
box_body = cube([box_width, floor_depth, box_height]);

// Cut the floor from the bottom
floor_cut = box_body - translate([0.01, 0.01, -floor_thickness]) cube([floor_width, floor_depth, floor_thickness]);

// Create the vertical walls using a loop to ensure uniform thickness
for (i = 0; i < box_height / wall_thickness + 1; i++) {
    // Calculate current height of the cut section
    current_height = i * wall_thickness;
    
    // Define the top face of this segment
    top_face = translate([box_width/2, floor_depth/2, -current_height]) cube([floor_width, floor_depth, wall_thickness]);
    
    // Cut a hole in the middle of this segment to create vertical walls
    // Hole dimensions: 1mm wide, 50mm deep (same as box depth)
    hole = translate([box_width/2, floor_depth/2, -current_height]) cylinder(r=0.5, h=wall_thickness);
    
    // Combine the top face and the cutout to form the vertical wall segment
    wall_segment = union(top_face, difference(hole));
    
    // Add this segment to the box body
    box_body = box_body + wall_segment;
}

// Create the open top (lid area) by removing a cylinder from the center of the top face
top_hole = translate([box_width/2, floor_depth/2, -floor_height]) cylinder(r=wall_thickness * 0.5, h=box_height);
box_body = box_body - top_hole;

// Part 1 is now printed as a single solid on the bed (z=0)

// Part 2: The Lid
// Dimensions in mm
lid_plate_width = 70.0; // X dimension
lid_plate_depth = 50.0; // Y dimension
lid_plate_height = 2.0; // Z dimension

lip_thickness = 1.5;
lip_height = 4.0;
lip_outer_width = 65.6;
lip_outer_depth = 45.6;

// Create the plate lying on the bed (z=0)
lid_plate = cube([lid_plate_width, lid_plate_depth, lid_plate_height]);

// Cut the lip from the top of the plate
lip_cut = translate([0.01, 0.01, -lid_plate_height]) cube([lip_outer_width, lip_outer_depth, lip_thickness]);

// Create a rectangular hole in the center of the lip to allow sliding into the box
hole_position_x = (lip_outer_width - lip_outer_depth) / 2; // Centered on outer width
hole_position_y = (lid_plate_depth - lip_outer_depth) / 2; // Centered on plate depth

// Cut a rectangular hole in the middle of the lip cut
lip_hole_cut = translate([hole_position_x, hole_position_y, -lip_thickness]) cylinder(r=0.5, h=lip_height);

// Combine the lip and the hole to form the lip wall
lip_wall = union(lip_cut, difference(hole));

// Create a rectangular slot in the plate where the lid will slide into
slot_width = 1.2; // Slightly smaller than lip outer width minus clearance (0.4mm)
slot_depth = 38.0; // Same as lip outer depth
slot_height = 5.0;

// Calculate center of slot relative to plate
slot_center_x = (lid_plate_width - slot_width) / 2;
slot_center_y = (lid_plate_depth - slot_depth) / 2;

// Create the slot using a polygon for better control over corners, or simply use a large cylinder with rounded edges if needed. 
// However, to ensure it fits exactly into the lip hole later, we need precise geometry.
// Let's create a rectangular prism for the slot and then cut out the center part that overlaps with the lip wall.

slot_body = translate([slot_center_x, slot_center_y, -lid_plate_height]) cube([slot_width, slot_depth, slot_height]);

// Cut the hole in the plate where the lid slides
plate_hole_cut = translate([hole_position_x, hole_position_y, -lip_thickness]) cylinder(r=0.5, h=lip_height);

// Combine the slot body and the cutout to form the sliding channel
slot_channel = union(slot_body, difference(plate_hole_cut));

// Create the lip wall on top of the plate (z > 2mm)
lid_plate_top = translate([0.01, 0.01, -lip_thickness]) cube([lip_outer_width, lip_outer_depth, lip_height]);

// Cut a hole in the top face of the plate where the lid slides
plate_hole_top_cut = translate([hole_position_x, hole_position_y, -lid_plate_height + lip_thickness]) cylinder(r=0.5, h=lip_height);

// Combine the slot channel and the top cutout to form the full lip wall
lip_wall_full = union(lip_wall, difference(plate_hole_top_cut));

// Add the lip wall to the plate
lid_plate = lid_plate + lip_wall_full;

// Center the entire assembly on the origin (X=0, Y=0) for printing
translate([box_width/2, box_depth/2, 0]) translate([0.5, 0.5, -10]) union([box_body, lid_plate]);

// Final cleanup: remove any floating faces or small gaps if necessary, though the difference operations should handle this.
// The gap between parts is handled by the 10mm offset in the translation command above.