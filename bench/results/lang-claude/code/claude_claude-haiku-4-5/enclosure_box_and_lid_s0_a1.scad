$fn = 64;

// ===== DIMENSIONS =====

// Box (Part 1)
box_outer_x = 70;    // Outer X dimension
box_outer_y = 50;    // Outer Y dimension
box_outer_z = 30;    // Outer Z dimension
wall_thick = 2;      // Wall thickness
floor_thick = 2;     // Floor thickness

// Lid (Part 2)
lid_base_x = 70;     // Base X dimension
lid_base_y = 50;     // Base Y dimension
lid_base_z = 2;      // Base thickness
rim_outer_x = 65.6;  // Rim outer X
rim_outer_y = 45.6;  // Rim outer Y
rim_thick = 1.5;     // Rim wall thickness
rim_height = 4;      // Rim height above base

// Spacing
gap = 10;            // Gap between parts on bed for printing

// ===== MODULES =====

// Box (Part 1) - centered on X and Y
module box() {
    difference() {
        // Solid outer box
        translate([-box_outer_x/2, -box_outer_y/2, 0])
        cube([box_outer_x, box_outer_y, box_outer_z]);
        
        // Inner cavity (open top) - extends 0.5mm beyond for clean cut
        translate([-box_outer_x/2 + wall_thick, 
                   -box_outer_y/2 + wall_thick, 
                   floor_thick])
        cube([box_outer_x - 2*wall_thick, 
              box_outer_y - 2*wall_thick, 
              box_outer_z - floor_thick + 0.5]);
    }
}

// Lid (Part 2) - positioned at +X side of box
module lid() {
    lid_x_pos = box_outer_x/2 + gap;
    
    // Base plate
    translate([lid_x_pos, -lid_base_y/2, 0])
    cube([lid_base_x, lid_base_y, lid_base_z]);
    
    // Rim with inner opening
    rim_inner_x = rim_outer_x - 2*rim_thick;
    rim_inner_y = rim_outer_y - 2*rim_thick;
    offset_x = (lid_base_x - rim_outer_x) / 2;
    offset_y = (lid_base_y - rim_outer_y) / 2;
    
    difference() {
        // Solid rim
        translate([lid_x_pos + offset_x, 
                   -lid_base_y/2 + offset_y, 
                   lid_base_z])
        cube([rim_outer_x, rim_outer_y, rim_height]);
        
        // Inner opening - extends 0.5mm below and 1mm above for clean cut
        translate([lid_x_pos + offset_x + rim_thick, 
                   -lid_base_y/2 + offset_y + rim_thick, 
                   lid_base_z - 0.5])
        cube([rim_inner_x, rim_inner_y, rim_height + 1]);
    }
}

// ===== RENDERING =====

box();
lid();