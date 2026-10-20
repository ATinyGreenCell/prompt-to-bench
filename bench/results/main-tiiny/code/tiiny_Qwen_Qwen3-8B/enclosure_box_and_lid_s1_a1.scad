// Variables for dimensions
box_length = 70;      // X dimension of the box
box_width = 50;      // Y dimension of the box
box_height = 30;     // Z dimension of the box
wall_thickness = 2;  // Thickness of the box walls
floor_thickness = 2; // Thickness of the floor
lid_thickness = 2;   // Thickness of the lid plate
lip_thickness = 1.5; // Thickness of the lip on the lid
lip_height = 4;      // Height of the lip on the lid
lip_outer_length = 65.6; // Outer length of the lip
lip_outer_width = 45.6;  // Outer width of the lip
gap_between_parts = 10;  // Gap between the box and the lid

// Box part: open top, 2mm walls, 2mm floor
// Create the box with walls and floor
box_base = floor_thickness;
box_wall = wall_thickness;
box = cube([box_length, box_width, box_height], center=false);

// Lid part: plate with lip, printed upside down
// Create the lid plate
lid_plate = cube([box_length, box_width, lid_thickness], center=false);

// Create the lip, which is a cube with dimensions lip_outer_length x lip_outer_width x lip_height
lip = cube([lip_outer_length, lip_outer_width, lip_height], center=false);

// Position the lip so it is centered on the lid plate and extends upward
lip_position = [ (box_length - lip_outer_length)/2, (box_width - lip_outer_width)/2, 0 ];
lip = translate(lip_position) * lip;

// Create the lid with lip
lid = union() {
  lid_plate;
  lip;
};

// Place the lid on the +X side of the box with a 10mm gap
lid_position = [box_length + gap_between_parts, 0, 0];
lid = translate(lid_position) * lid;

// Combine box and lid into a single model
final_model = union() {
  box;
  lid;
};

// Render the final model
final_model;