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

// --- Main Block ---
difference() {
    // Create the solid base block
    translate([0, 0, 0])
        cube([
            $base_length,
            $base_width,
            $base_height
        ]);

    // Cut 10 parallel slots
    // Slots run along X, so we cut cylinders or boxes oriented along X.
    // We use a box for the cut to ensure sharp corners and exact dimensions.
    // The cut shape extends slightly past the slot length to ensure clean removal.
    $cut_extension = 0.5; 
    
    for (i = [0 : $num_slots - 1]) {
        // Calculate Y position for the centre of the slot
        // The group is centred on the block in Y.
        // Total span of centres = (num_slots - 1) * spacing
        // Offset from centre = - (total_span / 2)
        $total_span = ($num_slots - 1) * $slot_spacing;
        $y_offset = -($total_span / 2);
        
        $slot_y = $y_offset + (i * $slot_spacing);
        
        // Define the cutting shape (Box)
        // Length along X: slot_length + extension
        // Width along Y: slot_width + extension (to ensure full cut)
        // Height along Z: slot_depth + extension (to ensure full cut)
        $cut_length = $slot_length + $cut_extension;
        $cut_width = $slot_width + $cut_extension;
        $cut_height = $slot_depth + $cut_extension;
        
        translate([
            0,              // X is centred
            $slot_y,        // Y position
            $base_height - $slot_depth // Z position: start at top face and go down
        ])
            cube([
                $cut_length,
                $cut_width,
                $cut_height
            ]);
    }
}