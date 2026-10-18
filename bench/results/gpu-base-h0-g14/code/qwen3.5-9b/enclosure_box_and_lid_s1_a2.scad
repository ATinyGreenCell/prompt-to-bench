// Two-part enclosure for small electronics board
// Part 1: Box (left)
// Part 2: Lid (right, printed upside down)
// Prints together with a 10 mm gap between them.

// --- Dimensions ---
// Box Outer Dimensions (X x Y x Z)
$box_outer_x = 70;
$box_outer_y = 50;
$box_outer_z = 30;

// Wall and Floor Thickness
$wall_thickness = 2;
$floor_thickness = 2;

// Lid Dimensions
// Plate thickness
$plate_thickness = 2;
// Lip dimensions
$lip_thickness = 1.5; // Not used in final geometry, lip height is 4
$lip_height = 4;
// Lip outer size (fits inside box opening)
$lip_outer_x = 65.6;
$lip_outer_y = 45.6;

// Clearance
// Box Inner X = 70 - 2*2 = 66
// Box Inner Y = 50 - 2 (floor) - 2 (side) = 46
// Lip Outer X = 65.6 -> Clearance = (66 - 65.6) / 2 = 0.2 mm per side
// Lip Outer Y = 45.6 -> Clearance = (46 - 45.6) / 2 = 0.2 mm per side

// Gap between parts
$gap = 10;

// --- Quality Settings ---
$fn = 64;

// --- Part 1: The Box ---
// Position: Resting on bed (Z=0).
// Center X = -($gap/2 + $box_outer_x/2) = -5 - 35 = -40.
// Center Y = 0.
// Center Z = $box_outer_z / 2 = 15.

$box_x_pos = -($gap/2 + $box_outer_x/2);
$box_y_pos = 0;
$box_z_pos = $box_outer_z / 2;

translate([$box_x_pos, $box_y_pos, $box_z_pos])
difference() {
    // Outer Block