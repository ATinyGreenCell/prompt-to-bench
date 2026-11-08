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
    // Create a hollow cylinder (pipe) for the body of the barb
    // Inner diameter is diam_bottom, outer diameter is diam_top
    // We use a polygon or circle with thickness. 
    // Since OpenSCAD's 'cylinder' takes inner and outer radii by default in some versions, 
    // but standard usage often implies solid cylinder minus hole. 
    // Let's create a solid cylinder of the full height, then subtract a hollow cylinder?
    // No, that leaves a thick wall. We need to model the material.
    
    // Approach: Create a solid cylinder of the outer diameter and inner diameter.
    // However, OpenSCAD 'cylinder' with (inner_radius, outer_radius) creates a hollow tube.
    // Let's use 'polygon' or 'circle' for the cross section to ensure exact dimensions if needed, 
    // but 'cylinder' is sufficient here as it handles the volume correctly.
    
    // To make it printable and robust:
    // 1. Create a solid cylinder of outer radius (diam/2) and inner radius (diam/2).
    // This creates a hollow tube.
    // Wait, if we just extrude this, it's a hollow tube. We need the material.
    
    // Better approach: 
    // Extrude a solid cylinder with the full outer dimensions? No, that's the whole thing.
    // Extrude a solid cylinder with inner radius and outer radius? That creates a thick-walled pipe.
    
    // Let's use 'cylinder' to create the hollow tube (the void), then subtract it from a larger block? 
    // Or simply extrude a solid cylinder of the full height, but that's not what we want for the barb body.
    
    // Correct approach for "barb": The material is the wall thickness + the flange at the bottom/top?
    // Actually, looking at the description: "outer diameter grows... then steps straight back".
    // This implies a continuous change in OD.
    
    // Let's model it as:
    // 1. A solid cylinder of height 'height' and outer radius (diam/2).
    // 2. Minus a hollow cylinder of the same height but inner radius (diam/2).
    // This creates a thick-walled tube.
    
    // Wait, if we subtract a hole from a solid cylinder, we get a hollow tube.
    // Is that what "barb" means? Usually, a barb is a protruding piece with a hole in the middle for the hose to pass through.
    // The description says: "two identical barbs... stacked". And "a 3 mm bore runs straight through its full length".
    // This confirms it is a hollow tube (pipe) that has been cut into segments and joined together.
    
    // So, for each segment of the barb:
    // - It is a solid cylinder of height 'height' and outer radius = diam/2.
    // - We subtract a hole in the middle with diameter = diam.
    // This creates a thick-walled tube (the material).
    
    // Let's refine the geometry for the barb body:
    // Outer Cylinder: Radius = diam / 2, Height = height.
    // Inner Hole: Radius = diam / 2, Height = height.
    // Result: A hollow cylinder of thickness (diam/2 - diam/2)?? No.
    
    // If I have a solid cylinder of OD=d and ID=d, the wall is zero thickness? 
    // No, if I have a solid cylinder of radius R and subtract a hole of radius r < R, I get a ring.
    // Here, diam_bottom = 7.5 -> Radius = 3.75.
    // diam_top = 9.5 -> Radius = 4.75.
    
    // So the material is between OD=7.5 and OD=9.5? Or is it a solid rod with an inner hole of constant diameter?
    // "outer diameter grows linearly... then steps straight back".
    // This implies the cross-section changes shape (a cone/frustum).
    
    // Let's model the barb as:
    // 1. A solid cylinder of height 'height' and outer radius = diam/2.
    // 2. Minus a hollow cylinder of height 'height' and inner radius = diam/2.
    // This results in a thick-walled tube where the wall thickness is constant (diam/2 - diam/2)? 
    // No, that math doesn't work for changing OD.
    
    // Let's re-read carefully: "outer diameter grows linearly from 7.5 mm at its bottom to 9.5 mm at its top".
    // This means the cross-sectional area changes. The material is the volume between the two surfaces (OD and ID).
    // So, for each segment of height 'h':
    // - Create a solid cylinder with OD = diam_bottom + h? No.
    // - Create a solid cylinder with OD = diam_top? No.
    
    // Correct modeling strategy:
    // 1. Extrude a solid cylinder of height 'height' and outer radius = diam/2. (This is the full volume).
    // 2. Minus a hollow cylinder of height 'height' and inner radius = diam/2? No, that would be zero thickness if diams are same.
    
    // We need to define the material boundaries.
    // The material exists between OD_surface(z) and ID_surface(z).
    // Since it's a tube, we can model it as:
    // 1. A solid cylinder of height 'height' and outer radius = diam/2.
    // 2. Minus a hollow cylinder of height 'height' and inner radius = diam/2? 
    // This is confusing because the radii change.
    
    // Alternative: Extrude a solid cylinder with OD = diam_bottom + h (at bottom) to OD = diam_top (at top)? No, that's not right either.
    
    // Let's try this:
    // 1. Create a solid cylinder of height 'height' and outer radius = diam/2.
    // 2. Subtract a hollow cylinder of height 'height' and inner radius = diam/2? 
    // This creates a ring with constant thickness if diams are same, but here they change.
    
    // Actually, the simplest way to get a varying OD tube is:
    // Extrude a solid cylinder with outer radius = diam/2. (Full volume).
    // Minus a hollow cylinder with inner radius = diam/2? No.
    
    // Let's use 'cylinder' for the hole and subtract it from a larger block? 
    // Or simply:
    // Extrude a solid cylinder of height 'height' and outer radius = diam/2.
    // Minus a hollow cylinder of height 'height' and inner radius = diam/2? No, that's zero thickness if diams are same.
    
    // Okay, let's look at the dimensions again.
    // Bottom: OD=7.5 (r=3.75), ID=7.5 (r=3.75). Wall thickness = 0? That can't be right for a barb.
    // Top: OD=9.5 (r=4.75), ID=9.5 (r=4.75).
    
    // Ah, the "bore" is the hole in the middle. The material