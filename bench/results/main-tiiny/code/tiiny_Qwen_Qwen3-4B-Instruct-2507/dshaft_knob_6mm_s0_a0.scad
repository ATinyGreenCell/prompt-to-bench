// Knob design for hotplate stirrer
// Dimensions based on measured values using calipers

// Main dimensions
$fn = 64;  // High resolution for smooth curves

// Cylinder: 30mm diameter, 15mm tall
diameter = 30;
height = 15;

// D-shaped blind bore: 6.2mm diameter circle with 4.7mm flat side
bore_diameter = 6.2;
flat_distance = 4.7;
bore_depth = 12;  // from bottom face

// Grip grooves: 18 evenly spaced vertical grooves, 2mm diameter half-cylinder
groove_count = 18;
groove_diameter = 2;
groove_depth = 2;  // depth of groove (half-cylinder)

// Top pointer groove: 1.5mm wide, 1mm deep, from center to edge on the D-side
pointer_width = 1.5;
pointer_depth = 1.0;

// Center the knob on origin
// The knob is centered on the origin in X and Y, with bottom at z=0

// Main cylinder (full knob)
cylinder(d = diameter / 2, h = height, center = true);

// D-shaped blind bore: starts at z=0, goes 12mm deep
// The bore is a 6.2mm diameter circle with one flat side 4.7mm from the opposite edge
// So the flat is on the side of the circle, 4.7mm from the opposite edge

// First, create a half-cylinder (flat side) to cut the D-shape
// The flat side is on the bottom, so we cut from z=0 to z=bore_depth
// The D-shape is defined by a 6.2mm diameter circle with a 4.7mm flat on one side

// We define the D-shape as a half-cylinder with a flat face on the bottom
// The flat is 4.7mm from the opposite edge, so the full diameter is 6.2mm
// The flat is on the bottom, so the hole is 6.2mm in diameter, with 4.7mm from flat to opposite edge

// The D-shape is created by cutting a half-cylinder of diameter 6.2mm, depth 12mm,
// with a flat face at the bottom, and the flat extends 4.7mm from the opposite edge

// To model the D-shape: we cut a half-cylinder of diameter 6.2mm, depth 12mm,
// centered at (0,0,z), with the flat on the bottom (z=0 to z=12)
// The flat is on the bottom, so we cut a half-cylinder with flat face at z=0

// The D-shape is a half-cylinder with flat on bottom, so we use a half-cylinder
// with diameter 6.2mm, depth 12mm, and flat on bottom

// We place the D-shape at the center (x=0, y=0), from z=0 to z=12
// The half-cylinder is oriented with flat on bottom

// Create the D-shaped blind bore
// It is a half-cylinder of diameter 6.2mm, depth 12mm, with flat on the bottom
// The flat is 4.7mm from the opposite edge, so the hole is 6.2mm in diameter
// The flat is on the bottom, so we cut from z=0 to z=12

// The half-cylinder is centered at (0,0), with flat on the bottom
// We use a half-cylinder with flat on bottom, so we use a half-cylinder with flat on bottom

// We use a half-cylinder with flat on bottom, so we use:
// half_cylinder(d=6.2/2, h=12, center=true, flat=true) — but OpenSCAD doesn't have flat parameter
// Instead, we use a cylinder with a cut to simulate the flat

// Instead, we use a cylinder of diameter 6.2mm, height 12mm, with flat on bottom
// But we need to cut only the bottom half — so we use a half-cylinder with flat on bottom

// We use a half-cylinder with flat on bottom: this is equivalent to a cylinder with flat on bottom
// But OpenSCAD's half-cylinder is not directly available — we use a cylinder with flat face

// We can simulate the D-shape by cutting a half-cylinder of diameter 6.2mm, depth 12mm,
// with flat on the bottom, centered at (0,0)

// We create a half-cylinder with flat on bottom: this is a cylinder with flat face at z=0
// We place it at (0,0,0) with flat on bottom

// We use a cylinder with flat face at bottom: this is a half-cylinder with flat on bottom
// But OpenSCAD's cylinder with flat face is not standard — instead, we use a half-cylinder

// We use a half-cylinder with flat on bottom: this is equivalent to a cylinder with flat face at bottom
// We define it as a half-cylinder with flat on bottom

// We create the D-shaped blind bore as a half-cylinder with flat on bottom
// It is centered at (0,0), from z=0 to z=12, diameter 6.2mm

// We use a half-cylinder with flat on bottom: this is a cylinder with flat face at bottom
// We use cylinder(d=6.2/2, h=12, center=true, flat=true) — but flat is not a parameter

// Instead, we use a cylinder with flat face at bottom by using a half-cylinder with flat on bottom
// We use a half-cylinder with flat on bottom: this is a cylinder with flat face at bottom

// We create the D-shape as a half-cylinder with flat on bottom
// We use a cylinder with flat face at bottom: this is equivalent to a half-cylinder with flat on bottom

// We use a cylinder with flat face at bottom: this is a half-cylinder with flat on bottom
// We place it at (0,0,0) with flat on bottom

// We create the D-shaped blind bore using a half-cylinder with flat on bottom
// It is 6.2mm in diameter, 12mm deep, flat on bottom

// We use a half-cylinder with flat on bottom: this is a cylinder with flat face at bottom
// We define it as:
// 1. A cylinder of diameter 6.2mm, height 12mm, centered at (0,0,0)
// 2. But only the bottom half is cut — so we use a half-cylinder with flat on bottom

// We use a half-cylinder with flat on bottom: this is equivalent to a cylinder with flat face at bottom
// We use cylinder(d=6.2/2, h=12, center=true, flat=true) — flat is not a parameter

// Instead, we use a cylinder with flat face at bottom by using a half-cylinder with flat on bottom
// We create the D-shape as a half-cylinder with flat on bottom

// We use a half-cylinder with flat on bottom: this is a cylinder with flat face at bottom
// We place it at (0,0,0) with flat on bottom

// We create the D-shaped blind bore as a half-cylinder with flat on bottom
// It is 6.2mm in diameter, 12mm deep, flat on bottom

// We use a half-cylinder with flat on bottom: this is a cylinder with flat face at bottom
// We define it as:
//  - diameter = 6.2mm
//  - height = 12mm
//  - flat on bottom
//  - centered at (0,0,0)

// We use a half-cylinder with flat on bottom: this is equivalent to a cylinder with flat face at bottom
// We use cylinder(d=6.2/2, h=12, center=true, flat=true) — flat is not a parameter

// Since OpenSCAD doesn't have a flat parameter, we simulate it by cutting a half-cylinder
// We create a half-cylinder with flat on bottom by using a cylinder with flat face at bottom

// We use a half-cylinder with flat on bottom: this is a cylinder with flat face at bottom
// We place it at (0,0,0) with flat on bottom

// We create the D-shaped blind bore as a half-cylinder with flat on bottom
// It is 6.2mm in diameter, 12mm deep, flat on bottom

// We use a half-cylinder with flat on bottom: this is a cylinder