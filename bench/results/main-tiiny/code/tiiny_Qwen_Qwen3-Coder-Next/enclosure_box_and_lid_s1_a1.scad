// Enclosure for Arduino-based temperature logger
// Part 1: Box (base)
// Part 2: Lid (with lip)

// Global settings
$fn = 64; // High resolution for curves

// Box dimensions (outer)
box_outer_x = 70;
box_outer_y = 50;
box_outer_z = 30;

// Wall and floor thickness
wall_thick = 2;
floor_thick = 2;

// Lid dimensions
lid_plate_z = 2;
lid_lip_height = 4;
lid_lip_thick = 1.5;
lid_lip_outer_x = 65.6;
lid_lip_outer_y = 45.6;
lid_clearance = 0.2; // clearance on each side

// Gap between parts for printing
gap = 10;

// Compute inner dimensions of box
box_inner_x = box_outer_x - 2 * wall_thick;
box_inner_y = box_outer_y - 2 * wall_thick;

// Positioning: Box centered at origin, lid on +X side with gap
box_x_pos = -box_outer_x / 2;
box_y_pos = 0;

// Lid plate should be 70 x 50 mm, centered on its own center
// The lip is centered on the plate, so lid plate center = lip center
lid_plate_x = box_x_pos + box_outer_x + gap + lid_lip_outer_x / 2;
lid_plate_y = lid_y_pos = 0;

// Part 1: Box (base)
module box_part() {
    // Outer shell
    difference() {
        // Outer box
        translate([box_x_pos, box_y_pos, 0])
            cube([box_outer_x, box_outer_y, box_outer_z]);
        
        // Inner cavity (hollow)
        translate([box_x_pos + wall_thick, box_y_pos + wall_thick, floor_thick])
            cube([box_inner_x, box_inner_y, box_outer_z + 0.1]);
    }
    
    // Floor (solid base)
    translate([box_x_pos, box_y_pos, 0])
        cube([box_outer_x, box_outer_y, floor_thick]);
}

// Part 2: Lid (printed upside down)
module lid_part() {
    // Plate (base of lid) - 70 x 50 x 2 mm
    // Center the plate at lid_plate_x, lid_plate_y
    plate_x = lid_plate_x - 70/2;
    plate_y = lid_plate_y - 50/2;
    translate([plate_x, plate_y, 0])
        cube([70, 50, lid_plate_z]);
    
    // Lip (upward from plate, printed upside down)
    // Lip outer dimensions: lid_lip_outer_x x lid_lip_outer_y
    // Lip thickness: lid_lip_thick
    // Lip height: lid_lip_height (exactly 4 mm)
    
    // Center the lip on the plate
    lip_x = lid_plate_x - lid_lip_outer_x / 2;
    lip_y = lid_plate_y - lid_lip_outer_y / 2;
    
    // Outer lip cube
    translate([lip_x, lip_y, lid_plate_z])
        cube([lid_lip_outer_x, lid_lip_outer_y, lid_lip_height]);
    
    // Hollow out the lip (to create the inner cavity for sliding fit)
    // Inner dimensions: lid_lip_outer_x - 2*lid_lip_thick, lid_lip_outer_y - 2*lid_lip_thick
    inner_lip_x = lip_x + lid_lip_thick;
    inner_lip_y = lip_y + lid_lip_thick;
    inner_lip_x_size = lid_lip_outer_x - 2 * lid_lip_thick;
    inner_lip_y_size = lid_lip_outer_y - 2 * lid_lip_thick;
    
    translate([inner_lip_x, inner_lip_y, lid_plate_z + 0.01])
        cube([inner_lip_x_size, inner_lip_y_size, lid_lip_height + 0.1]);
}

// Render both parts
box_part();
lid_part();