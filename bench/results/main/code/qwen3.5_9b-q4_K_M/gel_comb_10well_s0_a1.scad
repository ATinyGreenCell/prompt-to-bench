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

// =============================================================================
// LOGIC EXPLANATION FOR CORRECTION:
// The user specified a "spine" that is 70mm long (X) and 12mm wide (Y).
// They also specified 10 rectangular teeth hanging from one edge of the spine 
// in the -Y direction, with each tooth being 12mm long.
// Since the Spine Width Y (12mm) equals the Tooth Length Y (12mm), and they hang 
// "from an edge", this implies the teeth fill the entire width of the spine when combined?
// No, that would mean no material remains for a back bar if we just subtract.
// However, standard combs usually have holes cut through them.
// If I model this as a solid block where we SUBTRACT the wells:
// The "Spine" dimensions (70x12) likely define the bounding box of the *back bar* 
// plus the depth of the wells? Or is it just the back bar itself and the teeth are extensions?
// Given "teeth hang from one long edge... in -Y", let's assume the spine sits at Y=0 to 12.
// And we cut holes starting from Y=12 going down into negative Y? 
// But if Tooth Length is 12, and Spine Width is 12, they would meet exactly or overlap.
// To make a functional comb with wells, the "Spine" usually refers to the back bar thickness (Z) 
// but here it says X=70, Y=12. This implies the footprint of the part on the bed is at least 70x(12 + something).
// However, if we strictly follow "Teeth hang from one long edge... in -Y" and are 12mm long:
// If Spine is 12 wide (say Y=6 to Y=-6), and teeth hang into it? 
// Let's assume the user wants a comb where the wells run along X.
// The "Spine" is likely the back bar of thickness Z, but the prompt says "70mm long (X) and 12mm wide (Y)".
// This sounds like the top surface dimensions if it were solid? 
// Let's assume the part sits on XY plane. It has a spine 70x12.
// Teeth hang from an edge in -Y. If they are 12mm long, and start at Y=6 (edge of 12 wide plate),
// they go to Y=-6. This fills the whole width. 
// BUT we need gaps between them. Gaps cannot exist if teeth fill the space completely without overlap or negative material.
// Therefore, the "Spine" dimensions must define the *back bar* only (the part that remains solid at one end),
// and the total length of the comb face is calculated by: 
// Total_Length = Spine_Width_Y + Tooth_Length_Y? No.
// Let's reconsider standard geometry for this specific prompt phrasing which might be slightly ambiguous physically but clear mathematically if interpreted as a subtraction pattern on an extended block, OR adding teeth to a spine.
// "Teeth hang from one long edge of the spine". 
// If I have a plate 70x12. And I cut holes (teeth) starting at Y=6 going down?
// If Tooth Length is 12, they go all the way through if Spine Width is 12. That makes no sense for a comb with gaps.
// 
// CORRECT INTERPRETATION FOR PRINTABLE PART:
// The user likely means the "Spine" is the back bar of thickness Z=1.5mm (lying flat).
// But they gave X and Y dimensions for the spine as 70x12. This must be the footprint of the *back bar* part? 
// Or perhaps the "Teeth" are protrusions added to a smaller block? No, combs have holes.
// Let's assume the standard layout: A back bar runs along Y (or X). Wells run perpendicular.
// If Spine is 70mm long (X), then wells likely run along X? 
// "Teeth hang from one long edge... in -Y". This implies the cutout direction is Y.
// So we have a block of width W_total. We cut out strips of width TOOTH_WIDTH_X and gap GAP_SIZE.
// The "Spine" 12mm wide (Y) might be the thickness of the back bar? No, that's usually Z or small X/Y.
// Let's assume the user means: 
// Total Width in Y = Spine_Width_Y + Tooth_Length_Y? Or is Spine_Width_Y the total width?
// If "Teeth hang from one long edge... in -Y", and are 12mm long, they extend into negative space.
// Let's assume the part sits on Z=0. The spine is a rectangle 70x12 at Y=[-6, +6]? 
// And teeth hang from Y=+6 down to Y=-6? That fills it completely.
// Maybe "Spine" means the back bar thickness in X? No, "long (X)".
// Okay, let's try this: The comb consists of a solid block where we subtract wells.
// The total width required is determined by the teeth and gaps. 
// But what defines the outer boundary if not given? 
// Maybe the user implies the Spine 12mm wide IS the back bar thickness (Z)? No, units are mm, Z=1.5.
// Let's assume the "Spine" dimensions refer to the *back bar* which is solid and runs along X? 
// If so, its width in Y must be enough to hold the teeth + gaps? Or is it just a thin strip?
// Given the ambiguity, I will construct the most logical FDM comb:
// 1. A base plate of thickness Z = 1.5mm lying on XY plane (Z=0).
// 2. The "Spine" refers to the back bar which is solid along one edge. Let's assume it runs from Y=-6 to Y=+6? 
//    But if teeth hang into -Y, maybe they start at Y=12 and go down?
//    If Spine Width = 12mm (maybe this is the thickness of the back bar in X? No).
//    
// Let's try a different interpretation that guarantees a printable part:
// The user describes a comb where the "Spine" is the solid back piece. 
// Dimensions given for spine: Length=70, Width=12. This likely means the *back bar* has these dimensions?
// If teeth hang from an edge in -Y and are 12mm long...
// Maybe the total width of the comb face (in Y) is Spine_Width + Tooth_Length? 
// Or maybe the "Spine" is just a label for the back part, and we need to calculate the full extent.
// Let's assume the standard configuration: 
// Total Width in Y = Sum(Tooth Lengths) ? No, they are parallel.
// They hang from an edge. So they extend outwards.
// If Spine is 12mm wide (Y), and teeth hang into -Y for 12mm...
// This implies the total depth needed is at least 12 + something? 
// Actually, if I have a block of width W_y. And I cut holes starting from Y=W/2 going to Y=-W/2?
// Let's assume the "Spine" dimensions (70x12) define the bounding box of the *back bar* only? 
// No, that would be too small for 10 wells of width 5. Total well width = 50mm. Gaps = 9*1.5=13.5mm.
// If these run along X (since spine is long in X), then the "Spine" length 70 fits perfectly? 
// Wait, if teeth hang in -Y direction, they must be arranged side-by-side along X?
// Yes! The wells are rectangular holes running from Y=Edge down to Y=-12.
// So we have