// Drying Rack for 10 Microscope Slides
// Base: 90 x 45 x 20 mm
// Slots: 10 parallel slots along X, 77mm long, 1.6mm wide, 10mm deep
// Spacing: 3.5 mm centre-to-centre (Y)

// Base Dimensions
$base_length = 90;
$base_width = 45;
$base_height = 20;

// Slide Dimensions (for verification)
$slide_length = 75;
$slide_width = 25;
$slide_thickness = 1;

// Slot Dimensions
$num_slots = 10;
$slot_length = 77;
$slot_width = 1.6;
$slot_depth = 10;
$slot_spacing = 3.5; // Centre-to-centre in Y

// Extrusion quality for curved corners (though slots are rectangular, good practice)
$fn = 64;

// Calculate slot positions
// Group is centred on the block in Y.
// Total width of slot group = (num_slots - 1) * spacing
// Offset from center to first slot center = (Total width / 2) - (slot_width / 2)
// Actually, simpler: Center of the first slot is at: -( (num_slots-1)*spacing / 2 ) + (spacing/2) ? 
// No, let's just calculate the offset of the first slot from the center of the block.
// The centers are at: -d, -d+s, -d+2s ... +d
// Where d is the distance from center to the first slot center.
// The span from first center to last center is (num_slots - 1) * spacing.
// The distance from the absolute center of the group to the first slot center is:
// offset = ( (num_slots - 1) * slot_spacing ) / 2 - (slot_spacing / 2) ? 
// Let's re-evaluate.
// Centers: y_0, y_1, ... y_9.
// y_0 = -y_max, y_9 = +y_max.
// y_9 - y_0 = 9 * 3.5 = 31.5.
// So y_max = 31.5 / 2 = 15.75.
// The centers are at -15.75, -12.25, ..., +15.75.
// This ensures the group is perfectly centered on the block (width 45).

$slot_center_offset = ( ($num_slots - 1) * $slot_spacing ) / 2;

// Build the base block
difference() {
    // Main Block
    cube([
        $base_length, 
        $base_width, 
        $base_height
    ]);

    // Cut Slots
    for (i = [0 : $num_slots - 1]) {
        // Calculate Y position for this slot
        $y_pos = -($slot_center_offset) + (i * $slot_spacing);
        
        // Slot geometry: 
        // Length along X: $slot_length
        // Width along Y: $slot_width
        // Depth along Z: $slot_depth
        // Position: X centered, Y at $y_pos, Z at top of block ($base_height - $slot_depth)
        
        translate([
            0, 
            $y_pos, 
            $base_height - $slot_depth
        ]) {
            cube([
                $slot_length, 
                $slot_width, 
                $slot_depth
            ]);
        }
    }
}