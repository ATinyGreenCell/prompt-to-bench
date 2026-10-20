$fn = 64;

// --- Dimensions ---
// Part 1: The Box
box_outer_x = 70;
box_outer_y = 50;
box_outer_z = 30;
wall_thickness = 2;
floor_thickness = 2;
clearance = 0.2;

// Derived Dimensions
box_inner_x = box_outer_x - (wall_thickness * 2);
box_inner_y = box_outer_y - (wall_thickness * 2);
box_inner_z = box_outer_z - floor_thickness;

// Part 2: The Lid
lid_plate_x = 70;
lid_plate_y = 50;
lid_plate_z = 2;
lip_thickness = 1.5;
lip_height = 4;
lip_outer_x = 65.6;
lip_outer_y = 45.6;

// Derived Dimensions
lip_inner_x = lip_outer_x - (lip_thickness * 2);
lip_inner_y = lip_outer_y - (lip_thickness * 2);

// Assembly
lid_offset_x = box_outer_x + 10; // 10mm gap

module box_part() {
    // Outer Shell
    difference() {
        cube([box_outer_x, box_outer_y, box_outer_z]);
        
        // Cut out the interior
        translate([wall_thickness, wall_thickness, floor_thickness])
            cube([box_inner_x, box_inner_y, box_inner_z]);
    }
    
    // Add a small lip on the inside bottom corners for better grip
    // (Optional detail, adds 1mm to inner dimensions)
    translate([wall_thickness, wall_thickness, floor_thickness])
        cube([1, 1, box_inner_z]);
    translate([box_outer_x - wall_thickness - 1, wall_thickness, floor_thickness])
        cube([1, 1, box_inner_z]);
    translate([wall_thickness, box_outer_y - wall_thickness - 1, floor_thickness])
        cube([1, 1, box_inner_z]);
    translate([box_outer_x - wall_thickness - 1, box_outer_y - wall_thickness - 1, floor_thickness])
        cube([1, 1, box_inner_z]);
}

module lid_part() {
    // The main plate
    cube([lid_plate_x, lid_plate_y, lid_plate_z]);
    
    // The rectangular lip on top
    translate([(lid_plate_x - lip_outer_x) / 2, (lid_plate_y - lip_outer_y) / 2, lid_plate_z])
        cube([lip_outer_x, lip_outer_y, lip_height]);
}

// Render
union() {
    // Part 1: The Box
    translate([0, 0, 0])
        box_part();
    
    // Part 2: The Lid (Offset to the right)
    translate([lid_offset_x, 0, 0])
        lid_part();
}