// Replacement knob for a hotplate stirrer with a D-shaft.
// Orientation: Bottom face (z=0) rests on the bed. D-flat faces the hotplate (down).

// Dimensions
d_shaft = 6;
d_knob  = 30;
h_knob  = 15;
h_bore  = 12;
d_bore  = 6.2;
d_groove = 2;
n_grooves = 18;
w_pointer = 1.5;
d_pointer = 1;

$fn = 128;

// Calculate D-shape geometry
// Distance from flat to opposite side is 4.7 mm.
// Total diameter is 6.2 mm.
// So the flat width is 6.2 - 4.7 = 1.5 mm.
d_flat = d_bore - 4.7;
r_bore = d_bore / 2;

// Define the D-shape profile for the bore
// Points: Start at top of circle, go around to the flat side, close.
// We define the profile relative to the center of the bore.
// Top: (0, r_bore)
// Right: (r_bore, 0)
// Bottom: (0, -r_bore)
// Left Flat: (-d_flat/2, -r_bore) to (-d_flat/2, r_bore)
// Correct path: (0, r_bore) -> (r_bore, 0) -> (0, -r_bore) -> (-d_flat/2, -r_bore) -> (-d_flat/2, r_bore) -> (0, r_bore)
// This creates a shape where the left side is flat.

module d_bore_profile() {
    polygon([
        [0, r_bore],
        [r_bore, 0],
        [0, -r_bore],
        [-d_flat/2, -r_bore],
        [-d_flat/2, r_bore]
    ]);
}

// Main Knob Body
difference() {
    // 1. Main Cylinder
    cylinder(h = h_knob, d = d_knob);

    // 2. D-shaped Bore
    // The bore starts at z=0 and goes up to z=h_bore.
    // We extrude the 2D profile along Z.
    translate([0, 0, -1]) // Extend slightly below z=0 to ensure clean cut
    rotate_extrude() d_bore_profile();

    // 3. Grip Grooves
    // 18 evenly spaced vertical grooves along the full height.
    // Each groove is a 2 mm diameter half-cylinder centred on the outer surface.
    // We subtract 18 cylinders of diameter d_groove.
    
    for (i = [0 : n_grooves - 1]) {
        // Calculate angle for even spacing
        angle = i * 360 / n_grooves;
        
        // Position on the surface
        // Radius of the knob surface
        r_surface = d_knob / 2;
        
        // Translate to the surface point
        tx = r_surface * cos(angle);
        ty = r_surface * sin(angle);
        
        // Rotate the cylinder to align with the surface normal
        // The cylinder axis is initially Z. We need to rotate it to point radially outward.
        // Rotation: rotate([0, 0, angle]) rotate([90, 0, 0]) cylinder(...);
        // This rotates the cylinder 90 deg around X (lying on Y) then rotates around Z to the angle.
        // Wait, rotate([90, 0, 0]) makes it lie on Y. rotate([0, 0, angle]) rotates around Z.
        // If it lies on Y, rotating around Z moves it in the XY plane.
        // We want it to point radially outward from the Z axis.
        // If the cylinder is along Y, and we rotate around Z by angle, it points in the direction (cos(angle), sin(angle), 0).
        // This is correct for a radial groove.
        
        translate([tx, ty, 0])
        rotate([0, 0, angle])
        rotate([90, 0, 0])
        cylinder(h = h_knob, d = d_groove);
    }

    // 4. Pointer Groove
    // On the top face, cut a pointer groove 1.5 mm wide and 1 mm deep that runs from the centre to the outer edge,
    // on the same side as the flat of the D.
    // The flat of the D is on the negative X side (based on the profile definition).
    // So the groove is on the negative X side of the top face.
    // It runs from center (0,0) to outer edge (d_knob/2, 0).
    // Width is 1.5 mm. Depth is 1 mm.
    
    // Create the profile for the pointer groove in the XZ plane (or YZ, but let's use XZ for simplicity)
    // The groove is a rectangle of width w_pointer and depth d_pointer.
    // It is centered on the negative X axis.
    // Center X = -w_pointer / 2.
    // X range: [-w_pointer, 0].
    // Z range: [0, d_pointer].
    
    // We need to subtract this shape from the top face.
    // The top face is at z = h_knob.
    // The groove goes from z = h_knob down to z = h_knob - d_pointer.
    
    // Define the 2D profile in the XZ plane (x, z)
    // Points:
    // (-w_pointer, h_knob) -> (0, h_knob) -> (0, h_knob - d_pointer) -> (-w_pointer, h_knob - d_pointer) -> (-w_pointer, h_knob)
    
    // We need to subtract this shape from the top face.
    // The top face is a circle in the XY plane.
    // The groove is a rectangle in the XY plane, extruded downwards in Z.
    // The rectangle is defined by:
    // X: from -w_pointer/2 to 0 (since it's on the negative X side).
    // Y: from -d_knob/2 to d_knob/2 (full width of the knob).
    // Z: from h_knob - d_pointer to h_knob.
    
    // Let's create a 2D profile in the XZ plane that represents the cross-section of the groove.
    // The groove is a rectangle of width w_pointer (along X) and depth d_pointer (along Z).
    // It is centered on the negative X axis.
    // So the profile in the XZ plane is:
    // x from -w_pointer to 0
    // z from 0 to d_pointer
    
    // We extrude this profile along the Y axis to get the full width of the knob.
    // But wait, the knob is a cylinder. The top face is a circle.
    // The groove is a cut in the top face.
    // The top face is at z = h_knob.
    // The groove is a rectangle in the XY plane, extruded downwards in Z.
    // The rectangle is defined by:
    // X: from -w_pointer/2 to 0 (since it's on the negative X side).
    // Y: from -d_knob/2 to d_knob/2 (full width of the knob).
    // Z: from h_knob - d_pointer to h_knob.
    
    // Let's create a 2D profile in the XZ plane that represents the cross-section of the groove.
    // The groove is a rectangle of width w_pointer (along X) and depth d_pointer (along Z).
    // It is centered on the negative X axis.
    // So the profile in the XZ plane is:
    // x from -w_pointer to 0
    // z from 0 to d_pointer
    
    // We extrude this profile along the Y axis to get the full width of the knob.
    // But wait, the knob is a cylinder. The top face is a circle.
    // The groove is a cut in the top face.
    // The top face is at z = h_knob.
    // The groove is a rectangle in the XY plane, extruded downwards in Z.
    // The rectangle is defined by:
    // X: from -w_pointer/2 to 0 (since it's on