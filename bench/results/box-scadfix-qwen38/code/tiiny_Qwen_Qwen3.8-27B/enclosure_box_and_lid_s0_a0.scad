// Two-part enclosure for a small electronics board (Arduino temperature logger)
// Part 1: Box (bottom) - 70 x 50 x 30 mm, 2 mm walls, 2 mm floor, open top
// Part 2: Lid - 70 x 50 x 2 mm plate with 1.5 mm thick, 4 mm tall lip (65.6 x 45.6 mm outer)
// Both parts printed side by side with 10 mm gap, lid on +X side of box

// ==================== DIMENSIONS ====================

// Box dimensions
box_outer_x = 70;    // Box outer width (X)
box_outer_y = 50;    // Box outer depth (Y)
box_outer_z = 30;    // Box outer height (Z)
box_wall = 2;        // Box wall thickness
box_floor = 2;       // Box floor thickness

// Lid dimensions
lid_plate_x = 70;    // Lid plate width (X)
lid_plate_y = 50;    // Lid plate depth (Y)
lid_plate_z = 2;     // Lid plate thickness (Z)
lip_wall = 1.5;      // Lip wall thickness
lip_height = 4;      // Lip height
lip_outer_x = 65.6;  // Lip outer width (X) - 0.2 mm clearance each side vs box inner (66 mm)
lip_outer_y = 45.6;  // Lip outer depth (Y) - 0.2 mm clearance each side vs box inner (46 mm)

// Layout
gap = 10;            // Gap between box and lid

// ==================== BOX (Part 1) ====================
// Centered on origin in X and Y, rests on z=0

module box() {
    // Outer box
    difference() {
        // Outer solid
        translate([-box_outer_x/2, -box_outer_y/2, 0])
            cube([box_outer_x, box_outer_y, box_outer_z], center=false);
        
        // Inner cavity (open top)
        // Inner dimensions: outer - 2*wall for X and Y, floor for Z
        inner_x = box_outer_x - 2 * box_wall;
        inner_y = box_outer_y - 2 * box_wall;
        inner_z = box_outer_z - box_floor;
        
        // Cut from top, so extend 1 mm above to ensure clean cut
        translate([-inner_x/2, -inner_y/2, box_floor])
            cube([inner_x, inner_y, inner_z + 1], center=false);
    }
}

// ==================== LID (Part 2) ====================
// Printed upside down: plate on bed, lip on top
// Centered on origin in X and Y, rests on z=0

module lid() {
    union() {
        // Plate (base)
        translate([-lid_plate_x/2, -lid_plate_y/2, 0])
            cube([lid_plate_x, lid_plate_y, lid_plate_z], center=false);
        
        // Lip (rectangular wall on top of plate)
        // Lip outer: lip_outer_x x lip_outer_y, height lip_height
        // Lip inner: lip_outer_x - 2*lip_wall x lip_outer_y - 2*lip_wall
        // The lip is a hollow rectangular frame
        difference() {
            // Outer lip solid
            translate([-lip_outer_x/2, -lip_outer_y/2, lid_plate_z])
                cube([lip_outer_x, lip_outer_y, lip_height], center=false);
            
            // Inner lip cavity (hollow center)
            lip_inner_x = lip_outer_x - 2 * lip_wall;
            lip_inner_y = lip_outer_y - 2 * lip_wall;
            
            // Cut through the lip, extend 1 mm above to ensure clean cut
            translate([-lip_inner_x/2, -lip_inner_y/2, lid_plate_z])
                cube([lip_inner_x, lip_inner_y, lip_height + 1], center=false);
        }
    }
}

// ==================== LAYOUT ====================
// Box centered at origin
// Lid on +X side with 10 mm gap
// Box right edge at x = box_outer_x/2 = 35
// Lid left edge at x = 35 + gap = 45
// Lid center at x = 45 + lid_plate_x/2 = 45 + 35 = 80

$fn = 64;

// Part 1: Box at origin
box();

// Part 2: Lid on +X side
translate([box_outer_x/2 + gap + lid_plate_x/2, 0, 0])
    lid();