// =============================================================================
// OpenSCAD 10-Well Agarose Gel Comb Design
// Orientation: Lying flat (XY plane), building upward (+Z).
// Dimensions based on user specifications.
// =============================================================================

$fn = 64; // Ensure smooth curves for any rounded corners if added later

// --- Global Settings ---
PART_THICKNESS_Z = 1.5; // mm, thickness of the comb plate (lying flat)

// --- Spine Dimensions ---
SPINE_LENGTH_X = 70;   // mm, total length along X axis
SPINE_WIDTH_Y = 12;    // mm, width along Y axis (back bar height in print orientation)

// --- Tooth Specifications ---
NUM_TEETH = 10;        // Number of wells/teeth
TOOTH_WIDTH_X = 5.0;   // mm, width of each tooth opening into the spine
TOOTH_LENGTH_Y = 12;   // mm, length of each tooth (matches spine width)

// --- Gap Specifications ---
GAP_SIZE = 1.5;        // mm, distance between neighbouring teeth in X direction

// --- Derived Dimensions for Layout Calculation ---
// Total width occupied by the row of teeth and gaps along the X axis? 
// Wait: The prompt says "teeth hang from one long edge... straight spine 70mm long (X)".
// Usually, combs have a back bar running parallel to the length. 
// Let's re-read carefully: "straight spine ... 70 mm long (X) and 12 mm wide (Y)".
// "teeth that hang from one long edge of the spine in the -Y direction".
// This implies the teeth are cut OUT of a larger block, or added to? 
// Standard comb design: A solid back bar with holes. Or a plate with protruding teeth?
// The prompt says "10 rectangular teeth... gaps between neighbouring teeth".
// If they hang from an edge in -Y direction, and the spine is 70x12 (X by Y).
// It sounds like the comb consists of a back bar (the spine) and protruding teeth.
// However, standard agarose combs usually have holes cut into a solid block to form wells.
// BUT: "teeth that hang from one long edge... in -Y direction". 
// If I print this lying flat on the bed (Z=0), and it has a spine 70x12.
// And teeth hang down (-Y). This implies the object extends beyond the 12mm width?
// Or does "spine" refer to the back bar of the final part, and the teeth are extensions?
// Let's assume the standard interpretation for FDM printing: 
// A solid block where we cut out holes. But the description says "teeth hang...".
// If I have a 70x12 spine, and teeth hang in -Y (which is perpendicular to length X),
// then the total width would be Spine Width + Teeth Length? No, that doesn't make sense for a gel comb.
// 
// Alternative Interpretation: The "Spine" is the back bar of thickness 12mm (in Y). 
// The teeth are extensions perpendicular to it? No, combs run parallel to the length.
// Let's reconsider standard geometry:
// Length = X axis = 70mm. Width = Y axis = ?
// If there are 10 wells with width 5 and gap 1.5.
// Total well/gap span along X? No, usually combs run across the gel (X) or lengthwise (Y).
// Prompt: "straight spine ... 70 mm long (X)". So Length = 70mm.
// Teeth hang from one long edge in -Y direction. 
// This implies the teeth are perpendicular to the X axis? That would make a comb with wells running along Y?
// If teeth hang in -Y, they extend away from the spine's centerline or top/bottom face?
// "Spine ... 12 mm wide (Y)". So the spine is a rectangle 70x12.
// Teeth hang from one long edge (say y = +6) into negative Y direction (-Y).
// This means the teeth are extensions of width TOOTH_WIDTH_X along X, and length TOOTH_LENGTH_Y along -Y?
// If so, the total height in Y would be 12mm (spine) + 10 * 12mm (teeth)? That is huge.
// 
// Let's try the most logical physical interpretation for a gel comb:
// The "Spine" is the back bar of the finished part. It has length X=70 and width Y=?.
// Usually, combs have holes cut out. If we model it as subtraction from a larger block? 
// But rule 1 says "Use user's dimensions exactly".
// Maybe the user wants a comb where the teeth are physical protrusions (like a rack)? No, for agarose gels you need wells.
// Perhaps the description describes the geometry of the *holes* as if they were solid teeth hanging down?
// Or maybe the "Spine" is the top surface, and we cut holes through it?
// Let's assume the standard subtraction method but define the bounding box based on user dims.
// User: Spine 70x12. Teeth hang in -Y direction from one edge. 
// If I have a block of size X=70, Y=(Spine_Width + Tooth_Length)? No.
// Let's assume the "Teeth" are the voids (holes) but modeled as positive geometry for subtraction?
// OR: The user wants a comb where the back bar is 12mm wide, and the teeth extend *outwards* to create wells? 
// Actually, looking at standard combs: Back bar runs along one side. Wells are rectangular holes going through it.
// If "teeth hang from one long edge... in -Y", maybe the spine is on top (Z=0), Y goes from 6 to -6?
// And teeth extend further down? 
// Let's assume the total width of the comb face needs to accommodate the wells and gaps.
// But wait, if the spine is only 12mm wide in Y, and teeth hang into it...
// Maybe the "Spine" dimension given (70x12) refers ONLY to the back bar material remaining? 
// And we need to calculate the total width based on tooth count?
// Let's assume the standard layout: A row of wells.
// Total Width needed = Sum(Tooth_Width + Gap). But where is this located in Y?
// If teeth hang from an edge, let's say y=6 (top), extending to -Y.
// Then total depth = Spine_Thickness_Y/2 ? No.
// Let's assume the "Spine" 12mm wide refers to the back bar thickness perpendicular to the wells? 
// NO: "70 mm long (X) and 12 mm wide (Y)". This defines the footprint of the spine part.
// If teeth hang from one edge in -Y, they must be extensions or cutouts within that Y dimension?
// If they are cutouts, then the total width is still roughly defined by the user's "Spine" dimensions plus whatever overhang exists?
// 
// Let's try this specific interpretation which fits FDM printing of combs:
// The object is a flat plate. We define a bounding box that covers everything.
// However, if teeth hang from an edge in -Y, and the spine is 12mm wide...
// Maybe the user means the back bar is 70x12, and we cut holes through it? 
// If so, how deep are the holes? "Teeth ... 12 mm long (Y)". 
// This implies the hole depth along Y is 12mm. But the spine width is also 12mm!
// So if teeth hang in -Y direction from an edge of a 12mm wide plate, and are 12mm long...
// They would extend to y = -6 (if starting at +6) or similar? 
// If Spine Width Y = 12. Let's say it spans y=-6 to y=+6.
// Edge is likely one of these boundaries. Say top edge y=+6.
// Teeth hang in -Y direction for length 12mm. They would go from +6 down to -6.
// This perfectly fills the spine width! 
// So, we have a plate (Spine) that is effectively fully perforated by these "teeth" (holes)?
// But what about the gaps? Gaps are between teeth.
// If I cut holes of width 5 and gap 1.5...
// Total pattern length along X = Sum(Tooth_Width + Gap).
// How many patterns? 10 teeth -> 9 gaps between them, plus maybe edges? 
// Usually a comb has wells bounded by the back bar on one side and open air (or another plate) on the other.
// If we are printing just this piece: It's likely a "back-bar" style where you cast against it or use two pieces.
// But if teeth hang in -Y, maybe they form walls? 
// Let's assume the simplest geometric interpretation that