// Dimensions (mm)
block_length = 130;   // X
block_depth  = 60;    // Y
block_height = 45;    // Z

hole_diameter = 17.5;
hole_radius   = hole_diameter / 2;
hole_depth    = 40;   // along axis
hole_spacing  = 24;
num_holes     = 5;

tilt_angle = 30;      // degrees from vertical in YZ plane

// Derived positions
top_y = -10;          // Y position where axis meets top face
start_x = -(num_holes - 1) * hole_spacing / 2;

$fn = 64;

// Main block, centred on origin
difference() {
    translate([-block_length/2, -block_depth/2, 0])
        cube([block_length, block_depth, block_height]);

    // Five tilted blind holes
    for (i = [0 : num_holes - 1]) {
        x_pos = start_x + i * hole_spacing;
        
        // Translate to the point on the top face where the hole axis starts
        translate([x_pos, top_y, block_height])
        // Rotate so the cylinder axis tilts 30 deg toward +Y
        rotate([tilt_angle, 0, 0])
        // Cylinder extends downward along its local Z axis
        // Add 1 mm extra depth to ensure it cuts fully through the block if needed
        // and to satisfy the "extend past faces" rule for the bottom of the hole
        cylinder(r = hole_radius, h = hole_depth + 1, center = false);
    }
}