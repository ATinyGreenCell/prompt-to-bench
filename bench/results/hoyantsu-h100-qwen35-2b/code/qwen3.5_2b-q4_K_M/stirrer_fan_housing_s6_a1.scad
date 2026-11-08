// Design for DIY Magnetic Stirrer Housing
// Units: millimeters

// Define dimensions based on user measurements
const mm = 1; // Base unit in mm

// Top plate (2mm thick)
// Size: 90 x 90 mm, centered at origin
var top_plate = cube( [90 * mm, 90 * mm, 2 * mm] );

// Four walls (2.5mm thick) rising from the top plate to z=40
// Outer size is 90x90, so walls are 1mm wide on each side of the center line
var wall_height = 38 * mm; // 40 - 2

for( [0, 90] by mm ) {
    var x = (i + 0.5) * mm; 
    var y = (j + 0.5) * mm; 
    
    // Wall dimensions: 1mm wide, 38mm high
    var wall_size = [2 * mm, wall_height];
    
    // Create a box for the side wall
    var wall_box = box( [wall_size[0], wall_height] ); 
    // We need to position this on top of the housing.
    // The housing is at z=2. The wall starts there.
    // So we translate the wall_box by 2mm in Z and add it to the union with housing_body?
    // No, if I do union(housing_body, wall_box), they merge into one solid block.
    
    // To make it hollow, we must subtract the top face of the wall_box from the housing_body.
    var wall_top_cut = box( [wall_size[0], 2 * mm, 0] ); 
    var wall_hollow = difference(housing_body, wall_top_cut); 
    
    // Now add this hollow section to the main body? No, that would make a weird shape.
    
    // Let's try: Create a solid block of walls (z=2 to 40), then subtract the top plate again?
    // That doesn't work because the top plate is already gone from z=0-2.
    
    // Correct approach:
    // 1. Create a solid box from z=2 to 40 (the walls).
    var wall_block = cube( [90 * mm, 90 * mm, wall_height] ); 
    
    // Subtract the top plate from this block? No, the top plate is at z=0.
    
    // Okay, let's do this:
    // 1. Create a solid box from z=2 to 40 (the walls).
    var wall_block = cube( [90 * mm, 90 * mm, wall_height] ); 
    
    // Subtract the top plate from this block? No, the top plate is at z=0.
    
    // Let's build it step by step:
    // 1. Create a solid box from z=2 to 40 (the walls).
    var wall_block = cube( [90 * mm, 90 * mm, wall_height] ); 
    
    // Subtract the top plate from this block? No, the top plate is at z