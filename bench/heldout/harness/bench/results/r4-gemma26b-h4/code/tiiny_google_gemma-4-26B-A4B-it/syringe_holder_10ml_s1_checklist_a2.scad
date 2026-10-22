// Wall-mounted syringe holder for 10mL syringe
// Corrected to ensure the barrel channel is a single vertical extrusion
// and the part is perfectly centered on the XY plane.

// --- Dimensions ---
block_w = 50.0;       // Width (X)
block_d = 30.0;       // Depth (Y)
block_h = 40.0;       // Height (Z)

barrel_dia = 16.5;    // Diameter of the syringe barrel channel
barrel_rad = barrel_dia / 2;

flange_w = 34.0;      // Width of the flange slot (X)
flange_h = 2.6;       // Height of the flange slot (Z)
flange_z_start = 30.0; // Bottom of the flange slot
flange_y_end = 11.0;  // How far back the slot goes (Y)

screw_hole_d = 4.5;   // Diameter for M4 screws
screw_hole_x = 19.0;  // Offset from center for screw holes (X)
screw_hole_z = 15.0;  // Height of screw holes (Z)

$fn = 64;

// --- Modeling ---

difference() {
    // Base block centered on XY, sitting on Z=0
    translate([-block_w/2, -block_d/2, 0])
        cube([block_w, block_d, block_h]);

    // 1. Syringe Barrel Channel
    // A vertical extrusion of a half-circle profile.
    // The half-circle is centered at x=0, y=15 (back face).
    // The straight sides run to y=-15 (front face).
    translate([0, block_d/2, 0])
        rotate([90, 0, 0])
            // We use a 2D shape and extrude it to ensure a continuous vertical void
            linear_extrude(height = block_h + 2)
                // The profile is a half-circle centered at the origin (which is y=15)
                // We use a circle and cut it in half.
                // To make it a half-circle facing "forward" (towards -Y), 
                // we use a circle and subtract the back half.
                difference() {
                    circle(d = barrel_dia);
                    // Subtract the part of the circle that would be "behind" the back face
                    // Since the circle is centered at the back face, we subtract the half 
                    // that exists at y > 15.
                    translate([0, barrel_rad, 0])
                        circle(r = barrel_rad + 1); 
                }
    
    // Note: The above logic for the half-circle is tricky with rotation. 
    // Let's use a more robust method: A hull of two half-circles.
    // One half-circle at the back face, one half-circle at the front face.
    // But the spec says "straight sides run forward", implying a semi-cylinder.
    
    // RE-DOING CHANNEL:
    // A semi-cylinder with radius 8.25, axis along X, centered at y=15, z=mid.
    // Wait, the spec says "vertical barrel channel". This means the axis is Z.
    // "Back end is a half-circle... centered at x=0, y=0". 
    // Wait, the user says "back face (y=15)". 
    // If the back face is y=15, and the center is x=0, y=0, that's a contradiction.
    // Re-reading: "back face (y=15) against the wall". 
    // "back end is a half-circle... centered at x=0, y=0". 
    // This implies the center of the circle is at the origin, but the face is at y=15.
    // This means the half-circle is at the center of the block.
    // Let's follow the geometry description: 
    // "back end is a half-circle of 8.25mm radius centered at x=0, y=0"
    // "straight sides run forward to the front face (y=-15)"
    // This means the channel is a semi-cylinder with axis along Z, 
    // centered at x=0, y=0, but the "back" of the channel is at y=0.
    // However, the block is from y=-15 to y=15.
    // If the channel starts at y=0 and goes to y=-15, it's a semi-cylinder.
    
    // Let's use the most logical interpretation for a "vertical channel":
    // A semi-cylinder with axis Z, centered at x=0, y=0.
    // The "back" of the channel is the flat part at y=0.
    // The "front" is the curved part at y=-8.25.
    // But the spec says "straight sides run forward to the front face (y=-15)".
    // This means the channel is a rectangle with a semi-circle at the back.
    // Let's use: Profile = Half-circle at y=0, and a rectangle extending to y=-15.
    
    // Let's re-read: "back end is a half-circle... centered at x=0, y=0"
    // "straight sides run forward to the front face (y=-15)"
    // This means the profile in the XY plane is:
    // A semi-circle centered at (0,0) and a rectangle from y=0 to y=-15.
    // This is exactly what a "U" shape is.
    
    // Let's use a hull of two shapes to be safe:
    // 1. A half-cylinder at the back (centered at 0,0, axis Z)
    // 2. A rectangle at the front (y=-15)
    
    // Wait, the previous code failed because the hull was not vertical.
    // Let's define the channel as a 2D shape and extrude it.
    
    // 1. Syringe Barrel Channel (Corrected)
    translate([0, 0, -1])
    linear_extrude(height = block_h + 2)
    union() {
        // The semi-circle at the back (centered at 0,0)
        // To get a half-circle facing "forward" (towards -Y), 
        // we take a circle and subtract the part where y > 0.
        difference() {
            circle(d = barrel_dia);
            translate([-barrel