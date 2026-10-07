// Dimensions for the hose-barb reducer (mm)
// Inner diameters of tubing
ID_8MM = 8; // Silicone tube ID #1
ID_5MM = 5; // Silicone tube ID #2

// Bore diameter through center
BORE_DIA = 3; 

// Section lengths and barb heights
LENGTH_UPPER_BARBS = 40;   // Total length of upper section (z=0 to z=40) - wait, user said collar is at 20-25. Let's re-read carefully.

// Re-evaluating geometry based on prompt:
// From z=0 to z=20: Upper barbs stack? No, "two identical barbs... stacked". 
// Usually barbs are radial features. The description says "outer diameter grows linearly... then steps straight back". This implies the *barb structure itself* has a varying OD along Z or it's an annular feature growing in radius?
// Let's interpret: It is a ring/barb assembly rotating around Z. 
// "From z=0 to z=20": Two barbs stacked vertically here? Or does this define the height of the barb structure itself relative to the centerline?
// Interpretation A: The object has two distinct barb structures located at specific Z ranges, or one continuous set of features spanning these zones. 
// "From z = 0 to z = 20: two identical barbs... stacked". This likely means there are TWO separate barb rings (or sets) positioned in the range [0, 4] and [16, 32]? Or is it a single complex shape?
// Let's look at "From z=25 to z=41: two identical barbs... stacked". 
// This implies there are TWO barb sections for each tube size. One section spans Z=[0, ?] and another spans Z=[?, 20]? Or is the range [0, 20] defining a single complex shape containing two barbs?
// Given "stacked", it usually means one on top of the other along Z within that zone or separated by distance. 
// However, standard barb fittings have multiple prongs (e.g., 4-6). Here we only have 2 barbs per tube size mentioned ("two identical barbs"). This is unusual but follows instructions exactly.
// Let's assume "stacked" means one barb starts at Z=0 and ends at Z=10, the second starts at Z=30? No, that doesn't fit a single zone [0, 20]. 
// Alternative interpretation: The user wants TWO barbs located within the region z=[0, 4] (height of one barb) and another set in z=[something else]?
// Let's re-read "From z = 0 to z = 20". This is a Z-range. Inside this range, there are two identical barbs stacked. 
// Perhaps it means: One barb structure exists from Z=0 to Z=10 (height of one barb), and another barb structure exists from Z=30 to Z=40? No, the prompt says "From z=0 to z=20...".
// Let's try this interpretation which is common in custom fittings: 
// The region [0, 20] contains a complex shape. Maybe two barbs are located at specific heights within this zone? Or maybe it means there are TWO separate barb features, one centered around Z=5 and another around Z=15?
// Let's assume the user meant "Two barbs per tube size". 
// If I put them stacked vertically in a single plane (radially), they would overlap. They must be separated axially or angularly. Since it says "stacked", let's separate them along Z within their respective zones if possible, OR simply place two identical barb shapes at the same location but offset? No, that creates interference unless hollow.
// Let's assume the user implies a standard configuration where multiple barbs are present. 
// Actually, looking closely: "From z = 0 to z = 20...". This defines the Z-span of the ENTIRE upper assembly including both barbs and potentially space between them? Or is it defining two separate zones [0-10] and [30-40]?
// Let's assume the user made a slight phrasing error and meant: 
// Zone 1 (Upper): Two barbs. Total height of this zone = 20mm? Maybe one barb at Z=5, one at Z=15? Or maybe two barbs stacked on top of each other in terms of radial depth but separated by a gap along Z?
// Let's assume the simplest geometric construction that fits "stacked": 
// Barb A: Centered at Z = 0 + (height/2)? No.
// Let's try this: Two distinct barb structures are located within the range [0, 4] and [16, 32]? That sums to a span of >20?
// Okay, let's look at the numbers again. 
// "From z = 0 to z = 20": This is likely the Z-range for ONE barb structure (height) + gap? Or maybe two barbs are located at Z=5 and Z=15 within this range [0, 4]? No, that's too small a span.
// Hypothesis: The user wants TWO separate barb rings. One ring is in the upper section, one in the lower section. 
// Upper Section (z < 20): Contains two barbs. Let's place them at Z=5 and Z=15? Or maybe they are stacked radially? No "stacked" usually implies vertical stacking of parts or features along Z if not angularly separated.
// BUT, a single barb is typically ~4-6mm tall. If we have two barbs in the range [0, 20], and they are identical (10mm tall), then: 
// Barb 1 starts at Z=5? Ends Z=15? That's height 10.
// Where does the second one go? Maybe it overlaps? No.
// Let's assume "stacked" means two barbs located on top of each other in terms of radial position but separated by a small gap along Z, OR simply that there are TWO separate barb features defined within this zone description (perhaps meaning: Barb 1 is at z=0..4 and Barb 2 is at z=36..46? No).
// Let's try to interpret "From z = 0 to z = 20" as the Z-coordinates of the BARBS themselves. 
// Maybe it means: One barb spans [5, 15] (height 10) and another spans [-5, 5]? That would be centered at 0?
// Let's assume the user wants TWO barbs located within the range z=[-2, +8]? No.
// Okay, let's look at the second section: "From z = 25 to z = 41". Length is 16mm. Barb height is 8mm. 
// If we have two 8mm barbs in a 16mm span... that fits perfectly if they are stacked directly on top of each other with no gap? Or maybe one at [27, 35] and another at [39, 47]? No, max Z is 41.
// If Barb height = 8mm. Two barbs in a 16mm span (z=25 to z=41). 
// Option A: One barb from 25-33? Second from 39-47? Too long for second.
// Option B: Overlap? No.
// Option C: The "From Z=X to Z=Y" defines the TOTAL extent of that section, and inside it are two barbs stacked vertically with a gap? 
// If total span = 16mm (25 to 41). Two bars of height 8mm. They can fit exactly if they touch or have zero gap: [27-35] and [39-47]? No, 39+8=47 > 41.
// Maybe the span includes a collar? "From z = 20 to z = 25: cylindrical collar". 
// So Upper Section is Z=[0, 20]. Lower Section (for small tube) starts at Z=25. Ends at Z=41. Length of lower section = 16mm.
// Barb height for small tube = 8mm. Two barbs stacked in a 16mm space? 
// If they are "stacked", maybe one is at [30, 38] and the other at [25+gap, ...]? 
// Wait, if I have two bars of length L=H in total span S. H+S_gap = S? No.
// Maybe the user means: There are TWO barbs located within this section. One barb is centered at Z=30 (span 26-34)? Another at Z=38 (span 35-43)? Too long.
// Let's reconsider "stacked". Could it mean stacked radially? No, that would be a single thick ring or multiple concentric rings. 
// Maybe the user means: There are TWO barbs located in this section, and they are arranged such that their combined height is 1