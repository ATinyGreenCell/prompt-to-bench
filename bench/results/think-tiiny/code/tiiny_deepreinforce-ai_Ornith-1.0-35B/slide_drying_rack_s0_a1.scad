// Drying rack for microscope slides
// Base block: 90 x 45 x 20 mm
// 10 slots: 77 x 1.6 x 10 mm, 3.5 mm spacing, open at top

$fn = 64;

block_x = 90;
block_y = 45;
block_z = 20;

slot_x = 77;
slot_w = 1.6;
slot_z = 10;
slot_z_cut = slot_z + 0.01; // Extend past top face to avoid coplanar faces

slot_spacing = 3.5;
num_slots = 10;

slot_y_start = -(num_slots - 1) / 2 * slot_spacing;

difference() {
    // Block sits on z=0, extends to z=20
    translate([0, 0, block_z / 2]) {
        cube([block_x, block_y, block_z], center = true);
    }
    
    // Slots cut from top (z=10 to z=20)
    for (i = [0 : num_slots - 1]) {
        slot_y = slot_y_start + i * slot_spacing;
        translate([0, slot_y, block_z - slot_z]) {
            cube([slot_x, slot_w, slot_z_cut], center = false);
        }
    }
}