// Replacement knob for hotplate stirrer with 6 mm D-shaft
// Dimensions measured with calipers

// Knob body dimensions
knob_diameter = 30;
knob_radius = knob_diameter / 2;
knob_height = 15;

// D-shaft blind bore dimensions
bore_diameter = 6.2;
bore_radius = bore_diameter / 2;
bore_depth = 12;
// Distance from flat to opposite side of circle is 4.7 mm
// This means the flat is offset from center by: bore_radius - 4.7 = 3.1 - 4.7 = -1.6 mm
// So the flat is 1.6 mm on the opposite side of center from the "point" of the D
d_flat_offset = bore_radius - 4.7; // = -1.6 mm

// Grip groove dimensions
num_grooves = 18;
groove_diameter = 2;
groove_radius = groove_diameter / 2;

// Pointer groove dimensions
pointer_width = 1.5;
pointer_depth = 1;

// Print quality
$fn = 64;

// Main knob body
difference() {
    // Solid cylinder
    cylinder(h = knob_height, r = knob_radius, center = false);
    
    // D-shaped blind bore (centered on Z axis, extending from z=0 up to bore_depth)
    // The D-shape: a circle with one side cut flat
    // The flat is at distance d_flat_offset from center (negative means flat is on the -X side)
    // We create the D-shape by subtracting a half-space from a cylinder
    translate([0, 0, 0]) {
        difference() {
            // Cylindrical bore
            cylinder(h = bore_depth + 0.1, r = bore_radius, center = false);
            
            // Cut the flat side: remove material where x < d_flat_offset
            // This creates a flat surface at x = d_flat_offset
            // We use a large box that extends past the bore
            translate([d_flat_offset - 0.01, -knob_radius - 1, -0.1]) {
                cube([knob_radius + 1, 2 * knob_radius + 2, bore_depth + 0.3]);
            }
        }
    }
    
    // 18 evenly spaced vertical grip grooves along the outer surface
    for (i = [0 : num_grooves - 1]) {
        angle = i * 360 / num_grooves;
        // Position the groove center on the outer surface
        translate([knob_radius * cos(angle), knob_radius * sin(angle), 0]) {
            // Rotate so the half-cylinder faces inward
            rotate([0, 0, -angle]) {
                // Half-cylinder groove: cut into the knob from the outside
                // The groove is a half-cylinder of diameter 2 mm, centered on the surface
                // So it extends groove_radius inward and groove_radius outward (but outward is outside the knob)
                translate([0, 0, 0]) {
                    difference() {
                        cylinder(h = knob_height + 0.1, r = groove_radius, center = false);
                        // Remove the outer half (outside the knob) - not strictly necessary but clean
                        translate([-groove_radius - 0.01, -groove_radius - 0.01, -0.1]) {
                            cube([groove_radius + 0.02, 2 * groove_radius + 0.02, knob_height + 0.3]);
                        }
                    }
                }
            }
        }
    }
    
    // Pointer groove on top face: 1.5 mm wide, 1 mm deep, from center to outer edge
    // On the same side as the flat of the D (the flat is at x = d_flat_offset = -1.6 mm, so negative X side)
    // The groove runs from center (0,0) to outer edge in the -X direction
    // The previous code had a bug: it used a cube that was too wide in Y (knob_radius)
    // It should be a thin slot along X, centered on Y=0
    translate([-pointer_width/2, -pointer_width/2, knob_height - pointer_depth]) {
        cube([pointer_width, pointer_width, pointer_depth + 0.1]);
    }
    // Extend the groove to the edge
    translate([-pointer_width/2, -pointer_width/2, knob_height - pointer_depth]) {
        cube([knob_radius + pointer_width/2, pointer_width, pointer_depth + 0.1]);
    }
}