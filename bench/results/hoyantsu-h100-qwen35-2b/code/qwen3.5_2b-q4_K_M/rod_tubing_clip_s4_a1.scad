// Design a snap-on clip for lab tubing.
// Units: millimetres (mm).

// Define dimensions based on caliper measurements
const mm = 1; // Conversion factor if needed, though we use direct numbers in mm

// Ring 1: Rod ring
// Inner diameter: 12.7 mm -> Radius r_in = 6.35 mm
// Wall thickness: 3 mm -> Outer radius r_out = 9.35 mm
// Centred at origin (0,0)
// Opening cut out of -X side: x < 0 and -5 < y < 5

// Ring 2: Tubing ring
// Inner diameter: 6 mm -> Radius r_in = 3 mm
// Wall thickness: 2 mm -> Outer radius r_out = 5 mm
// Centred at (15, 0)
// Opening cut out of +X side: x > 15 and -2.25 < y < 2.25

// Solid bridge connecting the two rings
// Width in Y direction: 6 mm -> Radius r_bridge = 3 mm
// Centred at (8, 0) to connect Ring 1's right side to Ring 2's left side

fn = 64; // High number of slices for smooth curved surfaces and holes

// --- Build Part ---

// Create the solid body by extruding the profile in XY plane
// We will use a union of two rings (Ring1 + Ring2) plus the bridge.
// Note: The prompt asks to build the part as an extrusion of a 2D profile.
// However, simply extruding a ring creates a hollow tube. 
// To hold tubing "next to" it while snapping on, we usually need a solid block or a specific shape.
// Re-reading: "a 10 mm tall extrusion (Z) of a 2-D profile".
// This implies the part is a flat plate with thickness Z=10mm.
// To make this printable and functional as described (holding tubing), we need to ensure the geometry holds.
// A simple union of Ring1, Ring2, and Bridge creates a solid block if they touch perfectly at boundaries.

// Let's construct the profile components first.

// Component 1: Rod Ring
// Inner radius 6.35, Outer radius 9.35
// Hole in -X side (x < 0) from y=-5 to y=5
// We use polygon for the hole to ensure clean edges and correct dimensions
// To make this printable without errors, we will create a large bounding box that encompasses 
// the ring + the offset cut-out, then subtract it.

var ring1_poly = polygon([
    [0, 0],           // Center (0,0)
    [-9.35, 0],       // Left edge of outer circle (-r_out)
    [-9.35, -5],      // Bottom left corner of hole box
    [0, -5],          // Bottom center of hole box
    [0, 5],           // Top center of hole box
    [9.35, 5],        // Top right corner of hole box
    [9.35, 0]         // Right edge of outer circle (+r_out)
]);

// Create a large square that covers the entire ring area plus the offset for cutting
// The cut-out is defined by x < 0 and -5 < y < 5. 
// To subtract this cleanly from the ring, we create a bounding box around the ring + hole.
var big_square = square([
    [-9.35 - 1, 0],     // Left edge of outer circle minus epsilon (to prevent coplanar faces)
    [9.35 + 1, 0],      // Right edge of outer circle plus epsilon
    [-5 - 1, -5],       // Bottom left corner of hole box plus epsilon
    [5 + 1, 5]          // Top right corner of hole box plus epsilon
]);

// Create the polygon for the hole (cut-out)
var hole_poly = polygon([
    [0, 0],           // Center (0,0)
    [-6.35 - 1, 0],   // Left edge of inner circle minus epsilon
    [-6.35 - 1, -2.25], // Bottom left corner of hole box plus epsilon
    [0, -2.25],       // Bottom center of hole box plus epsilon
    [0, 2.25],        // Top center of hole box plus epsilon
    [6.35 + 1, 2.25], // Right edge of inner circle minus epsilon
    [6.35 + 1, 0]     // Right edge of inner circle plus epsilon
]);

// Combine ring and hole into one solid part using difference
var ring1 = union(ring1_poly, hole_poly);


// Component 2: Tubing Ring
// Inner radius 3, Outer radius 5
// Hole in +X side (x > 15) from y=-2.25 to y=2.25

var ring2_poly = polygon([
    [0, 0],           // Center (0,0)
    [-5 - 1, 0],      // Left edge of outer circle minus epsilon
    [-5 - 1, -2.25], // Bottom left corner of hole box plus epsilon
    [0, -2.25],       // Bottom center of hole box plus epsilon
    [0, 2.25],        // Top center of hole box plus epsilon
    [5 + 1, 2.25],    // Right edge of outer circle minus epsilon
    [5 + 1, 0]        // Right edge of outer circle plus epsilon
]);

// Create a large square that covers the entire ring area plus the offset for cutting
var big_square2 = square([
    [-5 - 1 - 1, 0],     // Left edge of outer circle minus epsilon minus epsilon (to prevent coplanar faces)
    [5 + 1 + 1, 0],      // Right edge of outer circle plus epsilon plus epsilon
    [-2.25 - 1, -2.25], // Bottom left corner of hole box plus epsilon plus epsilon
    [2.25 + 1, 2.25]     // Top right corner of hole box plus epsilon plus epsilon
]);

// Create the polygon for the hole (cut-out)
var hole_poly2 = polygon([
    [0, 0],           // Center (0,0)
    [-3 - 1, 0],      // Left edge of inner circle minus epsilon minus epsilon
    [-3 - 1, -1.125], // Bottom left corner of hole box plus epsilon plus epsilon
    [0, -1.125],       // Bottom center of hole box plus epsilon plus epsilon
    [0, 1.125],        // Top center of hole box plus epsilon plus epsilon
    [3 + 1, 1.125],    // Right edge of inner circle minus epsilon minus epsilon
    [3 + 1, 0]         // Right edge of inner circle plus epsilon plus epsilon
]);

// Combine ring and hole into one solid part using difference
var ring2 = union(ring2_poly, hole_poly2);


// Component 3: Solid Bridge
// Width in Y direction: 6 mm -> Radius r_bridge = 3 mm
// Centred at (8, 0) to connect Ring 1's right side to Ring 2's left side

var bridge_poly = polygon([
    [0, 0],           // Center (0,0)
    [-3 - 1, 0],      // Left edge of inner circle minus epsilon
    [-3 - 1, -1.5],   // Bottom left corner of hole box plus epsilon
    [0, -1.5],        // Bottom center of hole box plus epsilon
    [0, 1.5],         // Top center of hole box plus epsilon
    [3 + 1, 1.5],     // Right edge of inner circle minus epsilon
    [3 + 1, 0]        // Right edge of inner circle plus epsilon
]);

// Combine ring and bridge into one solid part using difference
var ring_bridge = union(ring1, bridge_poly);


// --- Assembly ---

// Create the final clip by extruding the combined profile in Z direction
var clip_height = mm; 
clip = extrude(clip_height);

// Final output
render(part); // Renders the final solid shape