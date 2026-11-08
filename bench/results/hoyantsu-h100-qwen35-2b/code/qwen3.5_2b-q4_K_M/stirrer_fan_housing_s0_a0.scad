// Design for DIY Magnetic Stirrer Housing
// Dimensions in millimeters

// Define the overall bounding box of the housing (90x90 mm)
box_size = 90; // X and Y dimensions

// Define wall thicknesses
wall_thickness_top = 2.0; // Top plate thickness
wall_thickness_walls = 2.5; // Side walls thickness

// Define hole specifications
hole_diameter = 4.5; // M4 screw holes
hole_spacing = 71.5; // Square pattern spacing along X and Y

// Define the power cable notch location
cable_notch_width = 12.0; // Width of the cutout
cable_cut_depth = 8.0;    // Depth from open edge (z=32 to z=40)
cable_start_z = 32.0;     // Start Z position for notch

// Define the stirring surface dimensions (square, centered on plate)
stir_surface_size = 90;   // Matches outer size of housing
stir_surface_thickness = wall_thickness_top; // Thickness of the top plate

// Create the main body structure using a box with rounded corners or simple extrusion
// We will use a large box and then cut away the sides to create the open box shape.
// However, for FDM printing stability and ease of modeling, we can construct it as:
// 1. A solid block (90x90x2) representing the top plate + one side wall.
// 2. Cut out the other three walls.

// Step 1: Create the base structure (Top Plate + One Side Wall)
base_structure = box(
    size = [box_size, stir_surface_size, wall_thickness_top], // 90 x 90 x 2
    origin = [0, 0, 0]
);

// Step 2: Create the four side walls (from z=2 to z=40)
// We will create a single large box for all sides and then use difference or intersection logic.
// Actually, it is easier to build one big hollow box from scratch using rotation/translate loops 
// OR simply subtracting blocks. Let's try the subtraction method as requested (difference).

// Create four identical side wall boxes centered on the base structure
// Each side wall is 90x2.5x38 (from z=2 to z=40)
side_wall_box = box(
    size = [box_size, stir_surface_size, wall_thickness_walls], // 90 x 90 x 2.5
    origin = [-box_size/2, -stir_surface_size/2, 1] // Start at z=1 to ensure overlap with top plate
);

// Create the four side walls and stack them around the base structure
// We need to rotate these boxes so they form a cube-like shape.
// The center of rotation is the center of the base structure (0,0).
center_x = 0;
center_y = 0;
center_z = 1 + wall_thickness_top; // Start at z=3

for(i = 0; i < 4; i++) {
    // Rotate -90 degrees around Y axis to bring the box from front to right, then rotate again for back? 
    // Easier: Just translate and rotate.
    
    // Front Wall (Right side of base structure)
    wall_front = translate([box_size/2, 0, center_z]) * rotate_extrude(90);
    
    // Back Wall (Left side of base structure)
    wall_back = translate([-box_size/2, 0, center_z]) * rotate_extrude(-90);
    
    // Right Wall (Top side of base structure)
    wall_right = translate([0, stir_surface_size/2, center_z]) * rotate_extrude(180);
    
    // Left Wall (Bottom side of base structure)
    wall_left = translate([0, -stir_surface_size/2, center_z]) * rotate_extrude(-180);
}

// Step 3: Combine all parts using Union to form the solid housing
housing = union(
    [base_structure], // The top plate + one side
    [wall_front],     // Front wall
    [wall_back],      // Back wall
    [wall_right],     // Right wall
    [wall_left]       // Left wall
);

// Step 4: Drill the four M4 holes through the top plate
// The holes are centered on a 71.5mm square pattern.
// We need to create a hole box that is offset from the center of the base structure by half the spacing.
hole_offset_x = hole_spacing / 2;
hole_offset_y = hole_spacing / 2;

// Create a temporary box for drilling (with some margin)
drill_box_size = [box_size + hole_offset_x, stir_surface_size + hole_offset_y]; // Add margin to ensure holes pass through
margin = 0.5; // Margin in mm

// We will create four separate drill boxes and subtract them from the housing.
// To ensure no coplanar faces (Rule 5), we add a small offset to each drill box.
drill_offset_x = hole_spacing / 2 + margin;
drill_offset_y = hole_spacing / 2 + margin;

for(i = 0; i < 4; i++) {
    // Determine which quadrant the hole is in based on rotation? 
    // Actually, since we are drilling through a square pattern centered at (0,0), 
    // and our housing is symmetric around Z axis, we can just place them at fixed offsets.
    
    // Front Right Hole (Positive X, Positive Y)
    drill_front_right = box(
        size = [drill_box_size + 2*margin, stir_surface_size + 2*margin, wall_thickness_top]
        origin = [hole_offset_x, hole_offset_y, center_z - margin] // Start at z=3 to be below top plate
    );

    // Front Left Hole (Negative X, Positive Y)
    drill_front_left = box(
        size = [drill_box_size + 2*margin, stir_surface_size + 2*margin, wall_thickness_top]
        origin = [-hole_offset_x, hole_offset_y, center_z - margin]
    );

    // Back Right Hole (Positive X, Negative Y)
    drill_back_right = box(
        size = [drill_box_size + 2*margin, stir_surface_size + 2*margin, wall_thickness_top]
        origin = [hole_offset_x, -hole_offset_y, center_z - margin]
    );

    // Back Left Hole (Negative X, Negative Y)
    drill_back_left = box(
        size = [drill_box_size + 2*margin, stir_surface_size + 2*margin, wall_thickness_top]
        origin = [-hole_offset_x, -hole_offset_y, center_z - margin]
    );

    // Subtract these holes from the housing. 
    // Note: The drill boxes extend past the faces by 'margin', satisfying Rule 5.
    housing = difference(
        [housing],
        [drill_front_right],
        [drill_front_left],
        [drill_back_right],
        [drill_back_left]
    );

    // Optional: Clean up small gaps if any, but for this design it should be fine.
}

// Step 5: Cut the power cable notch in one wall (Front Right Wall)
// The notch is centered along the wall and reaches z=32 to z=40.
// We need to cut a rectangular prism from the front right wall.
// The wall starts at z=2, goes up to z=40. The notch is 12mm wide (X) and cuts down 8mm (Z).
// Center of the wall in X is box_size/2 = 45.
// Center of the wall in Z is (2+40)/2 = 21.

notch_center_x = box_size / 2; // 45 mm
notch_center_z = (wall_thickness_top + stir_surface_size) / 2; // 21 mm

// Create a temporary notch box to cut
notch_box_size = [box_size, wall_thickness_walls, cable_cut_depth]; // 90 x 2.5 x 8
notch_origin_x = notch_center_x - notch_box_size[0] / 2;
notch_origin_z = notch_center_z - notch_box_size[2] / 2;

// Create the notch box with margin to ensure it extends past faces (Rule 5)
margin_notch = 1.0; // Slightly more than half of wall thickness to ensure overlap

notch_box_with_margin = box(
    size = [box_size + 2*margin_notch, stir_surface_size + 2*margin_notch, cable_cut_depth]
    origin = [notch_origin_x, notch_origin_z - margin_notch] // Start below the top plate (z=3)
);

// Cut the notch from the front right wall. 
// We use intersection to keep only the part of the box that is NOT the notch.
front_right_wall = translate([box_size/2, 0, center_z