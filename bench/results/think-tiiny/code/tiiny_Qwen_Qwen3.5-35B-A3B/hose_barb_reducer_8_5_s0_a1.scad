// Units are millimeters.
// Design: Straight hose-barb reducer (8mm to 5mm tubing)
// Orientation: Standing upright along Z axis (XY plane at z=0)
// Centered on origin in X and Y.

// --- Dimensions ---
// Inner bore diameter (constant through full length)
bore_diameter = 3;
bore_radius = bore_diameter / 2;

// --- Section 1: 8mm Tubing Side (z=0 to z=20) ---
// Two identical barbs, each 10mm tall
barb1_height = 10;
barb2_height = 10;

// Barb 1 dimensions
barb1_bottom_diameter = 7.5;
barb1_top_diameter = 9.5;
barb1_bottom_radius = barb1_bottom_diameter / 2;
barb1_top_radius = barb1_top_diameter / 2;

// Barb 2 dimensions (identical to Barb 1)
barb2_bottom_diameter = 7.5;
barb2_top_diameter = 9.5;
barb2_bottom_radius = barb2_bottom_diameter / 2;
barb2_top_radius = barb2_top_diameter / 2;

// --- Section 2: Cylindrical Collar (z=20 to z=25) ---
collar_diameter = 12;
collar_radius = collar_diameter / 2;
collar_height = 5;

// --- Section 3: 5mm Tubing Side (z=25 to z=41) ---
// Two identical barbs, each 8mm tall
barb3_height = 8;
barb4_height = 8;

// Barb 3 dimensions
barb3_bottom_diameter = 6.5;
barb3_top_diameter = 5.0;
barb3_bottom_radius = barb3_bottom_diameter / 2;
barb3_top_radius = barb3_top_diameter / 2;

// Barb 4 dimensions (identical to Barb 3)
barb4_bottom_diameter = 6.5;
barb4_top_diameter = 5.0;
barb4_bottom_radius = barb4_bottom_diameter / 2;
barb4_top_radius = barb4_top_diameter / 2;

// --- Geometry Construction ---

// Create the 2D profile for the outer shape in XY plane
// This profile will be rotated around Z to create the symmetric part
// Profile points: (x, y) where x is radius, y is height along Z
// We'll create a polygon that represents the outer contour

// Function to create a single barb profile (taper then step back)
// Returns a polygon with points in XY plane (X=radius, Y=height)
fn_barb_profile(bottom_radius, top_radius, height) {
    return polygon([
        [bottom_radius, 0],
        [top_radius, height],
        [bottom_radius, height]
    ]);
}

// Create the 2D profile for the entire outer shape
// We need to build this as a single polygon that represents the outer contour
// Starting from z=0, going up to z=41

// Build the outer profile polygon
outer_profile = [
    // Section 1: Barb 1 (z=0 to z=10)
    [barb1_bottom_radius, 0],
    [barb1_top_radius, barb1_height],
    [barb1_bottom_radius, barb1_height],
    
    // Section 1: Barb 2 (z=10 to z=20)
    [barb2_bottom_radius, barb1_height],
    [barb2_top_radius, barb1_height + barb2_height],
    [barb2_bottom_radius, barb1_height + barb2_height],
    
    // Section 2: Collar (z=20 to z=25)
    [collar_radius, barb1_height + barb2_height],
    [collar_radius, barb1_height + barb2_height + collar_height],
    
    // Section 3: Barb 3 (z=25 to z=33)
    [barb3_bottom_radius, barb1_height + barb2_height + collar_height],
    [barb3_top_radius, barb1_height + barb2_height + collar_height + barb3_height],
    [barb3_bottom_radius, barb1_height + barb2_height + collar_height + barb3_height],
    
    // Section 3: Barb 4 (z=33 to z=41)
    [barb4_bottom_radius, barb1_height + barb2_height + collar_height + barb3_height],
    [barb4_top_radius, barb1_height + barb2_height + collar_height + barb3_height + barb4_height],
    [barb4_bottom_radius, barb1_height + barb2_height + collar_height + barb3_height + barb4_height]
];

// Create the outer shape by rotating the profile around Z axis
// We use rotate_extrude on a 2D shape in XY plane
// Actually, for Z symmetry, we need to create a 2D shape in XY plane and rotate it 360 degrees
// But rotate_extrude rotates around X axis, so we need to think differently

// Better approach: Create a 2D polygon in XY plane representing the cross-section
// Then use rotate_extrude to create the 3D shape

// Actually, the simplest approach for a Z-symmetric part:
// Create a 2D profile in the XY plane (X=radius, Y=height)
// Then use rotate_extrude to rotate around X axis - this won't work for Z symmetry

// Correct approach: Use rotate_extrude on a 2D shape in the YZ plane
// Then rotate the result 90 degrees around X to make it Z-symmetric

// Actually, let's use a simpler approach:
// Create the shape using cylinder with varying radii via linear_extrude on a 2D shape

// Create a 2D polygon representing the outer contour in XY plane
// X = radius, Y = height (Z in 3D)
outer_contour = polygon(outer_profile);

// Extrude this 2D shape along Z to create the 3D shape
// But we need to rotate it 360 degrees around Z axis

// Use rotate_extrude on a 2D shape in XY plane
// This rotates around X axis, so we need to adjust

// Actually, the cleanest approach:
// Create a 2D profile in the YZ plane (Y=radius, Z=height)
// Then use rotate_extrude to rotate around X axis
// Then rotate the result 90 degrees around X to make it Z-symmetric

// Let's use a different approach: create the shape directly
// using multiple cylinders and unions

// Create the base shape
base_shape = union() {
    // Section 1: Barb 1 (z=0 to z=10)
    // Tapered cylinder from radius 3.75 to 4.75
    linear_extrude(height=barb1_height, center=false) {
        // Create a shape that tapers
        polygon([
            [barb1_bottom_radius, 0],
            [barb1_top_radius, barb1_height],
            [barb1_bottom_radius, barb1_height]
        ]);
    }
    
    // Section 1: Barb 2 (z=10 to z=20)
    linear_extrude(height=barb2_height, center=false) {
        polygon([
            [barb2_bottom_radius, 0],
            [barb2_top_radius, barb2_height],
            [barb2_bottom_radius, barb2_height]
        ]);
    }
    
    // Section 2: Collar (z=20 to z=25)
    linear_extrude(height=collar_height, center=false) {
        circle(r=collar_radius);
    }
    
    // Section 3: Barb 3 (z=25 to z=33)
    linear_extrude(height=barb3_height, center=false) {
        polygon([
            [barb3_bottom_radius, 0],
            [barb3_top_radius, barb3_height],
            [barb3_bottom_radius, barb3_height]
        ]);
    }
    
    // Section 3: Barb 4 (z=33 to z=41)
    linear_extrude(height=barb4_height, center=false) {
        polygon([
            [barb4_bottom_radius, 0],
            [barb4_top_radius, barb4_height],
            [barb4_bottom_radius, barb4_height]
        ]);
    }
};

// Create the inner bore
bore_shape = linear_extrude(height=41, center=false) {
    circle(r=bore_radius);
};

// Subtract the bore from the base shape
final_shape = difference() {
    base_shape;
    translate([0, 0, -0.01]) {
        bore_shape;
    }
};

// Render the final shape
render() {
    final_shape;
}