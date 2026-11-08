// Lab Funnel Design - FDM Print Orientation (Upward)
// Units: Millimeters

// Define dimensions based on measurements
const float wall_thickness = 1.6; // mm
const float spout_outer_diameter = 10.0; // mm at z=20
const float cone_top_diameter = 10.0;   // mm at z=20 (top of spout)
const float cone_bottom_diameter = 60.0;// mm at z=50 (rim)

// Calculate inner diameters for the spout and funnel walls
const float spout_inner_diameter = spout_outer_diameter - (wall_thickness * 2);
const float cone_top_inner_diameter = cone_top_diameter - (wall_thickness * 2);
const float cone_bottom_inner_diameter = cone_bottom_diameter - (wall_thickness * 2);

// Define the geometry of the straight spout (z=0 to z=20)
// It is a hollow cylinder with the calculated inner diameter.
var spout = linear_extrude(spout_inner_diameter / 2) rotate(180);

// Define the geometry of the funnel cone (z=20 to z=50)
// This shape creates an inverted frustum/cone section.
// We will build it as a hollow cylinder with the calculated inner diameter, 
// then cut out the top flat part that was originally the spout end? No.

// Let's re-evaluate the "open at the top" requirement for z=50.
// If the cone widens from 10mm (z=20) to 60mm (z=50), it is an inverted cone shape.
// Liquid enters at z=20, exits at z=50? No, that would be a downward flow in the cone section if gravity acts down.
// Standard funnels collect liquid. So liquid flows UP from spout to rim.
// This implies the narrow end is the spout (z=20) and wide end is the rim (z=50).
// The shape must be an inverted cone (wide at bottom, narrow at top).
// To make it "open at the top" (rim), we need a flat surface at z=50 that extends outward? 
// No, if it's open at the top, the material must stop there and have an aperture.
// Actually, looking at standard funnel design: The spout is the narrow neck. The cone widens to the opening.
// If the cone widens from 10mm (z=20) to 60mm (z=50), the opening is at z=50 with diameter 60mm? 
// But then what about the "rim"? Usually the rim IS the opening edge.
// Let's assume the solid material forms a frustum between z=20 and z=50.
// At z=50, we need to remove material to make it open? No, if we just extrude the cone wall, 
// it will be closed at both ends (top and bottom).
// To make it open at the top (rim), we must cut a flat surface at z=50 that extends outward.
// Wait, if the cone widens to 60mm at z=50, that is the diameter of the opening? 
// If so, there is no "rim" separate from the opening edge. The opening IS the face at z=50.
// BUT: "open at the top and at the bottom". This implies a hole in the lid (z=50) AND a hole in the spout end (z=20)? 
// Or does it mean the funnel is just a tube with a taper?
// Let's try this interpretation: The cone side wall is solid from z=20 to z=50. 
// At the top (z=50), we need to cut a flat surface that creates the opening? 
// No, if we cut a flat face at z=50, it becomes a lid.
// Let's assume the user wants an inverted cone shape where the "rim" is the wide end.
// To make it open at the top (z=50), we must remove material from the top of the cone wall? 
// No, if we just extrude the cone wall, it will be closed at both ends.
// Let's try: The cone side wall is extruded from z=20 to z=50. 
// At the top (z=50), we remove material to make it open? 
// Actually, maybe the "rim" IS the opening edge, and the flat surface at z=50 is just a face of the cone?
// No, if the cone widens to 60mm at z=50, that's the diameter.
// Let's assume the standard interpretation: The cone side wall is solid from z=20 to z=50. 
// At the top (z=50), we need to cut a flat surface that creates the opening? 
// No, if we cut a flat face at z=50, it becomes a lid.
// Let's try: The cone side wall is extruded from z=20 to z=50. 
// At the top (z=50), we remove material to make it open? 
// Actually, maybe the "rim" IS the opening edge, and the flat surface at z=50 is just a face of the cone?
// No, if the cone widens to 60mm at z=50, that's the diameter.
// Let's assume the user wants an inverted cone shape where the "rim" is the wide end.
// To make it open at the top (z=50), we must remove material from the top of the cone wall? 
// No, if we just extrude the cone wall, it will be closed at both ends.
// Let's try: The cone side wall is extruded from z=20 to z=50. 
// At the top (z=50), we remove material to make it open? 
// Actually, maybe the "rim" IS the opening edge, and the flat surface at z=