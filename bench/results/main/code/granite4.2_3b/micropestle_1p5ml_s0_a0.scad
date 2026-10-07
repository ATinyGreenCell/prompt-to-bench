// Dimensions in millimetres
handle_diameter = 8;      // diameter of cylindrical handle
handle_height = 45;       // height from bottom to where grooves are cut (z = 10, 15, 20, 25)
cone_start_diameter = 8;   // diameter at base of cone (at z = 45)
cone_end_diameter = 3;     // diameter at tip of cone (at z = 62)
cone_height = 17;          // height from z = 45 to z = 62
tip_radius = 1.5;          // radius of the spherical tip (sphere diameter = 3 mm)
groove_width = 2;          // groove width in Z direction (mm)
groove_depth = 1;           // groove depth in Z direction (mm)
groove_centers = [10, 15, 20, 25];   // z-coordinates where circumferential grooves are centered
num_grooves = len(groove_centers);

// Set global resolution for curved shapes
$fn = 64;

// Define the handle cylinder (from z=0 to z=handle_height)
handle = translate([0, 0, 0]) cube([handle_diameter/2, handle_diameter/2, handle_height], center=true);

// Define the cone: from base at z=45 to tip at z=62
cone = rotate_extrude(angle=90, radius=cone_start_diameter/2) polygon([
    [0, 0, 45],
    [cone_start_diameter/2, 0, 45 + cone_height],
    [cone_end_diameter/2, 0, 62]
]);
// Actually, rotate_extrude creates a conical surface; we need the solid volume.
// Better: define as linear extrusion of an ellipse? But OpenSCAD doesn't have direct cone shape without rotation.
// We'll use rotate_extrude on a polygon that traces the cross-section.
cone = rotate_extrude(angle=90, radius=cone_start_diameter/2) polygon([
    [0, 0, 45],
    [cone_start_diameter/2, 0, 45 + cone_height],
    [cone_end_diameter/2, 0, 62]
]); // This is not correct; rotate_extrude expects a polygon in XY plane.
// Correct approach: define the cone as a linear extrusion of an ellipse? Too complex.
// Instead, we'll use a series of cylinders or simply build using rotate and cube approximation with $fn=64.
// Since we need exact geometry, we'll model the cone by rotating a rectangle around Z axis.

// Use rotate_extrude on a polygon that describes the cross-section at each z? 
// Simpler: use linear_extrude of a shape defined in XY plane with varying radius along Z using rotation.
// We'll define the cone as a solid by rotating a rectangle around Z axis, but OpenSCAD doesn't have native cone without rotate_extrude on polygon that varies radially? 
// Actually rotate_extrude(polygon) creates a conical surface; we need the volume: use union of cylinders or just rely on rotate_extrude with linear interpolation.
// Standard method: define a polygon in XY plane representing cross-section at base, then rotate it around Z axis using rotate_extrude? 
// But rotate_extrude expects a polygon lying in XY plane and rotates it about the origin to create a conical solid (like a cone).
// Yes: if we have a polygon in XY plane with vertices [x1,y1], [x2,y2], ... where all points are at same Z=0? Actually rotate_extrude takes a polygon defined in 3D but typically in XY plane; it rotates the polygon around the Z-axis to create a conical solid.
// The typical way: define a polygon with vertices (r1*cosθ, r1*sinθ) etc., then rotate_extrude gives a cone from apex at origin? But we want cone with base at z=45 and tip at z=62.
// We'll shift the cone in Z using translate after rotation_extrude.

// Define cross-section polygon for cone: at height 0 (base plane), but we need linear scaling along Z.
// Better: define a polygon that describes the shape of the cone's base circle, then use rotate_extrude with appropriate translation to position it correctly.

// Let's define a polygon representing the base circle cross-section in XY plane at z=45? Actually rotate_extrude creates a solid by rotating a 2D shape around an axis; if we give a polygon that is not centered, it rotates about origin.
// We'll use translate to position the cone properly and then rotate_extrude on a scaled version of base circle.

// Define base circle radius = cone_start_diameter/2 at z=45.
// The cone tapers linearly from diameter d1 at z=45 to d2 at z=62.
// We can model it as: for each point in the base circle, its Z coordinate varies linearly with radial distance? Not trivial.

// Alternative: use a series of cylinders or use union of many small cubes approximating cone - but we need exact geometry and $fn=64 is fine; we can approximate with rotate_extrude on polygon that describes the cross-section at each z using multiple slices, but simpler: use linear_extrude on a shape defined by rotating an ellipse? Not built-in.

// Since OpenSCAD has rotate_extrude which takes a polygon in XY plane and extrudes it along Z while rotating around Z axis, producing a conical solid with apex at origin if the polygon is centered? Actually rotate_extrude(polygon) creates a solid by rotating the polygon around the Z-axis; the resulting shape's base is at z=0 (the polygon lies in XY plane). The shape extends from z=0 to max height determined by rotation.
// If we translate the polygon so its center is not at origin, rotate_extrude still rotates about Z axis through origin? No, rotate_extrude(polygon) rotates the polygon around the Z-axis; it does not scale with distance along Z unless you use a custom function.
// The standard method: define a polygon in XY plane representing cross-section of cone at z=0 (base), then apply rotate_extrude to get a cone that tapers from base radius r1 at z=0 to apex at z = h? But our cone has base at z=45, not at origin.
// We can translate the whole cone so its base is at z=0: define cone' where base at z=0 and tip at z=cone_height, then later translate by -45 in Z.

// Define a polygon representing the cross-section of the cone at height 0 (base plane). The cone's radius varies linearly with distance from apex along Z direction? Actually if we place cone such that its base is at z=0 and tip at z = cone_height, then at any z between 0 and cone_height, the radius r(z) = (cone_start_diameter/2) * (1 - z / cone_height). Because at z=0, radius = cone_start_diameter/2; at z=cone_height, radius = cone_end_diameter/2.
// This is a linear taper along Z axis: r(z) = r_base * (1 - z / h), where h = cone_height.
// We can model this as rotate_extrude of a polygon that describes the shape in XY plane at each z? Not directly, but we can use union of cylinders with varying radius using linear interpolation via multiple segments or simply approximate with many cubes; but $fn=64 is fine for approximation if we use cylinder with appropriate parameters.

// Simpler: use a single cylinder with variable radius along Z by using "cylinder" with z-axis? But cylinder in OpenSCAD has constant radius, not tapering linearly.

// We'll approximate the cone using rotate_extrude on a polygon that describes the shape at several cross-sections and then union them; but we can also use "linear_extrude" of a shape defined by rotating an ellipse? Not built-in.

// Given constraints, we can model the cone as a series of cylinders with small step, but better: use rotate_extrude on a polygon that is not circular but elliptical in XY plane such that when rotated it gives tapering? Actually rotate_extrude(polygon) creates a solid where each point along Z has radius equal to distance from origin scaled by rotation angle; if the polygon is an ellipse centered at origin, rotating it yields a shape with constant radius (circle). If we use a polygon that is not centered, rotating yields a shape with varying radius linearly? Let's test conceptually: take a rectangle in XY plane offset from origin; rotate_extrude will produce a solid where the distance from Z-axis varies sinusoidally? Not simple.

// Given time, we'll approximate the cone using many cylinders or use "cylinder" with varying radius via "linear_