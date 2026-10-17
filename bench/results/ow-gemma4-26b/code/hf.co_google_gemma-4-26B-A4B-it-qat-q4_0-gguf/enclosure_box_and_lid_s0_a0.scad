// --- Parameters: Box ---
box_width = 70;          // Outer width (X)
box_depth = 50;          // Outer depth (Y)
box_height = 30;         // Outer height (Z)
box_wall_thick = 2;      // Wall thickness
box_floor_thick = 2;     // Floor thickness

// --- Parameters: Lid ---
lid_plate_thick = 2;     // Thickness of the base plate
lid_lip_thick = 1.5;     // Thickness of the vertical lip wall
lid_lip_height = 4;      // Height of the lip
lid_lip_outer_w = 65.6;  // Outer width of the lip (for clearance)
lid_lip_outer_d = 45.6;  // Outer depth of the lip (for clearance)

// --- Layout ---
gap = 10;                 // Gap between parts for printing
$fn = 64;                // Smoothness for curves

// --- Part 1: The Box ---
// Positioned at origin, resting on XY plane
module box() {
    difference() {
        // Main outer body
        cube([box_width, box_depth, box_height]);
        
        // Hollow interior
        // We subtract the interior volume, extending slightly to ensure clean cut
        translate([box_wall_thick, box_wall_thick, box_floor_thick])
            cube([
                box_width - (box_wall_thick * 2) + 0.01, 
                box_depth - (box_wall_thick * 2) + 0.01, 
                box_height // Extends past top
            ]);
    }
}

// --- Part 2: The Lid ---
// Printed upside down (lip facing down towards bed)
// Positioned on the +X side of the box
module lid() {
    // We model the lid as it sits on the bed (upside down)
    // The plate is on the bed, the lip is built "up" from the plate
    // But since it's "upside down", the lip is actually the part that 
        // would be the "top" of the lid when assembled.
    
    union() {
        // The base plate
        cube([box_width, box_depth, lid_plate_thick]);
        
        // The lip (modeled as a hollow rectangular frame)
        // To print upside down, we place the lip on top of the plate
        translate([
            (box_width - lid_lip_outer_w) / 2, 
            (box_depth - lid_lip_outer_d) / 2, 
            lid_plate_thick
        ])
        difference() {
            // Outer boundary of the lip
            cube([lid_lip_outer_w, lid_lip_outer_d, lid_lip_height]);
            
            // Inner boundary of the lip (lip_outer - 2 * lip_thick)
            translate([lid_lip_thick, lid_lip_thick, -0.01])
                cube([
                    lid_lip_outer_w - (lid_lip_thick * 2) + 0.02, 
                    lid_lip_outer_d - (lid_lip_thick * 2) + 0.02, 
                    lid_lip_height + 0.02
                ]);
        }
    }
}

// --- Assembly / Layout for Printing ---

// Render Box
translate([0, 0, 0]) 
    box();

// Render Lid (placed on +X side, flipped upside down)
// Note: The user asked for the lid to be "printed upside down" 
// and "a plate 70x50x2 lying on the bed, with a rectangular lip on top of it".
// This means the plate is the contact surface with the bed.
translate([box_width + gap, 0, 0]) 
    lid();