// Flat tensile test specimen (dog bone), printed flat on the bed
// All dimensions in mm

thickness     = 4;    // specimen thickness (Z)
total_length  = 130;  // overall length (X)
gauge_width   = 8;    // width of narrow gauge section (Y)
gauge_length  = 40;   // length of gauge section (X)
grip_width    = 19;   // width of grip sections (Y)
grip_length   = 30;   // length of each grip section (X)
trans_length  = 15;   // length of each linear transition (X)

// Derived half-dimensions
hg = gauge_length / 2;                 // half gauge length (20)
ht = hg + trans_length;                // end of transition from centre (35)
hl = ht + grip_length;                 // half total length (65) = total_length/2
wg = gauge_width / 2;                  // half gauge width
ww = grip_width / 2;                   // half grip width

// Check that the section lengths add up to the total length
assert(abs(2 * hl - total_length) < 1e-6, "Section lengths do not sum to total length");

linear_extrude(height = thickness)
    polygon(points = [
        [-hl, -ww], [-ht, -ww], [-hg, -wg], [ hg, -wg], [ ht, -ww], [ hl, -ww],
        [ hl,  ww], [ ht,  ww], [ hg,  wg], [-hg,  wg], [-ht,  ww], [-hl,  ww]
    ]);
