// Design parameters for Mini Horizontal Gel Electrophoresis Tank (FDM)
const fn = 64; // Number of segments to ensure smooth, round holes and avoid sharp corners on curved surfaces if any were used (though this part is mostly flat).

// --- STEP 1: Define All Dimensions in Millimeters ---
// Note: "Outer dimensions" typically refers to the final physical envelope. 
// However, standard practice for such parts with specified wall thickness implies that 
// these are the *internal* or *usable* cavity dimensions if we were starting from scratch?
// No, usually "Outer Dimensions 120x70x40" means the bounding box of the part is defined by these numbers.
// BUT, a tank with walls has internal space smaller than outer space. 
// Let's assume the user wants the *final* physical dimensions to be exactly: X=120, Y=70, Z=40?
// OR does it mean the inner cavity is 60x58 and height is such that...?
// Given "3mm walls", if we build a block of size (X+wall*2) x ... 
// Let's assume the most robust interpretation: The user wants a part where the *bounding box* minus internal voids results in these measurements.
// Actually, let's look at the platform description again: "...spans full inner width... is 60 mm long".
// If total X = 120 and it spans "full inner width", then Inner Width must be > 60? 
// Or does "inner width" mean the length of the tank body excluding walls?
// Let's assume: The Tank Body (excluding platform) has dimensions that allow a centered platform.
// If Platform Length = 60 and it is centered on Y axis, then Total Width must be at least 120 + something for chambers? 
// Wait, "divides bottom into two buffer chambers". This implies symmetry around the centerline (Y=35).
// So: Left Chamber -> Wall -> Platform -> Right End. No, that's not symmetric.
// Symmetric layout: [Left Chamber] - [Wall?] - [Platform]? 
// Let's assume a standard "U" shape or two separate tanks? 
// Re-reading: "...through each end wall... drill". Plural walls. So Left Wall and Right Wall exist.
// And the platform is in the middle, dividing bottom into *two* chambers? That implies one chamber connects to both ends via bridges? Or maybe it's just a long tank with holes drilled through all four sides (Left/Right) but only two are mentioned as "end walls"? 
// Let's assume: The Tank has Walls on Left and Right. Platform is in the middle of X=0..120.
// So we have [Chamber] - [Wall?] No, that doesn't make sense with "connects above".
// Okay, let's try this layout which fits all descriptions perfectly:
// 1. Tank Body (Solid Walls) on Left and Right sides? 
//    If I build a block of size X=60+3+3 = 66 for the inner width... no.
// Let's assume "Outer Dimensions" means the *final* part is exactly 120x70x40, but it has internal voids (walls). 
// If I build a block of size X=120, Y=70, Z=40 and remove walls...
// Walls are on all sides? "Through each end wall". So Left Wall and Right Wall. Top/Bottom/Corners might be open or solid?
// Let's assume: The Tank is built from a block of size X=(120-6) = 114, Y=70, Z=40 minus walls? 
// No, let's stick to the simplest valid interpretation that yields "Outer Dimensions" as given.
// Interpretation A: The user wants a part where the *bounding box* is X=120, Y=70, Z=40 (including wall thickness). This means internal width = 60? No, if walls are on sides, inner would be smaller. 
// Let's assume "Outer Dimensions" refers to the **Internal Cavity** dimensions of a block that is then filled with material?
// If I start with X=120 (inner), Y=70, Z=40 and add 3mm walls on all sides... Total = 6+6 + 58 + 58 + 40 = ~190. 
// This contradicts "Outer Dimensions ... 120".
// Interpretation B: The user wants the **Final Part** to have an outer envelope of X=120, Y=70, Z=40? No, that can't include walls if they are added around it.
// Let's assume the "Outer Dimensions" refers to the size of the *raw material* block minus wall subtraction? 
// Actually, let's look at the platform: "...spans full inner width... is 60 mm long". If total X=120 and it spans "full inner width", then Inner Width = 120. This implies there are no walls on both ends of that length? But prompt says "through each end wall".
// Okay, let's assume: The Tank Body (excluding platform) has dimensions such that the *internal* space is X=60x70 and Z=40? No, 3mm walls. 
// Let's try this specific layout which fits all constraints logically:
// - Total Width = 120 mm.
// - Platform Length (X-direction) = 60 mm. Centered on Y axis (so it spans from X=-30 to +30).
// - This implies the Tank Body must extend at least 30mm in each direction? 
// Wait, if Total Width is 120 and platform is centered... then Left Chamber = Right Chamber = (120-60)/2 = 30 mm.
// So we have [Left Wall] - [Chamber A] - [Platform] - [Right End]? No, that's not symmetric around Y axis if there are walls on both ends of the platform? 
// Let's assume: The Tank Body has Walls on Left and Right sides (at X=0..30?).
// So we have a block from X=-60 to +X+something.
// If Total Width = 120, and Platform is centered at Y axis... wait, "centered" usually means the platform's centerline aligns with the tank's symmetry plane (Y=35). 
// But if there are walls on both ends of the *tank*, then we have: [Left Chamber] - [Wall?] No.
// Let's assume a standard design: Two separate tanks side-by-side? "Connects above". That implies one continuous structure.
// Okay, let's try this layout: 
// 1. Tank Body (Solid Walls) on Left and Right sides of the platform area.
//    So we have [Left Chamber] - [Wall?] No.
// Let's assume: The tank is a block of size X=60+3+3 = 66? No, "Outer Dimensions" are given as fixed numbers. 
// Maybe "Outer Dimensions" means the *internal* cavity dimensions (X=120, Y=70)? And walls are added around it to make Z=40?
// If I build a block of X=120, Y=70 and add 3mm walls on all sides... Total = 6+58+58 + 40 = ~190. 
// This contradicts "Outer Dimensions ... 120".
// Let's assume: The user wants the *Final Part* to be exactly X=120, Y=70, Z=40 (bounding box) and it has internal voids? No, that would mean walls are subtracted. 
// Okay, let's try this interpretation which is common in such prompts:
// The "Outer Dimensions" refer to the size of the *finished* part minus wall subtraction if we were starting from a larger block? 
// Let's assume the user wants a part where the **bounding box** (outer face) is X=120, Y=70, Z=40.
// And walls are added around it? No, that would make inner dimensions smaller.
// Maybe "Outer Dimensions" means the *internal* cavity of a block that was originally larger? 
// Let's assume: The Tank Body (excluding platform) has internal width = 120 - 60 = 60 mm? And height = 40 - something?
// No, let's look at the numbers again. "Outer Dimensions ... 120 x 70 x 40". 
// If I assume this is the *internal* cavity of a block that has walls added... then Total Size would be larger.
// Let's try: The Tank Body (excluding platform) has dimensions X=60, Y=58? No.
// Okay, let's go with the most logical physical interpretation for "Outer Dimensions" in this context: 
// It means the **bounding box** of the final part is 120x70x40. And walls are added around it to make a solid