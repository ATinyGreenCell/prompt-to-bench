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
// Lid position: right edge of box + gap + half of lid width
lid_x = (box_w / 2) + gap + (lip_w / 2);
lid_y = 0;

// --- Part 1: Box ---
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
// When printed upside down, the lip is on the bed and the plate is on top
translate([lid_x, lid_y, 0]) {
    // Lip walls (on the bed)
    difference() {
        // Full lip block
        cube([lip_w, lip_d, lip_h], center = false);
        
        // Hollow center
        translate([(lip_w - lip_iw) / 2, (lip_d - lip_id) / 2, 0])
            cube([lip_iw, lip_id, lip_h + 0.01], center = false);
    }
    
    // Plate (on top of lip)
    translate([0, 0, lip_h])
        cube([lip_w, lip_d, lid_thick], center = false);
}