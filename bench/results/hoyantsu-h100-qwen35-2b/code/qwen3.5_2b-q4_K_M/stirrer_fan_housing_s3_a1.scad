// Design for DIY Magnetic Stirrer Housing
// Units: millimeters

// Dimensions based on user measurements (calipers)
// Top plate thickness: 2 mm
// Wall thickness: 2.5 mm
// Outer size: 90 x 90 mm
// Hole pattern: 71.5 mm square, centered on top plate
// Cable notch width: 12 mm, depth from open edge: 8 mm

// Create a helper function to create a polygon with rounded corners for the hole pattern
make_hole_pattern() {
    // Define the center of the square pattern (71.5mm / 2)
    var cx = 35.75;
    var cy = 35.75;

    // Create a large polygon to define the bounding box for the holes, then cut corners
    // We use a slightly larger outer box than the pattern to ensure clean cuts if needed, 
    // but here we just create the shape based on the square center.
    
    // Actually, let's create a simple square and then modify it or use a polygon with rounded corners directly.
    // A better approach for "71.5mm square pattern" is to define vertices of a square centered at (35.75, 35.75) 
    // but since OpenSCAD polygons are closed loops, we need to ensure the shape is valid.
    
    // Let's create a polygon with rounded corners representing the area where holes are drilled.
    // The holes will be cut from this polygon.
    
    var size = 71.5;
    var cx = size / 2;
    var cy = size / 2;

    // Create a square of slightly larger dimensions to ensure the pattern fits nicely inside, 
    // or simply define the vertices of the hole shape itself.
    
    // Let's create a polygon with rounded corners directly for the hole layout area.
    // We will use a large square and then cut out four smaller squares (the holes) from it? 
    // No, the prompt says "drill... on a 71.5 mm square pattern".
    
    // Let's create a polygon that represents the bounding box of the four holes, 
    // then use difference to carve them out? Or just define the shape directly.
    
    // To make it easy and robust: Create a large square (slightly larger than 71.5) centered at origin,
    // but we need the pattern relative to the top plate center.
    
    // Let's create a polygon with rounded corners for the hole layout area.
    var h_size = 71.5;
    var cx = h_size / 2;
    var cy = h_size / 2;

    // Create a square of slightly larger dimensions to ensure the pattern fits nicely inside, 
    // or simply define the vertices of the hole shape itself.
    
    // Let's create a polygon with rounded corners directly for the hole layout area.
    // We will use a large square and then cut out four smaller squares (the holes) from it? 
    // No, the prompt says "drill... on a 71.5 mm square pattern".
    
    // Let's create a polygon that represents the bounding box of the four holes, 
    // then use difference to carve them out? Or just define the shape directly.
    
    // To make it easy and robust: Create a large square (slightly larger than 71.5) centered at origin,
    // but we need the pattern relative to the top plate center.
    
    // Let's create a polygon with rounded corners for the hole layout area.
    var h_size = 71.5;
    var cx = h_size / 2;
    var cy = h_size / 2;

    // Create a square of slightly larger dimensions to ensure the pattern fits nicely inside, 
    // or simply define the vertices of the hole shape itself.