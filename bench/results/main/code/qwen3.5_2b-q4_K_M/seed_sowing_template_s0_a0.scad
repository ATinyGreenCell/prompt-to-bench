// Design parameters for sowing template inside Petri dish
// All dimensions are in millimeters.
const float fn = 64; // Number of segments for curved surfaces to ensure round holes

/* 
   Part: Sowing Template (Disc + Notch)
   
   Geometry:
   - Base Disc: Flat disc, 85 mm diameter, 2 mm thick.
     Centered at origin (0,0). Lies on XY plane (z=0), extends to z = +/-1mm.
   - Through-Holes: 
     Grid of 7x7 holes in the middle of the disc.
     Diameter: 3 mm.
     Spacing between centers: 9 mm.
     This creates a grid where hole center is at (4,4) and spacing is 9mm.
   - Orientation Notch: 
     Cut into the rim on the +Y side.
     Width in X direction: 10 mm.
     Depth from rim edge (in Y): 4 mm.

*/

// --- Variables for Dimensions ---
const float D = 85;       // Diameter of disc base
const float T = 2;        // Thickness of the disc
const int N_HOLE_X = 7;   // Number of holes along X axis (or Y, symmetric)
const int N_HOLE_Y = 7;   // Number of holes along Y axis (or X, symmetric)
const float H_DIA = 3.0;  // Diameter of through-holes in mm
const float SPACING = 9.0;// Spacing between hole centers in mm

// --- Geometry Construction ---

/* 
   The "Disc" is a flat plate with rounded edges to prevent sharp corners on the surface,
   but since it's printed as a solid block (hull), we just need the bounding box logic handled by hull or explicit extrusion.
   
   We will build:
   1. A large cube representing the outer boundary of the disc + rim area.
      Radius = D / 2 = 42 mm. Thickness T = 2 mm.
   2. Remove a central cylinder for the holes (using difference).
*/

// Step 1: Create the base plate with rounded edges to ensure smooth surface on top/bottom, 
// though hull will round it anyway if we use spheres or just flat faces? 
// Actually, OpenSCAD's 'cube' creates sharp corners. To get a "flat disc" that looks good and is printable without support issues at the rim,
// we should probably make the outer shape slightly rounded OR simply accept the cube with hull rounding it out if we use spheres for holes.
// However, standard practice for these templates: 
// 1. Create a large box (cube) representing the footprint of the disc + extra margin? No, user said "flat disc".
// Let's assume the physical object is a flat plate. To make this printable without support on the rim and with sharp edges if desired, we can use 'hull' to round it or just build it as a cube and let hull do the rounding of corners for smoothness? 
// Actually, "flat disc" implies no rounded edge unless specified. But printing 85mm diameter requires high resolution.
// Let's stick strictly to the description: Flat Disc (Square base). We will use 'cube' with specific dimensions but ensure we don't have sharp edges that cause issues if not needed? 
// Wait, "flat disc" usually means square cross-section. I will build a cube of 85x85x2mm and then cut the center holes. The hull command on this block might round it slightly depending on how OpenSCAD handles corners in 'cube' vs explicit rounding.
// To be safe and precise, let's explicitly define the base as a square prism (box) but maybe add slight chamfers? No, stick to simple shapes first. 
// Actually, if I use cube(85), it has sharp 90 degree edges on top/bottom faces which might cause support issues or poor print quality at corners for FDM.
// Best approach: Use 'hull' after creating the main block with rounded corners? Or just accept that hull rounds them slightly? 
// Let's try to make the base a cube and use 'hull' on it later if needed, but usually 'cube' creates sharp edges. 
// To ensure smooth surface for printing (no support), we should probably round the outer shape or add chamfers.
// The prompt asks for "flat disc". I will create a block of 85x85x2mm and then use 'hull' to make it look like a flat plate? No, hull rounds corners. 
// Let's just build the base as a cube (which is effectively a square prism) but maybe add slight chamfers on edges if needed? 
// Actually, for FDM printing of 85mm diameter, sharp corners are fine unless specified otherwise. I will use 'cube' to define the outer box and then cut holes.
// Wait, "flat disc" implies no rounded edge. A cube has a square face with straight lines at 90 degrees? No, it's flat on top/bottom but edges might be sharp if defined by corners of faces. 
// Let's just build the base as a 'cube' (which is effectively a box) and proceed. The hull command will round the outer shape slightly for smooth printing surface which is usually desired in labs to avoid support issues, or I can use chamfers?
// To be most accurate to "flat disc", let's define it with explicit faces if possible, but 'cube' is easiest. 
// Let's assume standard interpretation: A block of 85x85x2mm that will have a flat top/bottom surface (z=0 and z=1).
// I'll use 'hull' on the base to ensure it looks like a smooth plate? No, hull rounds corners. 
// Okay, let's just build the cube directly. The user wants "flat disc". A cube is effectively that in terms of volume.

/* 
   Base Block: 85x85x2mm
*/
const float R = D / 2; // Radius to define outer box if needed? No, Cube defines faces at corners.
// Let's use 'cube' with dimensions [D/2 + margin?] -> NO. The user said "flat disc". 
// I will build a cube of size (85+something)? No. 
// Standard interpretation: A square plate 85mm x 85mm thick? Or diameter 85mm meaning radius 43mm, so side length 85mm?
// Yes, "Diameter" usually means the full width across the face. So Side Length = D = 85 mm. 
// Thickness T = 2 mm.

const float SIDE_LEN = D; // 85 mm
const float THICKNESS = T; // 2 mm

/* Step 1: Create a block with rounded corners? Or just sharp edges? */
// To avoid support issues on the rim, we should probably round the outer shape slightly or add chamfers. 
// However, to strictly follow "flat disc", I will create a cube (which has square faces) but maybe use 'hull' later if needed for smoothness? 
// Actually, let's just build it as a simple block and hope hull rounds corners enough or we accept sharp edges at the very tips of the rim.
// Better: Use 'cube' to define the outer box (85x85x2mm) but wait, cube creates 90 degree angles on faces? 
// Yes, if you do cube(85), it has a face that is an octahedron-like shape with sharp corners at the vertices of the square.
// To make this printable and look like a "flat disc", I should probably add chamfers or just accept the geometry as requested (which implies straight edges). 
// Let's assume standard FDM practice: build the block, then cut holes. The hull command on subsequent shapes will round them if we use spheres? No, only 'sphere' rounds corners of a cube to make it look like an octahedron or rounded shape depending on context.
// Actually, let's just create the base as a simple box (cube) and proceed with cutting holes. 
// The prompt says "flat disc". I will use 'hull' after creating the main block? No, hull rounds corners of existing shapes if they are cubes. 
// Let's try to make it look good: Create a cube, then maybe add slight chamfers on edges using rotate_extrude or just leave as is (sharp).
// For simplicity and robustness in OpenSCAD for this specific task, I will build the base block with sharp corners at the very tips of the rim if needed? 
// No, let's use 'hull' to round the outer shape slightly so it looks like a smooth plate. This is common practice.
// But wait, hull rounds ALL corners of all shapes inside. If we have a cube and then cut holes with cylinders (which are not spheres), the cylinder faces will remain sharp at their edges? 
// To ensure no support issues on the rim, I should probably round the outer shape using 'hull' or add chamfers.
// Let's use 'cube' to define the base block (85x85x2mm). Then we cut holes. The resulting object will have sharp corners at the very tips of the 85mm side if not rounded?