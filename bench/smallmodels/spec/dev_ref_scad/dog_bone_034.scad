// Flat tensile test specimen (dog bone) for printed plastics
// Print orientation: lying flat on the bed, symmetric about the origin in X and Y

// ---------------- Dimensions (mm) ----------------
thickness      = 4;    // specimen thickness (Z)
total_length   = 140;  // overall length (X)
gauge_width    = 8;    // width of narrow gauge section (Y)
gauge_length   = 50;   // length of gauge section (X)
grip_width     = 19;   // width of grip sections (Y)
grip_length    = 35;   // length of each grip section (X)
trans_length   = 10;   // length of each linear transition (X)

// ---------------- Derived values ----------------
x_gauge = gauge_length / 2;                 // gauge ends at +/- 25
x_trans = x_gauge + trans_length;           // transition ends at +/- 35
x_end   = x_trans + grip_length;            // grip ends at +/- 70
hg      = gauge_width / 2;                  // half gauge width
hw      = grip_width / 2;                   // half grip width

// Sanity check: sections add up to total length
assert(abs(2 * x_end - total_length) < 1e-6,
       "Section lengths do not sum to total_length");

// ---------------- Model ----------------
linear_extrude(height = thickness)
    polygon(points = [
        [-x_end,   -hw],
        [-x_trans, -hw],
        [-x_gauge, -hg],
        [ x_gauge, -hg],
        [ x_trans, -hw],
        [ x_end,   -hw],
        [ x_end,    hw],
        [ x_trans,  hw],
        [ x_gauge,  hg],
        [-x_gauge,  hg],
        [-x_trans,  hw],
        [-x_end,    hw]
    ]);
