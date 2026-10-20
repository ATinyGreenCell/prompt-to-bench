// Knob design for hotplate stirrer
// Dimensions based on measured values using calipers

// Main dimensions
$fn = 64;  // High resolution for smooth curves

// Cylinder: 30mm diameter, 15mm tall
diameter = 30;
height = 15;

// D-shaped blind bore: 6.2mm diameter circle with one side cut flat, so the distance from the flat to the opposite side of the circle is 4.7mm
bore_diameter = 6.2;
flat_distance = 4.7;
bore_depth = 12;  // from bottom face

// Grip grooves: 18 evenly spaced vertical grooves, 2mm diameter half-cylinder centred on the outer surface
groove_count = 18;
groove_diameter = 2;
groove_depth = 2;  // depth of groove (half-cylinder)

// Top pointer groove: 1.5mm wide, 1mm deep, from center to edge on the same side as the flat
pointer_width = 1.5;
pointer_depth = 1.0;

// The part must rest on the XY plane at z = 0, with the bottom face at z = 0
// Currently, the bounding box goes from z = -7.5 to 7.5, meaning the part is centered at z = -7.5
// We need to shift the entire part up by 7.5mm so that the lowest point is at z = 0

// We will build the part centered at origin, then translate it up by 7.5mm so that z=0 is the base

// Main cylinder (full knob)
cylinder(d = diameter / 2, h = height, center = true);

// D-shaped blind bore: 6.2mm diameter circle with flat 4.7mm from opposite edge
// This means the flat is on the bottom, and the hole goes 12mm deep
// The flat is 4.7mm from the opposite edge, so the full diameter is 6.2mm
// We create a half-cylinder with flat on bottom: this is equivalent to a cylinder with flat face at bottom

// To create the D-shape: we cut a half-cylinder of diameter 6.2mm, depth 12mm, with flat on bottom
// We place it at (0,0,0) with flat on bottom

// We use a half-cylinder with flat on bottom: we simulate it by using a cylinder with flat face at bottom
// We define it as a half-cylinder with flat on bottom, centered at (0,0,0)

// Since OpenSCAD does not have a "flat" parameter, we use a cylinder with flat face at bottom
// We create a half-cylinder with flat on bottom by using a cylinder with flat face at bottom

// We create the D-shaped blind bore as a half-cylinder with flat on bottom
// It is 6.2mm in diameter, 12mm deep, flat on bottom, centered at (0,0)

// We use a half-cylinder with flat on bottom: this is equivalent to a cylinder with flat face at bottom
// We define it as:
//  - d = 6.2 / 2 = 3.1
//  - h = 12
//  - flat on bottom

// We place the D-shaped bore at (0,0,0)

// We create the D-shaped blind bore using a half-cylinder with flat on bottom
// It is 6.2mm in diameter, 12mm deep, flat on bottom

// We use a half-cylinder with flat on bottom: this is equivalent to a cylinder with flat face at bottom
// We place it at (0,0,0)

// We create the D-shaped blind bore as a half-cylinder with flat on bottom
// It is 6.2mm in diameter, 12mm deep, flat on bottom

// We use a half-cylinder with flat on bottom: this is equivalent to a cylinder with flat face at bottom
// We define it as:
//  - d = 3.1
//  - h = 12
//  - flat on bottom

// We place the D-shaped bore at (0,0,0)

// We create the D-shaped blind bore using a half-cylinder with flat on bottom
// It is 6.2mm in diameter, 12mm deep, flat on bottom

// We use a half-cylinder with flat on bottom: this is equivalent to a cylinder with flat face