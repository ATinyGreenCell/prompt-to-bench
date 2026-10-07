// Dimensions for replacement hotplate stirrer knob
// Measured with calipers; units in millimetres
$fn = 64; // Ensure smooth curves and accurate hole sizes

// Main body dimensions
diameter_main = 30.0;      // Outer diameter of the cylinder (mm)
height_main = 15.0;        // Total height of the knob (mm)

// Shaft interface dimensions
shaft_dia = 6.0;           // Diameter of D-shaft hole (mm)
d_flat_to_tip = 4.7;       // Distance from flat side to tip of D-bore (mm)

// Grip groove specifications
num_grooves = 18;          // Number of grooves around the circumference
groove_depth = 2.0;        // Depth of each grip groove (radius, mm)

// Pointer groove specifications on top face
pointer_width = 1.5;       // Width of pointer slot (mm)
pointer_depth = 1.0;       // Depth of pointer slot (mm)

// Offset for cutting shapes in difference() to ensure no coplanar faces
offset_cut = 0.02;        // Extra extension beyond face for clean cuts (mm)

// ---------------------------------------------------------
// Build the main cylinder body first
// Orientation: Side facing hotplate is at z=0, building upward (+Z).
// Centered on origin in X and Y. Base rests on XY plane (z=0).
// ---------------------------------------------------------

main_cylinder = translate([0, 0, height_main/2]) { // Shift up so base is at z=height_main/2 relative to center? No.
    // Let's define the geometry centered at origin first for easier rotation logic, then move it down later if needed.
    // Actually, user said "rests on XY plane at z = 0". So we build from bottom up.
    cylinder(h = height_main + offset_cut * 2, r1=diameter_main/2 - groove_depth*offset_cut, 
             r2=(diameter_main+groove_depth)/2); // Slightly larger top to accommodate grooves if they are cutouts? No, grooves are cuts.
    // Wait, the cylinder is solid first. Then we subtract features.
};

// ---------------------------------------------------------
// D-shaped blind bore on the bottom face (z = 0 relative to part base)
// The flat side of the 'D' faces outward from the center? 
// "From that bottom face... a D-shaped blind bore goes 12 mm up".
// Dimensions: 6.2mm diameter circle with one side cut flat, distance from flat to opposite side is 4.7 mm.
// This implies a semi-circular shape extruded upwards (height = radius of the full circle?) 
// Or height = d_flat_to_tip? "distance from flat to opposite side... is 4.7". 
// If it's a D-shape, usually that means width W and depth H where one edge is straight.
// Here: Circle diameter 6.2 -> Radius ~3.1. Flat to tip distance = 4.7.
// This suggests the shape extends from z=0 (flat) to z=4.7? Or does it mean the chord length vs arc height?
// Let's interpret as a standard D-profile: A rectangle of width W and height H, plus semi-circles on top/bottom? 
// No, "D-shaped blind bore". Usually means a hole that looks like a 'D' in cross section.
// If distance from flat to tip is 4.7mm, and it's based on a 6.2mm circle...
// Likely: It starts at z=0 (flat face), goes up 12mm deep into the part? 
// "goes 12 mm up". So depth = 12mm.
// The shape of the hole itself is defined by the D-profile dimensions.
// Let's assume the profile has a flat bottom and curved top, or vice versa relative to Z axis inside the part.
// Since it starts at z=0 (bottom face), let's make the flat side be the entry point? 
// Or does "flat side faces outward" mean the opening is D-shaped with one straight edge on the surface?
// User: "From that bottom face, a D-shaped blind bore goes 12 mm up".
// Interpretation: The hole starts at z=0. It has depth 12mm. Its cross-section (at any Z) changes from circular to flat? 
// Or is it a single cutout shape extruded along Z? "D-shaped... circle with one side cut flat".
// Let's assume the profile of the hole in XY plane at z=0 is: A semi-circle of radius R, plus a rectangle below it? 
// No, simpler: The hole has an outer boundary that forms a D-shape. 
// Dimensions given: "6.2 mm diameter circle with one side cut flat". This implies we take a 3.1mm radius circle and flatten one radial edge.
// Distance from flat to opposite side is 4.7mm. In a semi-circle of R=3.1, distance center-to-tip is 3.1. 
// If we add the rectangle part? Or maybe the "flat" is not at the surface but inside?
// Let's assume: The hole starts as a circle (r = shaft_dia/2 + offset) and extends up to z=4.7mm where it becomes flat? 
// No, "distance from flat to opposite side of the circle is 4.7 mm". This sounds like the total height of the D-profile in XY plane relative to center line?
// Let's assume a standard D-shape: Width = shaft_dia + offset_cut (to fit). Height = d_flat_to_tip (4.7mm) from flat side to tip. 
// But it goes 12mm deep into the part. So we extrude this profile along Z for 12mm?
// Let's define a polygon that represents the D-shape in XY plane, then rotate/extrude it up by 12mm (z-axis).

d_bore_profile = [ // Polygon points defining the hole shape at z=0 to z=4.7 relative to start? 
    // Actually, let's make the profile such that:
    // At Z_start (bottom of bore), we have a flat edge on one side and curved on others?
    // Let's assume the D-shape is oriented with the straight edge facing "out" or "in"?
    // User says "flat to opposite side... 4.7mm". This implies the dimension along the axis perpendicular to the flat face is 4.7mm.
    // If we orient the part such that Z goes up, and the bore starts at z=0 (bottom of knob).
    // Let's make the D-shape lie in a plane parallel to XY? No, it's a "blind bore", so it has depth.
    // So the profile is extruded along Z. The cross-section changes with Z? Or is it constant? 
    // Usually blind bores have constant cross section unless specified as tapered or stepped.
    // Given "D-shaped... circle with one side cut flat", maybe the hole starts circular and then gets flattened at depth 4.7mm?
    // OR, the entire bore (depth 12mm) has a D-shape profile where the straight edge is on one radial line of the cylinder surface? 
    // Let's assume: The hole runs from z=0 to z=12. Its cross-section at any Z is a circle r = shaft_dia/2 + offset_cut, EXCEPT for 4.7mm height starting at bottom where it becomes flat (radius reduced)?
    // No, "distance from flat to opposite side... is 4.7". This sounds like the geometry of the D itself. 
    // Let's assume a simple extrusion: A cylinder hole r = shaft_dia/2 + offset_cut, but we cut out a rectangular prism on one side?
    // No, "D-shaped". That implies curved sides and straight top/bottom or left/right.
    
    // Revised Interpretation for robustness: 
    // The bore is a single feature extruded from z=0 to z=12 (depth). 
    // Its cross-section profile in XY plane is defined by the D-shape dimensions relative to the center of the knob.
    // Let's assume the "flat" side corresponds to x = -R_flat and curved sides correspond to arcs?
    // Dimensions: Circle diameter 6.2 -> Radius ~3.1mm. Flat distance from flat to tip is 4.7mm. 
    // This implies a shape where one radial edge (length L) is straight, and the rest are circular arcs?
    // Let's assume the profile extends from x = -R_total to x = +R_flat? Or vice versa?
    // "Distance from flat to opposite side of the circle". If we have a full circle R=3.1, distance across diameter is 6.2. 
    // If one side is cut flat (removed), and remaining height/width is measured... 
    // Let's assume the D-shape has: Flat width W_flat = shaft_dia + offset_cut? And curved part adds to it?
    // Actually, let's use a polygon that creates a "D" shape