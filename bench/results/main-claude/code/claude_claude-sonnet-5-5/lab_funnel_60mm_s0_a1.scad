// Lab funnel, printed upright (wide opening at top), open at both ends

$fn = 180;

spout_od     = 10;    // spout outer diameter
spout_h      = 20;    // spout height (z = 0 to 20)
rim_od       = 60;    // outer diameter at the rim
cone_top_z   = 50;    // z of the rim
wall         = 1.6;   // wall thickness, measured in horizontal cross-section (same in spout and cone)

// derived values
spout_or     = spout_od / 2;          // 5 mm outer spout radius
spout_ir     = spout_or - wall;       // 3.4 mm bore radius (6.8 mm bore diameter)
rim_or       = rim_od / 2;            // 30 mm outer rim radius
rim_ir       = rim_or - wall;         // 28.4 mm inner rim radius

// The inner cone runs parallel to the outer cone, offset by the wall
// thickness in every horizontal slice, so it starts at the bore radius at z = 20.
rotate_extrude(convexity = 10)
    polygon([
        [spout_or, 0],
        [spout_or, spout_h],
        [rim_or,   cone_top_z],
        [rim_ir,   cone_top_z],
        [spout_ir, spout_h],
        [spout_ir, 0]
    ]);