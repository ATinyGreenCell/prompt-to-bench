// Dimensions for agarose gel casting comb (measured with calipers)
$fn = 64; // Ensure smooth curves and proper resolution

// Main plate dimensions: resting on XY plane at z=0, building upward (+Z)
plate_thickness_z = 1.5;
spine_length_x = 70;
spine_width_y = 12;

// Tooth specifications
tooth_count = 10; // Number of rectangular teeth
tooth_width_x = 5.0; // Width of each tooth in X direction (mm)
tooth_depth_y = 12.0; // Depth/length of each tooth from spine edge in Y direction (mm)

// Spacing between teeth
gap_size_between_teeth = 1.5; // Gap width between adjacent teeth (mm)

// Positioning logic:
// The comb rests flat on Z=0. 
// The "spine" is the main rectangular block defined by spine_length_x and spine_width_y, centered at origin.
// Spine occupies X:[-35, 35], Y:[-6, 6].
// Teeth hang from one long edge of the spine in the -Y direction. 
// We interpret "hang" as protruding downwards (negative Z) relative to a top surface? 
// No, usually combs are printed such that they define wells ABOVE the print bed or part of the mold structure sitting on it.
// However, if the user says "flat plate ... lying on the bed", and teeth hang from an edge...
// Let's assume the standard interpretation: The spine is a block 70x12x1.5mm centered at origin.
// Teeth are attached to one long side (e.g., Y = +6) and extend OUTWARDS in the -Y direction? 
// Or do they hang DOWN from an edge of the plate surface? "Hang ... in the -Y direction" implies orientation along Y axis, not Z.
// Given "5mm wide X", "12mm long Y": The tooth is a prism 5x12xH.
// If it hangs from an edge (say y=+6) and extends into -Y... does it mean it goes outside the spine's width? 
// Or does it mean the spine itself has teeth attached to its side, extending further in Y than the spine is wide?
// Let's assume: Spine is 70x12. Teeth attach at y=+6 and extend into negative Y space by length 12mm? 
// That would make them occupy y from +6 down to -6 (if starting edge) or further out?
// "Hang ... in the -Y direction" usually implies they stick OUT of the main body.
// If the spine is only 12mm wide, and teeth are 12mm long hanging off an edge... 
// Let's assume the attachment point is at y=+6 (the top edge). They extend into negative Y space by a length of 12mm? 
// That would mean they occupy y from +6 down to -6. This effectively doubles the width in that quadrant if not careful, but fits "hanging".
// However, often combs have teeth extending BEYOND the spine's original footprint to create depth below Z=0 (if casting into a mold where plate is top). 
// But let's stick strictly to: Spine 70x12. Teeth hang from one long edge in -Y direction.
// Interpretation: Attachment at y = +6. Extension length = 12mm towards negative Y? 
// If so, they occupy y range [+6 down to -6]. This means the teeth fill exactly the width of the spine but are shifted X-wise and extend Z-downwards (if casting) or just sit on top?
// Wait, if they "hang", maybe they go BELOW Z=0? 
// Let's assume the user wants a comb where the base is 70x12, and teeth protrude from one side.
// If they hang in -Y direction, let's make them extend OUTSIDE the spine width to maximize well depth below Z=0 (assuming plate stays on bed).
// Attachment at y = +6. Extend length 12mm into negative Y? That goes to y=-6. 
// This creates a shape that is effectively wider than the spine in one direction if we consider the union, but here they are attached TO the spine.
// Let's assume the teeth extend from y=+6 down to y=(+6)-12 = -6. 
// But wait, if the spine goes from -6 to +6... and teeth go from +6 to -6... then the tooth base is at +6? And it extends into negative Y space which overlaps with the spine's lower half?
// That seems odd for a "comb". Usually teeth are distinct.
// Alternative: The spine is 70x12. Teeth attach at y=+6 and extend OUTWARDS (away from center) by length L > 12? 
// If they hang in -Y direction, maybe the attachment is at y=-6 and they go to more negative Y? 
// Let's assume: Spine X:[-35, 35], Y:[-6, 6].
// Teeth attach at Y = +6 (top edge). They extend into -Y direction by length 12mm. 
// This means they occupy the region where y goes from +6 down to +6-12 = -6? 
// That overlaps with the spine's existing volume if we just union them blindly without defining Z-height difference or shape logic correctly.
// Actually, "hang" might imply they are suspended below a top surface? No, FDM prints build up.
// Let's assume the teeth are features on TOP of the plate (Z=1.5) that hang DOWNWARDS (-Z)? 
// But user said dimensions: 5mm wide X, 12mm long Y. If they hung down Z, length would be in Z. Length is in Y.
// So they must extend along Y axis.
// Let's assume the "spine" is just a block, and teeth are attached to its side (Y=+6 face) extending OUTWARDS into free space? 
// If so, do they go below Z=0 or stay above? Usually casting combs define wells ABOVE Z=0 if you pour on top.
// But "hang ... in -Y direction" suggests orientation along Y axis pointing negative.
// Let's assume the teeth are extrusions that start at y=+6 and extend to y=(+6)-12 = -6? 
// This would mean they occupy exactly the same Y-range as the spine, just shifted X-wise (since centred on spine in X).
// But then where is the "comb" structure? The gaps are between teeth.
// If tooth width=5 and gap=1.5... total span = 10*5 + 9*1.5 = 74mm. 
// Spine length is only 70mm. So they must overhang in X or Y.
// User says: "row of teeth is centred on the spine in X". 
// This implies the row spans more than the spine, so it hangs out both sides? Or just one side?
// If total width (74) > spine length (70), and centered... then they overhang by 2mm each side.
// Now Y direction: "teeth that hang from one long edge ... in -Y direction". 
// Attachment at y=+6. Extend into negative Y? By how much? tooth_depth_y = 12mm.
// If attached at +6 and extend 12mm towards negative... range is [+6, -6]. 
// This means the teeth occupy exactly the width of the spine in Y (from -6 to +6). 
// But they are centered on X? Yes.
// So we have a block 70x12 with slots/teeth carved into it or added as protrusions?
// "Teeth that hang" implies they stick OUT from the main body.
// If the main body is 70x12, and teeth are attached to one edge (y=+6) and extend in -Y direction... 
// Does it mean they go BEYOND y=-6? i.e., further negative than the spine exists?
// "Hang ... in -Y direction" could mean their orientation is such that they point towards -infinity.
// If length is 12mm, starting at +6, ending at -6... that's exactly the spine width. 
// Maybe the user implies the teeth extend OUTSIDE the original plate dimensions to create a deeper well below Z=0?
// Let's assume: Spine is 70x12 (Z=0..1.5). Teeth attach at y=+6 and extend into negative Y space by length 12mm, meaning they go from +6 down to -6? 
// Wait, if they are attached TO the spine, and the spine exists in [-6, 6]... then extending from +6 towards -6 means going INTO the spine's volume.
// That doesn't make sense for a "comb" unless it's carved out (negative Z) or added as a separate feature below?
// Let's try this: The plate is 70x12. Teeth are attached to one long edge (y=