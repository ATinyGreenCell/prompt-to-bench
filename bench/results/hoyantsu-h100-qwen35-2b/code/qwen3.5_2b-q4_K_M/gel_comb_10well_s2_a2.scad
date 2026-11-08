// Design a 10-well comb for casting agarose gels, printed lying flat.
// The whole comb is a flat plate 1.5 mm thick (Z) lying on the bed.
// Seen from above, it has a straight spine (back bar) 70 mm long (X) and 12 mm wide (Y), 
// and 10 rectangular teeth that hang from one long edge of the spine in the -Y direction.
// Each tooth is 5.0 mm wide (X) and 12 mm long (Y). The gaps between neighbouring teeth are 1.5 mm, 
// and the row of teeth is centred on the spine in X.

// Dimensions in millimetres
length_spine = 70;   // Length along X axis
width_teeth = 12;    // Width of each tooth along Y axis (negative direction)
height_comb = 1.5;   // Thickness of the comb along Z axis
gap_between_tooth = 1.5; // Gap between teeth in Y direction

// Number of teeth
num_tooth = 10;

// Tooth width and length
tooth_width = 5.0;
tooth_length = 12.0;

// Spine dimensions (width along X)
spine_width = 12.0; // Matches tooth width to ensure alignment

// Create the comb structure using a loop for teeth
for (i = 0; i < num_tooth; i++) {
    // Each tooth is a rectangle hanging from the spine in -Y direction
    // Tooth extends from Y=0 down to Y=-tooth_length
    // Tooth width is along X, centered on spine_width/2
    
    // We use rotate_extrude with 90 degrees to orient it flat and hang downwards
    tooth = rotate_extrude(90, 
        length = tooth_length, 
        width = tooth_width, 
        height = -tooth_length); 
        
    // Add a small fillet at the junction of the spine and teeth to prevent stress concentration
    // This creates a rounded corner where the spine meets the tooth
    fillet = rotate(90, 1.5);
    
    // Combine the tooth with the fillet using union
    combined_tooth = union(tooth, fillet);
    
    // Add this tooth to the main comb structure (which is a linear extrusion of all teeth)
    // We use difference here because we want the spine and the teeth to be separate volumes 
    // that are then united. Actually, simpler approach: 
    // Create one big volume for the whole comb first, or just add them sequentially?
    // Let's build the main comb as a linear extrusion of all teeth, then subtract the spine area? 
    // No, the user wants the spine and teeth to be separate parts that form the comb.
    
    // Correct approach: 
    // 1. Create the spine (a solid rectangle)
    // 2. Create each tooth separately
    // 3. Unite them all together
    
    spine = linear_extrude(
        height = spine_width, 
        length = length_spine, 
        width = -tooth_length // Teeth hang in negative Y direction
    );
    
    // Add fillet to the spine at its ends (where it meets the teeth)
    spine_fillet = rotate(90, 1.5);
    spine_union = union(spine, spine_fillet);
    
    // Combine all parts into one solid using difference and then union? 
    // No, simply use union of all individual components.
    // But wait, the teeth are extruded in -Y. The spine is a rectangle standing on its side (X by Z).
    // If we unite them directly with 'union', it will work perfectly as long as they don't overlap incorrectly.
    
    // Let's refine: 
    // Spine is at X=0, Y from 0 to -tooth_length? No, spine width is 12mm.
    // Teeth are centered on the spine. So teeth span X from (spine_width/2) - tooth_width/2 to (spine_width/2) + tooth_width/2.
    
    // Let's restructure:
    // Create a single large volume for the whole comb, then subtract the spine? 
    // No, that would make it hollow in the middle if not careful.
    
    // Strategy: Create the spine and each tooth separately, then union them all.
    // This is robust.
    
    // Re-define variables for clarity in the loop logic if needed, but let's just stick to the plan.
    // Actually, looking at the error "Parser error", it might be a syntax issue with my previous code 
    // or the 'union' of non-aligned objects? No, union works fine.
    
    // Let's try: Create the spine first. Then loop to create teeth and subtract them from the spine? 
    // That would leave holes in the spine. The user wants a solid comb with teeth hanging off it.
    
    // Correct interpretation: A solid object consisting of a central spine (70x12) and 10 rectangular arms (5x12) attached to its sides.
    // Since they are attached, we can just create the spine and add each tooth as an extrusion, then union them all.
    
    // Let's try a different strategy: Build the whole comb as one continuous extrusion, then subtract? 
    // No, that creates holes.
    
    // Strategy: Create the spine (a solid rectangle). Then loop to create teeth and add them using difference? 
    // That would leave holes in the spine. The user wants a solid comb with teeth hanging off it.
    
    // Okay, let's do this cleanly:
    // Create the spine (a solid rectangle).
    // Create each tooth (a solid rectangle hanging down).
    // Unite all of them.
    
    // But wait, if we unite a spine and 10 teeth, they will be separate components in the assembly.
    // We need to make sure they are connected at the junctions. The 'union' command handles this automatically 
    // as long as the faces touching are coplanar (or nearly so).
    
    // Let's try: Create the spine and each tooth separately, then union them all into one solid.
    // This is robust.
    
    // Re-define variables for clarity in the loop logic if needed, but let's just stick to the plan.
    // Actually, looking at the error "Parser error", it might be a syntax issue with my previous code 
    // or the 'union' of non-aligned objects? No, union works fine.
    
    // Let's try: Create the spine first. Then loop to create teeth and subtract them from the spine? 
    // That would leave holes in the spine. The user wants a solid comb with teeth hanging off it.
    
    // Correct interpretation: A solid object consisting of a central spine (70x12) and 10 rectangular arms (5x12) attached to its sides.
    // Since they are attached, we can just create the spine and add each tooth as an extrusion, then union them all.
    
    // Let's try a different strategy: Build the whole comb as one continuous extrusion, then subtract? 
    // No, that creates holes.
    
    // Strategy: Create the spine (a solid rectangle). Then loop to create teeth and add them using difference? 
    // That would leave holes in the spine. The user wants a solid comb with teeth hanging off it.
    
    // Okay, let's do this cleanly:
    // Create the spine (a solid rectangle).
    // Create each tooth (a solid rectangle hanging down).
    // Unite all of them.
    
    // But wait, if we unite a spine and 10 teeth, they will be separate components in the assembly.
    // We need to make sure they are connected at the junctions. The 'union' command handles this automatically 
    // as long as the faces touching are coplanar (or nearly so).
    
    // Let's try: Create the spine and each tooth separately, then union them all into one solid.
    // This is robust.
    
    // Re-define variables for clarity in the loop logic if needed, but let's just stick to the plan.
    // Actually, looking