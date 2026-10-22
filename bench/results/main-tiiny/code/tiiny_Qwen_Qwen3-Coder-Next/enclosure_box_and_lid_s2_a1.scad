// Enclosure design: Box (Part 1) and Lid (Part 2) side-by-side
// Units: mm

// === Box (Part 1) ===
box_outer_x = 70;
box_outer_y = 50;
box_outer_z = 30;
box_wall = 2;
box_floor = 2;
box_inner_x = box_outer_x - 2 * box_wall;
box_inner_y = box_outer_y - 2 * box_wall;
box_inner_z = box_outer_z - box_floor;

// === Lid (Part 2) ===
lid_plate_thickness = 2;
lid_lip_thickness = 1.5;
lid_lip_height = 4;
lid_lip_clearance = 0.2; // clearance on each side
lid_outer_x = box_outer_x;
lid_outer_y = box_outer_y;
lid_lip_outer_x = box_inner_x - 2 * lid_lip_clearance;
lid_lip_outer_y = box_inner_y - 2 * lid_lip_clearance;
lid_lip_inner_x = lid_lip_outer_x - 2 * lid_lip_thickness;
lid_lip_inner_y = lid_lip_outer_y - 2 * lid_lip_thickness;

// Gap between parts on bed
gap = 10;

// === Box (Part 1) ===
module box_part() {
    // Outer shell
    difference() {
        // Outer box
        cube([box_outer_x, box_outer_y, box_outer_z]);
        
        // Hollow out: inner cavity
        translate([box_wall, box_wall, box_floor])
            cube([box_inner_x, box_inner_y, box_outer_z - box_floor + 0.01]);
    }
}

// === Lid (Part 2) ===
module lid_part() {
    // Base plate
    plate = cube([lid_outer_x, lid_outer_y, lid_plate_thickness]);
    
    // Lip dimensions
    lip_x = lid_lip_outer_x;
    lip_y = lid_lip_outer_y;
    lip_z = lid_lip_height;
    lip_t = lid_lip_thickness;
    
    // Compute offset to center lip on plate
    x_off = (lid_outer_x - lip_x) / 2;
    y_off = (lid_outer_y - lip_y) / 2;
    
    // Build lip as hollow box
    lip_outer = cube([lip_x, lip_y, lip_z]);
    lip_inner = cube([lip_x - 2*lip_t, lip_y - 2*lip_t, lip_z + 0.01]);
    
    // Union plate and lip
    union() {
        plate;
        translate([x_off, y_off, lid_plate_thickness]) {
            difference() {
                cube([lip_x, lip_y, lip_z]);
                translate([lip_t, lip_t, -0.01]) 
                    cube([lip_x - 2*lip_t, lip_y - 2*lip_t, lip_z + 0.02]);
            }
        }
    }
}

// === Position parts side-by-side ===
box_x_extent = box_outer_x;
lid_x_offset = box_x_extent + gap;

// Render both parts
translate([0, 0, 0]) {
    box_part();
}

translate([lid_x_offset, 0, 0]) {
    lid_part();
}