// --- Dimensions ---
// Outer box width (X)
box_w = 70;
// Outer box depth (Y)
box_d = 50;
// Outer box height (Z)
box_h = 30;
// Wall thickness
wall = 2;
// Floor thickness
floor = 2;
// Lid plate thickness
lid_thick = 2;
// Lip wall thickness
lip_wall = 1.5;
// Lip height
lip_h = 4;
// Lip outer width (X)
lip_w = 65.6;
// Lip outer depth (Y)
lip_d = 45.6;
// Gap between parts on bed
gap = 10;

// Derived dimensions
// Inner box width
box_iw = box_w - 2 * wall;
// Inner box depth
box_id = box_d - 2 * wall;
// Inner box height (usable)
box_ih = box_h - floor;

// Lip inner width (for clearance)
lip_iw = lip_w - 2 * lip_wall;
// Lip inner depth (for clearance)
lip_id = lip_d - 2 * lip_wall;

// Position offsets to place parts side by side
// Box centered at origin in X, lid to the right
box_x = 0;
box_y = 0;
lid_x = (box_w / 2) + (gap / 2) + (lip_w / 2);
lid_y = 0;

// --- Part 1: Box ---
translate([box_x, box_y, 0]) {
    // Outer shell
    difference() {
        // Full outer block
        cube([box_w, box_d, box_h], center = false);
        
        // Hollow out the inside (extend past bottom to cut through floor)
        translate([wall, wall, -0.01])
            cube([box_iw, box_id, box_h + 0.02], center = false);
    }
    
    // Floor (already created by the difference above, but let's ensure it's solid)
    // The difference above creates a box with floor thickness = wall (since we cut from z=0)
    // We need to add floor material below the cut
    // Actually, let's rebuild: outer block minus inner block starting from floor height
    // Let's redo this properly
}

// Let's rebuild Part 1 properly
translate([box_x, box_y, 0]) {
    difference() {
        // Outer solid block
        cube([box_w, box_d, box_h], center = false);
        
        // Inner cavity (starts at floor height, extends up)
        translate([wall, wall, floor])
            cube([box_iw, box_id, box_h - floor + 0.01], center = false);
    }
}

// --- Part 2: Lid (printed upside down) ---
translate([lid_x, lid_y, 0]) {
    // Plate (base)
    cube([lip_w, lip_d, lid_thick], center = false);
    
    // Lip walls (extruding upward from the plate)
    // Since lid is printed upside down, the lip will be on top when flipped
    // The lip is a hollow rectangular frame
    
    // Outer lip shape
    difference() {
        // Full lip block
        translate([0, 0, lid_thick])
            cube([lip_w, lip_d, lip_h], center = false);
        
        // Hollow center
        translate([(lip_w - lip_iw) / 2, (lip_d - lip_id) / 2, lid_thick])
            cube([lip_iw, lip_id, lip_h + 0.01], center = false);
    }
}