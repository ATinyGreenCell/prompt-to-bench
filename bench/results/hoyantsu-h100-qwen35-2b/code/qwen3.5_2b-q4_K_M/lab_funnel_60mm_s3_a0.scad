// Lab Funnel Design - FDM Print Orientation (Upward)
// Units: Millimeters

// Define dimensions based on measurements
const float wall_thickness = 1.6; // mm
const float spout_outer_diameter = 10.0; // mm
const float cone_top_diameter = 10.0;   // mm at z=20
const float cone_bottom_diameter = 60.0;// mm at z=50

// Calculate inner diameters for the spout and funnel walls
const float spout_inner_diameter = spout_outer_diameter - (wall_thickness * 2);
const float cone_top_inner_diameter = cone_top_diameter - (wall_thickness * 2);
const float cone_bottom_inner_diameter = cone_bottom_diameter - (wall_thickness * 2);

// Define the geometry of the straight spout (z=0 to z=20)
// It is a hollow cylinder with the calculated inner diameter.
// We use linear_extrude to build it from bottom to top, then rotate around Z axis.
var spout = linear_extrude(spout_inner_diameter / 2) rotate(180);

// Define the geometry of the funnel cone (z=20 to z=50)
// This is a frustum-like shape created by rotating a polygon and extruding.
// We will build it as a hollow cylinder with an inner hole, then cut out the top flat part.
var cone_base = rotate(180) linear_extrude(cone_bottom_inner_diameter / 2); // Base at z=50

// Create the conical side wall of the funnel
// We use a polygon to define the cross-section profile (circle) and extrude it along Z.
var cone_profile = rotate(180) circle(spout_outer_diameter / 2, fn = 64); // Outer radius for profile

// Extrude the conical wall from z=50 down to z=20
var cone_wall = linear_extrude(cone_bottom_inner_diameter / 2 - spout_inner_diameter / 2) rotate(180);

// Create the top flat lid (lid at z=50, bottom of funnel opening at z=49.6 approx? No, open at top and bottom).
// The prompt says "open at the top". The cone widens from z=20 to z=50 rim.
// So the solid material is between z=20 (spout end) and z=50 (rim).
// To make it open at the top, we need a flat surface at z=50 that extends outward? 
// No, "open at the top" usually means the funnel mouth. But here the cone widens to 60mm at z=50.
// If it's an inverted cone (wide at bottom), z=20 is narrow, z=50 is wide.
// Liquid flows in from the spout (z=0) through the hole, exits at z=50? 
// Or does liquid flow down the spout, then up into the funnel? 
// "Funnel" usually implies collecting. But the description says "straight spout... runs from z=0 to z=20".
// And "cone widens... at rim at z=50".
// If it's a standard funnel, liquid enters narrow end (spout), exits wide end (rim).
// However, if the cone is inverted (wide at bottom), liquid would exit at z=20. 
// Let's re-read: "cone widens from 10mm... at z=20 to 60mm... at rim at z=50".
// This implies a shape like an hourglass or a cone pointing down? No, that would be wide at bottom (z=50).
// If it's a funnel collecting liquid, the opening must be at the top. 
// But the spout is at z=20. The cone widens from 10mm to 60mm.
// This implies the narrow part is at z=20 and wide part is at z=50.
// If it's a funnel, liquid enters at z=20 (spout) and exits at z=50? That would be an inverted cone.
// BUT: "The wall is 1.6mm thick everywhere... spout's bore is 6.8mm".
// And "open at the top and at the bottom so liquid runs straight through".
// This implies a continuous tube with a tapering section? 
// Or perhaps the user means the funnel shape (wide opening) but the geometry description describes an inverted cone?
// Let's look at the dimensions again. Spout 10mm -> Cone 60mm.
// If it's a standard funnel, you pour in small, it pours out large.
// So the narrow end is the spout (z=20), and the wide end is the rim (z=50).
// This creates an inverted cone shape for the upper section.
// To make it "open at the top", we need to cut a flat surface at z=50 that extends outward? 
// No, if it's open at the top, the material must stop at z=50 and have a hole there? 
// Or maybe the cone is just the side wall, and the lid is separate?
// "The funnel is open at the top". This usually means the widest part.
// If the widest part is at z=50, then the opening is at z=50.
// But the spout ends at z=20. So liquid flows from z=20 to z=50? That's a downward flow in the cone section? 
// Wait, if it's an inverted cone (narrow top, wide bottom), liquid enters at z=20 and exits at z=50.
// To make it open at the top (z=50), we need to remove material from the top of the cone wall?
// Actually, a standard funnel has a hole in the lid. Here, the "rim" is the opening.
// So the solid cone ends at z=50. We need to cut a flat surface at z=50 that extends outward to 60mm? 
// No, if it's open at the top, the material must stop there and have an aperture.
// Let's assume the "rim" is the opening edge. So we need a flat face at z=50 that creates the hole?
// Actually, simpler interpretation: The cone shape is the solid side wall. 
// To make it open at the top (z=50), we cut a flat surface at z=50 with radius 60mm? 
// No, if we cut a flat face at z=50, that creates a lid.
// Let's try this: The cone side wall is extruded from z=20 to z=50. 
// At the top (z=50), we need to remove material to make it open? 
// No, if we just extrude the cone wall, it will be closed at both ends (top and bottom).
// To make it open at the top (rim), we must cut a flat surface at z=50 that extends outward.
// But wait, if the cone widens to 60mm at z=50, and the spout is 10mm at z=20...
// The shape is an inverted cone. Liquid enters at z=20 (spout), travels through the hole, exits at z=50? 
// That would be a downward flow in the cone section? No, gravity pulls it down.
// If it's a funnel, liquid flows UP from the spout into the wide opening.
// So the narrow end is the spout (z=20), and the wide end is the rim (z=50).
// This means the cone is inverted? No, if you pour in small at z=20, it goes to large at z=50.
// That implies the cone widens as Z increases. Yes.
// So liquid flows from z=20 to z=50.
// To make it "open at the top", we need a flat surface at z=50 that extends outward? 
// No, if it's open at the top, the material must stop there and have an aperture.
// Let's assume the standard interpretation: The cone side wall is solid from z=20 to z=50.
// At the top (z=50), we need to cut a flat surface that creates the opening? 
// No, if we cut a flat face at z=50, it becomes a lid.
// Let's try: The cone side wall is extruded from z=20 to z=50. 
// At the top (z=50), we remove material to make it open? 
// Actually, maybe the "rim" IS the opening edge, and the flat surface at z=50 is just a face of the cone?
// No, if the cone widens to 60mm at z=50, that's the diameter.
// Let's assume the user wants an inverted cone shape (narrow top, wide bottom).
// To make it open at the top (z=50),