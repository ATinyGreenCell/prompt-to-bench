// Replacement knob for hotplate stirrer with 6 mm D-shaft
// Dimensions
d_shaft = 6.0;           // shaft diameter (mm)
d_knob = 30.0;           // knob outer diameter (mm)
h_knob = 15.0;           // knob total height (mm)
h_bore = 12.0;           // depth of D-bore (mm)
d_bore = 6.2;            // bore circle diameter (mm)
flat_to_flat = 4.7;      // distance from flat side to opposite side of D-bore (mm)
groove_d = 2.0;          // groove diameter (half-cylinder) (mm)
n_grooves = 18;          // number of grip grooves
pointer_width = 1.5;     // pointer groove width (mm)
pointer_depth = 1.0;     // pointer groove depth (mm)

// Geometry calculations
r_knob = d_knob / 2;
r_bore = d_bore / 2;
// Distance from center to flat side of D-bore
h_flat = sqrt(r_bore^2 - (flat_to_flat/2)^2);
// Height of D-bore flat from center (negative because flat is at bottom)
y_flat = -h_flat;

// Set resolution for curves
$fn = 64;

module knob() {
    // Main cylinder
    cylinder(h = h_knob, r = r_knob, center = false);
}

module d_bore() {
    // D-shaped blind bore: cylinder with flat cut on one side
    translate([0, 0, -0.01]) {
        // Full cylinder
        cylinder(h = h_bore + 0.02, r = r_bore, center = false);
        
        // Cut flat side: extrude a rectangle to remove material
        // The flat is at y = -h_flat, and extends across the diameter
        translate([0, y_flat, -0.01]) {
            cube([d_bore + 0.02, flat_to_flat + 0.02, h_bore + 0.02]);
        }
    }
}

module grip_grooves() {
    r_groove = groove_d / 2;
    // Create semicircular groove profile (outer half-cylinder)
    // The groove is centered at r = r_knob - r_groove, and extends radially outward
    // We'll use rotate_extrude with a semicircle pointing outward
    
    // Define the semicircle profile in the r-z plane (r as x-axis, z as y-axis)
    // The semicircle has radius r_groove, centered at (r_knob - r_groove, 0)
    // We want the outer half (pointing away from center), so we'll use angles -90 to 90 degrees
    
    // Create the semicircular groove profile
    translate([r_knob - r_groove, 0, -0.01]) {
        rotate_extrude(angle = 180, $fn = 32) {
            // Semicircle pointing outward: from y = 0 to y = r_groove (top half in local coordinates)
            // But we need to flip it so it points outward
            // Use a polygon that represents a semicircle pointing in +r direction
            polygon(points = [
                [0, 0],
                [r_groove, 0],
                [r_groove, h_knob + 0.02],
                [0, h_knob + 0.02]
            ]);
        }
    }
}

module pointer_groove() {
    // Pointer groove: from center to outer edge, 1.5mm wide, 1mm deep
    // On the same side as the flat of the D (positive y side)
    // Width is along the circumference, so we need a wedge-shaped groove
    
    // Calculate the angle for the pointer groove
    // The groove is 1.5mm wide at the outer edge (radius = r_knob)
    // Angle = width / radius (in radians)
    pointer_angle = (pointer_width / r_knob) * (180 / PI);
    
    // But since the groove is radial, we'll use a different approach
    // Create a triangular wedge from center to edge
    // The groove is 1.5mm wide at the outer edge, so we need to calculate the angle
    
    // Actually, simpler: use a rotated wedge
    // The groove is centered on the positive y-axis (same side as D-flat)
    // So we'll rotate it to align with the D-flat side
    
    // Define the groove as a wedge
    rotate([0, 0, -pointer_angle/2]) {
        linear_extrude(height = pointer_depth, center = false, convexity = 10) {
            // Triangle from center to outer edge
            polygon(points = [
                [0, 0],
                [r_knob, -pointer_width/2],
                [r_knob, pointer_width/2]
            ]);
        }
    }
}

module knob_with_features() {
    difference() {
        knob();
        
        // D-shaped bore
        translate([0, 0, h_knob - h_bore]) {
            d_bore();
        }
        
        // Grip grooves
        // Use rotate_extrude approach for grip grooves
        // Create the semicircular groove profile and rotate it
        r_groove = groove_d / 2;
        
        // Create the groove profile as a semicircle pointing outward
        // We'll do this by creating a full cylinder and subtracting the inner half
        // But rotate_extrude is cleaner
        
        // Define the semicircle profile in the r-z plane
        // The profile is a semicircle of radius r_groove, centered at (r_knob - r_groove, 0)
        // We want the outer half, so we'll use angles -90 to 90 degrees
        
        // Create the semicircular groove
        translate([r_knob - r_groove, 0, -0.01]) {
            rotate_extrude(angle = 180, $fn = 32) {
                // Semicircle pointing outward: use a rectangle that will be rotated to make a hollow cylinder
                // But we need a semicircle, so use a polygon
                polygon(points = [
                    [0, 0],
                    [r_groove, 0],
                    [r_groove, h_knob + 0.02],
                    [0, h_knob + 0.02]
                ]);
            }
        }
        
        // Pointer groove
        translate([0, 0, h_knob - pointer_depth - 0.01]) {
            rotate([0, 0, 90]) {  // Align with D-flat side (positive y-axis)
                pointer_groove();
            }
        }
    }
}

// Build the final knob
knob_with_features();