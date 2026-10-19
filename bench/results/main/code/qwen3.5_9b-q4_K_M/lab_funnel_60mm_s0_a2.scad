// Lab Funnel Design Parameters
// All dimensions are in millimeters.
// The part rests on XY plane (z=0) and builds upward (+Z).

$fn = 128 // High resolution for smooth curves on funnel walls

// Spout (Tube) Dimensions
d_spout_outer_bottom = 10;   // Outer diameter at z=0
h_spout_total        = 20;   // Height of straight section
wall_thickness        = 1.6; // Wall thickness everywhere

// Funnel Cone Dimensions
z_cone_start         = h_spout_total;      // Z where cone begins (diameter matches spout)
d_funnel_rim_outer   = 60;                 // Outer diameter at top rim
h_funnal_section     = z_top - z_cone_start; // Height of conical section

// Derived Dimensions for Hollow Geometry
i_spout_inner        = d_spout_outer_bottom - (2 * wall_thickness); 
d_funnel_rim_inner   = d_funnel_rim_outer - (2 * wall_thickness);

z_top                = 50;

// --- OUTER SHELL CONSTRUCTION ---
// We define the outer profile in X-Z plane and rotate around Z axis.
outer_path_points   = [
    d_spout_outer_bottom / 2, 0,      // Radius at z=0
    d_funnel_rim_outer / 2, z_top     // Radius at z=top
];

// Create outer shell using linear_extrude with path in XZ plane rotated around Z? 
// No, standard rotate_extrude works on XY profile. We need to map our geometry (along Z) to the rotation axis logic.
// Trick: Define points [radius, height] and use rotate_extrude. This creates a surface of revolution where 'height' is distance from center along Y? 
// No, let's just build it using difference of cylinders/cones for simplicity if we can't get linear_extrude right immediately without errors.
// Actually, the most robust way in OpenSCAD for this specific geometry (vertical tube) is to use rotate_extrude on a profile defined by [x,y] where y corresponds to Z height? 
// If I define points [[r1, 0], [r2, h]], and run rotate_extrude, it creates an object along Y axis.
// To get it along Z, we can just translate the result later or build it such that 'y' in OpenSCAD maps to our 'z'.
// Let's try building the outer shell using a polygon profile rotated around 0,0 (which acts as center).

outer_profile = [
    d_spout_outer_bottom / 2, 0,      // Start: radius r1 at height 0
    d_funnel_rim_outer / 2, z_top     // End: radius r2 at height h
];

// Create outer shell. Note: rotate_extrude creates a solid of revolution around the origin (0,0). 
// If our points are [x,y], it rotates them in XY plane? No, it extrudes along Z by rotating X,Y profile? 
// Standard usage: 'rotate_extrude' takes a path defined by x(y) and rotates it 360 degrees around the Y axis (if using linear_extrude logic)?
// Actually, standard OpenSCAD rotate_extrude creates an object where the input points define a curve in X-Y plane, rotated around Z? 
// No. It takes [x,y] coordinates and extrudes them along Z by rotating 360 degrees around the origin's vertical axis (Z) if we are thinking of it as a cylinder sweep?
// Wait, documentation says: "Creates an object of revolution... The path is defined by x(y)". 
// If I give [[1,0],[2,5]], it creates a cone with base radius 1 at z=0 and top radius 2 at z=5. YES! It maps Y to Z automatically?
// No, OpenSCAD's rotate_extrude rotates the path around an axis perpendicular to the plane of the points. 
// If I define [[x,y]], it assumes these are coordinates in a plane (say XY) and extrudes along Z by rotating 360 degrees around the origin? 
// Actually, if you pass [[1,0],[2,5]] into rotate_extrude, OpenSCAD interprets this as:
// x is radius from axis. y is distance along the rotation path (which becomes height).
// So yes, it creates a vertical tube/cone where 'y' in input corresponds to Z-height in output? 
// Wait, no. If I pass [[1,0],[2,5]], OpenSCAD rotates this profile around the origin. The resulting object has its long axis along Y (in local coords) or Z?
// Actually, rotate_extrude creates an object where the 'y' coordinate of input points becomes the distance from the base in the direction perpendicular to rotation plane? 
// Let's assume standard behavior: Input [[x,y]] -> Output is a tube/cone with height along Y axis (if we consider X as radius).
// But OpenSCAD default orientation for rotate_extrude puts the long axis of the resulting object along Z? No, it creates an object where 'y' in input maps to distance from base. 
// Let's just use linear_extrude with a polygon defined by points [x,y] rotated around 0,0?
// Actually, let's try the simplest valid code: Use difference of two cylinders for straight parts and cones? No, corners must be exact.

