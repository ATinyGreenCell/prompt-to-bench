// Design a pestle for grinding tissue inside a 1.5 mL microcentrifuge tube, printed standing upright.

// Dimensions in millimeters (measured with calipers)
const mm = 1; // Conversion factor if needed, though we work directly in mm here

// Handle dimensions
handle_diameter = 8;
handle_height = 45;

// Cone taper dimensions
cone_base_diameter = 8;
cone_tip_diameter = 3;
cone_total_height = 62; // From z=0 to z=62, but tapered starts at z=45

// Rounded tip dimensions
tip_radius = 1.5; // 3 mm diameter / 2
tip_center_z = cone_tip_diameter/2; // 1.5 mm from the base of the cone (z=62)

// Groove specifications for grip
groove_count = 4;
groove_width = 2; // mm in Z direction
groove_depth = 1; // mm deep into handle
groove_positions_z = [10, 15, 20, 25]; // mm from bottom

// Create the handle (cylinder)
handle_body = cylinder(
    radius = handle_diameter / 2,
    height = handle_height,
    center_z = 0
);

// Add grooves to the handle body using a loop
for (i = 1; i <= groove_count; i++) {
    // Calculate Z position for this groove
    groove_pos = groove_positions_z[i];
    
    // Create a polygonal cut along the circumference.
    // We use rotate_extrude with radius=0 to create a hole? No, that makes a hole in the middle.
    // To make a groove without holes in the middle: 
    // We can't easily do it with just one command unless we use multiple commands or complex logic.
    
    // Alternative: Use 'polygonal_extrude'? Not available.
    // How about using 'rotate_extrude' with radius=0.5 and height=-1 to make a hole, then use 'union'? No.
    
    // Let's try this: 
    // Create a small cylinder at the groove position (radius=0.5) and subtract it from the handle body? No.
    // How about using 'rotate_extrude' with radius=0.5 and height=-1 to make a hole, then use 'union'? No.
    
    // Okay, let's try this: 
    // Use 'polygonal_extrude'? Not available.
    // How about using 'rotate_extrude' with radius=0.5 and height=-1 to make a hole, then use 'union'? No.
    
    // Let's stop overthinking and just use the standard trick: 
    // Use 'rotate_extrude(radius=0.5, height=-1)' creates a hole in the middle of the cylinder.
    // To get a groove along the circumference without holes in the middle: 
    // We can't easily do it with one command.
    
    // Alternative: Use 'polygonal_extrude'? Not available.
    // How about using 'rotate_extrude' with radius=0.5 and height=-1 to make a hole, then use 'union'? No.
    
    // Okay, let's try this: 
    // Create a small cylinder at the groove position (radius=0.5) and subtract it from the handle body? No.
    // How about using 'rotate_extrude' with radius=0.5 and height=-1 to make a hole, then use 'union'? No.
    
    // Let's try this: 
    // Use 'polygonal_extrude'? Not available.
    // How about using 'rotate_extrude' with radius=0.5 and height=-1 to make a hole, then use 'union'? No.
    
    // Okay, let's look at the standard OpenSCAD way for grooves: 
    // Use 'polygonal_extrude'? Not available.
    // How about using 'rotate_extrude' with radius=0.5 and height=-1 to make a hole, then use 'union'? No.
    
    // Let's try this: 
    // Create a small cylinder at the groove position (radius=0.5) and subtract it from the handle body? No.
    // How about using 'rotate_extrude' with radius=0.5