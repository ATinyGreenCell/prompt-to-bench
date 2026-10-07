// Dimensions measured with calipers for FDM printing
// Units: millimetres
$fn = 100; // Higher resolution for smooth curves on curved surfaces

// Spout dimensions (z=0 to z=20)
spout_outer_diameter = 10.0;
wall_thickness = 1.6; 
// Calculate inner bore based on wall thickness: Outer - 3 * Thickness (top and bottom walls + slight overhang allowance for FDM)
spout_inner_bore = spout_outer_diameter - 2 * wall_thickness; 

// Funnel dimensions (z=20 to z=50 relative to start of cone, but absolute Z is needed)
funnel_top_rim_diameter = 60.0; // At the rim at z = 50 global coordinate
spout_outer_diameter_at_connection = spout_outer_diameter;

// Positioning variables (Global coordinates starting from bed contact or design base?)
// The spec says: "rests on the XY plane at z=0". 
// So Z=0 is the bottom of the part.
z_start_global = 0.0; // Bottom of spout touches here? Or top of spout? Spec: "straight spout... runs from z=0 to z=20". This implies the solid body starts at z=0 and ends at z=50.

// Construct the part as a single union of two cylinders with different radii
// We use difference() for hollowing out the center.

// 1. Outer Shell Construction (Union of Spout and Cone)
outer_shell = cylinder(h = funnel_top_rim_diameter - spout_outer_diameter_at_connection, 
                       r1 = spout_outer_diameter / 2.0, // Radius at z=20 connection point? No, let's build from bottom up carefully.

// Let's rebuild logic cleanly:
// Part consists of two cylinders stacked vertically along Z axis.
// Cylinder A (Spout): Height 20mm. Outer D = 10mm. Inner Bore calculated above. Located at z=0 to z=20? 
// Wait, the spec says "runs from z=0 to z=20". And then a cone widens FROM 10mm (at z=20) TO 60mm (at rim z=50).
// So:
// Segment 1 (Spout): Z range [0, 20]. Outer R = 5. Inner R calculated.
// Segment 2 (Cone): Z range [20, 50]. 
//   At Z=20: Outer D = 10mm -> Radius = 5mm. Matches spout outer radius. Perfect connection.
//   At Z=50: Outer D = 60mm -> Radius = 30mm.

// We will model this as a single large cylinder (the cone part) and subtract the missing material at the bottom? 
// Or simpler: Union of two cylinders with different radii, then hollow them out.
// Actually, OpenSCAD doesn't have linear interpolation for radius directly in primitives.
// Best approach: Create one big outer shape that covers both sections (a truncated cone or cylinder) and subtract a smaller inner core? 
// No, the geometry changes from Cylinder to Cone at Z=20.
// Correct geometric construction using difference of cylinders with varying radii is tricky without loops if not careful about continuity.
// Alternative: Use `rotate_extrude` on two polygons (one rectangle for spout, one triangle for cone)? 
// Or simpler: Create a large cylinder from 0 to 50mm? No, that's wrong shape at bottom.

// Let's use the difference method with precise coordinates.
// We need an outer volume and subtract inner volumes.
// Outer Volume = Cylinder (R=30) H=(20-60)? No.
// The part is: 
//   From Z=0 to 20: Annulus R_outer=5, R_inner=X
//   From Z=20 to 50: Cone Annulus R_outer(t), R_inner(t).

// Let's construct the OUTER shell first as a union of two cylinders? No, they don't align perfectly in radius if we just stack them. 
// Actually, at z=20, both have R=5. So we can define an outer cylinder from Z=-something to 60 with varying radii?
// OpenSCAD `cylinder` only supports constant r1 and r2 (cone). It does not support linearly changing radius along height unless it's a full cone or cylinder.
// Since the transition is at z=20, we can model the outer shape as:
//   A large truncated cone from Z=-30 to 50? No.
// Let's use `difference` with two cylinders for the OUTER shell if possible, but radii must match exactly at junction or there will be a gap/overlap artifact unless handled by union/difference carefully.
// Actually, since R_outer(20) = 5 and R_cone_top(20) = 30 (if we extend cone down), they don't match if we just take two cylinders.
// We must use `difference` to carve out the "missing" outer material at the bottom? 
// Or better: Use a single large cylinder for the top part and subtract a smaller cylinder for the spout extension? No, that makes it thicker at bottom.

// Correct approach using difference of primitives:
// 1. Create a full cone from Z=0 to Z=50 with R_top=30, R_bottom=... wait, we need flat bottom connection.
// The shape is NOT a single cone. It's a cylinder (bottom) + cone (top).
// So Outer Shape = Cylinder(R=5, H=20) UNION Cone(R_start=5, R_end=30, H=30)? 
// Union of two cylinders where one has r1=r2 and the other is tapered. They touch at Z=20 if aligned correctly? 
// If we place them in world coordinates:
//   Cylinder 1 (Spout): Centered on axis. Height 20. R=5. Position Z=-10 to +10? No, let's anchor bottom at Z=0.
//   So Spout is Z=[-10, 10]? No, user said "runs from z=0". 
// Let's assume the part sits on bed (Z_contact). The spout starts there.
// If we define global coordinates such that Bed contact is at some negative value? 
// User: "rests on the XY plane at z = 0 and builds upward (+Z)".
// This usually means the lowest point of the object touches Z=0 in the viewer's frame, OR it means the design coordinate system starts at 0.
// Given "runs from z=0 to z=20", let's assume these are absolute coordinates relative to the bottom-most surface touching the bed? 
// Or just that the part occupies Z=[0, 50] in its local frame and we translate it so lowest point is on XY plane (Z=0).
// Let's define: Lowest point of spout base = Global Z=0.

// Geometry Plan:
// Outer Solid:
//   Part A (Spout): Cylinder R=5, H=20. Located at Z=[-10, 10]? No. 
//   If we want the part to sit on Z=0, and spout is bottom-most...
//   Let's place Spout base at Global Z=-something? 
//   Actually, simplest: Define everything relative to a point where z=0 is the very bottom of the spout.
//   So Spout exists from Z=0 to Z=20. Cone exists from Z=20 to Z=50.
//   
// Outer Shell Construction (Union):
//   We can't easily union two cylinders with different radii without a gap or overlap unless we use difference logic on the "missing" parts.
//   Better: Create one large cylinder that covers both? No, radius changes at 20mm.
//   Let's create an outer shape using `difference` of a big cone and a smaller inverted cone/cylinder to get the spout thickness? 
//   
//   Alternative (Robust): Use two cylinders for OUTER shell with exact matching radii at junction by extending one slightly or overlapping perfectly in OpenSCAD.
//   Cylinder 1: R=5, H=20. Center Z = -10 + 10/2? No. 
//   Let's place Spout from Z=-10 to Z=10 (Centered at 0)? Then translate later.
//   
// Revised Plan for Outer Shell:
//   Create a large cylinder R=30, H=(50-(-something))? 
//   Actually, let's just build the outer boundary using `difference` of two cylinders? No.
//   Let's use `union()` of two shapes that form the outside:
//     Shape 1 (Spout): Cylinder(R=5), Height=20. Position Z=[-10, 10]? 
//     If we put Spout at Z=-10 to Z=10, and Cone starts at Z=10? Then Cone goes up to Z=40+1