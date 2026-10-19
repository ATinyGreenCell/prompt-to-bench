// --- Dimensions (mm) ---
plate_width = 130;          // X dimension of the base plate
plate_depth = 90;           // Y dimension of the base plate
plate_thickness = 4;        // Z thickness of the base plate
wall_height = 70;           // Height of the side walls from the plate
wall_thickness = 4;         // Thickness of the side walls
hole_diameter = 30.5;       // Diameter of the tube holes
hole_spacing_x = 40;        // Center-to-center distance along X
hole_spacing_y = 40;        // Center-to-center distance along Y
num_holes_x = 3;            // Number of holes along X axis
num_holes_y = 2;            // Number of holes along Y axis

/* 
   PRINT ORIENTATION: 
   The user specifies the part is printed "upside down" and then flipped.
   In the print orientation (z=0 is the bed):
   - The plate is at the bottom (z=0 to 4).
   - The walls rise from the plate (z=4 to 70).
   - The holes are cut through the plate.
   - The part is centered on X and Y.
*/

$fn = 64;

// --- Main Assembly ---
union() {
    // 1. The Base Plate
    cube([plate_width, plate_depth, plate_thickness], center = true);

    // 2. The Two Side Walls
    // Walls are flush with the long edges (Y edges).
    // Since the plate is centered, the Y edges are at +/- plate_depth/2.
    // The walls are 130mm long (X) and 4mm thick (Y).
    
    // Wall 1 (at Y = plate_depth/2)
    translate([0, plate_depth/2 - wall_thickness/2, plate_thickness/2 + wall_height/2])
        cube([plate_width, wall_thickness, wall_height], center = true);
    
    // Wall 2 (at Y = -plate_depth/2)
    translate([0, -plate_depth/2 + wall_thickness/2, plate_thickness/2 + wall_height/2])
        cube([plate_width, wall_thickness, wall_height], center = true);
}

// --- Cutting Operations ---
difference() {
    // We use a dummy object to perform the difference on the whole assembly
    // but since we want to cut through the plate, we apply difference to the union.
    // To keep the code clean, we wrap the union in a difference.
    
    // (This is a structural logic choice: we subtract holes from the union above)
    // However, OpenSCAD requires the difference to wrap the object.
    // Let's re-structure the logic for a clean render.
}

// --- Corrected Structure for Rendering ---
// We will use a single difference block to ensure clean geometry.

difference() {
    // The Solid Part
    union() {
        // Base Plate
        cube([plate_width, plate_depth, plate_thickness], center = true);
        
        // Wall 1
        translate([0, plate_depth/2 - wall_thickness/2, plate_thickness/2 + wall_height/2])
            cube([plate_width, wall_thickness, wall_height], center = true);
            
        // Wall 2
        translate([0, -plate_depth/2 + wall_thickness/2, plate_thickness/2 + wall_height/2])
            cube([plate_width, wall_thickness, wall_height], center = true);
    }

    // The Holes
    // Holes are centered on the plate. 
    // Plate center is (0,0,0). 
    // X-range: -(3-1)*40/2 to +(3-1)*40/2 => -40 to 40.
    // Y-range: -(2-1)*40/2 to +(2-1)*40/2 => -20 to 20.
    
    for (i = [0 : num_holes_x - 1]) {
        for (j = [0 : num_holes_y - 1]) {
            // Calculate offsets from center
            // X offset: (i - (num_holes_x-1)/2) * spacing
            // Y offset: (j - (num_holes_y-1)/2) * spacing
            x_pos = (i - (num_holes_x - 1) / 2.0) * hole_spacing_x;
            y_pos = (j - (num_holes_y - 1) / 2.0) * hole_spacing_y;
            
            translate([x_pos, y_pos, 0])
                // Cylinder extends past the plate (z=0 and z=plate_thickness)
                // Plate is centered at 0, so it spans -2 to 2.
                // We extend cylinder from -5 to 7 to ensure clean cut.
                cylinder(h = plate_thickness + 10, d = hole_diameter, center = true);
        }
    }
}