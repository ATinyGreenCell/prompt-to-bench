// Design for DIY Magnetic Stirrer Housing
// Units: millimeters

// Dimensions in mm
box_thickness = 2.0; // Top plate thickness (z=0 to 2)
wall_thickness = 2.5; // Wall thickness (z=2 to z=40)
outer_size_x = 90.0;
outer_size_y = 90.0;

// Hole specifications for M4 screws
hole_diameter = 4.5;
hole_pitch = 71.5; // Square pattern spacing in mm
hole_offset_x = 45.0;
hole_offset_y = 45.0;

// Notch specification (Power cable)
notch_width = 12.0;
notch_depth_from_open_edge = 8.0; // From z=32 to z=40

// Create the main box body
var x = outer_size_x;
var y = outer_size_y;
var z_max = wall_thickness * 20; // Total height in mm (z=40)

// Helper function to create a hollow cylinder with an opening at the top
// mirror=(1,-1) makes the top face open, bottom closed.
function make_hollow_cylinder(radius, height, center_x, center_y, z_start = 0) {
    var r = radius;
    // Create a solid block first to define the volume
    var box_volume = cylinder(r, height);
    
    // To create an opening at z_start, we need to remove material.
    // However, OpenSCAD's difference/union logic with cylinders can be tricky for complex shapes.
    // A robust way: Create a large hollow cylinder (open top) and subtract the specific hole geometry? 
    // No, let's stick to rotating around Z axis directly as planned in previous attempts, but fix the syntax error.
    
    // Correct approach using rotate_extrude with mirror on the top face of the extrusion
    // We define a solid rectangle for each quadrant, then rotate it.
    // But simpler: Just use rotate_extrude with mirror=(1,-1) and ensure the height is correct relative to z_start? 
    // No, mirror makes the TOP surface open. The BOTTOM surface closes the box.
    // If we want an opening at z=0 (bottom), we need mirror=(0,-1).
    // If we want an opening at z=z_start (top), we need mirror=(1,-1) and set height to z_start? 
    // No, if we rotate around Z, the "height" parameter in rotate_extrude is the length of the extrusion.
    // The mirror command rotates the top face 90 degrees relative to the bottom face? No.
    // Mirror=(1,-1) reflects the Y axis across X=0 plane (top/bottom). It makes the top surface an opening.
    // So if we have a cylinder of height H, and mirror=(1,-1), it opens at z=H and closes at z=0.
    // We want to open at z=z_start. So we need a cylinder that starts at z=0 and goes up to z=z_start? 
    // No, the mirror operation happens on the *current* face being extruded.
    // Let's try: Create a solid block from 0 to H. Mirror=(1,-1) makes top open.
    // This works if we want an opening at z=H.
    
    return rotate_extrude(
        height=z_start, // The mirror operation happens on the face at z=z_start (the "top" of this cylinder segment)
        radius=r,
        center_x=center_x,
        center_y=center_y,
        mirror=(1,-1) // Makes the top face open.
    );
}

// 2. Create the four walls of the box
for (i = -1; i <= 1; i++) {
    var wall_x = x/2 + i * (x/4); 
    for (j = -1; j <= 1; j++) {
        var wall_y = y/2 + j * (y/4); 
        
        // Wall exists from z=2 to z=z_max
        var wall_height = z_max - 2;
        
        // Create a hollow cylinder for each quadrant of the box
        // We define the center and radius, then rotate around Z axis.
        // The mirror=(1,-1) makes the top face open at z=wall_height.
        // This creates a wall from z=0 to z=wall_height? No.
        // If we use make_hollow_cylinder with height=z_start (which is wall_height), it opens at z=wall_height.
        // So this will create the side of the box from z=0 to z=wall_height.
        
        var rot_x = x/2 + i * (x/4);
        var rot_y = y/2 + j * (y/4);
        
        rotate_extrude(
            height=wall_height,
            radius=x/2 + rot_x, // Radius of the box wall
            center_x=rot_x,
            center_y=rot_y,
            mirror=(1,-1) // Makes top face open at z=wall_height.
        );
    }
}

// 3. Create the Top Plate (z = 2 to z_max)
var top_radius = x/2; 
var top_height = wall_thickness;

rotate_extrude(
    height=top_height,
    radius=top_radius,
    mirror=(0,-1) // Makes bottom face open at z=0.
);

// 4. Cut out the Top Hole (M4 screws)
for (i = -1; i <= 1; i++) {
    var hole_x = x/2 + i * (x/4); 
    for (j = -1; j <= 1; j++) {
        var hole_y = y/2 + j * (y/4); 
        
        // Create a hollow cylinder for the hole (open at top)
        // We use make_hollow_cylinder with height=hole_radius? 
        // No, we need to cut a hole of diameter 4.5mm.
        // Let's create a solid block and subtract? Or just define the opening directly.
        
        // Method: Create a hollow cylinder (open at bottom) and mirror it? 
        // rotate_extrude with mirror=(0,-1) opens at z=height.
        // We want an opening at z=hole_radius (top of hole).
        // So we need to create a solid block from 0 to hole_radius, then open the top face?
        
        var h = hole_radius;
        rotate_extrude(
            height=h,
            radius=hole_diameter/2,
            center_x=hole_x,
            center_y=hole_y,
            mirror=(0,-1) // Opens at z=h (top of this cylinder).
        );
    }
}

// 5. Cut out the Notch (Power Cable)
var notched_wall_x = x/2 - 1 * (x/4); 
var notched_wall_y = y/2 - 1 * (y/4);

// The notch is a rectangular cutout of width=notch_width and depth=notch_depth_from_open_edge.
// It is centered on the wall.
// We will create this using a polygon for exact centering and shape, as cylinders are hard to align perfectly with walls without offsets.

var notched_radius = notch_width / 2; // Radius of the notch opening (diameter)
var notch_height = notch_depth_from_open_edge; // Length of the cut from z=32 to z=40? 
// Wait, user said "from z = 32 to z = 40". This is a length of 8mm.
// The notch depth in OpenSCAD terms (for rotate_extrude) is how far down it goes from the open face.
// If we want an opening at z=32, we need height=8? No, that's just the length.
// We need to cut a slot of 12mm width and 8mm depth.
// Let's use polygon for this specific feature to ensure exact dimensions and centering on the wall face.

var notched_polygon = polygon([notch_width/2, notch_height, -notch_width/2, notch_height]); 
// This creates a rectangle centered at (0,0) with width=12 and height=8? No.
// polygon([x,y]) draws a line from x to y.
// To draw a rectangle: [width/2, height], [-width/2, -height].

var notched_rect = polygon([notch_width/2, notch_height, -notch_width/2, -notch_height]);

// We need to place this polygon at the center of the wall.
// The wall is centered on (0,0). So we just rotate the polygon around Z axis? 
// No, rotating a rectangle around Z makes it an annulus or circle with a hole in the middle if not careful.
// Actually, rotating a flat rectangle around its own center creates a hollow cylinder shape (like a washer) but rotated 90 degrees? 
// No, rotate_ex