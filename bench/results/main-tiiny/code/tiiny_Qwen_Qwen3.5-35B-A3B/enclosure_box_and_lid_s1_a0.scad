// Dimensions for the electronics enclosure
// Part 1: Box
$box_outer_x = 70;
$box_outer_y = 50;
$box_outer_z = 30;
$box_wall_thickness = 2;
$box_floor_thickness = 2;

// Part 2: Lid
$lid_plate_thickness = 2;
$lid_lip_thickness = 1.5;
$lid_lip_height = 4;
$lid_lip_outer_x = 65.6;
$lid_lip_outer_y = 45.6;

// Spacing between parts
$gap = 10;

// Print orientation: XY plane, Z up
$fn = 64;

// --- Part 1: The Box ---
module box() {
    // Calculate inner dimensions
    $box_inner_x = $box_outer_x - 2 * $box_wall_thickness;
    $box_inner_y = $box_outer_y - 2 * $box_wall_thickness;
    $box_inner_z = $box_outer_z - $box_floor_thickness;

    // Base plate
    translate([0, 0, 0])
        cube([$box_outer_x, $box_outer_y, $box_floor_thickness]);

    // Walls (4 sides)
    // Front wall (Y negative)
    translate([0, $box_wall_thickness, $box_floor_thickness])
        cube([$box_outer_x, $box_outer_y - 2 * $box_wall_thickness, $box_inner_z]);
    
    // Back wall (Y positive)
    translate([0, $box_outer_y - $box_wall_thickness, $box_floor_thickness])
        cube([$box_outer_x, $box_outer_y - 2 * $box_wall_thickness, $box_inner_z]);

    // Left wall (X negative)
    translate([$box_wall_thickness, 0, $box_floor_thickness])
        cube([$box_outer_x - 2 * $box_wall_thickness, $box_outer_y, $box_inner_z]);

    // Right wall (X positive)
    translate([$box_outer_x - $box_wall_thickness, 0, $box_floor_thickness])
        cube([$box_outer_x - 2 * $box_wall_thickness, $box_outer_y, $box_inner_z]);
}

// --- Part 2: The Lid ---
module lid() {
    // Calculate inner dimensions of the lip to ensure fit
    // The lip outer size is 65.6 x 45.6.
    // The lip thickness is 1.5.
    // The lip height is 4.
    
    // Base plate
    translate([0, 0, 0])
        cube([$box_outer_x, $box_outer_y, $lid_plate_thickness]);

    // Lip structure
    // Centered on the plate
    translate([
        ($box_outer_x - $lid_lip_outer_x) / 2,
        ($box_outer_y - $lid_lip_outer_y) / 2,
        $lid_plate_thickness
    ])
    // Create the hollow lip by subtracting the inner volume from a solid block
    // We use a difference operation to create the hollow channel
    difference() {
        // Solid block representing the lip outer dimensions
        cube([$lid_lip_outer_x, $lid_lip_outer_y, $lid_lip_height]);
        
        // Cutout for the hollow channel
        // Inner dimensions of the lip
        $lip_inner_x = $lid_lip_outer_x - 2 * $lid_lip_thickness;
        $lip_inner_y = $lid_lip_outer_y - 2 * $lid_lip_thickness;
        
        // Cutout extends slightly past the top to ensure clean edges
        translate([
            ($lid_lip_outer_x - $lip_inner_x) / 2,
            ($lid_lip_outer_y - $lip_inner_y) / 2,
            0
        ])
        cube([$lip_inner_x, $lip_inner_y, $lid_lip_height + 0.01]);
    }
}

// --- Assembly ---
// Place Box at origin (0,0,0)
translate([0, 0, 0])
    box();

// Place Lid on the +X side with 10mm gap
// Box center X is 0, Lid center X will be (Box Width/2 + Gap/2 + Lid Width/2)
// Actually, simpler: Box is at 0. Lid needs to be shifted.
// Box extends from -35 to +35 in X.
// Lid extends from -35 to +35 in X (relative to its center).
// Gap is 10mm.
// So Lid center X = Box Right Edge + Gap + (Lid Width / 2)
// Box Right Edge = 35.
// Lid Center X = 35 + 10 + 25 = 70.
// Wait, let's re-verify the "side by side" logic.
// Box: X range [-35, 35].
// Gap: 10mm.
// Lid: X range [35 + 10 - 25, 35 + 10 + 25] = [20, 70].
// Center of Lid = (20 + 70) / 2 = 45.
// Let's calculate the translation explicitly.
$box_half_x = $box_outer_x / 2;
$lid_half_x = $box_outer_x / 2; // Lid plate is same width as box
$center_x = $box_half_x + $gap + $lid_half_x;

translate([$center_x, 0, 0])
    lid();