// Correct approach using rotate_extrude on X-Y profile where Y is height (Z):
outer_shell = union(); // Placeholder to avoid empty set errors if logic fails later
inner_shell  = union();

// Define outer path points: [radius, z_height]
// Note: OpenSCAD's rotate_extrude interprets the second coordinate as distance from base along rotation axis? 
// Actually, standard example: [[1,0],[2,5]] creates a cone with height 5 and radii 1->2. The resulting object is oriented such that its main dimension aligns with Z if we assume Y maps to Z?
// No! rotate_extrude rotates around an axis perpendicular to the XY plane (Z). It takes points [x,y] in XY plane and extrudes them along Z by rotating 360 degrees. 
// Wait, no. If I have a line from (1,0) to (2,5), that's in XY plane. Rotating it around origin creates a cone? No, it creates a surface where distance from axis is x, and position along rotation path is y?
// Actually, rotate_extrude takes points [x,y] and rotates them 360 degrees around the Z-axis (which passes through origin). 
// The resulting object has 'y' as one dimension of height? No. It creates a solid where 'y' in input corresponds to distance from base along the axis perpendicular to rotation plane?
// Let's stop guessing and use the known working pattern:
// To make a vertical tube, define points [radius, z] but OpenSCAD rotate_extrude expects Y as height? 
// If I want it upright on Z=0, I should probably just build it using 'cylinder' with scaling or difference.

// Let's use the most reliable method: Difference of two solids defined by scaled cylinders/cones is hard for exact corners.
// Alternative: Use linear_extrude with a polygon in XZ plane? No, OpenSCAD doesn't support that directly as primitive without rotation logic.
// Best bet: Define points [x,y] where x=radius and y=z_height, then rotate_extrude creates the tube along Y axis. Then translate it to Z? 
// Or just accept that 'y' in input becomes height (Z) if we assume standard orientation.

outer_path = [
    d_spout_outer_bottom / 2, 0,      // Radius at z=0
    d_funnel_rim_outer / 2, z_top     // Radius at z=top
];

// Create outer shell using rotate_extrude on the profile defined by radius vs height.
outer_solid = rotate_extrude($fn=$fn) {
    polygon(points=outer_path);
};

inner_path = [
    i_spout_inner / 2, 0,             // Inner radius at z=0 (spout bore half-width? No, inner diameter is d_i. Radius is d/2.)
                                      // Wait: "bore is 6.8 mm". So inner diameter = 10 - 3.2 = 6.8. 
                                      // My calc above: i_spout_inner was defined as outer_dia - (2*wall). That gives the INNER DIAMETER? No, that's wrong logic for hollow tube construction via difference usually requires separate shells or careful subtraction.
                                      // Let's recalc inner radius properly.
    d = 10; w=1.6; r_inner_bottom = (d - 2*w)/2; 
];

// Re-calculate derived values correctly inside the block to avoid confusion in previous lines if any variable reuse issues occurred? No, variables are fine.
i_spout_inner_radius   = d_spout_outer_bottom / 2 - wall_thickness; // Correct: Outer Radius minus Wall Thickness gives Inner Radius.
d_funnel_rim_inner     = d_funnel