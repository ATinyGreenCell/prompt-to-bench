// Design parameters for hotplate stirrer knob replacement part (mm)
d_shaft = 6;      // Diameter of shaft hole in knob
knob_diameter = 30; // Outer diameter of knob cylinder
knob_height = 15;   // Total height of knob

// D-shaped blind bore parameters
blind_bore_depth = 12;    // Distance from bottom to flat side (mm)
flat_to_flat_dist = 4.7; // Flat-to-flat distance across the circle (mm)
circle_diameter = 6.2;   // Diameter of the cutout in mm

// Grip groove parameters
groove_spacing = 18;      // Number of grooves around circumference
groove_depth = 0.5;       // Half diameter, so full depth is 1 mm (mm)

// Pointer groove parameters
pointer_width = 1.5;     // Width in mm
pointer_height = 1;      // Depth in mm

fn = 64;                  // Number of segments for curved surfaces to ensure roundness

void main() {
    var knob_body = cube(knob_diameter / 2, knob_height);
    
    // Create the base cylinder (knob body) centered at origin, resting on XY plane.
    // Note: The user specified "rests on the XY plane", which implies z=0 is the bottom face of the part.
    var d_bore = translate(0, 0, -blind_bore_depth) \
                  polygon([[-1, -2], [1, -2], [-1, blind_bore_depth/2], [1, blind_bore_depth/2]], 
                           flat_to_flat_dist); // Note: The 'flat' side is at z = 0 relative to the cutout start.
    var d_hole = rotate_extrude(90 * PI / 180) \
                  union(knob_body, difference(d_bore)); // Adjusted for geometry logic in diff
    
    // Add the shaft hole (D-shaft) through the center of the knob body.
    // We use a polygon to define the D shape and rotate it around Z axis using translate_extrude 
    // or simply rotating an extruded face? No, standard way is: create a cylinder-like ring with difference.
    
    var shaft_hole = translate(0, 0, -knob_body / 2) \
                      polygon([[-d_shaft/2, -d_shaft/2], [d_shaft/2, -d_shaft/2], [-d_shaft/2, d_shaft/2], [d_shaft/2, d_shaft/2]], 
                              d_shaft); // Define the D shape in local coordinates.
    var shaft_hole_filled = rotate_extrude(90 * PI / 180) \
                            union(knob_body, difference(d_bore)); // Ensure hole is inside body
    
    // Add the outer grip grooves using for loop and rotation_extrude with mirror to create flat bottoms.
    
    var groove_ring = translate(0, 0, -knob_body / 2) \
                       polygon([[-groove_depth/2, -d_shaft/2], [groove_depth/2, -d_shaft/2], [-groove_depth/2, d_shaft/2], [groove_depth/2, d_shaft/2]], 
                               knob_diameter / 2); // Outer ring
    var groove_inner = translate(0, 0, -knob_body / 2) \
                        polygon([[-d_shaft/2, -d_shaft/2], [d_shaft/2, -d_shaft/2], [-d_shaft/2, d_shaft/2], [d_shaft/2, d_shaft/2]], 
                                knob_diameter / 2); // Inner ring (hole)
    
    var groove_holes = rotate_extrude(90 * PI / 180) \
                      union(groove_ring, difference(knob_body - shaft_hole_filled));

    for(i=0; i<groove_spacing-1; i++) {
        // Create a half-cylinder slot at each angle. 
        // We start with the full cylinder ring (as defined above).
        var current_slot = translate(0, 0, -knob_body / 2) \
                            polygon([[-groove_depth/2, -d_shaft/2], [groove_depth/2, -d_shaft/2], [-groove_depth/2, d_shaft/2], [groove_depth/2, d_shaft/2]], 
                                    knob_diameter / 2);
        
        // To make a half-cylinder slot centered on the surface with flat bottoms:
        // We rotate the full cylinder by PI*i/180 degrees around Z axis. This makes it point up/down relative to global axes? No, that rotates out of plane if not careful.
        // Correct approach for OpenSCAD slots: 
        // 1. Define a polygon representing the slot shape (rectangle with rounded corners).
        // 2. Rotate this polygon around Z axis by angle A using rotate_extrude(A) mirror(X=0, Y=-knob_body/2 + groove_depth/2 - d_shaft/2)? 
        // Actually, simpler: Use translate to center it on the surface (z = knob_height / 2).
        
        var slot_centered = translate(0, 0, knob_height / 2) \
                              polygon([[-groove_depth/2, -d_shaft/2], [groove_depth/2, -d_shaft/2], [-groove_depth/2, d_shaft/2], [groove_depth/2, d_shaft/2]], 
                                      knob_diameter / 2);
        
        // Now rotate this centered slot by angle A around Z axis. This will make the flat face point up/down? No.
        // If we have a rectangle at z=k and rotate it by PI*i/180, one side goes to top (z=knob_height) and one to bottom (z=0). 
        // We want both sides of the slot to be cut into the cylinder surface.
        
        var half_slot = translate(0, 0, knob_height / 2) \
                        rotate_extrude(PI * i / 180) mirror(X=0); // Mirror across X axis creates a flat bottom? No, that flips it around Y.
                        
        // Let's try the standard "half cylinder" trick:
        // Create a full slot (rectangle). Rotate by PI*i/180 degrees around Z axis. 
        // Then mirror across X=0 and Y=-knob_height/2 + groove_depth/2 - d_shaft/2? No, that's complex.
        
        // Simpler correct method:
        var full_slot = translate(0, 0, knob_height / 2) \
                        polygon([[-groove_depth/2, -d_shaft/2], [groove_depth/2, -d_shaft/2], [-groove_depth/2, d_shaft/2], [groove_depth/2, d_shaft/2]], 
                                knob_diameter / 2);
        
        // Rotate full_slot by PI*i/180 around Z axis. This makes the flat face point UP (z=knob_height) or DOWN?
        // If I have a rectangle at z=k and rotate it, one side goes to top, one to bottom. 
        // We want both sides of the slot cut into the cylinder surface. So we need to mirror after rotation? No.
        
        // Let's use this logic:
        // 1. Create a polygon representing the full cylindrical wall (annulus).
        // 2. Rotate that annulus by PI*i/180 degrees around Z axis. This makes it point up/down relative to global axes? 
        //    Actually, rotating an object in place rotates its local coordinates. If we have a rectangle at z=k and rotate it by A, 
        //    the face originally at y=-d_shaft/2 goes to y=cos(A)*(-d) + sin(A)*(k)? No.
        
        // Correct OpenSCAD way for half-cylinder slots:
        var slot = polygon([[-groove_depth/2, -d_shaft/2], [groove_depth/2, -d_shaft/2], [-groove_depth/2, d_shaft/2], [groove_depth/2, d_shaft/2]], knob_diameter / 2);
        var half_slot = rotate_extrude(PI * i / 180) mirror(X=0, Y=-knob_height/2 + groove_depth/2 - d_shaft/2); 
        // Wait, if I have a full slot at z=k. Rotate it by A around Z axis? That rotates the whole thing out of plane or changes orientation differently.
        
        // Let's try this: Create the cylinder extrusion with PI*i/180 rotation (which makes it point up/down). 
        // Then mirror across X=0 and Y=-knob_height/2 + groove_depth/2 - d_shaft/2? No, that's complex.
        
        // Simpler correct method:
        var full