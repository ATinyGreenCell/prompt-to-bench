// Dimensions for the replacement knob
$fn = 64; // For curved shapes to ensure smoothness

// Main cylinder dimensions
knob_diameter = 30; // Diameter of the knob
knob_height = 15;   // Height of the knob

// D-shaped blind bore dimensions
d_bore_diameter = 6.2; // Diameter of the D-shaped bore
d_bore_flat_distance = 4.7; // Distance from flat to opposite side
d_bore_depth = 12; // Depth of the D-shaped bore into the knob

// Grip grooves dimensions
grip_groove_diameter = 2; // Diameter of each grip groove
grip_groove_count = 18;   // Number of grip grooves
grip_groove_angle = 360 / grip_groove_count; // Angle between each groove

// Pointer groove dimensions
pointer_groove_width = 1.5; // Width of the pointer groove
pointer_groove_depth = 1;   // Depth of the pointer groove
pointer_groove_angle = 45;  // Angle of the pointer groove from the center

// Create the main cylinder
cylinder(r = knob_diameter / 2, h = knob_height, $fn = 64);

// Create the D-shaped blind bore
// Define the D-shape as a circle with a flat cut
// The flat cut is at an angle to create the D-shape
// We use a rotated cylinder to simulate the flat cut

// Create the D-shape by subtracting a small cylinder from a larger one
// The D-shape is a circle with a flat cut, so we can use a rotated cylinder
// to simulate the flat part

// Create a cylinder for the D-shape
d_bore_cylinder = cylinder(r = d_bore_diameter / 2, h = d_bore_depth, $fn = 64);

// Rotate the D-shape to align the flat with the correct side
// The flat is on the side opposite the D-shaft, so we rotate it by 90 degrees
// around the Y-axis to position the flat part correctly

// Translate the D-shape to the center of the knob
translate([0, 0, 0]) // Move to the bottom face of the knob
rotate([0, 0, 90]) // Rotate to align the flat part
difference() {
    // Main cylinder
    cylinder(r = knob_diameter / 2, h = d_bore_depth, $fn = 64);
    
    // Subtract the D-shaped bore
    union() {
        // Create the D-shape by subtracting a small cylinder from a larger one
        // The flat part is created by rotating a small cylinder
        // The small cylinder is positioned to cut the flat part
        translate([0, 0, d_bore_depth / 2]) // Position the small cylinder in the middle of the bore depth
        rotate([0, 0, 0]) // No rotation for the flat part
        cylinder(r = d_bore_diameter / 2, h = d_bore_depth, $fn = 64);
        
        // Create the flat part by rotating a small cylinder
        translate([0, 0, d_bore_depth / 2]) // Position the small cylinder in the middle of the bore depth
        rotate([0, 0, 90]) // Rotate to create the flat part
        cylinder(r = d_bore_diameter / 2, h = d_bore_flat_distance, $fn = 64);
    }
}

// Create grip grooves
// Each groove is a half-cylinder, 2 mm diameter, centered on the outer surface
// They are evenly spaced around the circumference of the knob

for (i = [0: grip_groove_count - 1]) {
    // Calculate the angle for each groove
    angle = i * grip_groove_angle;
    
    // Create a half-cylinder for each groove
    // The groove is centered on the outer surface, so we use a radius of (knob_diameter / 2 - grip_groove_diameter / 2)
    // The groove is extruded along the height of the knob
    translate([0, 0, 0]) // Position at the bottom of the knob
    rotate([0, 0, angle]) // Rotate to position the groove
    linear_extrude(height = knob_height, $fn = 64)
    circle(r = grip_groove_diameter / 2, $fn = 64);
}

// Create the pointer groove
// The pointer groove is 1.5 mm wide and 1 mm deep, running from the center to the outer edge
// It is on the same side as the flat of the D-shape

// Define the pointer groove as a rectangle extruded along the Z-axis
// The groove is rotated to align with the flat part of the D-shape

// Calculate the center of the pointer groove
pointer_groove_center = knob_diameter / 2 - pointer_groove_width / 2;

// Create the pointer groove
translate([0, 0, 0]) // Position at the bottom of the knob
rotate([0, 0, pointer_groove_angle]) // Rotate to align with the flat part
linear_extrude(height = knob_height, $fn = 64)
polygon(points=[[0, 0], [pointer_groove_center, 0], [pointer_groove_center, pointer_groove_width], [0, pointer_groove_width]], $fn = 64);