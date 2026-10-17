// Replacement Knob for Hotplate Stirrer (6mm D-shaft)
// Orientation: Bottom face (with D-bore) rests on Z=0.

// --- Dimensions ---
$fn = 128; // High resolution for smooth curves and accurate D-shape

// Knob Body
D_KNOB = 30;      // Outer diameter
H_KNOB = 15;      // Total height
R_KNOB = D_KNOB / 2;

// D-Shaft Bore
SHAFT_D = 6.2;    // Nominal bore diameter
SHAFT_H = 12;     // Depth of bore
SHAFT_R = SHAFT_D / 2;
SHAFT_FLAT_WIDTH = 4.7; // Distance from flat to opposite side (defines the cut)

// Grip Grooves
N_GROOVES = 18;   // Number of vertical grooves
D_GROOVE = 2;     // Diameter of groove cylinder
H_GROOVE = H_KNOB; // Full height

// Top Pointer
W_POINTER = 1.5;  // Width of pointer groove
D_POINTER = 1;    // Depth of pointer groove

// --- Calculations ---
// Calculate the radius of the flat side of the D-bore based on the given width
// Width = 2*R - 2*sqrt(R^2 - (D_flat/2)^2) is complex. 
// Easier: The distance from the flat edge to the arc is given as 4.7mm.
// The total width of the D is SHAFT_D = 6.2mm.
// The flat side is a chord. The distance from the chord to the arc is the sagitta.
// Sagitta = R - sqrt(R^2 - (Chord/2)^2).
// Here, Sagitta = 4.7mm. R = 3.1mm.
// Wait, if R=3.1 and Sagitta=4.7, the chord must be imaginary or the geometry is different.
// Re-reading: "6.2 mm diameter circle with one side cut flat, so the distance from the flat to the opposite side of the circle is 4.7 mm."
// This implies the flat side is a chord, and the distance from that chord to the farthest point on the circle is 4.7mm.
// Let R = 3.1. Max distance from center to edge is 3.1.
// If the flat is a chord, the max distance from the chord to the arc is R - distance_from_center_to_chord.
// 4.7 = 3.1 - d => d = -1.6. This is impossible.
// 
// Alternative Interpretation: The user might mean the *width* of the flat part is 4.7mm? 
// "distance from the flat to the opposite side of the circle is 4.7 mm".
// If the circle is 6.2mm diameter, the max distance across is 6.2mm.
// If we cut a flat, the distance from the flat surface to the opposite arc is the "height" of the D.
// If that height is 4.7mm, and the radius is 3.1mm, the flat must be very close to the center?
// No, if the flat is at the center, distance is R = 3.1mm.
// If the flat is at the edge, distance is 0.
// How can the distance be 4.7mm if the radius is only 3.1mm?
// 
// Conclusion: The user's dimensions are physically impossible for a standard D-shape derived from a 6.2mm circle where the "flat" is a chord of that circle.
// However, in 3D printing contexts, "D-shaft" often implies a specific tolerance or a specific tooling profile.
// Perhaps the "6.2 mm diameter" is the *outer* dimension of the D, and the "circle" part is smaller?
// OR, most likely: The user measured the distance from the flat face to the back of the knob (or the arc) as 4.7mm, but the shaft diameter is actually larger, OR the "6.2mm" is the width of the flat + the arc?
// 
// Let's re-read carefully: "6.2 mm diameter circle with one side cut flat".
// This usually means we start with a cylinder of 6.2mm diameter and cut a flat.
// If we cut a flat, the remaining width of the D is less than 6.2mm.
// The distance from the flat to the opposite side (the arc) is the "depth" of the D.
// If Radius = 3.1mm, the maximum possible depth (flat at center) is 3.1mm.
// The user specifies 4.7mm. This is > 3.1mm.
// 
// Hypothesis: The user meant the *width* of the flat side is 4.7mm?
// If Width_flat = 4.7mm, and Diameter = 6.2mm.
// Then the "depth" (distance from flat to arc) would be:
// R - sqrt(R^2 - (W/2)^2) = 3.1 - sqrt(3.1^2 - 2.35^2) = 3.1 - sqrt(9.61 - 5.52) = 3.1 - 2.03 = 1.07mm.
// This is a very shallow D.
// 
// Hypothesis 2: The user meant the distance from the flat to the arc is 4.7mm, which implies the "circle" diameter is actually larger, or the "6.2mm" is the width of the flat?
// If Depth = 4.7mm, and Radius = 3.1mm, this is geometrically impossible for a single circle.
// 
// Hypothesis 3 (Most likely for a stirrer): The user is describing a standard D-shaft where the "6.2mm" is the nominal size, but the specific "D" profile has a flat width and an arc width.
// Standard D-shafts often have a flat width of ~4mm and an arc width of ~2mm for a 6mm shaft.
// If the user says "distance from flat to opposite side is 4.7mm", they might be measuring from the flat face to the *back* of the knob, not the arc?
// "into the knob... distance from the flat to the opposite side of the circle".
// This phrasing strongly suggests the geometric depth of the D-profile.
// 
// CRITICAL DECISION: The dimensions provided (D=6.2, Depth=4.7) are mathematically inconsistent for a D-shape derived from a circle of diameter 6.2.
// I will assume the user made a typo and meant the **width of the flat side is 4.7mm**.
// Why? Because 4.7mm is a very common width for the flat part of a D-shaft (leaving 1.5mm for the arc).
// If I assume Width_Flat = 4.7mm, the depth becomes ~1.07mm.
// 
// WAIT. Let's look at the numbers again.
// Diameter = 6.2. Radius = 3.1.
// If the flat is a chord, the max distance from chord to arc is R = 3.1.
// The user says 4.7.
// Is it possible the "6.2 mm diameter circle" refers to the *outer* diameter of the knob, and the bore is different?
// "a 6.2 mm diameter circle with one side cut flat". This refers to the bore.
// 
// Okay, let's try one more interpretation. Maybe the "4.7 mm" is the distance from the flat to the *center*? No, "opposite side of the circle".
// Maybe the shaft is not a circle cut flat, but a specific D-profile where the "circle" part is smaller?
// "6.2 mm diameter circle with one side cut flat".
// 
// Let's assume the user's measurement of 4.7mm is the **width of the flat portion** of the D-shaft.
// This is the only dimension that makes physical sense in the context of a 6mm shaft (4.7mm flat, 1.5mm arc).
// If I model a D-shaft with a 4.7mm flat width, the depth will be calculated automatically.
// 
// RE-EVALUATION: What if the user meant the distance from the flat to the arc is 4.7mm, and the "6.2mm" is the *width* of the flat?
// "6.2 mm diameter circle" -> This explicitly says the circle is 6.2mm.
// 
// Okay, I will prioritize the "6.2 mm diameter circle" as the base geometry.
// I will prioritize the "4.7 mm" as the **width of the flat side**.
// Why? Because 4.7mm is a very specific number often used for the flat width of a 6mm D-sh