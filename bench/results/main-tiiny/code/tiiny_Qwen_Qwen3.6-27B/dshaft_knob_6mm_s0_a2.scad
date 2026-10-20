// Replacement knob for hotplate stirrer
// Dimensions measured with calipers

// Main body dimensions
knob_diameter = 30;
knob_radius = knob_diameter / 2;
knob_height = 15;

// D-shaft bore dimensions
bore_diameter = 6.2;
bore_radius = bore_diameter / 2;
bore_depth = 12;
// Distance from flat to opposite side of circle is 4.7 mm
// The flat is offset from center by: bore_radius - (4.7 - bore_radius) = 2*bore_radius - 4.7
flat_offset = bore_radius - (4.7 - bore_radius);

// Grip groove dimensions
num_grooves = 18;
groove_diameter = 2;
groove_radius = groove_diameter / 2;

// Pointer groove dimensions
pointer_width = 1.5;
pointer_depth = 1;

// Set resolution for smooth curves
$fn = 64;

// Module to define the D-shaped bore solid
module d_shaped_bore() {
    difference() {
        // Cylinder part of the bore
        cylinder(h = bore_depth + 0.1, r = bore_radius, center = false);
        
        // Cut the flat side
        // The flat is at y = flat_offset.
        // We remove material from y = flat_offset to y = bore_radius + epsilon.
        // The block must cover the full width of the cylinder at that y.
        // Width of cylinder at any y is 2*sqrt(r^2 - y^2).
        // To be safe, we use a block wider than the diameter.
        translate([-bore_radius - 0.1, flat_offset, -0.05])
            cube([bore_diameter + 0.2, bore_radius - flat_offset + 0.1, bore_depth + 0.2]);
    }
}

// Main difference operation
difference() {
    // 1. Main knob body
    cylinder(h = knob_height, r = knob_radius, center = false);
    
    // 2. Subtract D-shaped blind bore
    d_shaped_bore();
    
    // 3. Subtract 18 evenly spaced vertical grip grooves
    for (i = [0 : num_grooves - 1]) {
        angle = i * 360 / num_grooves;
        
        // Position the groove center on the outer surface
        translate([
            knob_radius * cos(angle),
            knob_radius * sin(angle),
            0
        ])
        // Rotate so that the local X axis points towards the center of the knob
        rotate([0, 0, -angle])
        // Create the half-cylinder groove
        difference() {
            // Full cylinder for the groove
            cylinder(h = knob_height + 0.1, r = groove_radius, center = false);
            
            // Cut away the half that is outside the knob (positive X in local coords)
            // We keep the half that is inside (negative X in local coords)
            translate([0, -0.05, -0.05])
                cube([groove_radius + 0.1, groove_diameter + 0.1, knob_height + 0.2]);
        }
    }
    
    // 4. Subtract pointer groove on top face
    // 1.5 mm wide, 1 mm deep, from center to outer edge
    // On the same side as the flat of the D (+Y direction)
    // The groove runs from y=0 to y=knob_radius
    translate([0, knob_radius / 2, knob_height - pointer_depth])
        cube([pointer_width, knob_radius, pointer_depth + 0.1], center = true);
}