// Flat tensile test specimen (dog bone)
// Print orientation: flat on bed, symmetric about origin

// ---------- Dimensions ----------
thickness     = 3;    // specimen thickness (Z)
total_length  = 120;  // overall length (X)
gauge_width   = 6;    // gauge section width (Y)
gauge_length  = 30;   // gauge section length (X)
grip_width    = 15;   // grip section width (Y)
grip_length   = 35;   // grip section length (X), each end
trans_length  = 10;   // linear transition length (X), each side

// ---------- Derived ----------
x_gauge = gauge_length / 2;            // end of gauge (15)
x_trans = x_gauge + trans_length;      // end of transition (25)
x_end   = x_trans + grip_length;       // end of grip (60)
gw2     = gauge_width / 2;
pw2     = grip_width / 2;

// Sanity check
assert(abs(2 * x_end - total_length) < 0.001, "Section lengths do not sum to total length");

// ---------- Outline (top view) ----------
outline = [
    [ x_end,   -pw2], [ x_end,    pw2],
    [ x_trans,  pw2], [ x_gauge,  gw2],
    [-x_gauge,  gw2], [-x_trans,  pw2],
    [-x_end,    pw2], [-x_end,   -pw2],
    [-x_trans, -pw2], [-x_gauge, -gw2],
    [ x_gauge, -gw2], [ x_trans, -pw2]
];

// ---------- Part ----------
linear_extrude(height = thickness)
    polygon(points = outline);
