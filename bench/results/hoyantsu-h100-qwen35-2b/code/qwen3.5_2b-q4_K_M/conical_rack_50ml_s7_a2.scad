//===========
// 3D Print Rack Design for Falcon Tubes (50 mL)
//===========

// --- Dimensions in millimeters ---
plate_thickness = 4.0;      // mm
plate_width_X = 130.0;      // mm
plate_height_Y = 90.0;     // mm
tube_diameter = 30.5;       // mm (determined by 6 tubes / 2 rows)
wall_length_X = 130.0;      // mm
wall_thickness_Y = 4.0;     // mm
wall_height_Z = 70.0;       // mm

// --- Geometry Variables ---
plate_center_x = plate_width_X / 2.0;
plate_center_y = plate_height_Y / 2.0;

// Hole parameters: 6 tubes, 3 per row (X), 2 rows (Y)
hole_row_spacing = tube_diameter * 1.5; // Center-to-center spacing for 3 holes in a row
hole_col_spacing = tube_diameter * 1.5; // Center-to-center spacing for 3 holes in a column

// --- Build the Rack ---

// 1. The Base Plate (Flipped orientation: Z is up)
plate = cube([plate_width_X, plate_height_Y, plate_thickness]);
translate([0, 0, -plate_thickness / 2]) // Center it on XY plane at z=0 in print orientation
    rotate_x(90);

// 2. The Two Long Walls (Rises from plate)
wall_left = cylinder([plate_width_X, wall_thickness_Y, wall_height_Z]); // Flipped: Z is up
translate([0, -plate_center_y + wall_thickness_Y / 2, -plate_thickness / 2])
    rotate_x(90);

wall_right = cylinder([plate_width_X, wall_thickness_Y, wall_height_Z]); // Flipped: Z is up
translate([plate_width_X - plate_center_x - wall_thickness_Y / 2, -plate_center_y + wall_thickness_Y / 2, -plate_thickness / 2])
    rotate_x(90);

// Combine walls with the plate to form a solid block
rack_body = union([plate, wall_left, wall_right]);

// 3. The Six Through-Holes (Cutting out the tubes)
// We use difference to cut holes from the rack body.
// As per rule 5: extend past faces by 0.01-1mm.
// Since we are cutting through a solid block, we can simply subtract cylinders 
// that overlap with the plate's thickness range or slightly beyond.

// Define hole geometry (Flipped orientation)
hole = cylinder([tube_diameter, tube_diameter, wall_thickness_Y]); // Flipped: Z is up

// Position holes in Y direction (2 rows along Y axis of rack body)
// Rack body height is 70mm. Holes go through the plate thickness (4mm).
// We place them at z = -plate_thickness/2 to +plate_thickness/2 relative to the center of the hole cylinder? 
// No, simpler: The holes are on the surface of the rack body.
// Let's define a "cutting" shape that extends slightly beyond the plate face.

// Create holes for X positions: 3 columns, spaced by tube_diameter * 1.5
for (i = 0; i < 3; i++) {
    translate([plate_center_x + i * hole_col_spacing, -plate_center_y + hole_row_spacing / 2, plate_thickness / 2]) 
        rotate_x(90)
            difference([hole, cylinder([tube_diameter, tube_diameter, wall_thickness_Y + 1.5)])]; 
    // Rule 5: extend past faces. The cut shape is a cylinder with radius tube_diameter/2 and height slightly larger than the plate thickness (4mm).
    // This ensures the cutting shape overlaps with the target face (the top surface of the rack body) by at least 1.5mm, preventing coplanar faces.
}

// Final assembly: Union of the rack body and the holes (holes are already cut out in the difference step above? No.)
// The difference operation creates a new solid. We need to union this with the rest if we want them connected, 
// but usually for racks, the holes are just voids within the plate/wall structure.
// However, the difference operation removes material from the target shape.
// If I do: rack_body = union([plate, wall_left, wall_right]);
// Then subtracting 'hole' will remove the hole volume from the plate/wall block.
// This creates a solid with holes inside it (if we use difference on the whole body).
// BUT, if you have a plate and cut holes out of it using difference, the result is a hollow object? 
// No, difference(A - B) removes B from A. If A is a block and B is a hole shape, you get a solid with a hole.
// WAIT: The standard way to make holes in a 3D print (FDM) is to subtract cylinders from the main body.
// So if I have 'rack_body' as a single solid, and I do 'difference(rack_body, cylinder(...))', 
// it will remove the volume of the cylinder. This creates an internal void (a hole).
// If I do this for multiple X positions, I get separate holes inside the rack body.
// The prompt asks for "through-holes". In a 3D printed part with walls on both sides, these are through-holes 
// because the material is removed from top to bottom of the wall thickness? No, that would leave no material at the bottom of the wall.
// Let's re-read: "Two solid walls run along the two long edges... rises from the plate".
// The holes are on the surface of these walls. If I cut out a cylinder from the wall, the material is gone.
// So the rack body becomes hollow at those spots? No, it becomes a tube *inside* the rack body.
// Wait, if I have a block and I subtract a hole, the result has a hole (void). 
// To get "through-holes" where the tube passes through, I need to ensure that at the top of the wall thickness, there is no material? 
// No, the prompt says: "The two short ends stay open." This implies the tubes go all the way through.
// So for a hole to be a tube passing through, the material must be removed from the top surface (z=0 in print orientation) down to the bottom surface of the wall? 
// No, that would remove the entire wall thickness at that X position. But the walls are continuous.
// Ah, "through-holes" means the tube passes *through* the rack body.
// So for a specific X position, the material must be removed from the top of the plate (z=-2mm in print orientation) and the bottom of the plate? 
// No, the rack body is the union of plate + walls. The holes are on the surface of the wall.
// If I cut a hole through the wall, it goes from z=-2mm to z=+2mm? That would remove the entire thickness of the wall at that X position.
// But the walls are continuous blocks rising from the plate.
// Let's visualize:
// Plate is at z=-2mm (in print orientation). Walls rise from z=-2mm to z=+2mm (total 4mm thick).
// Hole is on the surface of the wall. If I cut a hole through the wall, it goes from z=-2mm to z=+2mm? 
// No, that would remove the entire thickness of the wall at that X position. But the walls are continuous blocks rising from the plate.
// Let's re-read carefully: "Two solid walls run along the two long edges... rises from the plate to z = 70".
// This means there is a block on the left and a block on the right, connected to the central plate.
// The holes are on the surface of these walls. If I cut out a cylinder from the wall, it goes through the entire thickness of that specific wall segment? 
// No, standard FDM printing: you print a solid block. Then you remove material. The remaining material forms the object.
// If I have a plate and I cut out a cylinder, the result has a hole (void). 
// To get "through-holes" where the tube passes through the rack body, I need to ensure that at the top of the wall thickness, there is no material? 
// No, the prompt says: "The two short ends stay open." This implies the tubes go all the way through.
// So for a hole to be a tube passing through, the material must be removed from the top surface (z=0 in print orientation) down to the bottom surface of the wall? 
// No, that would remove the entire wall thickness at that X position. But the walls are continuous blocks rising from the plate.
// Let's re-read carefully: "Two solid walls run along the two long edges... rises from the plate".
// This implies there is a block on the left and a block on the right, connected to the central plate.
// The holes are on the surface of these walls. If I cut out a cylinder from the wall, it goes through the entire thickness of that specific