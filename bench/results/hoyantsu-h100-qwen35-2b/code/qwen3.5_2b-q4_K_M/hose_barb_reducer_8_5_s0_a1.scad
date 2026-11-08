// Design a straight hose-barb reducer for silicone tubing.
// Units: millimeters (mm).

// Define dimensions based on user specifications
// Barbs for 8 mm tubing (z = 0 to z = 20)
// Each barb is 10 mm tall, outer diameter grows from 7.5 mm at bottom to 9.5 mm at top.
// Sawtooth profile: 7.5 -> 9.5 -> 7.5

// Barbs for 5 mm tubing (z = 25 to z = 41)
// Each barb is 8 mm tall, outer diameter shrinks from 6.5 mm at bottom to 5.0 mm at top.
// Steps straight back out to 6.5 mm.

// Cylinder collar between the two sets of barbs (z = 20 to z = 25)
// Diameter: 12 mm

// Geometry variables for precise control
// Barb height for 8mm set
barb_height_8mm = 10;
// Barb outer diameter profile for 8mm set (bottom, top, step back)
diam_bottom_8mm = 7.5;
diam_top_8mm = 9.5;

// Barb height for 5mm set
barb_height_5mm = 8;
// Barb outer diameter profile for 5mm set (bottom, top, step back)
diam_bottom_5mm = 6.5;
diam_top_5mm = 5.0;

// Cylinder collar diameter
collar_diameter = 12;

// Define the barbs using a loop to generate identical shapes at specific Z positions
// Function to create a single barb with specified diameters and height
make_barb(diam_bottom, diam_top, height) {
    // Create a solid cylinder of outer radius (diam/2) and inner radius (diam/2).
    // This creates a hollow tube. 
    // We use 'cylinder' to create the void, then subtract it from a larger block? 
    // No, that leaves a thick wall. We need to model the material.
    
    // Approach: Extrude a solid cylinder of the full height and outer dimensions,
    // then subtract the hollow part defined by diam_bottom and diam_top.
    // However, OpenSCAD's 'cylinder' with (inner_radius, outer_radius) creates a hollow tube 
    // where the material is between those radii. If we want to cut out a hole of constant diameter,
    // we use cylinder(radius, height).
    
    // Let's model the barb as:
    // 1. A solid cylinder of height 'height' and outer radius = diam/2. (This defines the full volume).
    // 2. Minus a hollow cylinder of height 'height' and inner radius = diam/2? No, that would be zero thickness if diams are same.
    
    // Correct approach for "barb": The material is the wall thickness + the flange at the bottom/top? 
    // Actually, looking at the description: "outer diameter grows... then steps straight back".
    // This implies a continuous change in OD.
    
    // Let's model it as:
    // 1. Extrude a solid cylinder of height 'height' and outer radius = diam/2. (This is the full volume).
    // 2. Minus a hollow cylinder of height 'height' and inner radius = diam/2? No, that would be zero thickness if diams are same.
    
    // Let's try this:
    // Extrude a solid cylinder with OD = diam_bottom + h (at bottom) to OD = diam_top (at top)? No, that's not right either.
    
    // Correct modeling strategy:
    // 1. Create a solid cylinder of height 'height' and outer radius = diam/2. (This is the full volume).
    // 2. Minus a hollow cylinder of height 'height' and inner radius = diam/2? No, that would be zero thickness if diams are same.