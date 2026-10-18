// Two-part enclosure for electronics board.
// Part 1: Box (left) - 70x50x30mm outer, 2mm walls/floor, open top.
// Part 2: Lid (right) - 70x50x2mm plate with 4mm tall lip (1.5mm wall), 
// placed on +X side with 10mm gap.

// Dimensions
box_outer_x = 70;
box_outer_y = 50;
box_outer_z = 30;
wall_thick  = 2;
floor_thick = 2;

// Lid dimensions
lid_plate_z = 2;
lip_height  = 4;
lip_wall    = 1.5;
lip_outer_x = 65.6;
lip_outer_y = 45.6;

// Gap between parts
gap = 10;

// Clearances for the lip to slide into the box
// Box inner width = 50 - 2*2 = 46
// Lip outer width = 45.6
// Clearance = (46 - 45.6) / 2 = 0.2 mm
clearance = 0.2;

$fn = 64;

// --- Part 1: The Box ---
// Constructed by taking a solid block and subtracting the empty space.
// The empty space is the inner volume plus the top opening.

difference() {
    // Main solid block
    translate([-box_outer_x/2, -box_outer_y/2, 0]) 
        cube([box_outer_x, box_outer_y, box_outer_z]);
    
    // Cut out the interior
    // Inner dimensions:
    // X: 70 - 2*2 = 66
    // Y: 50 - 2*2 = 46
    // Z: 30 - 2 (floor) = 28
    translate([-box_outer_x/2 + wall_thick, -box_outer_y/2 + wall_thick, floor_thick])
        cube([box_outer_x - 2*wall_thick, box_outer_y - 2*wall_thick, box_outer_z - floor_thick]);
}

// --- Part 2: The Lid ---
// Constructed as a plate with a raised lip.
// The lip is a wall of thickness 1.5mm and height 4mm.
// Outer size of lip: 65.6 x 45.6.
// Inner size of lip (hole): 65.6 - 2*1.5 = 62.6 x 45.6 - 2*1.5 = 42.6.

difference() {
    // Base plate
    translate([-box_outer_x/2, -box_outer_y/2, 0])
        cube([box_outer_x, box_outer_y, lid_plate_z]);
    
    // The Lip (raised part)
    // We create a solid block for the lip and cut the hole through it.
    // Lip outer size: 65.6 x 45.6
    // Lip height: 4mm
    // Lip wall: 1.5mm
    
    // Solid block for the lip
    translate([-box_outer_x/2, -box_outer_y/2, lid_plate_z])
        cube([lip_outer_x, lip_outer_y, lip_height]);
    
    // Hole in the lip
    // Inner dimensions:
    // X: 65.6 - 2*1.5 = 62.6
    // Y: 45.6 - 2*1.5 = 42.6
    translate([-box_outer_x/2, -box_outer_y/2, lid_plate_z])
        cube([lip_outer_x - 2*lip_wall, lip_outer_y - 2*lip_wall, lip_height]);
}

// --- Assembly ---
// Place the box at the origin.
// Place the lid on the +X side with a 10mm gap.
// Box width is 70, so the right face is at X = 35.
// Lid left face should be at X = 35 + 10 = 45.
// Lid center X = 45 + 70/2 = 80.

translate([0, 0, 0])
    part1_box();

translate([gap + box_outer_x/2, 0, 0])
    part2_lid();

// Helper modules to keep the code clean and avoid re-defining geometry twice
module part1_box() {
    difference() {
        translate([-box_outer_x/2, -box_outer_y/2, 0]) 
            cube([box_outer_x, box_outer_y, box_outer_z]);
        
        translate([-box_outer_x/2 + wall_thick, -box_outer_y/2 + wall_thick, floor_thick])
            cube([box_outer_x - 2*wall_thick, box_outer_y - 2*wall_thick, box_outer_z - floor_thick]);
    }
}

module part2_lid() {
    difference() {
        translate([-box_outer_x/2, -box_outer_y/2, 0])
            cube([box_outer_x, box_outer_y, lid_plate_z]);
        
        translate([-box_outer_x/2, -box_outer_y/2, lid_plate_z])
            cube([lip_outer_x, lip_outer_y, lip_height]);
        
        translate([-box_outer_x/2, -box_outer_y/2, lid_plate_z])
            cube([lip_outer_x - 2*lip_wall, lip_outer_y - 2*lip_wall, lip_height]);
    }
}