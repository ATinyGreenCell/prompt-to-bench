// Drying Rack for 10 Microscope Slides
// Base: 90 x 45 x 20 mm
// Slots: 10 parallel slots, 77mm long, 1.6mm wide, 10mm deep
// Spacing: 3.5mm centre-to-centre (Y)
// Orientation: Rests on XY plane at Z=0, builds upward (+Z)

// Base Dimensions
$base_length = 90;
$base_width = 45;
$base_height = 20;

// Slide Dimensions (for reference)
$slide_length = 75;
$slide_width = 25;
$slide_thickness = 1;

// Slot Dimensions
$num_slots = 10;
$slot_length = 77;
$slot_width = 1.6;
$slot_depth = 10;
$slot_spacing = 3.5; // Centre-to-centre in Y

// Extrusion quality for curved/rounded features
$fn = 64;

// Calculate slot positions
// The group of slots is centred on the block in X and Y.
// Since slots run along X, their X position is fixed at the center of the block.
// Their Y positions are calculated based on the total width and spacing.

// Total width occupied by the slots + gaps
// We need to center the entire array of 10 slots within the base width ($base_width).
// The distance from the center of the first slot to the center of the last slot is:
// (num_slots - 1) * slot_spacing
$offset_from_center = (($num_slots - 1) * $slot_spacing) / 2;

// Generate Y positions for the slots
// We iterate from -offset to +offset
for (i = [0 : $num_slots - 1]) {
    $y_pos = -($offset_from_center) + (i * $slot_spacing);
    
    // Define the slot geometry
    // The slot is a rectangular prism cut into the top face.
    // It runs along X (length $slot_length), is wide in Y ($slot_width), and deep in Z ($slot_depth).
    // Position: X is centered, Y is $y_pos, Z starts at $base_height - $slot_depth.
    
    translate([
        0, // X center
        $y_pos, // Y position
        $base_height - $slot_depth // Z start (bottom of the cut)
    ])
    difference() {
        // The cutting shape must extend slightly past the faces to ensure clean cuts
        // Extending 0.1mm in all directions
        cube([
            $slot_length + 0.1,
            $slot_width + 0.1,
            $slot_depth + 0.1
        ]);
    }
}

// Build the main solid block
translate([0, 0, 0])
cube([
    $base_length,
    $base_width,
    $base_height
]);