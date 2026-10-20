// Define dimensions
box_length = 70;        // X dimension of the box
box_width = 50;         // Y dimension of the box
box_height = 30;        // Z dimension of the box
wall_thickness = 2;     // Thickness of the box walls
floor_thickness = 2;    // Thickness of the box floor
lid_thickness = 2;     // Thickness of the lid plate
lip_thickness = 1.5;   // Thickness of the lip on the lid
lip_height = 4;        // Height of the lip on the lid
lip_outer_length = 65.6; // Outer length of the lip
lip_outer_width = 45.6; // Outer width of the lip
gap_between_parts = 10; // Gap between the box and the lid

// Create the box part
box = cube([box_length, box_width, box_height], center=false);

// Create the floor of the box
floor = cube([box_length, box_width, floor_thickness], center=false);

// Create the lid plate (printed upside down)
lid_plate = cube([box_length, box_width, lid_thickness], center=false);

// Create the lip of the lid (slightly smaller to allow clearance)
lip = cube([lip_outer_length, lip_outer_width, lip_height], center=false);

// Position the box at origin
box_position = [0, 0, 0];

// Position the lid plate on the +X side of the box with a 10 mm gap
lid_position = [box_length + gap_between_parts, 0, 0];

// Combine the box and floor into a single part
box_with_floor = union() {
    box;
    translate([0, 0, -floor_thickness]) floor;
}

// Combine the lid plate and lip into a single part
lid_with_lip = union() {
    translate(lid_position) lid_plate;
    translate([lid_position[0] + (box_length - lip_outer_length)/2, 
               lid_position[1] + (box_width - lip_outer_width)/2, 
               lid_position[2] + lid_thickness - lip_height]) lip;
}

// Final assembly: box and lid
final_enclosure = union() {
    box_with_floor;
    lid_with_lip;
}

// Render the final enclosure
final_enclosure;