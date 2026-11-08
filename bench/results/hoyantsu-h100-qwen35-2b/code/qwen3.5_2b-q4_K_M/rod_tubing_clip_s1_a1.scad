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
    radius = 6.35, 
    height = 10, 
    center_x = 0, 
    center_y = 0
);

// Cutout for Rod Ring: -X side, -5 < y < 5
// We use polygon to cut a rectangular hole.
cutout_rect = polygon([
    [-18.7, -5], // Bottom Left
    [0, -5],     // Top Left (Center line)
    [0, 5],      // Top Right (Center line)
    [-18.7, 5]   // Bottom Right
]);

// The cutout shape is the difference between the full ring and the hole rectangle.
rod_ring = difference(
    rod_profile, 
    cutout_rect
);

// --- Geometry Definitions ---

// 2. Tubing Ring Profile
// Centered at x=15, y=0.
// Wall thickness = 2mm -> Radius = 3mm. Inner Diameter = 6mm -> Radius = 3mm.
// Outer Diameter = 10mm -> Radius = 5mm.
// Extrusion height Z = 10mm.

tubing_profile = cylinder(
    radius = 3, 
    height = 10, 
    center_x = 15, 
    center_y = 0
);

// Cutout for Tubing Ring: +X side, -2.25 < y < 2.25
cutout_tubing_rect = polygon([
    [18.7, -2.25], // Bottom Left
    [30, -2.25],   // Top Left (Center line)
    [30, 2.25],    // Top Right (Center line)
    [18.7, 2.25]   // Bottom Right
]);

tubing_ring = difference(
    tubing_profile, 
    cutout_tubing_rect
);

// --- Geometry Definitions ---

// 3. Solid Bridge
// Connects the two rings at x=8 to x=12 (Y dimension).
bridge_rect = polygon([
    [8, -5],     // Bottom Left (Rod ring edge)
    [12, -5],    // Top Left (Rod ring edge)
    [12, 5],     // Top Right (Tubing ring edge)
    [8, 5]       // Bottom Right (Tubing ring edge)
]);

// Extrude the bridge up. 
bridge_extrusion = linear_extrude(
    height = 10,   // From z=0 to z=10
    center_x = 10, // Midpoint of the bridge (8+12)/2
    center_y = 5,  // Midpoint of the bridge ( -5 + 5 ) / 2
    center_z = 5   // Centered on average height
);

// --- Final Assembly ---

clip = union(
    rod_ring, 
    bridge_extrusion
);

print("Design complete: snap-on clip.");