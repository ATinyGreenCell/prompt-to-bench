// Dimensions for the box and lid
box_outer_x = 70;
box_outer_y = 50;
box_outer_z = 30;
wall_thickness = 2;
floor_thickness = 2;

lid_plate_x = 70;
lid_plate_y = 50;
lid_plate_z = 2;

lip_outer_x = 65.6;
lip_outer_y = 45.6;
lip_thickness = 1.5;
lip_height = 4;

gap = 10;

// Calculate derived dimensions
box_inner_x = box_outer_x - 2 * wall_thickness;
box_inner_y = box_outer_y - 2 * wall_thickness;
box_inner_z = box_outer_z - floor_thickness;

// Position offsets to place parts side by side with a 10mm gap
// Box is centered at origin (0,0,0) in XY, sitting on z=0
// Lid is placed on +X side.
// Box extends from -35 to +35 in X.
// Gap is 10mm.
// Lid plate is 70mm wide. Center of lid should be at 35 + 10 + 35 = 80mm in X.
lid_offset_x = box_outer_x / 2 + gap + lid_plate_x / 2;

$fn = 64;

// Part 1: The Box
translate([-box_outer_x/2, -box_outer_y/2, 0]) {
    difference() {
        // Outer shell
        cube([box_outer_x, box_outer_y, box_outer_z]);
        
        // Inner cavity (open top)
        // Extend slightly past the top to ensure clean cut
        translate([wall_thickness, wall_thickness, -0.01]) 
            cube([box_inner_x, box_inner_y, box_inner_z + 0.02]);
    }
}

// Part 2: The Lid (Printed Upside Down)
// The lid consists of a plate and a lip.
// Printed upside down means the plate is on the bed (z=0).
// The lip is "on top" of the plate in the print orientation, meaning it builds up from z=2.
// However, the description says "lip on top of it... slides into the box".
// When printed upside down, the lip will be pointing UP in the print orientation.
// When flipped over for use, the lip will point DOWN into the box.
// The lip outer size is 65.6 x 45.6.
// The lip is centred on the plate.

translate([lid_offset_x - lid_plate_x/2, -lid_plate_y/2, 0]) {
    difference() {
        union() {
            // Plate
            cube([lid_plate_x, lid_plate_y, lid_plate_z]);
            
            // Lip (solid block)
            // Calculate offsets for the lip relative to the plate's bottom-left corner
            // These variables must be defined BEFORE they are used in translate()
            lip_offset_x = (lid_plate_x - lip_outer_x) / 2;
            lip_offset_y = (lid_plate_y - lip_outer_y) / 2;
            
            translate([lip_offset_x, lip_offset_y, lid_plate_z]) {
                cube([lip_outer_x, lip_outer_y, lip_height]);
            }
        }
        
        // Cut out the inside of the lip
        // Inner dimensions of the lip wall:
        inner_lip_x = lip_outer_x - 2 * lip_thickness;
        inner_lip_y = lip_outer_y - 2 * lip_thickness;
        
        // Position of the inner cutout:
        // It starts at the same XY offset as the outer lip, plus the wall thickness.
        cut_offset_x = lip_offset_x + lip_thickness;
        cut_offset_y = lip_offset_y + lip_thickness;
        
        // The cutout starts at the top of the plate (z = lid_plate_z) and goes through the lip.
        // Extend slightly past the top of the lip (z = lid_plate_z + lip_height) to ensure clean cut.
        translate([cut_offset_x, cut_offset_y, lid_plate_z - 0.01]) {
            cube([inner_lip_x, inner_lip_y, lip_height + 0.02]);
        }
    }
}