// Dimensions for 96-well PCR tube rack (ANSI/SLAS footprint)
$fn = 64;

// Overall dimensions
length_X = 127.76;   // Length along X axis (12 columns)
width_Y = 85.48;     // Width along Y axis (8 rows)
height_Z = 20.0;     // Total height

// Hole parameters
hole_diameter = 6.2;           // Diameter of each through-hole
hole_spacing_X = 9.0;        // Center-to-center spacing along X (columns)
hole_spacing_Y = 9.0;          // Center-to-center spacing along Y (rows)
num_cols = 12;                 // Number of columns (along X)
num_rows = 8;                   // Number of rows (along Y)

// Position of first hole (A1) from left and back edges
offset_X = 14.38;               // From left edge (X)
offset_Y = 11.24;              // From back edge (Y)

// Chamfer parameters (45-degree chamfer at A1 corner)
chamfer_leg = 5.0;               // Length of each leg of the chamfer (in X and Y)

// Calculate the origin of the block (centered at origin)
// The block is centered at (0, 0, 0), so:
//   Left edge: -length_X / 2
//   Back edge: -width_Y / 2
//   A1 hole center is at:
//     X: -length_X / 2 + offset_X
//     Y: -width_Y / 2 + offset_Y

// Create base block (centered at origin)
module base_block() {
    cube([length_X, width_Y, height_Z], center = true);
}

// Create chamfer at A1 corner (front-left bottom corner when viewed from A1 side)
// The chamfer is on the vertical edge at the A1 corner (where X is min, Y is min)
// We'll cut a 45-degree chamfer from the bottom (z=0) to top (z=height_Z)
// The chamfer is a pyramid-like cut with two faces: one along X, one along Y

module chamfer_A1() {
    // Define the chamfer region: a pyramid that removes material from the A1 corner
    // The chamfer is a 45-degree bevel, so the cut is a plane that goes from:
    //   (X, Y, Z) = (minX, minY, 0) to (minX + chamfer_leg, minY + chamfer_leg, height_Z)
    // But we need to define a solid that removes a pyramid from the corner

    // The chamfer is a pyramid with:
    //   Apex: (minX, minY, 0)  // bottom corner
    //   Base: a square at Z = height_Z, from X = minX to minX + chamfer_leg, Y = minY to minY + chamfer_leg

    // We'll define the chamfer as a polyhedron with 5 vertices:
    //   0: (minX, minY, 0)           // apex at bottom
    //   1: (minX + chamfer_leg, minY, height_Z)  // top front-left
    //   2: (minX, minY + chamfer_leg, height_Z)  // top back-left
    //   3: (minX + chamfer_leg, minY + chamfer_leg, height_Z)  // top back-left (top corner)
    //   4: (minX, minY, height_Z)     // top corner (same as point3 but at Z=height_Z)

    // But actually, we can define it as a pyramid with apex at (minX, minY, 0) and base at Z = height_Z

    // Calculate min X and Y for the A1 corner
    minX = -length_X / 2;
    minY = -width_Y / 2;

    // Define the 5 points of the chamfer pyramid:
    points = [
        [minX, minY, 0],                    // 0: apex (bottom corner)
        [minX + chamfer_leg, minY, height_Z], // 1: top front-left
        [minX, minY + chamfer_leg, height_Z], // 2: top back-left
        [minX + chamfer_leg, minY + chamfer_leg, height_Z], // 3: top back-left (top corner)
        [minX, minY, height_Z]               // 4: top corner (same as point3 but at Z=height_Z)
    ];

    // Define the faces (polyhedron faces):
    // Face 0: base (top face) - points 1, 3, 2, 4 (in order)
    // Face 1: front face - points 0, 1, 3, 4
    // Face 2: left face - points 0, 4, 2, 3
    // Face 3: back face - points 0, 2, 3, 1
    // Face 4: right face - points 0, 1, 4, 2

    // Actually, let's define it properly:
    // The pyramid has:
    //   - 4 triangular faces from apex to each edge of the base
    //   - 1 square base

    // Faces:
    //   0: base (top face) - 1, 3, 2, 4 (but 4 is same as 3 in X,Y, so we need to adjust)

    // Let's redefine the points:
    //   0: (minX, minY, 0)           // apex
    //   1: (minX + chamfer_leg, minY, height_Z)  // front-left top
    //   2: (minX, minY + chamfer_leg, height_Z)  // back-left top
    //   3: (minX + chamfer_leg, minY + chamfer_leg, height_Z)  // back-left top (top corner)
    //   4: (minX, minY, height_Z)     // top corner (same as (minX, minY, height_Z))

    // But (minX, minY, height_Z) is not in the base, so we don't need it

    // Correct: the base is a square at Z = height_Z:
    //   P1: (minX, minY, height_Z)
    //   P2: (minX + chamfer_leg, minY, height_Z)
    //   P3: (minX + chamfer_leg, minY + chamfer_leg, height_Z)
    //   P4: (minX, minY + chamfer_leg, height_Z)

    // Apex: (minX, minY, 0)

    // So define points:
    points = [
        [minX, minY, 0],                    // 0: apex
        [minX, minY, height_Z],             // 1: top front-left (same as A1 corner at top)
        [minX + chamfer_leg, minY, height_Z], // 2: top front-right
        [minX + chamfer_leg, minY + chamfer_leg, height_Z], // 3: top back-right
        [minX, minY + chamfer_leg, height_Z]  // 4: top back-left
    ];

    // Faces:
    //   Face 0: base (top face) - 1, 2, 3, 4 (in order)
    //   Face 1: front face - 0, 1, 2
    //   Face 2: right face - 0, 2, 3
    //   Face 3: back face - 0, 3, 4
    //   Face 4: left face - 0, 4, 1

    // But this is not correct for a pyramid

    // Correct: the pyramid has:
    //   - 4 triangular faces from apex to each edge of the base
    //   - 1 square base

    // So:
    //   Face 0: base - 1, 2, 3, 4 (in order)
    //   Face 1: apex to edge 1-2 - 0, 1, 2
    //   Face 2: apex to edge 2-3 - 0, 2, 3
    //   Face 3: apex to edge 3-4 - 0, 3, 4
    //   Face 4: apex to edge 4-1 - 0, 4, 1

    // But this would be a pyramid with a square base and apex at bottom

    // However, the chamfer is not a pyramid from apex to base, but a bevel that removes a pyramid from the corner

    // We'll use a different method: use a cube that is cut at 45 degrees

    // Alternative: use a cube that is rotated 45 degrees in both X and Y

    // We'll use a cube that is chamfer_leg * 2 in X and Y, and height_Z in Z
    // Then rotate it around the apex to cut the chamfer

    // But simplest: use a difference with a cube that is large enough and rotated