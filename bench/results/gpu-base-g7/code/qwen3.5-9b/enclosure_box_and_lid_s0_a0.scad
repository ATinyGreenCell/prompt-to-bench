// Two-part enclosure for small electronics board
// Part 1: Box (left)
// Part 2: Lid (right, printed upside down)
// Prints together with a 10mm gap between them.

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
// Box inner size calculation
$box_inner_x = $box_outer_x - (2 * $wall_thickness);
$box_inner_y = $box_outer_y - (2 * $wall_thickness);
$box_inner_z = $box_outer_z - $floor_thickness;

// Lid lip inner size (should match box inner size with 0.2mm clearance total -> 0.1mm per side)
// Box inner: 66 x 46
// Lip outer: 65.6 x 45.6
// Lip inner: 65.6 - 2*1.5 = 62.6 x 45.6 - 2*1.5 = 42.6
// Wait, let's re-read the prompt carefully.
// "lip ... whose outer size is 65.6 x 45.6 mm, centred on the plate, so it slides into the box opening with 0.2 mm clearance on each side."
// Box Inner X = 70 - 4 = 66.
// Box Inner Y = 50 - 4 = 46.
// Lip Outer X = 65.6. Clearance X = (66 - 65.6) / 2 = 0.2. Correct.
// Lip Outer Y = 45.6. Clearance Y = (46 - 45.6) / 2 = 0.2. Correct.
// Lip Inner X = 65.6 - 2 * 1.5 = 62.6.
// Lip Inner Y = 45.6 - 2 * 1.5 = 42.6.
// This creates a very tight fit for the electronics inside the lip, but that is what the prompt specified.

// Placement
// Box rests at origin, centered in X/Y? Prompt says "centre it on the origin in X and Y".
// Lid is on the +X side of the box with a 10mm gap.
// Box Center X = 0. Box Extent X = -35 to +35.
// Gap = 10mm.
// Lid Center X = 35 + 10 = 45.
// Lid Center Y = 0.

$box_center_x = 0;
$box_center_y = 0;
$box_center_z = 0; // Floor is at Z=0

$gap = 10;
$lid_center_x = $box_center_x + ($box_outer_x / 2) + $gap;
$lid_center_y = $box_center_y;

// --- Configuration ---
$fn = 64;

module box() {
    translate([$box_center_x, $box_center_y, 0]) {
        // Build the box from the bottom up
        // Floor
        cube([
            $box_outer_x, 
            $box_outer_y, 
            $floor_thickness
        ]);
        
        // Walls (using difference to cut out the interior)
        // We extrude a solid block that covers the top, then subtract the inner void.
        // To ensure no coplanar faces, we extend the cutting shape slightly.
        $cut_extend = 0.05;
        
        // Calculate inner void dimensions
        $void_x = $box_inner_x;
        $void_y = $box_inner_y;
        $void_z = $box_outer_z - $floor_thickness;
        
        // Position of the void cutter:
        // It needs to start just above the floor and extend slightly past the top.
        translate([
            -$box_outer_x/2 + $wall_thickness + $cut_extend/2,
            -$box_outer_y/2 + $wall_thickness + $cut_extend/2,
            $floor_thickness - $cut_extend/2
        ]) {
            cube([
                $void_x + $cut_extend,
                $void_y + $cut_extend,
                $void_z + $cut_extend
            ]);
        }
    }
}

module lid() {
    // The lid is printed upside down.
    // It consists of a plate and a lip.
    // We model it as a single solid block (Plate + Lip) and then rotate it 180 around X to print upside down.
    
    // Base dimensions of the combined shape (Plate + Lip)
    // The plate is 70x50. The lip sits on top of it.
    // The lip outer size is 65.6 x 45.6.
    // The lip is centered on the plate.
    
    // Combined block dimensions:
    // X: 70
    // Y: 50
    // Z: $plate_thickness + $lip_height
    
    translate([$lid_center_x, $lid_center_y, 0]) {
        // Create the combined block
        cube([
            $box_outer_x, // 70
            $box_outer_y, // 50
            $plate_thickness + $lip_height
        ]);
        
        // Cut out the hole for the electronics inside the lip
        // The hole goes through the lip thickness.
        // Hole dimensions: Lip Inner X x Lip Inner Y
        $hole_x = $lip_outer_x - (2 * $lip_thickness);
        $hole_y = $lip_outer_y - (2 * $lip_thickness);
        
        // Position of the hole cutter
        // It starts at the bottom of the lip (which is $plate_thickness from the bottom of the block)
        // and extends slightly past the top of the lip.
        $lip_bottom_z = $plate_thickness;
        $lip_top_z = $plate_thickness + $lip_height;
        
        translate([
            -$lip_outer_x/2 + $lip_thickness + 0.05, // Extend past walls
            -$lip_outer_y/2 + $lip_thickness + 0.05,
            $lip_bottom_z - 0.05
        ]) {
            cube([
                $hole_x + 0.1,
                $hole_y + 0.1,
                $lip_height + 0.1
            ]);
        }
        
        // Cut out the hole for the plate itself (if the electronics are larger than the lip inner, 
        // or if we want to see the plate surface). 
        // The prompt implies the electronics go into the lip. The plate is just a cover.
        // However, usually, you want to see the board through the plate or have a hole.
        // The prompt says "slides into the box opening". The box opening is 66x46.
        // The lip outer is 65.6x45.6.
        // The plate is 70x50.
        // So the plate overhangs the lip. The electronics go into the lip.
        // Do we need a hole in the plate? The prompt doesn't explicitly ask for a hole in the plate,
        // just a lip that slides in. I will leave the plate solid as described, 
        // but the lip hole allows access to the board inside the box.
    }
    
    // Rotate 180 degrees around X to print upside down
    rotate([180, 0, 0]) {
        // The module above built the shape in its "upside down" state relative to the final print?
        // No, the prompt says "printed upside down: a plate ... lying on the bed".
        // This means the flat face of the plate is on the bed (Z=0).
        // My module `lid` currently builds the shape with the plate at the bottom (Z=0) and lip on top.
        // If I rotate this 180 around X, the lip will be at the bottom and the plate on top.
        // That is NOT what we want.
        // We want the plate on the bed.
        // So the shape I built in `lid` (Plate at bottom, Lip on top) is the correct orientation for printing IF the part is upright.
        // But the prompt says "printed upside down".
        // Usually "printed upside down" for a lid means the part is inverted so the lip is at the bottom to snap into the box?
        // Let's re-read: "Part 2, the lid, printed upside down: a plate 70 x 50