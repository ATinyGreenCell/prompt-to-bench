// Flat tensile test specimen (dog bone) for printed plastic
// Lies flat on the bed (z = 0), symmetric about the origin in X and Y.

// ---------------- Parameters ----------------
thickness      = 3;    // specimen thickness (Z)
total_length   = 130;  // overall length along X (check value)
gauge_width    = 8;    // gauge section width (Y)
gauge_length   = 30;   // gauge section length (X)
grip_width     = 15;   // grip section width (Y)
grip_length    = 35;   // grip section length (X), each end
trans_length   = 15;   // transition length (X), each side, linear taper

// ---------------- Derived values ----------------
x_gauge = gauge_length / 2;            // end of gauge section
x_trans = x_gauge + trans_length;      // end of transition / start of grip
x_end   = x_trans + grip_length;       // specimen end (= total_length/2)
hg = gauge_width / 2;                  // half gauge width
hw = grip_width / 2;                   // half grip width

// Sanity check on overall length
assert(abs(2 * x_end - total_length) < 1e-6,
       "Section lengths do not sum to total_length");

// ---------------- Outline (top view) ----------------
outline = [
    [-x_end,   -hw], [-x_trans, -hw], [-x_gauge, -hg],
    [ x_gauge, -hg], [ x_trans, -hw], [ x_end,   -hw],
    [ x_end,    hw], [ x_trans,  hw], [ x_gauge,  hg],
    [-x_gauge,  hg], [-x_trans,  hw], [-x_end,    hw]
];

// ---------------- Model ----------------
linear_extrude(height = thickness)
    polygon(points = outline);
