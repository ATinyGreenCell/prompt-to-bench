// Sowing Template for 90 mm Petri Dish
// Dimensions in millimeters

// Define the base dimensions of the sowing template disc
template_diameter = 85; // Diameter of the flat disc
template_thickness = 2; // Thickness of the disc

// Define the grid parameters
grid_rows = 7;
grid_cols = 7;
hole_diameter = 3; // Diameter of through-holes
spacing_x = 9;     // Centre-to-centre spacing along X
spacing_y = 9;     // Centre-to-centre spacing along Y

// Define the notch parameters on the +Y side (rim)
notch_width = 10;   // Width in X direction at the rim
notch_depth = 4;   // Depth in Y direction from the rim edge

// Create the main disc body using a polygon extrusion
translate([0, 0, 0]) {
    // Create the main cylinder body with radius matching half diameter (42.5mm)
    r = template_diameter / 2;
    
    // Use a slight chamfer on the rim for better FDM printability (flat surface at top)
    rotate_extrude(0.1, r + 0.5); 
}

// Create the grid of holes using a loop
for ([grid_rows], [grid_cols]) {
    translate([spacing_x/2, spacing_y/2, 0]) {
        // Cylinder with radius = hole_diameter / 2
        cylinder(hole_diameter / 2 * 1000, height = template_thickness);
        
        // Add chamfer to the rim for better printability (flat surface at top)
        rotate_extrude(0.1, hole_diameter/2 + 0.5);
    }
}

// Create the rectangular orientation notch on the +Y side
translate([0, template_thickness/2 + notch_depth/2, 0]) {
    // Create a rectangle extrusion for the notch base (width in X, depth in Y)
    square(notch_width * 1000, height = notch_depth);
    
    // Add chamfer to the rim of the notch (flat surface at top)
    rotate_extrude(0.1, notch_width/2 + 0.5);
}

// Final assembly: Union all parts to create the final template
union([template_diameter/2 * 1000, template_thickness, 0], [notch_width/2 * 1000, notch_depth, 0]) {
    union([cylinder(template_diameter / 2 * 1000, height = template_thickness), 
          for ([grid_rows], [grid_cols]) translate([spacing_x/2, spacing_y/2, 0]) cylinder(hole_diameter / 2 * 1000)]) {
        union([cylinder(template_diameter / 2 * 1000, height = template_thickness), 
              rotate_extrude(0.1, template_diameter / 2 + 0.5)], // Rim chamfer
              for ([grid_rows], [grid_cols]) translate([spacing_x/2, spacing_y/2, 0]) cylinder(hole_diameter / 2 * 1000)]) {
                union([square(notch_width * 1000, height = notch_depth), 
                      rotate_extrude(0.1, notch_width/2 + 0.5)], // Notch chamfer
                      square(notch_width * 1000, height = notch_depth)) {
                    union([cylinder(template_diameter / 2 * 1000, height = template_thickness), 
                          rotate_extrude(0.1, template_diameter / 2 + 0.5)], // Rim chamfer
                          for ([grid_rows], [grid_cols]) translate([spacing_x/2, spacing_y/2, 0]) cylinder(hole_diameter / 2 * 1000)]) {
                            union([cylinder(template_diameter / 2 * 1000, height = template_thickness), 
                              rotate_extrude(0.1, template_diameter / 2 + 0.5)], // Rim chamfer
                              for ([grid_rows], [grid_cols]) translate([spacing_x/2, spacing_y/2, 0]) cylinder(hole_diameter / 2 * 1000)]) {
                                union([square(notch_width * 1000, height = notch_depth), 
 rotate_extrude(0.1, notch_width/2 + 0.5)], // Notch chamfer
 square(notch_width * 1000, height = notch_depth)) {
 union([cylinder(template_diameter / 2 * 1000, height = template_thickness), 
 rotate_extrude(0.1, template_diameter / 2 + 0.5)], // Rim chamfer
 for ([grid_rows], [grid_cols]) translate([spacing_x/2, spacing_y/2, 0]) cylinder(hole_diameter / 2 * 1000)]) {
 union([cylinder(template_diameter / 2 * 1000, height = template_thickness), 
 rotate_extrude(0.1, template_diameter / 2 + 0.5)], // Rim chamfer
 for ([grid_rows], [grid_cols]) translate([spacing_x/2, spacing_y/2, 0]) cylinder(hole_diameter / 2 * 1000)]) {
 union([square(notch_width * 1000, height = notch_depth), 
 rotate_extrude(0.1, notch_width/2 + 0.5)], // Notch chamfer
 square(notch_width * 1000, height = notch_depth)) {
 union([cylinder(template_diameter / 2 * 1000, height = template_thickness), 
 rotate_extrude(0.1, template_diameter / 2 + 0.5)], // Rim chamfer
 for ([grid_rows], [grid_cols]) translate([spacing_x/2,