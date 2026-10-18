// Sowing template for 90 mm Petri dish - flat disc with grid holes and orientation notch.

// Dimensions
DISH_DIA = 90;
DISC_DIA = 85;
THICKNESS = 2;
HOLE_COUNT = 7;
HOLE_DIA = 3;
HOLE_SPACING = 9;
NOTCH_WIDTH = 10;
NOTCH_DEPTH = 4;

$fn = 64;

// Calculate grid offsets to centre the 7x7 grid on the origin
// For 7 holes, indices are 0..6. Centre index is 3.
// Offset = (index - 3) * spacing
grid_offset = (HOLE_COUNT - 1) / 2 * HOLE_SPACING;

difference() {
    // Main disc body
    // Translate to sit on Z=0, centred in X and Y
    translate([0, 0, 0]) 
        cylinder(h = THICKNESS, d = DISC_DIA);

    // Grid of holes
    for (i = [0 : HOLE_COUNT - 1]) {
        for (j = [0 : HOLE_COUNT - 1]) {
            // Calculate position relative to origin
            x = (i - grid_offset) * HOLE_SPACING;
            y = (j - grid_offset) * HOLE_SPACING;
            
            // Cut hole extending slightly past the top face
            // Cylinder starts at Z=0 to ensure intersection with the disc at Z=0..2
            translate([x, y, 0]) 
                cylinder(h = THICKNESS + 1, d = HOLE_DIA);
        }
    }

    // Orientation notch on the +Y side
    // Notch is 10mm wide (X) and 4mm deep (Y)
    // Centred on Y axis, so it spans from -5 to +5 in X
    // It cuts into the rim from the outside inwards
    // The rim is at radius 42.5. We cut a rectangle starting at Y = 42.5 - NOTCH_DEPTH
    
    // Define the notch as a 2D shape extruded along Z
    // The notch is a rectangle in the XY plane, extruded down to cut the disc
    // We position it so it cuts the outer edge
    
    // The notch removes material where:
    // X is between -5 and 5
    // Y is between (42.5 - 4) and 42.5
    
    // We create a block that intersects the disc at the notch location
    // Block dimensions: Width=10, Depth=4, Height=THICKNESS+1
    // Position: X=0, Y = 42.5 - NOTCH_DEPTH, Z = 0
    
    notch_y_start = DISC_DIA / 2 - NOTCH_DEPTH;
    
    translate([0, notch_y_start, 0]) 
        cube([NOTCH_WIDTH, NOTCH_DEPTH, THICKNESS + 1]);
}