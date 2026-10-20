// --- Dimensions (mm) ---
knob_diameter = 30.0;          // Total diameter of the knob
knob_height = 15.0;            // Total height of the knob
d_shaft_circle_dia = 6.2;      // Diameter of the circular part of the D-bore
d_shaft_flat_dist = 4.7;       // Distance from flat to opposite side of D-bore
d_bore_depth = 12.0;           // Depth of the D-shaped bore
grip_groove_dia = 2.0;         // Diameter of the half-cylinder grooves
grip_groove_count = 18;        // Number of vertical grooves
pointer_width = 1.5;           // Width of the pointer groove
pointer_depth = 1.0;           // Depth of the pointer groove

// --- Constants ---
$fn = 64;

// --- Main Model ---
// The knob is printed with the bottom face at Z=0
difference() {
    // Main Body
    cylinder(h = knob_height, d = knob_diameter, center = false);

    // 1. D-shaped Blind Bore
    // We create the D-shape by subtracting a segment from a cylinder
    translate([0, 0, -0.01]) // Extend slightly below Z=0 to ensure clean cut
    difference() {
        cylinder(h = d_bore_depth + 0.01, d = d_shaft_circle_dia);
        
        // Subtracting a block to create the flat side of the D-bore
        // The distance from center to flat is d_shaft_flat_dist / 2
        // We move the block so it cuts the side of the cylinder
        translate([0, -(d_shaft_circle_dia/2 + 1), 0])
        cube([d_shaft_circle_dia + 2, d_shaft_flat_dist/2 + 1, d_bore_depth + 0.02]);
        
        // Note: The user specified: "distance from the flat to the opposite side is 4.7mm"
        // This means the distance from center to flat is (4.7 - 6.2)/2? No.
        // If the diameter is 6.2, and the flat-to-edge distance is 4.7, 
        // then the distance from center to flat is 4.7 - (6.2/2) = 4.7 - 3.1 = 1.6mm.
        // Let's recalculate the offset based on the user's specific measurement:
        // Distance from center to flat = (4.7 - (6.2/2)) is wrong.
        // Let's use the geometry: Total height of D = 4.7. Radius = 3.1.
        // Distance from center to flat = 4.7 - 3.1 = 1.6.
    }
    
    // Corrected D-bore logic:
    // We will use a more robust method for the D-shape:
    // A cylinder minus a segment.
    // The distance from center to the flat face is: (4.7 - 6.2/2) is not right.
    // Let's re-read: "6.2 mm diameter circle with one side cut flat, 
    // and the distance from the flat to the opposite side is 4.7 mm."
    // This means the "height" of the D-shape is 4.7mm.
    // Since the radius is 3.1, the flat is 3.1 - (4.7 - 3.1) = 1.5mm from center? No.
    // Let's use: distance_from_center_to_flat = 4.7 - 3.1 = 1.6mm.
    // Wait, if the diameter is 6.2, the radius is 3.1. 
    // If the distance from flat to edge is 4.7, then the flat is 4.7 - 3.1 = 1.6mm from center.
    // Let's use that.
    
    // Re-implementing D-bore subtraction properly:
    // (This part is inside the difference block)
    // We'll use a helper to define the D-bore shape
}

// --- Refined Model Construction ---

module d_bore_shape(dia, flat_to_edge) {
    radius = dia / 2;
    dist_to_flat = flat_to_edge - radius;
    difference() {
        cylinder(h = d_bore_depth + 2, d = dia);
        // The cutting block to make it a D-shape
        // We move it to the edge of the circle
        translate([0, -radius, 0])
        cube([dia, radius - dist_to_flat, d_bore_depth + 2]);
        // Wait, the math: if dist_to_flat is 1.6, and radius is 3.1.
        // The flat is at y = -1.6.
        // The block should be at y = -3.1 to -1.6.
    }
}

// Let's restart the structure for clarity and precision
module knob_body() {
    cylinder(h = knob_height, d = knob_diameter);
}

module d_bore() {
    // Diameter 6.2, Flat-to-edge 4.7. 
    // Radius = 3.1. 
    // Distance from center to flat = 4.7 - 3.1 = 1.6.
    // We want to cut the part of the cylinder where y < -1.6.
    // Wait, if the distance from flat to opposite side is 4.7, 
    // and the radius is 3.1, then the flat is 4.7 - 3.1 = 1.6mm from the center.
    // So the flat is at y = -1.6.
    
    difference() {
        cylinder(h = d_bore_depth + 0.1, d = d_shaft_circle_dia);
        // The cutting block to create the flat
        // We move it to the side of the cylinder.
        // The flat is at y = -1.6. The cylinder edge is at y = -3.1.
        // So the block is from y = -3.1 to y = -1.6.
        translate([0, -3.1, -0.05])
        cube([d_shaft_circle_dia + 0.1, 3.1 - 1.6, d_bore_depth + 0.2]);
    }
}

// Final Assembly
union() {
    difference() {
        knob_body();
        
        // 1. D-bore (Blind)
        translate([0, 0, -0.01])
        d_bore();
        
        // 2. Grip Grooves (Vertical half-cylinders)
        for (i = [0 : grip_groove_count - 1]) {
            rotate([0, 0, i * (360 / grip_groove_count)])
            translate([knob_diameter/2, 0, 0])
            cylinder(h = knob_height + 1, d = grip_groove_dia);
        }
        
        // 3. Pointer Groove (Top face)
        // "On the top face, cut a pointer groove 1.5 mm wide and 1 mm deep 
        // that runs from the centre to the outer edge, on the same side as the flat of the D."
        // The flat is at y = -1.6. The center is 0. 
        // To be "on the same side", we align the groove along the Y axis.
        translate([-pointer_width/2, -knob_diameter/2, knob_height - pointer_depth])
        cube([pointer_width, knob_diameter, pointer_depth + 0.1]);
    }
}

// Note on the D-bore math:
// Diameter = 6.2 -> Radius = 3.1.
// Flat to opposite side = 4.7.
// Distance from center to flat = 4.7 - 3.1 = 1.6.
// The code uses this logic.