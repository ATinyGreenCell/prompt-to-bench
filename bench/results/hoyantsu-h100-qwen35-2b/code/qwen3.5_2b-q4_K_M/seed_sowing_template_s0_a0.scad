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

// Create the grid of holes using a for loop
for (i = -grid_size_y / 2 + 1 to grid_size_y / 2 - 1 by 1) {
    // Define the center point of each hole in X and Y coordinates relative to the template's center
    hole_x = i * center_spacing;
    hole_y = j * center_spacing;

    // Create a small cylinder for the hole, centered on the grid intersection
    // We use translate to move the hole position to (hole_x, hole_y)
    // The radius is half of the hole diameter
    hole_radius = hole_diameter / 2.0;
    
    sowing_template_hole = cylinder(
        radius = hole_radius,
        height = template_thickness
    );

    translate([hole_x, hole_y, 0]) rotate_x(90) sowing_template_hole;
}

// Create the rectangular orientation notch on the +Y side (rim)
// The notch is centered on the Y axis of the template.
// Width in X: 10 mm
// Depth in Y: 4 mm (measured from the rim edge inward)
notch_width = 10.0; // Width along X
notch_depth = 4.0;  // Depth along Y

// Define a polygon for the notch shape
// The notch is cut into the side of the cylinder.
// We define vertices relative to the center of the template (0,0).
// Since it's on the +Y side, we need to offset coordinates slightly or use a specific approach.
// However, OpenSCAD polygon works best if defined around the center and then rotated/translated.

notch_vertices = [
    // Center of notch: 5mm from rim (rim is at Y=template_radius), so X=0, Y=-4+5 = +1? 
    // Wait, let's re-read carefully: "rectangular orientation notch... centered on the Y axis".
    // Rim is at Y = template_radius. The notch goes inward 4mm. So it ends at Y = template_radius - 4.
    // Center of notch is at Y = (template_radius + (template_radius - 4)) / 2 = template_radius - 2.
    // X coordinate is centered, so X = 0.
    
    // Let's construct the polygon vertices directly based on geometry relative to the center (0,0).
    // The notch spans from Y = -notch_depth/2 + offset to Y = notch_depth/2 + offset? 
    // No, it cuts into the side. It is a rectangle in the X-Y plane of the cylinder surface.
    
    // Vertices for a rectangle centered at (0, 0) with width W and depth D:
    // Top-Left: (-W/2, -D/2)
    // Top-Right: (W/2, -D/2)
    // Bottom-Right: (W/2, +D/2)
    // Bottom-Left: (-W/2, +D/2)
    
    notch_vertices = [
        [-notch_width / 2.0, -notch_depth / 2.0],
        [notch_width / 2.0, -notch_depth / 2.0],
        [notch_width / 2.0, notch_depth / 2.0],
        [-notch_width / 2.0, notch_depth / 2.0]
    ];

// Create the polygon for the notch cut
// We need to rotate this polygon so it aligns with the +Y axis of the cylinder surface.
// The polygon is currently in X-Y plane (horizontal). We want it on the side facing +Z? 
// No, the template rests on XY. The "rim" usually implies the top edge or a vertical cut.
// "Cut... into the rim on the +Y side". This implies a vertical slot cutting down from the rim.
// If we rotate the polygon 90 degrees around X axis (or Y?), it will align with the cylinder surface.
// Let's try rotating the polygon -90 degrees around the Z axis to bring the flat face into alignment? 
// No, standard orientation: Polygon vertices are in XY plane. We want them on the side of the cylinder.
// If we rotate the polygon 90 degrees (-PI/2) around X axis, it moves from horizontal (XY) to vertical (XZ).
// Wait, if I have a rectangle in XY plane and rotate -90 deg around Z? No, that's just flipping.
// Let's visualize: Cylinder surface normal is +Y. We want the notch on this face.
// So we need the polygon vertices to lie on the plane X=template_radius (or similar).
// If we take our flat rectangle [(-W/2, -D/2) ...] and rotate it 90 degrees around the Z axis? 
// That would move it to the YZ plane. But the cylinder is symmetric around Z.
// Actually, if we just translate the polygon vertices by (template_radius, 0, 0), they will be on the surface X=template_radius.
// Then rotate that whole assembly -90 degrees around the X axis? 
// Let's try a simpler approach: Rotate the entire sowing_template -90 degrees around the Z axis? No, that moves it to YZ plane.
// The easiest way is to create the polygon in the XY plane (flat), then translate it to the rim location, and rotate it 90 degrees (-PI/2) around the X axis so it stands vertically on the side of the cylinder.

translate([template_radius, 0, 0]) // Move to the rim
rotate(-90) notch_polygon = polygon(notch_vertices);

// Cut the notch from the sowing template using difference
sowing_template_notch = difference(
    shape = sowing_template,
    cutout = notch_polygon
);

// Final assembly: Union all parts together so they form a single solid object
final_object = union([
    sowing_template,           // The main flat disc
    sowing_template_hole,      // All the holes (rotated 90 deg)
    sowing_template_notch     // The notch cut into it
]);

// Print settings for FDM printing
print_settings(
    material = "PLA",
    orientation = [90, 0, 0], // Rotate so the flat face is on top (Z=0), holes are vertical? 
 // Wait, user said "sits inside... lying on the bed". 
 // If we print with [90, 0, 0] (rotate X by 90), then Z becomes Y.
 // The flat face was originally at Z=template_thickness/2. Now it is at Z=0? No.
 // Original: Flat face on XY plane (Z=0). Height = template_thickness.
 // Rotate X by 90: New Z axis aligns with old Y axis. Old Z (flat face) becomes new Y.
 // This means the flat face is vertical. That's wrong for a dish bed.
 // We want the flat face to be on the XY plane (Z=0).
 // So we should print with [0, 90, 0] or just leave it as is if we define orientation correctly?
 // Standard OpenSCAD: rotate_x(90) puts old Z into new Y. Old X becomes new Z.
 // If we want the flat face (old Z=0) to be on the XY plane of the print, we need to rotate around Y axis by 90 degrees? 
 // No, if we rotate around Y, old Z goes to X. Still not flat.
 // To make a vertical cylinder stand up with its base on the table:
 // We want the flat face (originally at Z=0) to be at Z=0 in the final model? 
 // No, if we print a solid block of height H, and rotate it 90 deg around