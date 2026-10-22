// Dimensions
box_width = 70;
box_height = 50;
box_depth = 30;
box_wall = 2;
box_floor = 2;

lid_width = 70;
lid_height = 50;
lid_depth = 2;
lid_wall = 1.5;
lid_lip_height = 4;
lid_lip_width = 65.6;
lid_lip_clearance = 0.2;

// Box
box = differenceunion() [
    cube_size([box_width, box_height, box_depth], center=true) - 
    cube_size([box_width - 2*box_wall, box_height - 2*box_wall, box_depth - box_floor], center=true)
];

// Lid
lid = differenceunion() [
    cube_size([lid_width, lid_height, lid_depth], center=true) - 
    cube_size([lid_width - 2*lid_wall, lid_height - 2*lid_wall, lid_depth], center=true) - 
    cube_size([lid_lip_width + 2*lid_lip_clearance, lid_lip_height, lid_depth], center=true) - 
    cube_size([lid_lip_width + 2*lid_lip_clearance, lid_lip_height, lid_depth], center=true, translate=[(lid_width - lid_lip_width)/2, (lid_height - lid_lip_height)/2, 0])
];

// Final model
difference() {
    translate([0, 0, 0]) box
    // Gap between parts
    // translate([box_width + 10, 0, 0]) lid
    // Uncomment the line above to print the lid on the +X side of the box
    // If you want both parts to print together, comment out the line above and uncomment the line below
    // translate([box_width + 10, 0, 0]) lid
    // translate([box_width + 10, 0, 0]) lid
    // translate([box_width + 10, 0, 0]) lid
    // translate([box_width + 10, 0, 0]) lid
    // translate([box_width + 10, 0, 0]) lid
    // translate([box_width + 10, 0, 0]) lid
    // translate([box_width + 10, 0, 0]) lid
    // translate([box_width + 10, 0, 0]) lid
    // translate([box_width + 10, 0, 0]) lid
    // translate([box_width + 10, 0, 0]) lid
    // translate([box_width + 10, 0, 0]) lid
    // translate([box_width + 10,