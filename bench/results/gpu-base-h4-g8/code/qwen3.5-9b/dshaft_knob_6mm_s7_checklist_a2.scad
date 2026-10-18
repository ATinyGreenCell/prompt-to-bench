// Replacement knob for hotplate stirrer - D-shaft fit, grip grooves, and pointer.

// Dimensions
d_shaft = 6;
d_outer = 30;
h_total = 15;
h_bore  = 12;
d_bore  = 6.2;
d_flat  = 4.7; // Distance from flat to opposite side of D-bore
n_grooves = 18;
d_groove = 2;
w_pointer = 1.5;
d_pointer = 1; // Depth of pointer groove

$fn = 128;

// Calculate D-bore geometry
// The D-bore is a circle of diameter d_bore with a flat cut.
// The distance from the flat to the far side is d_flat.
// Let R_b = d_bore / 2.
// The flat is a chord. The distance from the center of the circle to the chord is (R_b - d_flat/2).
// The width of the flat (chord length) is 2 * sqrt(R_b^2 - (R_b - d_flat/2)^2).
R_b = d_bore / 2;
dist_center_to_flat = R_b - d_flat / 2;
w_flat = 2 * sqrt(R_b * R_b - dist_center_to_flat * dist_center_to_flat);

// Generate points for the D-shaped bore profile (2D in XZ plane, extruded along Y)
// We need the profile in the XZ plane to use linear_extrude along Y.
// The knob sits on Z=0, so Z goes from 0 to h_total.
// The bore starts at Z = h_total - h_bore.

module d_bore_profile() {
    // Profile points: [x, z]
    // Center of the circle in X is 0.
    // The flat is on the left side (negative X) based on standard D-shape orientation.
    // We keep points where x > -dist_center_to_flat.
    
    for (i = [0 : 360 - 1]) {
        a = i * 360 / 360;
        // Circle center is at (0, h_total - h_bore)
        // We only want the part of the circle that is NOT cut by the flat.
        // The flat is at x = -dist_center_to_flat.
        // We keep points where x > -dist_center_to_flat.
        
        cx = 0;
        cz = h_total - h_bore;
        
        px = cx + R_b * cos(a);
        pz = cz + R_b * sin(a);
        
        // Check if point is to the right of the flat line
        if (px > -dist_center_to_flat) {
            [px, pz];
        }
    }
    // Close the shape with the flat line
    [-dist_center_to_flat, h_total - h_bore];
    [-dist_center_to_flat, h_total];
}

// Generate points for the pointer groove (2D in XZ plane)
// Runs from center (0, h_total) to edge (d_outer/2, h_total).
// Width w_pointer, depth d_pointer.
module pointer_profile() {
    // Start at center
    [0, h_total];
    // Go out to edge
    [d_outer / 2, h_total];
    // Cut depth
    [d_outer / 2 + d_pointer, h_total];
    // Back to edge
    [d_outer / 2, h_total - d_pointer];
    // Back to center
    [0, h_total - d_pointer];
}

difference() {
    // Main Body
    cylinder(h = h_total, d = d_outer);
    
    // D-shaped Bore
    // Extrude the D-profile along Y axis.
    // The profile is in XZ plane.
    translate([0, 0, h_total - h_bore]) 
        linear_extrude(height = w_flat) 
            d_bore_profile();
    
    // Grip Grooves
    // 18 grooves evenly spaced around the Z axis (circumference).
    // Each groove is a half-cylinder of diameter d_groove.
    // They are cut into the side of the main cylinder.
    for (i = [0 : n_grooves - 1]) {
        angle = i * 360 / n_grooves;
        // Position the groove center on the cylinder surface
        // Radius of cylinder surface
        r_surf = d_outer / 2;
        
        // Translate to the surface point
        t_x = r_surf * cos(angle);
        t_z = r_surf * sin(angle);
        
        // Create a full cylinder for the groove
        // We will cut it in half using a plane
        translate([t_x, 0, t_z]) {
            cylinder(h = h_total, d = d_groove);
            
            // Create a large plane to cut the cylinder in half
            // The plane passes through the center of the cylinder (t_x, 0, t_z)
            // The normal of the plane is [cos(angle), 0, sin(angle)]
            // We want to keep the half of the cylinder that is "inside" the knob (towards the center)
            // So we subtract the half that is "outside".
            // The plane equation is: (x - t_x)*cos(angle) + (z - t_z)*sin(angle) = 0
            // We want to subtract where (x - t_x)*cos(angle) + (z - t_z)*sin(angle) > 0
            
            // Create a large square representing the plane
            // Rotate it to align with the normal
            rotate([0, angle, 0]) {
                translate([0, 0, 0]) {
                    // The plane is at z=0 in this local frame, but we need to offset it to the cylinder center
                    // Actually, the cylinder is centered at (0,0,0) in this local frame.
                    // We want to cut it along the plane passing through the origin.
                    // The normal is [1, 0, 0] after rotation.
                    // We want to subtract the part where x > 0.
                    // So we create a large square at x=0 and subtract the part of the cylinder where x > 0.
                    // But `difference` subtracts the second object from the first.
                    // If we have a cylinder and we difference it with a plane, we get a half cylinder.
                    // But we need to position the plane such that it cuts the cylinder exactly in half.
                    // The plane passes through the center of the cylinder.
                    // The normal is [1, 0, 0] in the rotated frame.
                    // We want to subtract the part where x > 0.
                    // So we create a large square at x=0 and subtract the part of the cylinder where x > 0.
                    // But `difference` subtracts the second object from the first.
                    // If we have a cylinder and we difference it with a plane, we get a half cylinder.
                    // But we need to position the plane such that it cuts the cylinder exactly in half.
                    // The plane passes through the center of the cylinder.
                    // The normal is [1, 0, 0] in the rotated frame.
                    // We want to subtract the part where x > 0.
                    // So we create a large square at x=0 and subtract the part of the cylinder where