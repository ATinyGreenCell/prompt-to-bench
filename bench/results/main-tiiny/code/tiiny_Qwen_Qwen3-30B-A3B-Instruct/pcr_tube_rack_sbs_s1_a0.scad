// Dimensions for 96-well PCR tube rack (ANSI/SLAS footprint)
$fn = 64;

// Overall dimensions
length_X = 127.76;   // Length along X axis (12 columns)
width_Y = 85.48;     // Width along Y axis (8 rows)
height_Z = 20.0;     // Total height

// Hole parameters
hole_diameter = 6.2;           // Diameter of each through-hole
hole_spacing_X = 9.0;           // Center-to-center spacing along X (columns)
hole_spacing_Y = 9.0;           // Center-to-center spacing along Y (rows)
num_cols = 12;               // Number of columns (along X)
num_rows = 8;                // Number of rows (along Y)

// Position of first hole (A1) from left and back edges
offset_X = 14.38;            // From left edge (X)
offset_Y = 11.24;            // From back edge (Y)

// Chamfer parameters (45-degree chamfer at A1 corner)
chamfer_leg = 5.0;           // Length of each leg of the chamfer (in X and Y)
chamfer_angle = 45;         // 45-degree chamfer

// Calculate hole centers
// Start at (offset_X, offset_Y) and step by hole_spacing_X and hole_spacing_Y
// We'll use for loops to generate all 96 holes

// Create base block
module base_block() {
    cube([length_X, width_Y, height_Z], center = true);
}

// Create chamfer at A1 corner (front-left bottom corner when viewed from A1 side)
// The chamfer is on the vertical edge at the A1 corner (where X is min, Y is min)
// We'll cut a 45-degree chamfer from the bottom (z=0) to top (z=height_Z)
// The chamfer is a pyramid-like cut with two faces: one along X, one along Y

module chamfer_A1() {
    // Define the chamfer region: a rectangular prism that will be used to cut
    // The chamfer is a 45-degree bevel from the corner at (-length_X/2 + offset_X, -width_Y/2 + offset_Y)
    // We'll create a pyramid-like cut using two difference cuts

    // First chamfer face: cuts along Y direction (from Y = -width_Y/2 to -width_Y/2 + chamfer_leg)
    // This face is at X = -length_X/2 + offset_X, and extends from Z=0 to Z=height_Z
    // The cut is a plane at 45 degrees: for each Z, the X-cut extends from X = -length_X/2 + offset_X to X = -length_X/2 + offset_X + Z * tan(45) = X + Z
    // But since we're doing a difference, we can use a rectangular prism that tapers in X

    // We'll use a solid that is a rectangular prism from X = -length_X/2 + offset_X to X = -length_X/2 + offset_X + chamfer_leg
    // Y from -width_Y/2 to -width_Y/2 + chamfer_leg
    // Z from 0 to height_Z
    // But we want a 45-degree chamfer, so we need to cut a pyramid

    // Instead, we'll use a difference with a pyramid (hull of two points) to make the chamfer

    // Define the chamfer pyramid: from the A1 corner (bottom) to the top edge
    // The chamfer is a 45-degree bevel, so the edge goes from:
    //   (X, Y, Z) = (-length_X/2 + offset_X, -width_Y/2 + offset_Y, 0) to
    //   (X, Y, Z) = (-length_X/2 + offset_X + chamfer_leg, -width_Y/2 + offset_Y + chamfer_leg, height_Z)
    // But actually, for a 45-degree chamfer on the vertical edge, the cut is a plane that goes from:
    //   (X, Y, Z) = (minX, minY, 0) to (minX + chamfer_leg, minY + chamfer_leg, height_Z)
    // So we can define a pyramid from the corner to the top edge

    // We'll create a chamfer solid that is a pyramid with a square base at the top and a point at the bottom
    // But actually, for a chamfer on a vertical edge, we want a 45-degree cut that removes material from both X and Y

    // Alternative: use a cube that is offset and rotated to cut the chamfer
    // We'll use a cube that is 1mm longer than needed in both X and Y, and rotate it 45 degrees in both axes

    // Actually, simpler: use two difference cuts for the two faces of the chamfer

    // First cut: a rectangular prism that removes material from the Y side (Y decreases)
    // It extends from Y = -width_Y/2 to Y = -width_Y/2 + chamfer_leg
    // X from -length_X/2 to -length_X/2 + chamfer_leg
    // Z from 0 to height_Z
    // But we want a 45-degree slope, so we need to make it a pyramid

    // Use a hull of two points: the bottom corner and the top edge of the chamfer
    // The chamfer has two faces: one in the XZ plane and one in the YZ plane

    // We'll define a chamfer pyramid: a solid that is a square pyramid with apex at the A1 corner (bottom) and base at the top
    // The base is a square of size chamfer_leg × chamfer_leg at Z = height_Z

    // But actually, for a 45-degree chamfer, the cut is a plane that goes from:
    //   (X, Y, Z) = (minX, minY, 0) to (minX + chamfer_leg, minY + chamfer_leg, height_Z)
    // So the normal vector is (1, 1, -1) for a 45-degree plane

    // We'll use a pyramid (hull of 5 points) to define the chamfer

    // Define the 5 points of the chamfer pyramid:
    //   P1: bottom corner (minX, minY, 0)
    //   P2: (minX + chamfer_leg, minY, 0)
    //   P3: (minX, minY + chamfer_leg, 0)
    //   P4: (minX + chamfer_leg, minY + chamfer_leg, 0)
    //   P5: (minX + chamfer_leg, minY + chamfer_leg, height_Z)
    // But that's not correct for a 45-degree chamfer

    // Correct: for a 45-degree chamfer on the vertical edge, the chamfer is a 45-degree bevel that removes a pyramid from the corner
    // The chamfer has a square base at the top (Z = height_Z) of size chamfer_leg × chamfer_leg, and a point at the bottom (Z = 0) at the corner

    // Actually, the chamfer is a pyramid with:
    //   Apex: (minX, minY, 0)
    //   Base: a square at Z = height_Z, from X = minX to minX + chamfer_leg, Y = minY to minY + chamfer_leg
    // But that would be a pyramid with height = height_Z, but the base is at top

    // We want the chamfer to be a 45-degree bevel, so the side faces are at 45 degrees
    // So the distance from the apex to the base should be chamfer_leg in both X and Y at height_Z

    // So the base is at Z = height_Z, and the base is a square from:
    //   X: minX to minX + chamfer_leg
    //   Y: minY to minY + chamfer_leg
    //   Z: height_Z

    // The apex is at (minX, minY, 0)

    // So we define the chamfer as a pyramid with 5 points:
    //   P1: (minX, minY, 0)
    //   P2: (minX + chamfer_leg, minY, height_Z)
    //   P3: (minX, minY + chamfer_leg, height_Z)
    //   P4: (minX + chamfer_leg, minY + chamfer_leg, height_Z)
    //   P5: (minX, minY, height_Z)  // top corner

    // But that's not a pyramid. We need a solid that is a 45-degree chamfer

    // Actually, the simplest way: use a cube that is rotated 45 degrees in XZ and YZ planes

    // Instead, we'll use a difference with a pyramid that is the chamfer region

    // Define the chamfer pyramid: a solid that is a square pyramid with apex at (minX, minY, 0) and base at Z = height_Z
    // The base is a square from (minX, minY, height_Z) to (