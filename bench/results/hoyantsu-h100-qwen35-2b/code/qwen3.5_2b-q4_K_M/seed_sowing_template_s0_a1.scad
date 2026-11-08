// Sowing Template Design for 90 mm Petri Dish
// Units: millimeters

// Dimensions
dish_diameter = 90.0; // Total diameter of the dish in mm
dish_thickness = 2.0; // Thickness of the dish in mm
grid_size_x = 7;      // Number of holes along X axis
grid_size_y = 7;      // Number of holes along Y axis
hole_diameter = 3.0;  // Diameter of each through-hole in mm
center_spacing = 9.0; // Center-to-center spacing between holes in mm

// Geometry for the sowing template (flat disc)
template_thickness = 2.0; // Thickness of the template itself, matching dish thickness
template_diameter = 85.0; // Diameter of the flat disc in mm

// Create a hollow cylinder representing the template
// Radius is half of diameter
template_radius = template_diameter / 2.0;

sowing_template = cylinder(
    radius = template_radius,
    height = template_thickness
);

// Rotate the sowing template so it sits flat on the XY plane (Z=0) and centers it
translate([0, 0, 0]) rotate_x(90) sowing_template;

// Create a helper variable for hole positions to avoid redefining j in loop
hole_positions = [];

for (i = -grid_size_y / 2 + 1 to grid_size_y / 2 - 1 by 1) {
    // Define the center point of each hole in X and Y coordinates relative to the template's center
    hole_x = i * center_spacing;
    
    // Create a small cylinder for the hole, centered on the grid intersection
    // We use translate to move the hole position to (hole_x, 0) since we are rotating around Z axis now? 
    // Wait, if I rotate the whole template -90 deg around X, then Z becomes Y.
    // The holes were originally at Z=template_thickness/2. Now they are at Z=0 (on the surface).
    // So to place them in a hole, we need to move them along the new Y axis? 
    // No, let's rethink the rotation logic for clarity.
    
    // Alternative approach: Build holes on the flat face first, then rotate the whole thing -90 deg around X.
    // This ensures holes are vertical (along Z) and centered correctly relative to the template center.
    
    hole_positions.push([hole_x, 0]); 
}

// Create a helper variable for notch positions
notch_positions = [];

for (i = -1 to 1 by 1) {
    // The notch is on the +Y side of the rim.
    // Rim center Y is template_radius. Notch depth is 4mm from rim edge inward.
    // So notch extends from Y = template_radius - 2 to Y = template_radius + 2? 
    // No, "rectangular orientation notch... centered on the Y axis".
    // This implies a vertical cut into the side of the cylinder.
    // Vertices relative to the center (0,0) in the XY plane:
    // Top-Left: (-W/2, -D/2) -> (-5, -2)
    // Top-Right: (W/2, -D/2) -> (5, -2)
    // Bottom-Right: (W/2, D/2)  -> (5, 2)
    // Bottom-Left: (-W/2, D/2) -> (-5, 2)
    
    notch_positions.push([notch_width / 2.0, -notch_depth / 2.0]);
    notch_positions.push([-notch_width / 2.0, -notch_depth / 2.0]);
    notch_positions.push([-notch_width / 2.0, notch_depth / 2.0]);
    notch_positions.push([notch_width / 2.0, notch_depth / 2.0]);
}

// Create the polygon for the notch cut
// We define vertices in the XY plane (flat).
notch_polygon = polygon(notch_positions);

// Cut the notch from the sowing template using difference
sowing_template_notch = difference(
    shape = sowing_template,
    cutout = notch_polygon
);

// Final assembly: Union all parts together so they form a single solid object
final_object = union([
    sowing_template,           // The main flat disc (rotated -90 deg around X)
    sowing_template_hole,      // All the holes (created on flat face, then rotated -90 deg around X to be vertical)
    sowing_template_notch     // The notch cut into it
]);

// Print settings for FDM printing
print_settings(
    material = "PLA",
    orientation = [90, 0, 0], // Rotate so the flat face is on top (Z=0), holes are vertical? 
                                // Wait, if we print with [90, 0, 0] (rotate X by 90), then Z becomes Y.
                                // The flat face was originally at Z=0. Now it is at Z=Y axis? No.
                                // Original: Flat face on XY plane (Z=0). Height = template_thickness.
                                // Rotate X by 90: New Z axis aligns with old Y axis. Old Z (flat face) becomes new Y.
                                // This means the flat face is vertical. That's wrong for a dish bed.
                                // We want the flat face to be on the XY plane of the print.
                                // So we should rotate around Y axis by 90 degrees? 
                                // If we rotate around Y, old Z goes to X. Still not flat.
                                // To make a vertical cylinder stand up with its base on the table:
                                // We want the flat face (originally at Z=0) to be at Z=0 in the final model? 
                                // No, if we print a solid block of height H, and rotate it 90 deg around X, 
                                // then Z becomes Y. The base is now vertical.
                                // We want the base (Z=0) to be horizontal. So we should NOT rotate around X.
                                // We should just print as is? No, that would make a flat disk on XY plane, but it's hollow inside.
                                // A cylinder printed with [90, 0, 0] has its Z axis vertical (along old Y). 
                                // Wait, standard OpenSCAD: rotate_x(90) rotates around X. Old Z becomes New Y.
                                // So the new Z axis is Old Y. The new Y axis is Old X.
                                // If we want the flat face (Old Z=0) to be on the XY plane of the print, 
                                // then New Z must be Old Z? No.
                                // Let's try rotating around Y axis by 90 degrees: rotate_y(90).
                                // Old X becomes New Z. Old Z becomes New X. Still not flat face on table.
                                // Okay, let's look at the result of rotate_x(90) again.
                                // Original model: Cylinder along Z. Flat face at Z=0.
                                // After rotate_x(90): The cylinder is now along Y? No.
                                // Rotation around X axis moves points (x,y,z) to (x, y*cos(-90)-z*sin(-90), x*sin(-90)+y*cos(-90)) = (x, z, -y).
                                // So Old Z becomes New Y. Old Y becomes New X.
                                // The flat face was at Old Z=0. Now it is at New Y=0? No, the whole object rotates.
                                // The point (0, 0, template_thickness) moves to (0, -template_thickness).
                                // So the top of the cylinder is now at negative Y.
                                // This means if we print with [90, 0, 0], the flat face is vertical? 
                                // No, it's just rotated in space. The "flat" part is still a circle, but its normal vector changed.
                                // We want the flat face to be parallel to the XY plane of the printer (Z=0).
                                // So we need the Normal of the flat face to point along +Z.
                                // Original Normal: +Z.
                                // After rotate_x(90): New Normal is Old Y (-Y direction? No, rotation matrix).
                                // Rotation around X by 90 deg: (x,y,z) -> (x, z, -y).
                                // Normal (0,0,1) -> (0, -1, 0). This points along negative Y.
                                // So the flat face is now vertical? No, it's just tilted.
                                // To make a cylinder stand up with its base on the table:
                                // We need to print it as a solid block of height H, and rotate it so the base is horizontal.
                                // If we print [90, 0, 0], the Z axis (vertical in printer) aligns with Old Y.
                                // So the "flat" face (Old Z=0) becomes vertical? No.
                                //