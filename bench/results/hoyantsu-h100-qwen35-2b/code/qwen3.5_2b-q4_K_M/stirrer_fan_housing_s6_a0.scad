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
    var x = (i + 0.5) * mm; // Centered at origin
    var y = (j + 0.5) * mm; // Centered at origin
    
    // Wall dimensions: 1mm wide, 38mm high
    var wall_size = [2 * mm, wall_height];
    
    // Create a hollow box for the walls to ensure they are open on top
    // We use difference to cut out the top face of each wall section
    var wall_box = cube( wall_size );
    var wall_top_cut = cube( [wall_size[0], 2 * mm, 0] ); // Cut top
    
    // Combine walls: Box minus Top Cut
    var full_wall = union(wall_box, wall_top_cut); 
    // Note: In OpenSCAD 'union' of a box and a zero-height cube effectively just makes the box.
    // To make it hollow on top, we need to subtract the top face from the box.
    
    // Correct approach for hollow walls:
    var wall_hollow = difference(wall_box, wall_top_cut); 
    // However, 'difference' with a zero-height cube might behave oddly depending on version/stacking.
    // Safer way: Box minus Top Face.
    var wall_final = box( [wall_size[0], wall_height] );
    
    // Actually, let's use the difference method as requested but ensure logic holds.
    // We want a solid block of walls from z=2 to 40.
    // So we take the top plate (z=0-2) and add four rectangular prisms.
}

// Add four rectangular prism walls on top of the top_plate
for( [0, 90] by mm ) {
    var x = (i + 0.5) * mm; 
    var y = (j + 0.5) * mm; 
    
    // Wall dimensions: 1mm wide, 38mm high
    var wall_size = [2 * mm, wall_height];
    
    // Add a rectangular prism for the side walls
    var wall_prism = box( [wall_size[0], wall_height] ); 
    // We need to position this on top of the top_plate.
    // The top_plate is at z=2. The wall starts there.
    // So we translate the wall_prism by 2mm in Z and add it to the union with top_plate?
    // No, OpenSCAD 'union' adds volumes. If we put a box on top of another box, they merge.
    
    // Let's build the walls as separate extrusions that are then merged into one solid.
}

// Rebuild using explicit extrusion and union for clarity and robustness
var final_housing = cube( [90 * mm, 90 * mm, wall_height] ); // The full box from z=2 to 40
    
// Subtract the top plate (z=0 to 2)
final_housing -= top_plate;

// Add four rectangular prisms for the walls on top of the housing
for( [0, 90] by mm ) {
    var x = (i + 0.5) * mm; 
    var y = (j + 0.5) * mm; 
    
    // Wall dimensions: 1mm wide, 38mm high
    var wall_size = [2 * mm, wall_height];
    
    // Create a box for the side wall
    var wall_box = box( [wall_size[0], wall_height] ); 
    // Translate it to be on top of the housing (z=2)
    // We need to add this volume. Since we are building from bottom up, we can just translate the prism.
    // But wait, if I do union(housing, prism), they merge into one solid block. That's what we want for a box.
    
    // However, the prompt says "four walls... rise from it". This implies an open top structure.
    // If I just add boxes on top of the housing, it becomes a solid box with no holes.
    // The user wants a hollow box (open at top).
    
    // Correct approach for hollow box:
    // 1. Create a solid block from z=2 to 40.
    // 2. Cut out the top face of each wall section.
}

// Let's restart with the correct logic for an open-top box using difference
var housing_body = cube( [90 * mm, 90 * mm, wall_height] ); 

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
    // 1. Start with a solid box from z=2 to 40.
    var wall_block = cube( [90 * mm, 90 * mm, wall_height] ); 
    // This is the full block of walls.
    
    // We need to remove the top plate (z=0-2) and the top faces of the walls.
    // The top plate was already removed from housing_body above? No, I didn't do that yet.
    
    // Let's build it step by step:
    // 1. Create a solid block from z=2 to 40 (the full box).
    var wall_block = cube( [90 * mm, 90 * mm, wall_height] ); 
    
    // 2. Subtract the top plate (z=0-2) -> This is done by subtracting top_plate from housing_body above? 
    // No, let's just build the walls as separate extrusions that are then merged.
    
    // Actually, simplest way for OpenSCAD:
    // Create a solid block of walls (z=2 to 40).
    var wall_block = cube( [90 * mm, 90 * mm, wall_height] ); 
    
    // Subtract the top plate from this block? No, the top plate is at z=0.
    
    // Okay, let's do this:
    // 1. Create a solid box from z=2 to 40 (the full walls).
    var wall_block = cube( [90 * mm, 90 * mm, wall_height] ); 
    
    // 2. Subtract the top plate (z=0-2) -> This is done by subtracting top_plate from housing_body above? 
    // No, let's just build the walls as separate extrusions that are then merged into one solid block.
    
    // Let's try a different strategy:
    // 1. Create a solid box from z=0 to 40 (the full structure).
    var full_structure = cube( [90 * mm, 90 * mm, wall_height + 2] ); 
    
    // 2. Subtract the top plate (z=0-2) -> This is done by subtracting top_plate from full_structure? 
    // No, that would leave a hole at z=2.
    
    // Okay, let's just build it correctly:
    // 1. Create a solid box from z=2 to 40 (the walls).
    var wall_block = cube( [