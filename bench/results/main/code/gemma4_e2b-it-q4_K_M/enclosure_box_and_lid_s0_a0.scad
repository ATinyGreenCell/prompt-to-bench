// --- Dimensions ---
// Box dimensions (Outer)
box_x = 70; // Outer X dimension of the box (mm)
box_y = 50; // Outer Y dimension of the box (mm)
box_z = 30; // Outer Z dimension of the box (mm)

// Box wall thickness and floor thickness
wall_thickness = 2; // Wall thickness of the box (mm)
floor_thickness = 2; // Thickness of the floor (mm)

// Lid dimensions
lid_plate_x = 70; // Plate X dimension of the lid (mm)
lid_plate_y = 50; // Plate Y dimension of the lid (mm)
lid_plate_z = 2; // Plate thickness of the lid (mm)

// Lid lip dimensions
lip_wall_thickness = 1.5; // Thickness of the lip wall (mm)
lip_height = 4; // Height of the lip (mm)
lip_outer_x = 65.6; // Outer X dimension of the lip (mm)
lip_outer_y = 45.6; // Outer Y dimension of the lip (mm)

// Spacing and clearance
gap_spacing = 10; // Gap between the two parts on the bed (mm)
lid_clearance = 0.2; // Clearance for lid insertion (mm)

// --- Part 1: The Box ---
module box() {
    // Outer dimensions of the box
    outer_x = box_x;
    outer_y = box_y;
    outer_z = box_z;

    // Inner dimensions calculation
    inner_x = outer_x - 2 * wall_thickness;
    inner_y = outer_y - 2 * wall_thickness;
    inner_z = outer_z - floor_thickness; // Since it's open top, the internal cavity height is Z - floor thickness

    // Base (Floor)
    translate([0, 0, 0])
        cube([outer_x, outer_y, floor_thickness], center = true);

    // Walls (Building up from the floor)
    // Front/Back walls (X direction)
    color("blue")
    translate([0, 0, floor_thickness])
        cube([wall_thickness, inner_y, outer_z - floor_thickness], center = true);

    // Left/Right walls (Y direction)
    translate([outer_x - wall_thickness, 0, floor_thickness])
        cube([wall_thickness, inner_y, outer_z - floor_thickness], center = true);

    // Top rim (Since it's open top, we just define the outer boundary for structure)
    // We use difference to cut out the internal void if we were building a solid block first, 
    // but here we build the walls explicitly.

    // To ensure clean walls and floor:
    // 1. Start with the full outer volume (optional, easier to manage cuts)
    // 2. Subtract the inner void.

    // Let's redefine using subtraction for cleaner geometry based on required thickness:
    difference() {
        // Outer solid block
        cube([outer_x, outer_y, outer_z], center = true);

        // Inner void (The space inside)
        translate([wall_thickness, wall_thickness, floor_thickness])
            cube([inner_x, inner_y, outer_z - floor_thickness - wall_thickness], center = true);
    }
}

// --- Part 2: The Lid ---
module lid() {
    // Plate (Base of the lid)
    color("red")
    translate([0, 0, 0])
        cube([lid_plate_x, lid_plate_y, lid_plate_z], center = true);

    // Lip (The raised part that fits into the box)
    // The lip is printed upside down relative to its final placement.
    // We build it on top of the plate.
    translate([0, 0, lid_plate_z]) {
        color("red")
        // The lip structure itself (a rectangular block with a raised section)
        // Since the description implies a wall structure:
        
        // Base plate dimensions for reference (70x50)
        // Lip outer dimensions (65.6 x 45.6) centered on the plate (70x50)
        
        // Calculate placement offset for centering the lip on the plate
        offset_x = (lid_plate_x - lip_outer_x) / 2; // (70 - 65.6) / 2 = 2.2
        offset_y = (lid_plate_y - lip_outer_y) / 2; // (50 - 45.6) / 2 = 2.2

        // The lip structure is a rectangular prism that rises up.
        // We define the solid part of the lip wall.
        
        // Since it's a wall, we model the outer shape and subtract the inner void.
        
        difference() {
            // Outer shape of the lip (Height = lip_height)
            translate([offset_x, offset_y, 0])
                cube([lip_outer_x, lip_outer_y, lip_height], center = true);

            // Inner void to create the wall thickness (1.5 mm)
            translate([offset_x + lip_wall_thickness, offset_y + lip_wall_thickness, 0])
                cube([lip_outer_x - 2 * lip_wall_thickness, lip_outer_y - 2 * lip_wall_thickness, lip_height], center = true);
        }
    }
}

// --- Assembly and Placement ---

// Position Box at origin (0, 0)
translate([0, 0, 0]) {
    box();
}

// Position Lid on the +X side of the box, separated by gap_spacing
translate([box_x + gap_spacing, 0, 0]) {
    lid();
}