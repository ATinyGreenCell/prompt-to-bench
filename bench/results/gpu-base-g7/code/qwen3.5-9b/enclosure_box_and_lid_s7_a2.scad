// Two-part enclosure for small electronics board
// Part 1: Box (left)
// Part 2: Lid (right, printed upside down)
// Prints together with a 10 mm gap.

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
// Lip dimensions (height and wall thickness)
$lip_height = 4;
$lip_wall_thickness = 1.5;
// Lip outer size (X x Y)
$lip_outer_x = 65.6;
$lip_outer_y = 45.6;

// Clearance
$clearance = 0.2;

// Gap between parts
$gap = 10;

// --- Configuration ---
// Set global resolution for curved shapes
$fn = 64;

// --- Part 1: The Box ---
// Position: Centered on its own footprint, then shifted left by half gap
// Footprint: $box_outer_x * $box_outer_y
translate([-($gap/2) - ($box_outer_x/2), -($box_outer_y/2), 0])
difference() {
    // Outer Box
    cube([
        $box_outer_x, 
        $box_outer_y, 
        $box_outer_z
    ]);
    
    // Inner Void (to create walls and floor)
    // Inner X = Outer X - 2*Wall
    // Inner Y = Outer Y - 2*Wall
    // Inner Z = Outer Z - Floor (Top is open)
    translate([
        $wall_thickness, 
        $wall_thickness, 
        0
    ])
    cube([
        $box_outer_x - (2 * $wall_thickness),
        $box_outer_y - (2 * $wall_thickness),
        $box_outer_z - $floor_thickness
    ]);
}

// --- Part 2: The Lid ---
// Position: Centered on its own footprint (the Plate), then shifted right by half gap + box width
// Footprint: $box_outer_x * $box_outer_y (70 x 50)
// The lip (65.6 x 45.6) is centered within this plate.
translate([
    $gap + ($box_outer_x/2), 
    -($box_outer_y/2), // FIXED: Center based on Plate Y (50), not Lip Y (45.6)
    0
])
difference() {
    // 1. The Main Plate (70x50x2)
    cube([
        $box_outer_x, // 70
        $box_outer_y, // 50
        $plate_thickness // 2
    ]);
    
    // 2. The Lip Void
    // We need to remove the material inside the lip dimensions to create the hole.
    // Lip Outer: 65.6 x 45.6
    // Lip Wall: 1.5
    // Lip Height: 4
    
    // Calculate Lip Inner Dimensions
    $lip_inner_x = $lip_outer_x - (2 * $lip_wall_thickness);
    $lip_inner_y = $lip_outer_y - (2 * $lip_wall_thickness);
    
    // The void starts at Z = $plate_thickness and goes up by $lip_height
    translate([
        ($lip_outer_x/2) - $lip_wall_thickness, // Center X
        ($lip_outer_y/2) - $lip_wall_thickness, // Center Y
        $plate_thickness // Start at top of plate
    ])
    cube([
        $lip_inner_x,
        $lip_inner_y,
        $lip_height
    ]);
    
    // 3. Cut the Lip Wall Material (to make the hole round/clean and ensure fit)
    // We cut a shape slightly larger than the inner lip dimensions to ensure the 0.2mm clearance is respected
    // and the hole is clean.
    // Target inner size for the hole: Lip Outer - 2*Clearance
    $cut_x = $lip_outer_x - (2 * $clearance);
    $cut_y = $lip_outer_y - (2 * $clearance);
    
    translate([
        ($lip_outer_x/2) - ($cut_x/2),
        ($lip_outer_y/2) - ($cut_y/2),
        $plate_thickness
    ])
    cube([
        $cut_x,
        $cut_y,
        $lip_height + 0.1 // Extend slightly past lip height to ensure clean cut
    ]);
}