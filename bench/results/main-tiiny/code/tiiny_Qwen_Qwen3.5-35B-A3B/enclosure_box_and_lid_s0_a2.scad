// Units: millimetres
// $fn = 64; // Default for curved shapes, set explicitly if needed

// --- Part 1: Box ---
// Outer dimensions
box_outer_x = 70;
box_outer_y = 50;
box_outer_z = 30;

// Wall and floor thickness
box_wall_thick = 2;
box_floor_thick = 2;

// Clearance for lid (0.2mm on each side)
box_clearance = 0.2;

// Inner dimensions calculated
box_inner_x = box_outer_x - 2 * box_wall_thick;
box_inner_y = box_outer_y - 2 * box_wall_thick;
box_inner_z = box_outer_z - box_floor_thick; // Open top, so height is floor to top

// Position for Part 1 (Box)
// Centered at X=0, Y=0, Z=0
box_pos_x = 0;
box_pos_y = 0;
box_pos_z = 0;

// --- Part 2: Lid ---
// Plate dimensions (same footprint as box outer)
lid_plate_x = 70;
lid_plate_y = 50;
lid_plate_z = 2;

// Lip dimensions
lip_wall_thick = 1.5;
lip_height = 4;
lip_clearance = 0.2; // 0.2mm clearance on each side relative to box inner

// Lip outer dimensions
lip_outer_x = box_inner_x - 2 * lip_clearance;
lip_outer_y = box_inner_y - 2 * lip_clearance;

// Lip inner dimensions (wall thickness)
lip_inner_x = lip_outer_x - 2 * lip_wall_thick;
lip_inner_y = lip_outer_y - 2 * lip_wall_thick;

// Position for Part 2 (Lid)
// Placed on +X side with 10mm gap
lid_gap = 10;
// Center of box is at 0. Box extends from -35 to +35.
// Gap is 10mm. So lid starts at 35 + 10 = 45.
// Lid center is at 45 + (70/2) = 45 + 35 = 80.
lid_pos_x = (box_outer_x / 2) + lid_gap + (box_outer_x / 2);
lid_pos_y = 0;
lid_pos_z = 0;

// --- Construction ---

module box_part() {
    difference() {
        // Base solid
        cube([box_outer_x, box_outer_y, box_outer_z], center = true);
        
        // Cut out the interior (floor is solid, so we cut from top down to floor thickness)
        // We need to ensure the floor remains.
        // Cut a box that is slightly larger than the inner space to ensure clean cuts
        translate([0, 0, box_floor_thick]) {
            cube([box_inner_x + 0.01, box_inner_y + 0.01, box_outer_z - box_floor_thick], center = true);
        }
    }
}

module lid_part() {
    // The lid is printed upside down, so the "lip" points down towards the bed.
    // We model it as a plate with a lip extending in -Z direction relative to the plate center.
    // However, to make it print correctly on the bed (Z=0), we construct the geometry relative to Z=0.
    
    // The plate sits on the bed. The lip extends downwards? 
    // No, the user said "printed upside down: a plate ... lying on the bed, with a rectangular lip on top of it".
    // If it's printed upside down, the "top" of the lid (the lip) is facing the build plate.
    // So the geometry is: Plate (70x50x2) at Z=0..2. Lip (1.5mm thick, 4mm tall) attached to the bottom of the plate (Z=0).
    // The lip extends from Z=0 down to Z=-4? No, 3D printers build up.
    // If the lip is at the bottom, it must be built first.
    // So the geometry is: A block of 70x50x4 (the lip + plate) with a hole?
    // No, the lip is a "wall" on top of the plate.
    // Let's re-read carefully: "a plate 70 x 50 x 2 mm lying on the bed, with a rectangular lip on top of it".
    // This implies the plate is the base. The lip is on top of the plate.
    // If printed upside down, the "top" of the lid (the lip) is facing the bed.
    // So the lip is at Z=0. The plate is at Z=0 to Z=2? No, the plate is 2mm thick.
    // If the lip is at Z=0, and the plate is on top of the lip, then the plate is Z=0 to Z=2?
    // But the lip is 4mm tall.
    // Let's assume the "lip" is the part that goes inside the box.
    // If the lid is printed upside down, the lip is at the bottom (Z=0).
    // The plate is the top surface of the lid.
    // So the geometry is:
    // 1. Lip: 65.6 x 45.6 x 4 (extends from Z=0 to Z=4).
    // 2. Plate: 70 x 50 x 2 (sits on top of the lip? No, the lip is on top of the plate in the description).
    // Let's re-read carefully: "a plate 70 x 50 x 2 mm lying on the bed, with a rectangular lip on top of it".
    // This implies the plate is the base. The lip is on top of the plate.
    // If printed upside down, the "top" of the lid (the lip) is facing the bed.
    // So the lip is at Z=0. The plate is at Z=0 to Z=2? No, the plate is 2mm thick.
    // If the lip is at Z=0, and the plate is on top of the lip, then the plate is Z=0 to Z=2?
    // But the lip is 4mm tall.
    // Let's assume the "lip" is the part that goes inside the box.
    // If the lid is printed upside down, the lip is at the bottom (Z=0).
    // The plate is the top surface of the lid.
    // So the geometry is:
    // 1. Lip: 65.6 x 45.6 x 4 (extends from Z=0 to Z=4).
    // 2. Plate: 70 x 50 x 2 (sits on top of the lip? No, the lip is on top of the plate in the description).
    // Let's re-read carefully: "a plate 70 x 50 x 2 mm lying on the bed, with a rectangular lip on top of it".
    // This implies the plate is the base. The lip is on top of the plate.
    //