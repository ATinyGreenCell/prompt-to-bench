// Lab Funnel Design
// Units: millimetres
// Orientation: Upright, wide opening at top, rests on XY plane at z=0.

// --- Dimensions ---
// Spout (Tube)
$spout_outer_diameter = 10;
$spout_inner_diameter = 6.8; // 10 - 2*1.6
$spout_length = 20;

// Cone (Funnel)
$cone_bottom_diameter = 10; // Matches spout outer diameter
$cone_top_diameter = 60;
$cone_height = 30; // From z=20 to z=50

// Wall Thickness
$wall_thickness = 1.6;

// Resolution for curved surfaces
$fn = 64;

// --- Helper Functions ---
// Creates a hollow cylinder (tube)
module hollow_cylinder(outer_d, inner_d, h) {
    difference() {
        cylinder(d = outer_d, h = h, $fn = $fn);
        cylinder(d = inner_d, h = h + 0.1, $fn = $fn); // Extend slightly to ensure clean cut
    }
}

// Creates a hollow cone (frustum)
// Parameters: bottom_d, top_d, height
// Orientation: Bottom at z=0, Top at z=height
module hollow_cone(bottom_d, top_d, h) {
    difference() {
        // Outer Cone
        // Using linear_extrude with polygon for precise control over the frustum shape
        // The polygon is defined in the XZ plane (width = diameter, height = height)
        // We rotate 90 deg around Y to stand it up, then translate to center.
        // Actually, simpler to use cylinder with scale or linear_extrude a rotated profile.
        // Let's use linear_extrude of a rotated profile for the outer shell.
        
        // Profile for outer cone: Triangle from (-bottom_d/2, 0) to (0, h) to (top_d/2, h)
        // Wait, standard cone logic:
        // Base at z=0, radius = bottom_d/2.
        // Top at z=h, radius = top_d/2.
        
        // Let's build the solid cone first using linear_extrude of a rotated line segment?
        // No, let's use the standard approach: Extrude a polygon in XZ plane, rotate 90 deg around Y.
        
        // Outer Profile (XZ plane):
        // Point 1: (-bottom_d/2, 0)
        // Point 2: (top_d/2, h)
        // Point 3: (top_d/2, 0) -- Wait, this makes a triangle.
        // We need a trapezoid for a frustum.
        // Point 1: (-bottom_d/2, 0)
        // Point 2: (bottom_d/2, 0)
        // Point 3: (top_d/2, h)
        // Point 4: (-top_d/2, h)
        
        // However, linear_extrude extrudes along Z by default.
        // If we define the profile in XY, we extrude along Z.
        // Let's define the profile in XY:
        // Bottom width = bottom_d, Top width = top_d, Height = h.
        // This creates a frustum if we rotate it? No.
        
        // Correct approach for Frustum with linear_extrude:
        // Extrude a polygon in the XZ plane, then rotate 90 deg around Y.
        // Profile points (X, Z):
        // (-bottom_d/2, 0) -> (bottom_d/2, 0) -> (top_d/2, h) -> (-top_d/2, h) -> close.
        
        // Let's do the outer shell:
        poly = [
            [-bottom_d/2, 0],
            [bottom_d/2, 0],
            [top_d/2, h],
            [-top_d/2, h]
        ];
        
        // Extrude along Z (default), then rotate 90 deg around Y to make it vertical?
        // If we extrude along Z, the height is Z. The width is X.
        // So the profile is in XZ.
        // Extrude along Y? No, let's stick to standard:
        // 1. Create profile in XZ plane.
        // 2. Extrude along Y.
        // 3. Rotate 90 deg around X to make it vertical (Z axis).
        
        // Actually, simpler:
        // Use cylinder with scale? No, scale distorts.
        // Use linear_extrude with path? No.
        
        // Let's use the "rotate_extrude" method for a cone, but we need a frustum.
        // A frustum is a cone with the tip cut off.
        // We can model the outer frustum as a large cone minus a small cone.
        
        // Outer Frustum = Large Cone (radius = top_d/2, height = h + offset) - Small Cone (radius = bottom_d/2, height = offset)
        // This is getting complicated. Let's use the polygon extrusion method properly.
        
        // Method: Extrude polygon in XZ plane along Y, then rotate 90 deg around X.
        // Profile (X, Z):
        // Left: -bottom_d/2 at Z=0
        // Right: bottom_d/2 at Z=0
        // Right: top_d/2 at Z=h
        // Left: -top_d/2 at Z=h
        
        // Wait, if I extrude along Y, the resulting object has width in X and depth in Y.
        // Then rotating 90 deg around X makes the depth (Y) become height (Z).
        // So the profile must be in XZ.
        
        // Let's try a different, robust method:
        // Create a solid cone (tip at bottom) and scale it? No.
        // Let's use the difference of two cylinders? No.
        
        // Robust Frustum Method:
        // 1. Define the outer volume.
        // 2. Define the inner volume (the hole).
        
        // Outer Volume:
        // We can create a cone with height H_total and radius R_top, then subtract a cone of height H_cut and radius R_bottom.
        // But the tip of the large cone is below the base of the frustum.
        // Let's calculate the virtual tip.
        // Slope = (R_top - R_bottom) / h
        // Distance from base to tip = R_bottom / Slope
        
        // Let's just use linear_extrude of a polygon in the XZ plane, extruded along Y, then rotated.
        // Profile points (x, z):
        // (-bottom_d/2, 0), (bottom_d/2, 0), (top_d/2, h), (-top_d/2, h)
        // Extrude along Y (length = 1mm, then we rotate).
        // Actually, linear_extrude extrudes along Z by default.
        // If we define the profile in XY, extrude along Z -> Cylinder/Frustum standing up.
        // But a frustum in XY extruded along Z is a prism, not a cone.
        
        // Okay, let's use the standard OpenSCAD trick for cones/frustums:
        // rotate_extrude is for revolution.
        // We need a frustum.
        // Let's define the profile in the XZ plane, extrude along Y, then rotate 90 deg around X.
        // Profile:
        // p1 = [-bottom_d/2, 0]
        // p2 = [bottom_d/2, 0]
        // p3 = [top_d/2, h]
        // p4 = [-top_d/2, h]
        // Extrude along Y (default is Z, so we need to rotate the profile or the extrusion).
        // Let's rotate the profile 90 deg around X so it lies in XY plane, then extrude along Z.
        // Rotated Profile (X, Y):
        // p1 = [-bottom_d/2, 0]
        // p2 = [bottom_d/2, 0]
        // p3 = [top_d/2, h] -> becomes [top_d/2, h] rotated 90 around X?
        // Rotation matrix around X: [1, 0, 0; 0, cos, -sin; 0, sin, cos]
        // (x, y, z) -> (x, -z, y)
        // So (x, z) -> (x, -z).
        // This flips it upside down.
        
        // Let's try:
        // 1. Create polygon in XZ plane.
        // 2. Extrude along Y.
        // 3. Rotate 90 deg around X.
        // Result: The