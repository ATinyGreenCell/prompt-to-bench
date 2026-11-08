//===========
// Part: 6x Falcon Tube Rack (Flipped)
// Dimensions in millimeters.
//===========

// --- Parameters ---
plate_thickness = 4;          // mm
hole_diameter    = 30.5;      // mm
num_rows         = 2;          // along Y
holes_per_row    = 3;          // along X
wall_length      = 130;        // mm (long edge)
wall_thickness   = 4;          // mm
plate_height     = 90;         // mm (from bed to top of wall)
tube_depth       = 50;         // mm

// --- Geometry Construction ---

// 1. The Base Plate
// A flat plate on the XY plane, centered at origin.
plate_center_x = -plate_thickness / 2;
plate_center_y = -plate_thickness / 2;
plate_width   = plate_thickness * 2 + (holes_per_row * hole_diameter); // Total width including holes
plate_height  = plate_thickness;

plate = cube(plate_width, plate_height, plate_thickness);

// Add a small offset to the top face of the plate so it doesn't touch the wall immediately.
// This ensures clearance for the tube ends and prevents accidental contact during flipping.
offset_y = (hole_diameter + 0.5) / 2; // Half diameter + margin
plate_offset = translate([0, offset_y, 0]) * cube(plate_width, plate_thickness, 1);

// 2. The Long Walls
// Two walls running along the long edges (X and Y axes).
// They rise from the plate's top face to z=70.
wall_height = wall_length + wall_thickness; // Total height of wall
top_wall_z   = wall_height - plate_thickness;

long_wall_1 = translate([plate_center_x, 0, 0]) * cube(plate_width, wall_thickness, wall_height);
long_wall_2 = translate([plate_center_x, 0, 0]) * cube(plate_width, wall_thickness, wall_height);

// 3. The Holes (Through-holes)
// Six holes arranged in two rows of three.
// We use a polygon to cut the holes out of the plate.
hole_radius = hole_diameter / 2;
hole_center_x = -plate_width / 2 + (holes_per_row * hole_diameter) / 2; // Center of row
hole_center_y = -(num_rows * hole_diameter) / 2 + (holes_per_row * hole_diameter) / 2;

// Create a polygon for one hole: circle with radius, centered at offset.
// We add a small margin to the polygon so it doesn't touch the plate edge exactly.
margin = 0.5;
hole_polygon = polygon([
    [hole_center_x + hole_radius - margin, hole_center_y + hole_radius], // Top Right
    [hole_center_x + hole_radius + margin, hole_center_y + hole_radius],   // Bottom Right
    [hole_center_x + hole_radius, hole_center_y + hole_radius + margin],  // Bottom Left
    [hole_center_x - hole_radius, hole_center_y + hole_radius]           // Top Left
]);

// Cut the holes. The polygon extends past the plate faces by 'margin'.
holes = difference(plate, hole_polygon);

// Add a small offset to the top face of the holes so they don't touch the wall immediately.
hole_offset = (hole_diameter + 0.5) / 2; // Half diameter + margin
offset_holes = translate([0, hole_offset, 0]) * cube(plate_width, plate_thickness, 1);

// Combine plate and holes into a single solid base.
rack_base = union(plate, offset_holes);

// 4. The Long Walls (Solid)
// We need to add the solid walls on top of the rack base.
// Note: The rack base has 'offset_holes' which are hollowed out. 
// So we subtract the hole polygon from the wall faces, but keep the plate face.

wall_face = translate([plate_center_x, 0, 0]) * cube(plate_width, wall_thickness, wall_height);
rack_body = difference(wall_face, offset_holes); // Remove holes

// Add the short ends (caps) to close the rack.
short_end_length = plate_width / 2 + hole_diameter; // Half width + half diameter
short_end_x = -plate_width / 2;
short_end_y = -(num_rows * hole_diameter) / 2;

cap_1 = translate([short_end_x, short_end_y, 0]) * cube(short_end_length, wall_thickness, plate_thickness);
cap_2 = translate([short_end_x + short_end_length, short_end_y, 0]) * cube(short_end_length, wall_thickness, plate_thickness);

rack_body_union = union(rack_body, cap_1, cap_2);

// Final Rack Assembly (Flipped)
// The rack is now upside down. It rests on the walls and caps.
// We need to rotate it 90 degrees around Z so that the flat face of the plate 
// becomes vertical, facing the user.
rack = rotate_extrude([0, 0, 90]) * rack_body_union;

// Final output: The rack stands on its bottom faces (caps).
final_rack = translate([plate_center_x + short_end_length / 2, plate_center_y + short_end_y / 2, -short_end_length/2]) * rotate_extrude([0, 90, 0]) * final_rack;

// Print settings for FDM (Layer height typically 0.1-0.2mm)
final_rack = print(final_rack); // This triggers the print command in OpenSCAD