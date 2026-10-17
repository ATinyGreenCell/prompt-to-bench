// Small lab funnel - printed upright, wide opening at top
// Built as a single rotate_extrude of a 2D wall profile (open top and bottom)

$fn = 128;

// ---------------- Dimensions (mm) ----------------
spout_od     = 10;    // spout outer diameter
spout_h      = 20;    // spout height (z = 0 .. 20)
rim_od       = 60;    // cone outer diameter at rim
rim_z        = 50;    // rim height (top of funnel)
wall         = 1.6;   // wall thickness (normal to surface)

// ---------------- Derived values ----------------
spout_r      = spout_od / 2;                // 5.0  outer spout radius
bore_r       = spout_r - wall;              // 3.4  spout bore radius (6.8 mm bore)
rim_r        = rim_od / 2;                  // 30.0 outer rim radius
cone_h       = rim_z - spout_h;             // 30.0 cone height
cone_k       = (rim_r - spout_r) / cone_h;  // radial growth per mm of height
cone_ang     = atan(cone_k);                // cone wall angle from vertical
cone_dr      = wall / cos(cone_ang);        // horizontal offset for normal wall = 1.6
bore_r_top   = bore_r + cone_dr;            // inner radius at top of cone
// height where inner cone surface meets the spout bore
join_z       = spout_h + (bore_r_top - wall) / cone_k;

// ---------------- Wall profile (r, z) ----------------
profile = [
    [bore_r,      0],          // bottom inner edge of spout
    [spout_r,     0],          // bottom outer edge of spout
    [spout_r,     spout_h],    // top of straight spout (outer)
    [rim_r,       rim_z],      // outer rim
    [bore_r_top,  rim_z],      // inner rim
    [bore_r_top,  join_z],     // inner cone meets bore
    [spout_r - cone_dr, join_z] // outer cone meets spout (adjusted for normal wall)
];

// ---------------- Model ----------------
rotate_extrude(convexity = 4)
    polygon(points = profile);