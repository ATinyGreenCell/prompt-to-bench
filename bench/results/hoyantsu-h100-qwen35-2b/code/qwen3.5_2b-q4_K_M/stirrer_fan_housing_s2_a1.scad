// Design for DIY Magnetic Stirrer Housing from PC Case Fan
// Units: millimeters

// Dimensions
box_thickness = 2.0; // mm (top plate)
wall_thickness = 2.5; // mm (walls)
outer_size_x = 90.0; // mm (X dimension)
outer_size_y = 90.0; // mm (Y dimension)
fan_diameter_mm = 80.0; // mm
drill_hole_diameter_mm = 4.5; // mm
drill_hole_pitch_mm = 71.5; // mm
power_cable_notch_width_mm = 12.0; // mm (width of notch)
power_cable_cut_depth_mm = 8.0; // mm (depth from open edge to cut)

// Create the main housing block (the "box" before removing top)
// This is a single solid extrusion to ensure no gaps between walls initially
main_housing_block = linear_extrude(z = wall_thickness + box_thickness);

// 3. Remove the top plate (z_top to z_bottom - box_thickness)
// We use difference(). The cut shape extends slightly past faces as per rules.
top_plate_cut = cube(x = outer_size_x, y = outer_size_y, z = box_thickness + 0.01); // Slightly larger than actual thickness

housing_with_top_removed = main_housing_block - top_plate_cut;

// 4. Drill four holes for M4 screws on a square pattern
// Pattern: centered at (x/2, y/2) with pitch x_pitch and y_pitch
hole_pattern_x = drill_hole_pitch_mm / 2;
hole_pattern_y = drill_hole_pitch_mm / 2;

// Create the hole geometry. 
// We use rotate_extrude to create a cylinder that is slightly larger than the drill hole diameter
// so it fits snugly and removes material effectively, extending past faces by default if not specified otherwise? 
// Actually, standard rotate_extrude cuts through the model. To ensure "extend 0.01-1mm past", we need to be careful.
// The rule says: "In difference(), make every cutting shape extend 0.01-1 mm past the faces it cuts".
// This implies I should define the cut shape (e.g., a slightly larger rectangle) and then call difference().
// However, rotate_extrude rotates the object. 
// Let's try this: Create the notch as a slightly larger rectangle in the plane of the wall (Y=wall_thickness), centered on X axis? No, that would be a hole.
// To cut a rectangular notch, we can create the shape using for loop to make 4 corners and use difference? 
// Actually, standard practice: Create the notch as a slightly larger rectangle in the plane of the wall (e.g., at Y = wall_thickness + notch_wide_x/2), centered on X axis. Then rotate_extrude it around X axis? No, that makes a cylinder.
// Rotate_extrude with direction=[1,0,0] rotates around X. If I have a shape in the YZ plane (rectangle), rotating 90 degrees creates a cylinder along Z? 
// Let's visualize: Rectangle at y=2.5, z=32..40. Centered on X axis. Rotate_extrude