// Mini Horizontal Gel Electrophoresis Buffer Tank
// Outer dimensions: 120 (X) x 70 (Y) x 40 (Z)
// Wall thickness: 3 mm
// Floor thickness: 3 mm
// Inner platform: 60 (X) x 70 (Y) x 10 (height above inner floor)
// Electrode holes: 2 mm diameter, horizontal along X, at Y=0, Z=30 (outer coords)

$fn = 64;

// Outer Dimensions
X_out = 120;
Y_out = 70;
Z_out = 40;

// Wall Thickness
wall = 3;

// Floor Thickness
floor_t = 3;

// Inner Dimensions (calculated from outer and walls)
X_in  = X_out - 2 * wall;
Y_in  = Y_out - 2 * wall;
Z_in  = Z_out - floor_t; // Inner floor is at Z = floor_t

// Platform Dimensions
plat_len = 60; // Length in X
plat_w   = Y_in; // Spans full inner width
plat_h   = 10;  // Height above inner floor

// Electrode Hole Specs
hole_d   = 2;
hole_y   = wall; // Centered on Y axis (Y=0 in local coords if centered, but prompt says Y=0 relative to tank center? Prompt says "at y = 0". Assuming tank center is Y=0. So hole is on the centerline of the tank width.)
hole_z   = Z_out - 30; // Prompt says z=30. Assuming Z=0 is bottom outer. So 30mm from bottom.
// Wait, prompt says "z = 30". If Z_out is 40, and floor is 3, inner floor is at 3.
// If the hole is at Z=30 (from bottom), it is 10mm from the top.
// The prompt says "horizontal hole along X at y = 0, z = 30".
// Let's assume the coordinate system origin is the bottom center of the tank.
// So hole Z is 30. Hole Y is 0 (centerline).

// Helper to create the main tank shell
module tank_shell() {
    // Create the outer block
    translate([0, 0, 0]) cube([X_out, Y_out, Z_out]);
    
    // Cut out the inner volume (air space)
    // Inner volume starts at Z = floor_t
    translate([wall, wall, floor_t]) cube([X_in, Y_in, Z_in]);
}

// Helper to create the platform
module platform() {
    // Platform sits on the inner floor.
    // Inner floor is at Z = floor_t.
    // Platform top is at Z = floor_t + plat_h.
    // Platform bottom is at Z = floor_t.
    
    // Position: Centered in X, Full width in Y, Height from inner floor
    translate([
        (X_out - plat_len) / 2, 
        0, // Centered in Y (Y_in / 2 - Y_in / 2 = 0 relative to center)
        floor_t
    ]) 
    cube([plat_len, plat_w, plat_h]);
}

// Helper to create the electrode holes
// Hole is a cylinder drilled horizontally along X.
// Center at (X_center, Y=0, Z=30).
// Length needs to go through the wall thickness.
// Wall thickness is 3mm. So length = 3 + 3 = 6mm? 
// Actually, the hole goes through the wall. The wall is 3mm thick.
// So the cylinder should be slightly longer than 3mm to ensure clean cut.
// Let's make it 4mm long.
module electrode_hole() {
    // Position: Center of the tank in X, Y=0, Z=30
    translate([X_out / 2, 0, 30]) {
        // Cylinder along X axis
        rotate([90, 0, 0]) cylinder(h = wall + 1, d = hole_d);
    }
}

// Main assembly
difference() {
    union() {
        tank_shell();
        platform();
    }
    
    // Cut electrode holes
    // There are two holes, one at each end wall (X ends).
    // The hole is horizontal along X.
    // We need to cut a cylinder that spans the entire width of the tank at the specific Y and Z.
    // The hole is 2mm diameter.
    // The tank is 120mm long. The hole goes through the 3mm wall.
    // We need to cut a cylinder that is long enough to pass through the wall.
    // Let's cut a cylinder of length 4mm (slightly more than wall thickness 3mm).
    // Position: Center of the tank in X, Y=0, Z=30.
    
    // Wait, the prompt says "Through each end wall... drill a 2 mm diameter horizontal hole along X".
    // This implies the hole is centered on the tank's X-axis? Or centered on the wall?
    // Usually, for a horizontal hole through an end wall, it is centered on the tank's longitudinal axis (Y=0) and at the specified Z.
    // The hole runs along X.
    // So we place a cylinder at (X_center, Y=0, Z=30) with axis along X.
    // The cylinder length should be enough to clear the wall.
    
    // Let's define the cut cylinder.
    // Center: (X_out/2, 0, 30)
    // Axis: X
    // Diameter: hole_d
    // Length: wall + 1 (to ensure it cuts through)
    
    // We need two holes? "Through each end wall".
    // If the hole is centered at X_out/2, it goes through the middle of the tank.
    // Does it go through both end walls? No, it goes through the center.
    // Ah, "Through each end wall" usually means there is a hole in the Left wall and a hole in the Right wall.
    // If the hole is horizontal along X, and centered at X_out/2, it is in the middle of the tank.
    // Maybe the user means the hole is centered on the tank's X-axis, so it passes through the middle of the tank?
    // Or maybe the hole is centered on the wall?
    // "Through each end wall... drill a ... hole along X".
    // If I drill a hole along X through the left wall, it enters the tank.
    // If I drill a hole along X through the right wall, it enters the tank.
    // If the hole is centered at X_out/2, it is in the middle of the tank.
    // Let's assume the hole is centered on the tank's X-axis (X_out/2) and runs along X.
    // This would mean the hole is in the middle of the tank, not "through each end wall" in the sense of being at the ends.
    // However, if the hole is at X_out/2, it is equidistant from both ends.
    // Perhaps the user means the hole is centered on the tank's X-axis, and the hole is long enough to exit both walls?
    // No, that would be a hole through the entire tank.
    // "Through each end wall" implies two separate holes, one in the left wall and one in the right wall.
    // If the hole is horizontal along X, and centered at X_out/2, it is in the middle.
    // Maybe the user means the hole is centered on the tank's Y-axis (Y=0) and Z=30, and runs along X.
    // If it runs along X, it goes from left to right.
    // If it is centered at X_out/2, it is in the middle.
    // If it is centered at X=0 (left wall) or X=X_out (right wall), it is at the end.
    // Let's re-read: "Through each end wall ... drill a 2 mm diameter horizontal hole along X at y = 0, z = 30".
    // This phrasing is slightly ambiguous.
    // Interpretation A: Two holes. One in the left wall, one in the right wall. Both centered at Y=0, Z=30.
    // Interpretation B: One hole in the middle of the tank, running along X, centered at Y=0, Z=30.
    // "Through each end wall" strongly suggests Interpretation A.
    // So we need a hole in the left wall (centered at X=wall) and a hole in the right wall (centered at X=X_out-wall).
    // Both holes run along X.
    // So we place a cylinder at (X=wall, Y=0, Z=30) with length = wall + 1.
    // And another at (X=X_out-wall, Y=0, Z=30)