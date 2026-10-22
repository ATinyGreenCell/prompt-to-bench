// Dimensions for DIY Magnetic Stirrer Housing
// Units: mm

// Overall Dimensions
outer_x = 90;
outer_y = 90;
wall_thickness = 2.5;
top_plate_thickness = 2;

// Fan Mounting Pattern
fan_hole_spacing = 71.5;
fan_hole_diameter = 4.5;
fan_hole_offset = (fan_hole_spacing - fan_hole_diameter) / 2;

// Cable Notch
notch_width = 12;
notch_depth = 8;
notch_z_start = 32; // From open edge (z=40) downwards

// Derived Dimensions
inner_x = outer_x - (wall_thickness * 2);
inner_y = outer_y - (wall_thickness * 2);
inner_z = 40;

// Fan hole coordinates (centered on 0,0)
fan_holes = [
    [-fan_hole_offset, -fan_hole_offset],
    [fan_hole_offset, -fan_hole_offset],
    [-fan_hole_offset, fan_hole_offset],
    [fan_hole_offset, fan_hole_offset]
];

$fn = 64;

// Main Housing Assembly
module stirrer_housing() {
    union() {
        // 1. Top Plate (Base)
        // The prompt specifies the top plate lies on the bed (z=0 to 2).
        // We model it centered at z=0.
        translate([0, 0, 0])
            cube([outer_x, outer_y, top_plate_thickness], center = true);

        // 2. Walls
        // The prompt specifies walls rise from the top plate to z=40.
        // We model the walls starting at z=0.
        
        // Create the solid block for walls
        wall_block_x = outer_x;
        wall_block_y = outer_y;
        
        // We need to cut the top plate out of the walls, so we start with
        // a block that includes the top plate thickness, then subtract it.
        // However, the prompt says "walls rise from it". 
        // To ensure the top plate is exactly 2mm thick and walls start at z=0,
        // we will model the walls starting at z=0.
        
        // Wall Block (Full height)
        translate([0, 0, 0])
            cube([wall_block_x, wall_block_y, inner_z], center = true);

        // Cut out the top plate from the wall block
        // This creates the cavity where the top plate sits, leaving the walls
        // rising from z=0.
        translate([0, 0, top_plate_thickness / 2])
            cube([outer_x, outer_y, top_plate_thickness + 0.1], center = true);

        // 3. Fan Mounting Holes
        // Cut holes through the top plate and walls
        for (pos = fan_holes) {
            translate([pos[0], pos[1], top_plate_thickness / 2])
                cylinder(d = fan_hole_diameter + 0.1, h = top_plate_thickness + 0.1, center = true);
        }

        // 4. Cable Notch
        // Located on one wall (e.g., the wall at +Y)
        // The notch is 12mm wide, centered along the wall.
        // It reaches 8mm down from the open edge (z=40).
        // So it spans z = 32 to 40.
        
        // Position the notch on the +Y wall
        // The wall is at y = outer_y/2 - wall_thickness/2
        notch_y_pos = (outer_y / 2) - (wall_thickness / 2);
        
        // The notch is centered along the wall (X axis)
        notch_x_pos = 0;
        
        // The notch depth is 8mm. 
        // Since the wall thickness is 2.5mm, the notch cuts through the wall.
        // We cut a rectangular slot.
        
        translate([notch_x_pos, notch_y_pos, 0]) {
            // We cut a slot that goes from z=0 up to z=40.
            // But we only want it to be 8mm deep (32 to 40).
            // We cut a tall slot and then subtract the bottom part.
            
            // Cut the tall slot
            translate([0, 0, 0])
                cube([notch_width, wall_thickness + 0.1, inner_z], center = true);
            
            // Subtract the bottom part to make it 8mm deep
            translate([0, 0, (inner_z - notch_depth) / 2])
                cube([notch_width + 0.1, wall_thickness + 0.2, notch_depth + 0.1], center = true);
        }
    }
}

// Render the part
stirrer_housing();