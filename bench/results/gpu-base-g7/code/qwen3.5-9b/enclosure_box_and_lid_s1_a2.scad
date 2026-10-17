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
$clearance = 0.2;

// Gap between parts
$gap = 10;

// --- Configuration ---
$fn = 64; // Smooth curves

// --- Part 1: The Box ---
// Position: Centered in Y, starts at X = -($box_outer_x/2 + $gap/2)
// Rests on Z=0
translate([ -($box_outer_x/2 + $gap/2), 0, 0 ])
difference() {
    // Outer block
    cube([ $box_outer_x, $box_outer_y, $box_outer_z ]);
    
    // Cut out the inside (open top)
    // Inner dimensions:
    // X: outer_x - 2*wall
    // Y: outer_y - 2*wall
    // Z: outer_z - floor (cut all the way to the bottom of the box walls)
    inner_x = $box_outer_x - (2 * $wall_thickness);
    inner_y = $box_outer_y - (2 * $wall_thickness);
    inner_z = $box_outer_z - $floor_thickness;
    
    // Extend cut slightly past the bottom face to ensure no thin walls remain at the very bottom edge
    translate([0, 0, -0.1]) 
    cube([ inner_x, inner_y, inner_z + 0.1 ]);
}

// --- Part 2: The Lid ---
// Position: Centered in Y, starts at X = +($box_outer_x/2 + $gap/2)
// Rests on Z=0 (printed upside down as requested)
// The lid geometry is modeled with the plate at Z=0 and the lip extending upwards.
translate([ $box_outer_x/2 + $gap/2, 0, 0 ])
difference() {
    // Base Plate
    cube([ $box_outer_x, $box_outer_y, $plate_thickness ]);
    
    // Cut out the hole for the lip
    // The lip outer size is $lip_outer_x by $lip_outer_y.
    // We need to cut a hole slightly larger than the lip outer size to allow it to slide in.
    // Clearance on each side is 0.2mm.
    // Hole X = lip_outer_x + 2*clearance
    // Hole Y = lip_outer_y + 2*clearance
    hole_x = $lip_outer_x + (2 * $clearance);
    hole_y = $lip_outer_y + (2 * $clearance);
    
    // Depth = lip_height + lip_thickness (to remove the material the lip will sit on)
    // We extend the cut slightly past the top of the lip to ensure clean separation.
    hole_depth = $lip_height + $lip_thickness + 0.1;
    
    // The cut starts from the bottom of the plate (Z=0) and goes up through the plate and the lip.
    cube([ hole_x, hole_y, hole_depth ]);
}