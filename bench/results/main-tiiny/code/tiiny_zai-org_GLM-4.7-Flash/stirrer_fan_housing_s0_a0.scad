// Dimensions for DIY Magnetic Stirrer Housing
// Units: mm

// Outer dimensions
outer_x = 90;
outer_y = 90;
wall_thickness = 2.5;
top_plate_thickness = 2;

// Fan mounting holes
hole_diameter = 4.5;
hole_spacing_x = 71.5;
hole_spacing_y = 71.5;

// Power cable notch
notch_width = 12;
notch_depth = 8;
notch_z_start = 32; // From z = 32 to z = 40

// Rendering
$fn = 64;

// Main Housing Assembly
module housing() {
    union() {
        // 1. Top Plate (Base of the print)
        translate([0, 0, 0])
            cube([outer_x, outer_y, top_plate_thickness], center = true);

        // 2. Four Walls
        // We model the walls as 2.5mm thick blocks rising from the plate
        // The box is open at the top (z = 40)
        wall_height = 40;

        // Wall 1 (Positive X side)
        translate([(outer_x / 2) - (wall_thickness / 2), 0, top_plate_thickness / 2])
            cube([wall_thickness, outer_y, wall_height], center = true);

        // Wall 2 (Negative X side)
        translate([-(outer_x / 2) - (wall_thickness / 2), 0, top_plate_thickness / 2])
            cube([wall_thickness, outer_y, wall_height], center = true);

        // Wall 3 (Positive Y side)
        translate([0, (outer_y / 2) - (wall_thickness / 2), top_plate_thickness / 2])
            cube([outer_x, wall_thickness, wall_height], center = true);

        // Wall 4 (Negative Y side)
        translate([0, -(outer_y / 2) - (wall_thickness / 2), top_plate_thickness / 2])
            cube([outer_x, wall_thickness, wall_height], center = true);
    }
}

// Cutout Logic
module cutouts() {
    // 3. Fan Mounting Holes (M4)
    // Pattern is a 71.5mm square centered on the plate
    // We drill through the top plate and the walls
    for (x = [-1, 1]) {
        for (y = [-1, 1]) {
            translate([
                x * (hole_spacing_x / 2),
                y * (hole_spacing_y / 2),
                0
            ]) {
                // Hole through the top plate
                cylinder(d = hole_diameter, h = top_plate_thickness + 1, center = true);
                
                // Hole through the walls
                // We use a slightly larger radius to ensure we cut through the 2.5mm walls cleanly
                // The walls are centered at +/- 43.75mm (90/2 - 2.5/2)
                // The holes are at +/- 35.75mm (71.5/2)
                // Distance from wall center to hole center is 8mm
                // The hole radius is 2.25mm. The wall thickness is 2.5mm.
                // 2.25 + 2.25 = 4.5mm > 2.5mm. The hole overlaps the wall.
                
                // We cut a rectangular slot through the wall thickness
                // The hole is centered at (x * 35.75, y * 35.75)
                // The wall is centered at (x * 43.75, 0)
                // We translate the hole to the wall center
                translate([x * (hole_spacing_x / 2 - outer_x / 2 + wall_thickness / 2), 0, 0])
                    cylinder(d = hole_diameter, h = wall_height + 1, center = true);
            }
        }
    }

    // 4. Power Cable Notch
    // Located on one wall (e.g., Positive Y side)
    // 12mm wide, centered along the wall
    // Reaches 8mm down from the open edge (z = 32 to z = 40)
    
    // The Positive Y wall is centered at (0, outer_y/2, top_plate_thickness/2)
    // The notch is centered along the wall (y = 0)
    // The notch is 12mm wide (x = -6 to 6)
    // The notch starts at z = 32 and goes to z = 40
    
    translate([0, (outer_y / 2) - (wall_thickness / 2), top_plate_thickness / 2])
        cube([
            notch_width, 
            wall_thickness, 
            notch_depth
        ], center = true);
}

// Final Part
difference() {
    housing();
    cutouts();
}