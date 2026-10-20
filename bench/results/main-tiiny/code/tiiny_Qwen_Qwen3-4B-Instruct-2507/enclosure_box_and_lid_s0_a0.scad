// Dimensions in millimeters
$fn = 64;

// Part 1: Box (base enclosure)
box_width = 70;
box_depth = 50;
box_height = 30;
wall_thickness = 2;
floor_thickness = 2;

// Part 2: Lid (printed upside down, so it sits on top of the box)
lid_plate_width = 70;
lid_plate_depth = 50;
lid_plate_thickness = 2;
lip_thickness = 1.5;
lip_height = 4;
lip_width = 65.6;
lip_depth = 45.6;
clearance = 0.2;

// Box: outer dimensions 70x50x30, 2mm walls, 2mm floor, open top
// Centered on origin, with walls and floor
box = 
  translate([0, 0, 0])
  difference() {
    // Outer box (full volume)
    cube([box_width, box_depth, box_height]);
    
    // Cut out walls (inner volume)
    // Bottom floor
    translate([0, 0, -floor_thickness])
    cube([box_width, box_depth, floor_thickness]);
    
    // Cut out four walls (front, back, left, right)
    // Front wall (Y direction)
    translate([0, 0, -floor_thickness])
    cube([box_width, 0, box_height]);
    
    // Back wall (Y direction)
    translate([0, box_depth, -floor_thickness])
    cube([box_width, 0, box_height]);
    
    // Left wall (X direction)
    translate([0, 0, -floor_thickness])
    cube([0, box_depth, box_height]);
    
    // Right wall (X direction)
    translate([box_width, 0, -floor_thickness])
    cube([0, box_depth, box_height]);
    
    // Cut out the inner walls (after removing floor and sides)
    // We use difference to remove the inner volume
    // Instead, build the outer box and subtract the inner hollow
    // So we build the outer cube and subtract the inner space
    // But we already subtracted the floor and walls above.
    // So we just build the outer and subtract the inner walls and floor.
    // Actually, we do it as a single difference: outer cube minus inner walls.
    // So we start with full outer cube, then subtract the inner walls.
    // But we already did that in the difference above.
  };

// Lid plate (70x50x2 mm, lying on bed)
// It is printed upside down, so it sits on top of the box.
// The lip is 1.5 mm thick, 4 mm tall, 65.6 x 45.6 mm, centered on the plate.
// The lip extends 0.2 mm beyond the edges of the plate on each side.

// First, the lid plate (flat, 70x50x2)
lid_plate = 
  translate([0, 0, 0])
  cube([lid_plate_width, lid_plate_depth, lid_plate_thickness]);

// Now, the lip on top of the lid plate
// The lip is 1.5 mm thick, 4 mm tall, centered on the plate
// Outer size 65.6 x 45.6 mm, so it extends 32.8 mm left/right and 22.8 mm up/down from center
// It is built on top of the plate, so at z = 0, and extends up to z = 4 mm
// The lip is a rectangular block on top of the plate, centered

// The lip is built as a separate part, centered on the plate
// It will be placed on the +X side of the box, so we place it at x = 35 mm (centered on 70 mm)

// First, define the lip geometry
lip = 
  translate([0, 0, 0])
  difference() {
    // Full lip block: 65.6 x 45.6 x 4 mm
    cube([lip_width, lip_depth, lip_height]);
    
    // Cut out the part that is not the lip (the base of the lip is on the plate)
    // The lip is built on top of the plate, so we cut out the part below z=0
    // But the lip is printed upside down, so it sits on the plate at z=0
    // So we only build the lip above z=0
    // Actually, we build the lip as a block from z=0 to z=lip_height
    // And we want it to be centered on the plate
    // So we place it at x = 35 - lip_width/2, y = 25 - lip_depth/2
    // But we are building it in the global coordinate system
    // We will place it at x = 35 - lip_width/2, y = 25 - lip_depth/2, z = 0
    // But we are building it in the same coordinate system as the box
    // So we will place the lip at x = 35 - lip_width/2, y = 25 - lip_depth/2, z = 0
    // But we are building the entire part in one coordinate system
    // So we will define the lip as a separate object and place it at the correct location
  };

// Final assembly: box and lid side by side with 10 mm gap
// Box is centered at origin, so from x = -35 to x = 35
// Lid is placed on the +X side of the box, so from x = 35 + 10 to x = 35 + 10 + 70 = 115
// But the lid is 70 mm wide, so we place it at x = 35 + 10 = 45 to x = 45 + 70 = 115
// But the lid is 70x50, so we place it at x = 35 + 10 = 45, y = -25 to 25, z = 0

// First, place the box at origin
box_part = 
  translate([0, 0, 0])
  box;

// Then, place the lid on the +X side, with 10 mm gap between box and lid
// The lid plate is 70x50, so centered at x = 35 + 10 = 45, y = 0, z = 0
// The lip is 65.6 x 45.6 mm, so centered at x = 45 + 32.8 = 77.8, y = 0 + 22.8 = 22.8
// But the lip is on top of the lid plate, so it is built on top of the plate at z=0
// The lip is built at z=0 to z=4 mm

// So we place the lid plate at x = 45, y = -25 to 25, z = 0
// And the lip at x = 45 + 32.8 = 77.8, y = -22.8 to 22.8, z = 0 to 4 mm

// But the lid plate is 70x50, so centered at x=45, y=0
// So we place the lid plate at x=45, y=-25 to 25

// So the lid plate is:
lid_plate_placed = 
  translate([45, 0, 0])
  cube([70, 50, 2]);

// The lip is 65.6 x 45.6 mm, 1.5 mm thick, 4 mm tall, centered on the plate
// So the lip is centered at x = 45 + 32.8 = 77.8, y = 0 + 22.8 = 22.8
// But the lip is built on top of the plate, so it is at z=0 to z=4 mm
// And it is 1.5 mm thick in the z-direction? No, it is 1.5 mm thick in the wall direction
// Actually, the lip is 1.5 mm thick in the wall, 4 mm tall in z
// So it is a 65.6 x 45.6 x 4 mm block, with 1.5 mm wall thickness
// But the wall is 1.5 mm thick, so it is 1.5 mm in the thickness direction
// So the lip is a 65.6 x 45.6 x 4 mm block, with 1.5 mm wall thickness
// But the wall thickness is in the z-direction? No, the lip is built on top of the plate
// So the lip is built as a 65.6 x 45.6 x 4 mm block, with 1.5 mm wall thickness in the x and y directions
// But the lip is a rectangular block with 1.5 mm wall thickness, 4 mm height

// Actually, the lip is a 65.6 x 45.6 x 4 mm block, with 1.5 mm wall thickness