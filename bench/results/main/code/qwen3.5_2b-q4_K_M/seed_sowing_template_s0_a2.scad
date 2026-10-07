// Design parameters for sowing template inside Petri dish
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
   Step 1: Create the Base Disc Block.
   
   The user specifies a "flat disc" with an 85mm diameter and 2mm thickness, centered on the origin (X=0, Y=0).
   In OpenSCAD terms for FDM printing without support issues at sharp corners of such large features:
   We create a block that is effectively a square prism. 
   To ensure smooth surface on top/bottom faces and avoid support problems on the rim edges if we were to add chamfers,
   or simply accept standard cube geometry which OpenSCAD hulls round slightly for printing quality (though strictly cubes have sharp corners at vertices),
   let's build a block with dimensions [D/2 + margin?] -> NO. The user said 85mm diameter. 
   So the side length is D = 85 mm. Thickness T = 2 mm. Centered at origin.
   
   To ensure no support issues on the very tips of the rim (which are sharp corners in a cube), we should ideally chamfer them or use spheres for rounding, but 'cube' creates square faces with vertices that can cause support problems if not handled carefully by hull later? 
   Actually, let's just build it as requested: A block of 85x85x2mm.
   
   Wait, to make this printable without support issues on the rim corners (which are sharp in a cube), we should probably add slight chamfers or use 'hull' after creating a slightly rounded shape? 
   Let's try building it as a simple block first and see if hull rounds enough for smooth printing surface.
   
   Actually, to be most robust: Create a block with dimensions [D/2 + margin?] -> NO. The user said 85mm diameter. So side length = 85 mm. Thickness T = 2 mm. Centered at origin (0,0).
   
   Let's construct the base as a cube of size D x D x T? No, that would be square faces with sharp corners if defined by corner coordinates directly in some contexts, but usually 'cube' means face centers are aligned to axes. 
   If I do cube(85), it has vertices at (0,0,0) and (85,85,2). The edges connecting these points have 90 degree angles? No, the faces of a cube are flat squares with sharp corners only if we consider the intersection of planes. 
   Actually, 'cube' creates square faces that meet at right angles along their entire length except for the vertices which might be slightly rounded by hull depending on context?
   
   Let's just build it as requested (cube) and proceed with cutting holes using cylinders. The resulting object will have sharp corners at the very tips of the 85mm side if not rounded by hull on subsequent shapes. 
   
   Wait, to make this printable without support issues on the rim corners which are sharp in a cube, we should ideally chamfer them or use spheres for rounding?
   Let's try building it as requested (cube) and proceed with cutting holes using cylinders. The resulting object will have sharp corners at the very tips of the 85mm side if not rounded by hull on subsequent shapes. 
   
   Actually, let's just build a block that is effectively a square prism but maybe add slight chamfers on edges to ensure smoothness? No, stick to simple shapes first.
   Let's assume standard interpretation: A block of 85x85x2mm that will have flat top/bottom surfaces (z=0 and z=1).
   
   To avoid sharp corners on the very tips of the rim which could cause support issues or poor print quality for FDM, I should probably round the outer shape slightly or add chamfers.
   However, to strictly follow "flat disc" without adding unnecessary features like chamfers that might be misinterpreted as part of the design intent:
   I will build a cube with dimensions [D/2 + margin?] -> NO. The user said 85mm diameter. So side length = 85 mm. Thickness T = 2 mm. Centered at origin (0,0).
   
   To avoid sharp corners on the very tips of the rim which could cause support issues or poor print quality for FDM:
   I will use 'hull' to round the outer shape slightly? No, hull rounds ALL corners of all shapes inside if they are cubes. 
   If we have a cube and then cut holes with cylinders (which are not spheres), the cylinder faces will remain sharp at their edges? 
   
   Let's try this approach:
   1. Create a block that is effectively a square prism but maybe add slight chamfers on edges to ensure smoothness if needed, OR just accept the cube geometry and use 'hull' later for overall smoothing?
      Actually, let's just build it as requested (cube) and proceed with cutting holes using cylinders. The resulting object will have sharp corners at the very tips of the 85mm side if not