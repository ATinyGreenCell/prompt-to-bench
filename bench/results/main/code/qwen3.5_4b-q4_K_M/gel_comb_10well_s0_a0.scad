// Dimensions for agarose gel casting comb
// Measured with calipers; units in millimetres
$fn = 64; // Ensure smooth curves for holes/teeth

// Main plate dimensions (resting on XY plane, building up +Z)
plate_thickness_z = 1.5;
spine_length_x = 70;
spine_width_y = 12;

// Tooth specifications
tooth_count = 10; // Number of rectangular teeth
tooth_width_x = 5.0; // Width of each tooth in X direction (mm)
tooth_depth_y = 12.0; // Depth/length of each tooth from spine edge in Y direction (mm)

// Spacing between teeth
gap_size_between_teeth = 1.5; // Gap width between adjacent teeth (mm)

// Positioning: Teeth hang from the -Y long edge, centred on X axis relative to spine row
// The comb rests flat on Z=0 plane.

// Calculate total length of the tooth array in Y direction including gaps and depth
total_tooth_array_length = (tooth_count * tooth_depth_y) + ((tooth_count - 1) * gap_size_between_teeth);

// Offset to center the entire row of teeth within the spine width
offset_from_spine_center_x = (spine_width_y / 2.0) - (total_tooth_array_length / 2.0);

// Define base plate geometry: a flat rectangle on Z=0 plane, extending from X=-35 to +35 and Y=-6 to +6
base_plate = cube([spine_length_x, spine_width_y, plate_thickness_z]);

// Function to generate individual tooth extrusions
function make_tooth(x_pos) {
    // Each tooth is a rectangular prism hanging down (-Y direction from the top edge of the spine)
    // The teeth are positioned such that they hang from one long edge (the +X axis line at Y = 6 for this orientation logic, 
    // but since we want them to "hang" in -Y direction starting from an edge, let's define the attachment point carefully).
    
    // Re-evaluating geometry based on description:
    // Spine is X=70mm long (X range), Y=12mm wide. Let spine occupy X:[-35, 35], Y:[-6, 6].
    // Teeth hang from one long edge in the -Y direction. The "long edges" are at Y = +/- 6? 
    // Actually, a rectangle with length 70 (X) and width 12 (Y). Long sides are parallel to X axis.
    // So the teeth should attach along an edge where y is constant (e.g., y=6 or y=-6).
    // "Hanging from one long edge in the -Y direction" implies they extend towards negative Y starting from that edge? 
    // Or does it mean they are oriented such that their length goes into -Y relative to some reference?
    
    // Let's interpret: The spine is a plate. Teeth hang off ONE side (one of the long edges).
    // If we place the spine centered at origin, its Y range is [-6, 6]. 
    // One long edge could be at y = -6 or y = +6. "Hanging in -Y direction" suggests they extend further negative than the attachment point?
    // Or does it mean the teeth themselves are oriented along the -Y axis relative to their base on the spine?
    
    // Standard interpretation for such combs: Teeth protrude from one side of the plate, perpendicular to that side. 
    // If attached at Y = +6 (top edge), and they "hang" in -Y direction, then each tooth extends from y=+6 down to y=(+6) - 12?
    // That would mean teeth go outside the spine's original width if not careful with overlap. 
    // However, usually these combs have a base plate that is wider than just the spine or the "spine" includes the mounting area for teeth.
    
    // Let's re-read: "flat plate 1.5 mm thick (Z) lying on the bed... straight spine ... 70mm long and 12mm wide". 
    // Then "teeth that hang from one long edge of the spine in the -Y direction".
    // This implies the attachment is at an edge, say y = +6. The teeth extend downwards (negative Y) relative to that edge? 
    // If so, they would occupy y > 6 down to y = 6-12 = -6? That overlaps with the spine's other side if not careful.
    
    // Alternative interpretation: The "spine" is just the back bar without teeth. The whole assembly (plate + teeth) has a specific footprint. 
    // But usually, you print one piece. So the plate must be large enough to hold the teeth or the spine extends under them?
    // If the spine is 12mm wide and teeth are 12mm deep hanging from an edge... if they hang OUTSIDE the original width, we need a larger base plate. 
    // But the prompt says "The whole comb is a flat plate ... straight spine". This might imply the spine IS the main body including tooth bases?
    
    // Let's assume the teeth are attached to one side of the 12mm wide spine and extend OUTWARDS in -Y direction (further negative Y). 
    // If attachment edge is at y = +6, extending into -Y means they go from y=+6 down to y=(+6)-12 = -6.
    // This would mean the teeth fill exactly the width of the spine? That doesn't make sense for a "comb" where you need gaps between them 
    // and space below the plate if it's casting (usually agarose is poured into wells, so teeth should be ABOVE Z=0 or part of the mold).
    
    // Wait, standard gel combs: You pour liquid INTO the comb. The comb has a base that stays in place while you remove it? 
    // Or does the whole thing stay and you cut out the gel from between teeth? Usually you keep the plate with teeth embedded or attached to cast the gel around them?
    
    // Most common design: A rectangular block (the spine) with slots/teeth carved into one face. The "plate" is the base that holds everything together. 
    // If the user says "flat plate ... straight spine", maybe the spine IS the main volume and teeth are extrusions from it?
    
    // Let's assume: Base Plate = Spine dimensions (70x12). Teeth hang FROM one long edge (say y=+6) into -Y direction. 
    // If they extend 12mm in length, starting at y=+6 and going to y=-6? That covers the whole spine width.
    // But then where are the gaps between teeth located relative to this? The prompt says "gaps between neighbouring teeth".
    
    // Perhaps the interpretation is: 
    // 1. Main body (Spine) = 70mm X, 12mm Y, 15mm Z (including tooth depth?). No, plate thickness is 1.5mm.
    // 2. Teeth are separate features attached to one edge of the spine.
    
    // Let's try this layout: 
    // Spine occupies X:[-35, 35], Y:[0, 12] (shifted for easier calculation). Long edges at y=0 and y=12.
    // Teeth attach to one long edge (say y=12) and extend in -Y direction? That would mean they go from y=12 down to y=(12-12)=0. 
    // So teeth occupy the same Y-range as spine but are deeper into Z? No, "flat plate ... lying on bed".
    
    // Correct interpretation for casting: The comb is a mold. You pour agarose in. It fills around the teeth. Then you remove the comb (or cut it out). 
    // So the teeth must be ABOVE the pouring level or part of the structure that defines the well shape.
    
    // Let's assume the "plate" includes both spine and tooth bases, but the user specified:
    // Plate thickness Z = 1.5mm. Spine length X=70, width Y=12. Teeth hang from one long edge in -Y direction. 
    // If they are attached to an edge of a 12mm wide spine and extend 12mm deep... if the attachment is at y=+6 (center line?) no "long edge".
    
    // Let's assume: Spine Y range = [-6, +6]. One long edge is at y = -6. Teeth hang from this edge into more negative Y? 
    // That would mean teeth extend from y=-6 down to y=(-6)-12 = -18. 
    // This creates a comb where the base plate (spine) is 70x12, and below it hangs an array of teeth extending further out in Y (-Y direction).
    
    // Let's calculate positions:
    // Spine X range: [-35, +35]
    // Spine Y range: [-6, +6] (width 12)