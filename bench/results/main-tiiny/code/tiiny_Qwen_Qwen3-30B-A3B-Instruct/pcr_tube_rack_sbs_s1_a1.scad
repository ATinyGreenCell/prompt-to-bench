// Dimensions for 96-well PCR tube rack (ANSI/SLAS footprint)
$fn = 64;

// Overall dimensions
length_X = 127.76;   // Length along X axis (12 columns)
width_Y = 85.48;        // Width along Y axis (8 rows)
height_Z = 20.0;       // Total height

// Hole parameters
hole_diameter = 6.2;           // Diameter of each through-hole
hole_spacing_X = 9.0;        // Center-to-center spacing along X (columns)
hole_spacing_Y = 9.0;          // Center-to-center spacing along Y (rows)
num_cols = 12;                 // Number of columns (along X)
num_rows = 8;                  // Number of rows (along Y)

// Position of first hole (A1) from left and back edges
offset_X = 14.38;              // From left edge (X)
offset_Y = 11.24;               // From back edge (Y)

// Chamfer parameters (45-degree chamfer at A1 corner)
chamfer_leg = 5.0;             // Length of each leg of the chamfer (in X and Y)
chamfer_angle = 45;            // 45-degree chamfer

// Calculate the origin of the block (centered on origin)
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
    // But actually, for a 45-degree chamfer, the side faces are at 45 degrees, so the horizontal extent at height Z is Z * tan(45) = Z

    // Since chamfer_leg = 5.0 and height_Z = 20.0, we need to ensure the chamfer fits
    // But we want a chamfer that extends 5 mm in both X and Y at the top (Z = height_Z)

    // So the chamfer pyramid has:
    //   Apex: (minX, minY, 0)
    //   Base: a square at Z = height_Z, from X = minX to minX + chamfer_leg, Y = minY to minY + chamfer_leg

    // We'll define the chamfer as a hull of 5 points:
    //   P1: (minX, minY, 0)           // apex (bottom corner)
    //   P2: (minX + chamfer_leg, minY, height_Z)  // top front-left
    //   P3: (minX, minY + chamfer_leg, height_Z)  // top back-left
    //   P4: (minX + chamfer_leg, minY + chamfer_leg, height_Z)  // top back-left (top corner)
    //   P5: (minX, minY, height_Z)  // top corner (same as P4 in X,Y but at Z=height_Z)

    // Actually, we can define it as a pyramid with a square base at Z = height_Z and apex at (minX, minY, 0)

    // Calculate min X and Y for the A1 corner
    minX = -length_X / 2;
    minY = -width_Y / 2;

    // Define the 5 points of the chamfer pyramid:
    point1 = [minX, minY, 0];                    // apex at bottom
    point2 = [minX + chamfer_leg, minY, height_Z];  // top front-left
    point3 = [minX, minY + chamfer_leg, height_Z]; // top back-left
    point4 = [minX + chamfer_leg, minY + chamfer_leg, height_Z]; // top back-left (top corner)
    point5 = [minX, minY, height_Z];        // top corner (same as point4 but at Z=height_Z)

    // Use hull to create a pyramid from the apex to the top base
    // But hull only takes two points at a time, so we need to use multiple hulls or a different method

    // Alternative: use a cube that is rotated and scaled to form the chamfer
    // We'll use a difference with a pyramid defined by a hull of the base and apex

    // Create a pyramid using hull of the apex and the base square
    // First, define the base square (at Z = height_Z)
    base_points = [
        [minX, minY, height_Z],
        [minX + chamfer_leg, minY, height_Z],
        [minX + chamfer_leg, minY + chamfer_leg, height_Z],
        [minX, minY + chamfer_leg, height_Z]
    ];

    // Create a pyramid by taking hull of apex and each base point
    // But we can't do that directly. Instead, we can use a polyhedron

    // Use polyhedron to define the chamfer pyramid (5 faces: 4 triangles and 1 base)
    // But simpler: use a cube that is cut at 45 degrees

    // Alternative: use a cube that is rotated 45 degrees in both X and Y, but that's complex

    // Best: use a difference with a rectangular prism that is offset and rotated

    // Actually, we can use a cube that is large enough and rotate it to cut the chamfer

    // We'll use a cube that is chamfer_leg * 2 in X and Y, and height_Z in Z
    // Then rotate it around the apex to cut the chamfer

    // But simpler: use a single cube that is cut at 45 degrees

    // We'll define a chamfer solid as a rectangular prism that is:
    //   X: from minX to minX + chamfer_leg
    //   Y: from minY to minY + chamfer_leg
    //   Z: from 0 to height_Z
    // But this is a rectangular prism, not a chamfer

    // We want a 45-degree bevel, so the cut is a plane: X - minX = Z * tan(45) = Z
    // and Y - minY = Z * tan(45) = Z

    // So the chamfer is the region where:
    //   X >= minX and Y >= minY and Z >= 0 and X - minX <= Z and Y - minY <= Z

    // But we can't do that in OpenSCAD easily

    // Instead, we'll use a cube that is rotated 45 degrees in XZ and YZ planes

    // Let's use a different approach: create a chamfer by removing a pyramid using hull

    // Define the chamfer as a polyhedron with 5 vertices:
    //   0: (minX, minY, 0)
    //   1: (minX + chamfer_leg, minY, height_Z)
    //   2: (minX, minY + chamfer_leg, height_Z)
    //   3: (minX + chamfer_leg, minY + chamfer_leg, height_Z)
    //   4: (minX, minY, height_Z)

    // Faces:
    //   Face 0: 0, 1, 3, 2  (top face)
    //   Face 1: 0, 1, 4     (front face)
    //   Face 2: 0, 2, 4     (left face)
    //   Face 3: 1, 3, 4     (back face)
    //   Face 4: 2, 3, 4     (right face)

    // But that's not correct

    // Correct: the chamfer pyramid has:
    //   Apex: 0: (minX, minY, 0)
    //   Base: 1: (minX + chamfer_leg, minY, height_Z)
    //         2: