// Two-part enclosure for small electronics board
// Part 1: Box (left)
// Part 2: Lid (right, printed upside down)
// Prints together with a 10 mm gap.

$fn = 128;

// --- Dimensions ---

// Box Dimensions (Outer)
BOX_X = 70;
BOX_Y = 50;
BOX_Z = 30;

// Wall and Floor Thickness
WALL_THICK = 2;
FLOOR_THICK = 2;

// Gap between parts
PART_GAP = 10;

// Lid Dimensions
// Plate thickness
LID_PLATE_THICK = 2;
// Lip dimensions
LIP_WALL_THICK = 1.5;
LIP_HEIGHT = 4;
// Lip outer size (matches box opening + clearance)
LIP_X_OUT = 65.6;
LIP_Y_OUT = 45.6;

// --- Helper Functions ---

// Create the Box (Part 1)
// Oriented: Rests on XY, builds +Z. Centred on origin.
module create_box() {
    // Calculate inner dimensions
    inner_x = BOX_X - 2*WALL_THICK;
    inner_y = BOX_Y - 2*WALL_THICK;
    inner_z = BOX_Z - FLOOR_THICK; // Open top

    // Build box using difference to ensure clean walls
    difference() {
        // Outer block
        cube([BOX_X, BOX_Y, BOX_Z], center = true);
        
        // Cut out the inside (open top)
        // The hole goes from z=0 to z=inner_z relative to the box center.
        // Box center Z is BOX_Z/2.
        // Hole bottom Z = BOX_Z/2 - inner_z/2 = (BOX_Z - inner_z)/2 = FLOOR_THICK/2.
        // Hole top Z = BOX_Z/2 + inner_z/2.
        
        translate([
            -inner_x/2, 
            -inner_y/2, 
            FLOOR_THICK/2
        ]) {
            cube([inner_x, inner_y, inner_z + 0.1], center = true);
        }
    }
}

// Create the Lid (Part 2)
// Oriented: Printed upside down. 
// This means the plate lies on the bed (XY), and the lip extends UPWARDS (+Z) 
// so that when flipped, the lip goes down into the box.
module create_lid() {
    // Plate dimensions
    plate_x = BOX_X;
    plate_y = BOX_Y;
    plate_z = LID_PLATE_THICK;

    // Lip dimensions (Outer)
    lip_x_out = LIP_X_OUT;
    lip_y_out = LIP_Y_OUT;
    lip_z = LIP_HEIGHT;
    lip_w = LIP_WALL_THICK;

    // Lip Inner dimensions (to match the cutout)
    lip_x_in = lip_x_out - 2*lip_w;
    lip_y_in = lip_y_out - 2*lip_w;

    difference() {
        // 1. The main plate
        cube([plate_x, plate_y, plate_z], center = true);

        // 2. The Lip (cut out from the plate volume)
        // We subtract the volume of the lip channel.
        // The channel is defined by the inner void and the side walls.
        
        // Start cutting from the top surface of the plate
        cut_z_start = plate_z;
        
        // Inner Void (the hole)
        translate([
            -lip_x_in/2, 
            -lip_y_in/2, 
            cut_z_start
        ]) {
            cube([lip_x_in, lip_y_in, lip_z + 0.1], center = true);
        }
        
        // Side Walls (Left and Right relative to X)
        // Wall 1 (Left)
        translate([
            -lip_x_out/2 - lip_w/2, 
            -lip_y_out/2, 
            cut_z_start
        ]) {
            cube([lip_w, lip_y_out, lip_z + 0.1], center = true);
        }
        // Wall 2 (Right)
        translate([
            lip_x_out/2 - lip_w/2, 
            -lip_y_out/2, 
            cut_z_start
        ]) {
            cube([lip_w, lip_y_out, lip_z + 0.1], center = true);
        }
        
        // Side Walls (Front and Back relative to Y)
        // Wall 3 (Front)
        translate([
            -lip_x_out/2, 
            -lip_y_out/2 - lip_w/2, 
            cut_z_start
        ]) {
            cube([lip_x_out, lip_w, lip_z + 0.1], center = true);
        }
        // Wall 4 (Back)
        translate([
            -lip_x_out/2, 
            lip_y_out/2 - lip_w/2, 
            cut_z_start
        ]) {
            cube([lip_x_out, lip_w, lip_z + 0.1], center = true);
        }
    }
}

// --- Assembly ---

// Positioning:
// Box is centered at origin.
// Lid is placed on the +X side with a 10mm gap.
// Box center X = 0. Box right edge = 35.
// Gap = 10.
// Lid left edge should be at 35 + 10 = 45.
// Lid center X = 45 + (LIP_X_OUT / 2) = 45 + 32.8 = 77.8.

translate([0, 0, 0]) {
    create_box();
}

translate([
    BOX_X/2 + PART_GAP + LIP_X_OUT/2, 
    0, 
    0
]) {
    create_lid();
}