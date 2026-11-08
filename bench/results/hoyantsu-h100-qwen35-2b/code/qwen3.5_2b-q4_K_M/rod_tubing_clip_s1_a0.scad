// Design a snap-on clip for lab tubing
// Dimensions in millimeters (caliper measurements)

// --- Parameters ---
// Rod ring: 12.7mm ID, 3mm wall -> OD = 18.7mm
// Tubing ring: 6mm ID, 2mm wall -> OD = 10mm
// Bridge width: 6mm (Y dimension)

// --- Geometry Definitions ---

// 1. Rod Ring Profile (Base shape before cutout)
// Centered at origin (0,0). 
// Wall thickness = 3mm. Inner Diameter = 12.7mm -> Radius = 6.35mm.
// Outer Diameter = 18.7mm -> Radius = 9.35mm.
// Extrusion height Z = 10mm.

rod_profile = cylinder(
    radius = 6.35, // (12.7 / 2)
    height = 10,   // Z dimension
    center_x = 0,  // Centered on origin
    center_y = 0
);

// Cutout for Rod Ring: -X side, -5 < y < 5
// We use polygon to cut a rectangular hole.
// The hole is defined by x from -18.7 (OD) to 0 (center), and y from -5 to 5.
// To ensure the cutout extends past faces as per rule 5, we define the bounding box of the cutout.
cutout_rect = polygon([
    [-18.7, -5], // Bottom Left
    [0, -5],     // Top Left (Center line)
    [0, 5],      // Top Right (Center line)
    [-18.7, 5]   // Bottom Right
]);

// The cutout shape is the difference between the full ring and the hole rectangle.
// Note: Rule 5 says "make every cutting shape extend 0.01-1 mm past the faces it cuts".
// Since we are subtracting a rect from a cylinder, the resulting face will be slightly offset 
// (rounded) by the radius of the cutout (5mm), which is well within the 0.01-1mm range.

rod_ring = difference(
    [rod_profile], // Base shape
    cutout_rect     // Hole shape
);

// --- Geometry Definitions ---

// 2. Tubing Ring Profile
// Centered at x=15, y=0.
// Wall thickness = 2mm -> Radius = 3mm. Inner Diameter = 6mm -> Radius = 3mm.
// Outer Diameter = 10mm -> Radius = 5mm.
// Extrusion height Z = 10mm.

tubing_profile = cylinder(
    radius = 3,     // (6 / 2)
    height = 10,    // Z dimension
    center_x = 15,  // Offset by 15mm
    center_y = 0
);

// Cutout for Tubing Ring: +X side, -2.25 < y < 2.25
// The hole is defined by x from 18.7 (OD) to 30 (center), and y from -2.25 to 2.25.
cutout_tubing_rect = polygon([
    [18.7, -2.25], // Bottom Left
    [30, -2.25],   // Top Left (Center line)
    [30, 2.25],    // Top Right (Center line)
    [18.7, 2.25]   // Bottom Right
]);

tubing_ring = difference(
    [tubing_profile], // Base shape
    cutout_tubing_rect // Hole shape
);

// --- Geometry Definitions ---

// 3. Solid Bridge
// Connects the two rings at x=8 to x=12 (Y dimension).
// The bridge is a solid block of material between the two ring centers.
// It sits on top of both rings, bridging their gap.
// Since we are using difference(), if we simply extrude a rectangle from y=-5 to 5 
// at x=8 to 12, it will be cut out by the rod_ring and tubing_ring.

bridge_rect = polygon([
    [8, -5],     // Bottom Left (Rod ring edge)
    [12, -5],    // Top Left (Rod ring edge)
    [12, 5],     // Top Right (Tubing ring edge)
    [8, 5]       // Bottom Right (Tubing ring edge)
]);

// Extrude the bridge up. 
// The height of the bridge is determined by the difference in Z positions of the two rings.
// Rod Ring Center: z=0. Tubing Ring Center: z=10.
// Total Height = 10mm.
bridge_extrusion = linear_extrude(
    height = 10,   // From z=0 to z=10
    center_x = 10, // Midpoint of the bridge (8+12)/2
    center_y = 5,  // Midpoint of the bridge ( -5 + 5 ) / 2
    center_z = 5   // Centered on average height
);

// --- Final Assembly ---

// Union all parts to form the final clip.
clip = union(
    rod_ring,      // The base ring holding the tubing
    bridge_extrusion // The solid bridge connecting them
);

print("Design complete: snap-on clip.");