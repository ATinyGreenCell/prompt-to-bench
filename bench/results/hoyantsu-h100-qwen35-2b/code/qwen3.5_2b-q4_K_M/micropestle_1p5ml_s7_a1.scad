// Design a pestle for grinding tissue inside a 1.5 mL microcentrifuge tube, printed standing upright.

// Dimensions in millimetres (measured with calipers)
const mm = 1; // Default unit scale

// Handle dimensions
handle_diameter = 8;
handle_length = 45;
groove_count = 4;
groove_width_z = 2;
groove_depth = 1;
groove_positions = [10, 15, 20, 25];

// Cone dimensions (taper from handle to tip)
cone_base_diameter = handle_diameter; // 8 mm at z=45
cone_tip_diameter = 3;                // 3 mm at z=62
cone_length = cone_tip_diameter / 2 + handle_diameter / 2; // Total length from base to tip top

// Tip dimensions (rounded sphere)
tip_radius = 1.5;                      // 3 mm diameter -> radius 1.5 mm
tip_height = cone_tip_diameter / 2;   // 1.5 mm height from base of tip

// Hole grid parameters for the handle
hole_count = groove_count * 4;
hole_spacing_z = handle_length / hole_count;
hole_radius = (handle_diameter / 2) - groove_width_z;

print("Designing pestle...");

// Create the main body using a large cylinder and then cut away material to form the shape
// We start with a solid cylinder of the base diameter, then extrude it up.
// The 'hull' operation will remove the excess material (the handle part) from this block.

// 1. Define the initial solid block: Cylinder at z=0, Diameter=8mm, Length=62mm
block_diameter = handle_diameter;
block_length = cone_base_diameter + cone_length; // Total length of the tapered section including tip height
block_height = tip_radius * 2;           // Height of the rounded tip

// Create a large cylinder block at z=0 to z=62, diameter=8mm
large_cylinder_block = cylinder(
    radius = mm * handle_diameter / 2,
    length = mm * block_length,
    center_x = mm * 0.5,
    center_y = mm * 0.5,
    center_z = mm * 0
);

// Create the rounded tip at z=62 (top of large cylinder)
tip_cylinder_block = cylinder(
    radius = mm * tip_radius,
    length = mm * block_height,
    center_x = mm * 0.5,
    center_y = mm * 0.5,
    center_z = mm * block_length + mm * block_height // Centered at z=62+1.5mm
);

// Unite the two blocks to form a solid cylinder from bottom (z=0) to top of tip (z=62+1.5mm)
solid_cylinder_block = union([large_cylinder_block, tip_cylinder_block]);

// 2. Create the cone shape by cutting away material along Z-axis
// We will use a linear_extrude with a polygon cross-section.
// The cone starts at z=45 (base of handle) and ends at z=62+1.5mm (tip top).
// To make it look like a cone tapering from 8mm to 3mm over the length,
// we need to define the polygon profile for each Z level or use a complex extrude.

// Alternative approach: Extrude a polygon that changes shape along Z? 
// OpenSCAD's linear_extrude with polygon requires a list of polygons (list of lists).
// We can generate the polygon vertices dynamically based on Z.

// Define the cone geometry using for loops to create the polygon cross-sections
cone_vertices = []; // Will store list of [x, y] coordinates

for (i = 0; i < groove_count * 4; i++) {
    z_pos = mm * handle_length + mm * i / groove_count; // Z position of groove center
    
    // Calculate radius at this specific Z
    if (z_pos >= mm * cone_base_diameter) {
        // Inside the cone body, tapering from base to tip
        r_at_z = mm * (cone_tip_diameter - handle_diameter + 2 * z_pos) / (mm * cone_length); 
        // Wait, simpler math: Linear interpolation between radius at z=45 and z=62.15mm
        r_at_z = mm * (cone_tip_diameter - handle_diameter + 2 * z_pos) / (mm * cone_length);
        
        // Calculate angle for the circle at this Z
        theta = atan2(0, d_at_z / 2); // Angle in radians
        
        // Create two points on the perimeter (top and bottom of the cone face)
        x1 = mm * handle_diameter / 2 + r_at_z; 
        y1 = 0;
        
        x2 = -mm * handle_diameter / 2 + r_at_z;
        y2 = 0;
        
        // Add to vertices list (using a small epsilon for precision, though not strictly needed here)
        cone_vertices.append([x1, y1]);
        cone_vertices.append([x2, y2]);
    } else {
        // Inside the handle cylinder (z < 45mm), keep it flat at diameter 8mm
        r_at_z = mm * handle_diameter / 2;
        d_at_z = mm * 2 * r_at_z;
        
        theta = atan2(0, d_at_z / 2); // Angle in radians
        
        x1 = mm * handle_diameter / 2 + r_at_z; 
        y1 = 0;
        
        x2 = -mm * handle_diameter / 2 + r_at_z;
        y2 = 0;
        
        cone_vertices.append([x1, y1]);
        cone_vertices.append([x2, y2]);
    }
}

// Create the polygon extrusion for the cone part
// The polygon list contains vertices in order (clockwise or counter-clockwise)
// We need to close the loop by adding a final vertex at the start of the first point.
// Note: OpenSCAD's linear_extrude expects the polygon to be closed, i.e., [x1,y1]...[x2,y2][start_x,start_y].

// Create a list of vertices for the cone extrusion
cone_poly_list = []; // Will hold the list of polygons (list of lists)

for (i = 0; i < length_of_cone_vertices; i++) {
    if (i == length_of_cone_vertices - 1) {
        // Close the polygon by adding a vertex at the start of the first point
        cone_poly_list.append([cone_vertices[i][0], cone_vertices[i][1]]);
    } else {
        // Add the current segment as a polygon (list of two points)
        cone_poly_list.append([cone_vertices[i][0], cone_vertices[i][1]]);
    }
}

// Extrude the cone shape from z=45 to z=62.15mm
// The length of this extrusion is the total height of the tapered section + tip radius? 
// No, linear_extrude with polygon creates a solid where the base is defined by the polygon list.
// We want the base at z=45 (diameter 8mm) and taper to z=62.15 (tip top).
// The length of this extrusion will be from z=45 to z=62.15.

cone_extrude = linear_extrude(
    radius = mm * handle_diameter / 2, // Base diameter / 2
    polygon = cone_poly_list,
    center_x = mm * 0.5,
    center_y = mm * 0.5,
    center_z = mm * 45,
    length = mm * (cone_tip_diameter + handle_diameter) / 2 // Length from z=45 to z=62.15
);

// 3. Create the rounded tip by cutting away material on top of the cone extrusion
// The cone extrusion ends at z=62.15mm (top of the cylinder). We need a sphere of radius 1.5mm centered there.
// So we cut from z=62.15 to z=63.65 (tip top + tip radius) using a polygon that matches the sphere profile.

sphere_poly_list = []; // Will hold list of polygons for sphere extrusion

for (i = 0; i < length_of_cone_vertices; i++) {
    if (i == length_of_cone_vertices - 1) {
        // Close the polygon by adding a vertex at the start of the first point
        sphere_poly_list.append([cone_vertices[i][0], cone_vertices[i][1]]);
    } else {
        // Add the current segment as a polygon (list of two points)
        sphere_poly_list.append([cone_vertices[i][0], cone_vertices[i][1]]);
    }
}

// Extrude the sphere shape from z=62