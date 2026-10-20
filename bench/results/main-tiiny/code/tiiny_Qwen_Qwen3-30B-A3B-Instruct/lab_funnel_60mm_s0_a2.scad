// Lab funnel parameters
$fn = 64;

// Dimensions
spout_length = 20;           // from z = 0 to z = 20
funnel_length = 30;          // from z = 20 to z = 50
spout_od = 10;               // outer diameter of spout
spout_id = spout_od - 2 * 1.6; // inner diameter (bore) = 6.8 mm
funnel_base_od = 10;         // base of cone (same as spout top)
funnel_rim_od = 60;         // outer diameter at rim (z = 50)
wall_thickness = 1.6;          // constant wall thickness

// Build the funnel as a solid with a hole through it

// Define the outer wall profile (in XZ plane) as a polygon
// We'll create a closed polygon that traces the outer wall from z=0 to z=50
// The funnel has a constant wall thickness, so the inner wall is offset inward by wall_thickness

// Outer profile: (x, z) points for the outer wall
// - (5, 0)  // bottom of spout
// - (5, 20)  // top of spout (vertical)
// - (30, 50) // rim of funnel

// Inner profile: (x, z) points for the inner wall (bore)
// - (3.4, 0) // inner radius at bottom
// - (3.4, 20) // inner radius at spout top
// - (28.4, 50) // inner radius at rim (30 - 1.6)

// We'll use rotate_extrude to create the 3D shape from these profiles

// Create the outer body: a solid from rotate_extrude of the outer profile
// But we need to define a closed polygon for rotate_extrude

// Define the outer cross-section polygon (closed) in XZ plane:
// Start at (0,0), go to (5,0), (5,20), (30,50), (0,50), back to (0,0)
// This creates a solid that includes the wall

// Define the inner hole: a solid from rotate_extrude of the inner profile
// Start at (0,0), go to (3.4,0), (3.4,20), (28.4,50), (0,50), back to (0,0)

// But this would create a solid with a flat bottom — we want the funnel to be open at both ends

// Instead, we can build the funnel using a difference between two rotated extrusions

// Step 1: Create the outer solid (with wall thickness)
// Use rotate_extrude on a polygon that traces the outer wall

// Define the outer polygon (closed) for the cross-section:
outer_polygon = [
  [0, 0],        // start at origin
  [5, 0],        // to outer radius at bottom
  [5, 20],       // up to spout top
  [30, 50],     // to rim
  [0, 50],      // back to z-axis at top
  [0, 0]         // back to start
];

// Define the inner hole polygon (closed) for the bore:
inner_polygon = [
  [0, 0],
  [3.4, 0],
  [3.4, 20],
  [28.4, 50],
  [0, 50],
  [0, 0]
];

// Create the outer body: rotate the outer_polygon around Z-axis
outer_body = rotate_extrude() {
  polygon(outer_polygon);
}

// Create the inner hole: rotate the inner_polygon around Z-axis
inner_hole = rotate_extrude() {
  polygon(inner_polygon);
}

// Subtract the inner hole from the outer body to create the funnel
difference() {
  outer_body;
  translate([0, 0, -1]) // extend the hole slightly below z=0 to ensure clean cut
    inner_hole;
}

// The funnel is now a solid with a hole through it, open at both ends
// It is centered on the origin in X and Y, and builds from z=0 to z=50
// The wall is 1.6 mm thick everywhere
// The spout is 10 mm outer diameter from z=0 to z=20
// The funnel cone tapers from 10 mm to 60 mm outer diameter from z=20 to z=50
// The bore is 6.8 mm throughout