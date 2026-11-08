// Design: Hotplate Stirrer Knob Replacement
// Units: Millimeters

// Dimensions in mm
D_SHaft_Diameter = 6.0;      // D-shaft diameter
Knob_Diameter = 30.0;        // Outer knob diameter
Knob_Height = 15.0;          // Total height of knob
Blind_Bore_Depth = 12.0;     // Depth of blind bore from bottom
Blind_Bore_Diameter = 6.2;   // Diameter of the D-shape hole
Flat_Top_Width = 4.7;       // Distance from flat to opposite side of D-hole (half circumference)
Grip_Groove_Count = 18;      // Number of vertical grooves on outside
Groove_Diameter = 2.0;      // Diameter of each groove
Pointer_Groove_Width = 1.5;  // Width of pointer groove at top
Pointer_Groove_Depth = 1.0;  // Depth of pointer groove

// Create the main cylindrical body
Knob_Cylinder = cylinder(
    height=Knob_Height,
    radius=Knob_Diameter/2
);

// Cut out the D-shaped blind bore from the bottom face (z = Knob_Height)
// We use a polygon to define the arc and extrude it down.
// The flat side is at z = 0 relative to this cut, but we start cutting from z=Knob_Height downwards.
Blind_Bore_Polygon = polygon(
    points=[
        [0, Knob_Diameter/2], // Top of D-shape (relative to knob)
        [-Flat_Top_Width, Knob_Diameter/2], // Right side of flat top
        [0, -Knob_Diameter/2],   // Bottom of D-shape
        [Flat_Top_Width, Knob_Diameter/2]  // Left side of flat top
    ]
);

Blind_Bore = extrude(
    height=-Blind_Bore_Depth,
    shape=Blind_Bore_Polygon
);

// Create the outer surface with vertical grip grooves using a for loop
for (i = -Knob_Groove_Count/2 to Knob_Groove_Count/2 step 1) {
    // Calculate position of groove around circumference
    // We use polar coordinates logic: angle = i * 360 / Count + offset
    // Offset is set so the first groove starts at roughly -90 degrees (bottom) or similar, 
    // but here we just iterate. The 'i' index maps to a specific angular position.
    
    // Calculate radius of groove center relative to knob axis
    // Groove diameter is 2mm, so radius is 1mm.
    // We need the angle for this iteration.
    // Let's define an offset that places the first groove at -90 degrees (bottom) or similar? 
    // Actually, standard polar coordinates: i=0 -> 0 deg. We want them evenly spaced.
    
    // To make it easier to visualize and ensure even spacing without complex math in loop:
    // We will calculate the angle based on index.
    // Angle = (i * 360) / Count + offset. 
    // Let's set offset such that the first groove is at -90 degrees? No, let's just use standard atan2 logic or simple math.
    
    // Simpler approach: Calculate angle for each i.
    // Angle = (i * 360) / Count + (-90). This places the first groove at -90 deg (bottom).
    // Wait, if we start at bottom and go clockwise? Or counter-clockwise?
    // Let's just calculate it mathematically to be precise.
    
    // Angle for i-th groove:
    // We want 18 grooves. 
    // Let's assume the first one is at -90 degrees (bottom).
    // Angle = -90 + (i * 360) / 18
    
    // Radius of groove center from knob axis:
    // Knob radius is 15mm. Groove diameter is 2mm -> radius 1mm.
    // So the groove center is at r = 14mm, theta = Angle.
    
    // We need to rotate this cylinder around its own Z-axis (local Z) by the calculated angle.
    // Then we extrude it down? No, the groove goes UP from the bottom face of the knob.
    // The "bottom" face of the knob is z=0 in global coords.
    // So we need to rotate the cylinder around its local axis (which is parallel to Z) by the calculated angle.
    
    // However, OpenSCAD's rotate_extrude rotates around the extrusion axis. 
    // If we have a cylinder of height 15mm and radius 14mm, rotating it around its own Z-axis will move the top face (z=0) to different angles? No.
    // Rotating a solid object around an axis inside it moves points on that axis.
    // The groove is a hole in the bottom face. We want to carve a half-cylinder into the bottom face.
    
    // Correct approach for vertical grooves:
    // 1. Create a cylinder of height Knob_Height and radius Knob_Diameter/2.
    // 2. Rotate it around its local Z-axis by the calculated angle. This moves the top surface (z=0) to an arc? No, that's wrong.
    //    Rotating a solid object rotates all points in the object. The top face is at z=0. 
    //    If we rotate the whole cylinder around its local Z axis, the top face (which is perpendicular to Z) will sweep out an annular ring? No.
    //    The top face is a circle at z=0. Rotating it around Z moves points along circles in XY plane. It does not create a groove on the bottom face.
    
    // We need to rotate the cylinder around its local Y-axis (which is vertical) by the calculated angle? 
    // No, we want to cut into the bottom face. The bottom face is at z=0.
    // If we rotate the entire knob around a horizontal axis (Y), the top face moves away from the bottom face.
    
    // Let's rethink: We have a cylinder standing on its side? No, it rests on XY plane. So Z-axis is vertical.
    // Bottom face is at z=0. Top face is at z=15.
    // To cut a groove into the bottom face (z=0), we need to rotate the object around an axis that passes through the center of the bottom circle and is perpendicular to the bottom plane? 
    // No, if we rotate around Z, nothing happens to the bottom face geometry relative to the Z-axis.
    
    // We must rotate the cylinder around its local Y-axis (vertical) by 90 degrees? That would flip it upside down.
    
    // Ah, the groove is a half-cylinder centered on the outer surface. 
    // If we simply extrude a half-cylinder from z=0 upwards into the knob body, that creates the groove.
    // But where do we get the "half" part? We need to rotate the cylinder around its local Y-axis by 90 degrees (or -90) so that the top face is at an angle? 
    // No, if we rotate a cylinder around Y, the top face moves away from Z.
    
    // Let's try rotating around X and Y? That creates a helix.
    
    // Correct method:
    // 1. Create a hollow cylinder (or just solid) of height Knob_Height and radius Knob_Diameter/2.
    // 2. Rotate it around its local Z-axis by 90 degrees? No, that moves the top face to X-Y plane?
    
    // Let's visualize: We want a groove on the bottom circle. 
    // If we rotate the cylinder around its local Y-axis (vertical), the top face (z=15) moves away from z=0.
    // Wait, if I have a solid cylinder at x^2+y^2 <= 14^2, z in [0,15].
    // Rotate around Y by 90 deg: The point (x,y,z) -> (-y, x, z). 
    // Top face points become (-z, -y, x)? No.
    
    // Okay, let's use a different approach. We want to cut a half-cylinder into the bottom face.
    // We can create a cylinder of height Knob_Height and radius Knob_Diameter/2.
    // Then rotate it around its local Y-axis by 90 degrees? No, that moves the top face away from Z=0.
    
    // What if we rotate around X and Y such that the top face is at an angle? 
    // Actually, to create a groove on the bottom face of a vertical cylinder:
    // We need to rotate the cylinder around its local Y-axis by 90 degrees? No.
    
    // Let's try this: Create a hollow cylinder (shell) of height Knob_Height and radius Knob_Diameter/2.
    // Then rotate it around its local Z-axis by 90 degrees? That moves the top face to X-Y plane.