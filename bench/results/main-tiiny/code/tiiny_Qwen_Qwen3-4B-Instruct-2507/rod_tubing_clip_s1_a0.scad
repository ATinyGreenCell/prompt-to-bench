// Dimensions in millimeters
$fn = 64;

// Rod ring: 12.7 mm inner diameter, 3 mm wall => 18.7 mm outer diameter
rod_ring_inner_d = 12.7;
rod_ring_wall = 3.0;
rod_ring_outer_d = rod_ring_inner_d + 2 * rod_ring_wall;

// Tubing ring: 6 mm inner diameter, 2 mm wall => 8 mm outer diameter
tubing_ring_inner_d = 6.0;
tubing_ring_wall = 2.0;
tubing_ring_outer_d = tubing_ring_inner_d + 2 * tubing_ring_wall;

// Opening widths
rod_opening_width = 10.0;
tubing_opening_width = 4.5;

// Bridge dimensions
bridge_width = 6.0;
bridge_x_start = 8.0;
bridge_x_end = 12.0;

// Height of the clip (Z direction)
clip_height = 10.0;

// Create the rod ring (centered at origin)
rod_ring = cube([rod_ring_outer_d, 20, clip_height], center=true);
// Cut out the opening on the -X side (x < 0, y between -5 and 5)
rod_opening = cube([rod_ring_outer_d, 10, clip_height], center=true);
rod_opening = translate([0, 0, 0]) cube([rod_ring_outer_d, 10, clip_height], center=true);
// Actually, we need to cut out a rectangular region on the left side
// Define the opening as a rectangle at x < 0, y in [-5, 5]
rod_ring = difference() {
    cube([rod_ring_outer_d, 20, clip_height], center=true);
    cube([rod_ring_outer_d, 10, clip_height], center=true, center=true);
    // Actually, we need to subtract a rectangle at x < 0, y in [-5, 5]
    // So we create a solid and subtract a rectangle
    cube([rod_ring_outer_d, 20, clip_height], center=true);
    cube([rod_ring_outer_d, 10, clip_height], center=true);
    // Instead, build the ring and cut the opening
    // First, build the full ring
    cube([rod_ring_outer_d, 20, clip_height], center=true);
    // Then subtract the opening on the left
    cube([rod_ring_outer_d, 10, clip_height], center=true);
    // But we need to place the opening at x < 0, y in [-5, 5]
    // So we subtract a rectangle at x < 0, y in [-5, 5]
    // We do this with a difference
    // Start with the full ring
    cube([rod_ring_outer_d, 20, clip_height], center=true);
    // Subtract a rectangle at x < 0, y in [-5, 5], full height
    cube([rod_ring_outer_d, 10, clip_height], center=true);
    // Actually, we need to define the opening as a separate solid
    // We will build the ring and subtract the opening
    // The opening is from x = -rod_ring_outer_d/2 to x = 0, y = -5 to 5
    // So we subtract a rectangle at x < 0, y in [-5, 5]
    // We do this with difference
    // First, build the ring
    cube([rod_ring_outer_d, 20, clip_height], center=true);
    // Then subtract a rectangle at x < 0, y in [-5, 5]
    // The rectangle has width = rod_ring_outer_d/2, height = 10
    // But only for x < 0
    // So we create a rectangle at x < 0, y in [-5, 5], z in [0, clip_height]
    // We place it at x from -rod_ring_outer_d/2 to 0, y from -5 to 5
    // So we subtract a cube at x in [-rod_ring_outer_d/2, 0], y in [-5, 5], z in [0, clip_height]
    // But we need to do it in difference
    // So:
    // 1. Full ring
    // 2. Subtract a rectangle on the left
    // We define the opening as a cube at x < 0, y in [-5,5]
    // The opening is 10 mm wide in y, 10 mm in z, and from x = -rod_ring_outer_d/2 to 0
    // So we subtract a cube of size [rod_ring_outer_d/2, 10, clip_height] at x = 0 to x = -rod_ring_outer_d/2
    // But we need to place it at x < 0
    // So we translate it to x = -rod_ring_outer_d/2
    // Actually, we place the rectangle at x from -rod_ring_outer_d/2 to 0, y from -5 to 5
    // So we define it as:
    //   translate([ -rod_ring_outer_d/2, 0, 0 ]) cube([rod_ring_outer_d/2, 10, clip_height])
    // But we need to subtract it from the ring
    // So:
    rod_ring = cube([rod_ring_outer_d, 20, clip_height], center=true);
    rod_ring = difference(rod_ring, cube([rod_ring_outer_d/2, 10, clip_height], center=true));
    // But that would cut from center, not from left
    // Actually, we need to place the opening at x < 0, so we place the cube at x = -rod_ring_outer_d/2
    // So we do:
    //   rod_ring = cube([rod_ring_outer_d, 20, clip_height], center=true);
    //   rod_ring = difference(rod_ring, translate([ -rod_ring_outer_d/2, 0, 0 ]) cube([rod_ring_outer_d/2, 10, clip_height]));
    // But that would cut from the left, yes.
    // But we need to cut only the part where x < 0, y in [-5,5]
    // So we define the opening as a cube at x in [-rod_ring_outer_d/2, 0], y in [-5,5], z in [0,clip_height]
    // So we do:
    rod_ring = cube([rod_ring_outer_d, 20, clip_height], center=true);
    rod_ring = difference(rod_ring, translate([ -rod_ring_outer_d/2, 0, 0 ]) cube([rod_ring_outer_d/2, 10, clip_height]));
    // But this cuts a rectangle at the left, which is correct.
    // However, the ring is centered at origin, and we are cutting from x = -rod_ring_outer_d/2 to 0.
    // That is correct.
    // But we need to define it properly.
    // Let's restart the construction.
};

// Better: build the rod ring as a full ring, then subtract the opening
// Full rod ring: centered at origin, diameter 18.7 mm
rod_ring = cube([rod_ring_outer_d, 20, clip_height], center=true);
// Subtract a rectangle on the left: x < 0, y in [-5,5], z in [0,clip_height]
// The rectangle has width = rod_ring_outer_d/2, height = 10, depth = clip_height
// Place it at x = -rod_ring_outer_d/2
rod_ring = difference(rod_ring, translate([ -rod_ring_outer_d/2, 0, 0 ]) cube([rod_ring_outer_d/2, 10, clip_height]));

// Tubing ring: centered at (15, 0), diameter 8 mm (outer)
tubing_ring = cube([tubing_ring_outer_d, 20, clip_height], center=true);
// Translate to (15, 0)
tubing_ring = translate([15, 0, 0]) cube([tubing_ring_outer_d, 20, clip_height]);
// Cut out a 4.5 mm wide opening on the +X side (x > 15, y in [-2.25, 2.25])
// So we subtract a rectangle at x > 15, y in [-2.25, 2.25], z in [0, clip_height]
// The rectangle has width = 4.5 mm (x from 15 to 15+4.5), height = 4.5 mm (y from -2.25 to 2.25)
// So we subtract a cube at x in [15, 15+4.5], y in [-2.25, 2.25], z in [0, clip_height]
tubing_ring = difference(tubing_ring, translate([15, 0, 0]) cube([4.5, 4.5, clip_height]));

// Bridge: 6 mm wide in Y, between x=8 and x=12
bridge = cube([6, 6, clip_height], center=true);
bridge = translate([10, 0, 0]) cube([6