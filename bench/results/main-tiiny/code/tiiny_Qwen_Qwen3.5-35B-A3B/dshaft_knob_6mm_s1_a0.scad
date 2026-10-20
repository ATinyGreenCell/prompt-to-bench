// Dimensions for Hotplate Stirrer Knob Replacement
// All units in millimetres (mm)

// Main knob dimensions
knob_diameter = 30;
knob_height = 15;

// D-shaft bore dimensions
shaft_diameter = 6;
bore_diameter = 6.2;
bore_depth = 12;
bore_flat_width = 4.7; // Distance from flat to opposite side of circle

// Grip groove dimensions
groove_count = 18;
groove_diameter = 2;
groove_depth = 1; // Half of groove diameter for half-cylinder cut

// Pointer groove dimensions
pointer_width = 1.5;
pointer_depth = 1;

// Safety margin for cutting operations
cut_margin = 0.5;

// Calculate radius and half-widths
knob_radius = knob_diameter / 2;
bore_radius = bore_diameter / 2;
bore_flat_half_width = bore_flat_width / 2;
groove_radius = groove_diameter / 2;
pointer_half_width = pointer_width / 2;

// Center the knob on the XY plane
translate([0, 0, 0]) {
    // 1. Create the main cylinder body
    // The knob rests on the bed (z=0) and builds upward
    cylinder(h = knob_height, r = knob_radius, $fn = 64);
    
    // 2. Create the D-shaped blind bore
    // The bore is a 6.2mm circle with one side cut flat.
    // The flat is on the side facing the "pointer" side (positive X for simplicity).
    // The distance from flat to opposite side is 4.7mm.
    // We create a cylinder for the circle and subtract a rectangular prism for the flat.
    
    // The bore is centered at X=0, Y=0, Z=0 (bottom of bore) to Z=12 (top of bore).
    // The flat side is at X = (4.7 - 6.2)/2 = -1.25? No.
    // Let's re-orient: The flat is on the "pointer" side.
    // If the pointer is on the positive X side, the flat is on the positive X side.
    // The circle is 6.2mm diameter. The flat cuts off the side.
    // Distance from flat to opposite side = 4.7mm.
    // This means the flat is at X = 6.2 - 4.7 = 1.5mm from the center?
    // No, the distance from the flat surface to the farthest point on the circle is 4.7mm.
    // The diameter is 6.2mm. The flat cuts the circle.
    // If the flat is at X = x_flat, the farthest point is at X = -6.2/2 = -3.1.
    // Distance = x_flat - (-3.1) = 4.7 => x_flat = 1.6mm.
    // Let's verify: Flat at X=1.6. Circle extends from -3.1 to 3.1.
    // Distance from flat (1.6) to far side (-3.1) is 4.7. Correct.
    // So the flat is at X = 1.6mm.
    
    // Create the bore cylinder (slightly larger than shaft)
    // We will use difference to cut the bore into the main knob.
    // The bore is a cylinder of 6.2mm diameter, 12mm high.
    // But we need to cut the flat side.
    
    // We create a "D-shape" by taking a cylinder and subtracting a rectangular prism.
    // The rectangular prism must be large enough to cut through the cylinder.
    
    // Bore cylinder
    bore_cyl = translate([0, 0, 0]) {
        cylinder(h = bore_depth, r = bore_radius, $fn = 64);
    };
    
    // Flat cut plane
    // The flat is at X = 1.6mm. We need to cut everything to the right of this.
    // We use a large box to subtract.
    flat_cut = translate([1.6, 0, 0]) {
        cube([10, 10, bore_depth + cut_margin], center = true);
    };
    
    // Combine bore shape
    bore_shape = difference() {
        bore_cyl;
        flat_cut;
    };
    
    // Subtract the bore from the main knob
    difference() {
        // Main knob body (already drawn, but we need to subtract from it)
        // We will do the subtraction in the final union/difference block
        // Actually, let's build the final object by subtracting features from the main cylinder.
    }
    
    // Let's restructure: Build the main cylinder, then subtract the bore and grooves.
    // We need to be careful with the order of operations.
    
    // Main body
    main_body = cylinder(h = knob_height, r = knob_radius, $fn = 64);
    
    // 2. Subtract the D-shaped bore
    // The bore is a cylinder of 6.2mm diameter, 12mm high.
    // The flat is at X = 1.6mm (calculated above: 6.2 - 4.7 = 1.5? Wait.
    // Distance from flat to opposite side is 4.7.
    // If flat is at X = f, opposite side is at X = -3.1.
    // f - (-3.1) = 4.7 => f = 1.6. Correct.
    // So the flat is at X = 1.6.
    
    // Create the bore cutter
    bore_cutter = translate([0, 0, 0]) {
        // Cylinder for the circle part
        cylinder(h = bore_depth, r = bore_radius, $fn = 64);
    };
    
    // Create the flat cutter
    // We need to cut the cylinder at X = 1.6.
    // The flat cutter is a box that covers the right side of the cylinder.
    flat_cutter = translate([1.6, 0, 0]) {
        cube([10, 10, bore_depth + cut_margin], center = true);
    };
    
    // The actual bore shape is the cylinder minus the flat cutter.
    // But we are subtracting from the main body.
    // So we subtract the union of the cylinder and the flat cutter?
    // No, we subtract the shape that represents the void.
    // The void is the cylinder minus the part that is "flat".
    // Actually, the void is a D-shape.
    // We can model the void as a cylinder with a flat cut.
    // To subtract this from the main body, we subtract the cylinder and then add back the flat part?
    // No, simpler: Subtract the cylinder, then subtract the flat cut?
    // No, the flat cut is part of the void.
    // The void is the cylinder minus the "flat" part? No.
    // The void is the D-shape.
    // The D-shape is a cylinder with one side cut flat.
    // To create this void, we can subtract a cylinder and then subtract a box that cuts the flat?
    // No, if we subtract a cylinder, we have a round hole.
    // Then we subtract a box that cuts the flat side?
    // If we subtract a box from the round hole, we get a D-shape.
    // Yes.
    
    // So:
    // 1. Subtract a cylinder (6.2mm diameter, 12mm high) from the main body.
    // 2. Subtract a box (to create the flat) from the resulting hole.
    
    // Wait, the flat is on the "pointer" side.
    // The pointer is on the same side as the flat.
    // So the flat is at X = 1.6.
    // The box to cut the flat should be at X = 1.6.
    
    // Let's do the subtraction properly.
    // We will subtract the bore shape from the main body.
    // Bore shape = Cylinder - FlatCut? No.
    // Bore shape = Cylinder with a flat side.
    // To subtract this, we subtract the cylinder and then subtract the flat cut?
    // No, if we subtract the cylinder, we have a round hole.
    // Then we subtract a box that cuts the flat side?
    // If we subtract a box from the round hole, we get a D-shape.
    // Yes.
    
    // So:
    // difference() {
    //   main_body;
    //   union() {
    //     cylinder(h = bore_depth, r = bore_radius, $fn = 64);
    //     // Flat cutter box
    //     translate([1.6, 0, 0]) {
    //