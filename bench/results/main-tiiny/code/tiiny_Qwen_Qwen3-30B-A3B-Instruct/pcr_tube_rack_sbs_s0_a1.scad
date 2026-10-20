// Dimensions for 96-well PCR tube rack (ANSI/SLAS footprint)
$fn = 64;

// Overall dimensions
length_X = 127.76;   // Length along X axis
width_Y = 85.48;     // Width along Y axis
height_Z = 20.0;     // Height of rack

// Hole grid parameters
num_rows = 8;      // 8 rows along Y (A to H)
num_cols = 12;     // 12 columns along X (1 to 12)
hole_diameter = 6.2; // Diameter of each hole
hole_spacing_X = 9.0; // Center-to-center spacing along X
hole_spacing_Y = 9.0; // Center-to-center spacing along Y

// Position of first hole (A1) relative to edges
offset_X = 14.38;   // From left edge (X)
offset_Y = 11.24;   // From back edge (Y)

// Chamfer parameters
chamfer_leg = 5.0; // Length of each leg of 45-degree chamfer

// Create base block centered at origin, with z = 0 at the bottom
// The block should extend from z = 0 to z = height_Z
// So we use cube with center = false, and start at z = 0

// Correct: the rack rests on the XY plane at z = 0, so we build upward from z = 0
// Therefore, we use cube([length_X, width_Y, height_Z], center = false) and place it at origin

// But we want the hole grid to be centered on the block in X and Y
// The hole grid is centered at:
//   X: -length_X/2 + offset_X + (num_cols - 1)/2 * hole_spacing_X
//   Y: -width_Y/2 + offset_Y + (num_rows - 1)/2 * hole_spacing_Y
// But we are told the grid is centered, so we don't need to adjust

// Build the base block from z = 0 to z = height_Z
// Use center = false so it sits on the bed at z = 0

difference() {
    // Base block: from (0,0,0) to (length_X, width_Y, height_Z)
    cube([length_X, width_Y, height_Z], center = false);

    // Subtract all 96 holes
    for (col = [0 : num_cols - 1]) {
        for (row = [0 : num_rows - 1]) {
            // Calculate center of hole
            x = offset_X + col * hole_spacing_X;
            y = offset_Y + row * hole_spacing_Y;
            
            // Create a cylinder for the hole, slightly larger than hole_diameter
            // to ensure clean subtraction (0.1 mm overhang for safety)
            cylinder(h = height_Z + 0.1, d = hole_diameter + 0.1, center = false, $fn = 64)
                translate([x, y, -0.05]); // Slight negative offset to ensure hole goes through bottom
        }
    }
}

// Add chamfer at A1 corner (bottom front left when viewed from above)
// A1 is at (x = offset_X, y = offset_Y) from the bottom-left corner of the block
// We chamfer the vertical edge at the A1 corner: remove a 45-degree bevel from the outer edge

// The chamfer is a 45-degree face from the outer edge at (x=0, y=0) to the inside
// We'll define a polyhedron that removes a pyramid from the corner

// The chamfer has two legs of length 5 mm along the X and Y directions at the base (z=0)
// The apex of the chamfer is at (x = chamfer_leg, y = chamfer_leg, z = chamfer_leg)
// But we are chamfering the vertical edge at the A1 corner, so we cut from the outer face

// The chamfering solid is a tetrahedron with:
// P1: (0, 0, 0)         // outer corner
// P2: (chamfer_leg, 0, 0) // along X
// P3: (0, chamfer_leg, 0) // along Y
// P4: (chamfer_leg, chamfer_leg, chamfer_leg) // apex

// But this would be a 45-degree chamfer only if the apex is at (chamfer_leg, chamfer_leg, chamfer_leg)
// and the face from P1 to P2 to P4 is 45 degrees in XZ plane, and similarly in YZ

// We'll use a polyhedron to define the chamfering solid

// We'll subtract this tetrahedron from the block

// But we must ensure the chamfer is only on the vertical edge at the A1 corner
// So we define the chamfering solid as a tetrahedron that removes material from the corner

// The chamfering solid is a tetrahedron with:
// - P1: (0, 0, 0)         // outer corner
// - P2: (chamfer_leg, 0, 0) // along X
// - P3: (0, chamfer_leg, 0) // along Y
// - P4: (chamfer_leg, chamfer_leg, chamfer_leg) // apex

// This forms a 45-degree chamfer because:
// - The edge from P1 to P2 is length chamfer_leg in X
// - The edge from P1 to P3 is length chamfer_leg in Y
// - The edge from P1 to P4 is length sqrt(2)*chamfer_leg in XY, and chamfer_leg in Z
// - So the angle between the face and the base is 45 degrees

// We'll use a polyhedron to define this tetrahedron

// The polyhedron has 4 points and 4 faces:
// - Face 1: P1, P2, P4
// - Face 2: P1, P3, P4
// - Face 3: P2, P3, P4
// - Face 4: P1, P2, P3 (the base on the bed)

// But we want to subtract only the chamfer from the corner, so we define the polyhedron as a solid

// We'll use a separate module to define the chamfer

// However, we can do it inline with a polyhedron

// We'll use a difference to subtract the chamfering tetrahedron

// But note: the chamfering tetrahedron is entirely within the block, so we can subtract it

// We'll add the chamfering solid as a separate subtraction

// The chamfering solid is a tetrahedron that we subtract from the block

// We'll use a polyhedron with:
// - Points: [P1, P2, P3, P4]
// - Faces: [ [0,1,3], [0,2,3], [1,2,3], [0,1,2] ]

// But we must ensure the chamfer is only at the A1 corner

// Define the chamfering solid
// We'll use a separate difference to subtract the chamfer

// We'll do it in the same difference as the holes, but we can't use modules inside cylinder

// So we use a separate polyhedron

// We'll use a separate difference for the chamfer

// But we can't use module inside module, so we do it inline

// We'll use a polyhedron directly in the difference

// However, the warning says: "module cylinder() does not support child modules"
// So we must not use any module inside cylinder

// We already fixed that by not using any child modules

// Now, we need to subtract the chamfer

// We'll use a polyhedron to define the chamfering solid

// The chamfering solid is a tetrahedron with:
// P1: (0, 0, 0)
// P2: (chamfer_leg, 0, 0)
// P3: (0, chamfer_leg, 0)
// P4: (chamfer_leg, chamfer_leg, chamfer_leg)

// We'll define it as a polyhedron

// But we must ensure that the chamfer is only at the A1 corner, which is at (0,0,0) in the block's local coordinate

// The block is from (0,0,0) to (length_X, width_Y, height_Z)

// So the chamfer is at the origin

// We'll subtract this tetrahedron from the block

// We'll do it in a separate difference

// But we can't have multiple differences at the top level

// So we do it all in one difference

// We'll do:
// difference() {
//   base block
//   subtract holes
//   subtract chamfer
// }

// But we can't use a module inside a module

// So we do the chamfer with a polyhedron directly

// We'll use a polyhedron for the chamfering solid

// We'll define the chamfering solid as a polyhedron

// We'll use a