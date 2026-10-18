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
$lip_thickness = 1.5;
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
// Position: Centered on origin in X/Y relative to its own block, then shifted left.
// Box center X = -($gap/2 + $box_outer_x/2)
// Box center Y = 0
// Box center Z = $box_outer_z / 2

$box_x_pos = -($gap/2 + $box_outer_x/2);
$box_y_pos = 0;
$box_z_pos = $box_outer_z / 2;

translate([$box_x_pos, $box_y_pos, $box_z_pos])
difference() {
    // Outer Block
    cube([
        $box_outer_x, 
        $box_outer_y, 
        $box_outer_z
    ], center = true);
    
    // Cut Floor (Open Top)
    // Floor is at bottom (Z=0 relative to box). Thickness = $floor_thickness.
    // Cut from Z=0 to Z=$floor_thickness.
    translate([0, 0, 0])
    cube([
        $box_outer_x, 
        $box_outer_y, 
        $floor_thickness
    ], center = false);
    
    // Cut Side Walls (Open Top)
    // We need to cut the top face of the side walls to create the opening.
    // The opening is at the top of the box.
    // Side walls are at X = +/- $wall_thickness and Y = +/- $wall_thickness.
    // We cut a rectangle at the top surface.
    
    // Cut Left Wall Top
    translate([-($box_outer_x/2) + $wall_thickness, 0, $box_outer_z - $wall_thickness])
    cube([
        $box_outer_x - 2*$wall_thickness, 
        $wall_thickness + 0.01, // Extend slightly past wall top
        $wall_thickness + 0.01
    ], center = false);
    
    // Cut Right Wall Top
    translate([-($box_outer_x/2) - $wall_thickness, 0, $box_outer_z - $wall_thickness])
    cube([
        $box_outer_x - 2*$wall_thickness, 
        $wall_thickness + 0.01,
        $wall_thickness + 0.01
    ], center = false);
    
    // Cut Front Wall Top
    translate([0, -($box_outer_y/2) + $wall_thickness, $box_outer_z - $wall_thickness])
    cube([
        $wall_thickness + 0.01,
        $box_outer_y - 2*$wall_thickness,
        $wall_thickness + 0.01
    ], center = false);
    
    // Cut Back Wall Top
    translate([0, -($box_outer_y/2) - $wall_thickness, $box_outer_z - $wall_thickness])
    cube([
        $wall_thickness + 0.01,
        $box_outer_y - 2*$wall_thickness,
        $wall_thickness + 0.01
    ], center = false);
}

// --- Part 2: The Lid ---
// Position: To the right of the box.
// Lid center X = $gap/2 + $box_outer_x/2 + $lip_outer_x/2
// Lid center Y = 0
// Lid center Z = $plate_thickness / 2 (Since it prints upside down, the plate is on the bed, lip is up)

$lip_x_pos = $gap/2 + $box_outer_x/2 + $lip_outer_x/2;
$lip_y_pos = 0;
$lip_z_pos = $plate_thickness / 2;

translate([$lip_x_pos, $lip_y_pos, $lip_z_pos])
difference() {
    // Outer Block (Plate + Lip)
    // Total Height = Plate Thickness + Lip Height
    // Total Width = Lip Outer X
    // Total Depth = Lip Outer Y
    cube([
        $lip_outer_x, 
        $lip_outer_y, 
        $plate_thickness + $lip_height
    ], center = true);
    
    // Cut the hole for the lip to slide into the box
    // The hole is in the plate section (bottom part).
    // The lip sits on top of the plate.
    // The hole needs to be slightly larger than the lip inner dimensions to allow sliding.
    // Lip Outer X = 65.6. Lip Outer Y = 45.6.
    // Clearance = 0.2 mm per side.
    // Hole Inner X = 65.6 + 0.4 = 66.0
    // Hole Inner Y = 45.6 + 0.4 = 46.0
    
    $hole_x = $lip_outer_x + 0.4;
    $hole_y = $lip_outer_y + 0.4;
    
    // Position the hole at the bottom of the block (the plate)
    // Block bottom Z = 0. Block top Z = $plate_thickness + $lip_height.
    // Plate is from Z=0 to Z=$plate_thickness.
    // Hole is centered in X/Y, located at bottom Z.
    
    translate([0, 0, 0])
    cube([
        $hole_x, 
        $hole_y, 
        $plate_thickness + 0.01 // Extend slightly past plate top to ensure clean cut
    ], center = false);
    
    // Cut the Lip itself (the part sticking up)
    // The lip is the top part of the block.
    // Lip Outer X = 65.6, Lip Outer Y = 45.6, Lip Height = 4.
    // Lip is centered on the block.
    // Lip bottom Z = $plate_thickness. Lip top Z = $plate_thickness + $lip_height.
    
    translate([0, 0, $plate_thickness])
    cube([
        $lip_outer_x, 
        $lip_outer_y, 
        $lip_height
    ], center = false);
}