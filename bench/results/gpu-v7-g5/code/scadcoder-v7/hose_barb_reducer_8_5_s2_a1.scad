// Hose-barb reducer: joins 8 mm ID silicone tubing to 5 mm ID silicone tubing
// Print orientation: standing upright along +Z
// Units: mm. A 3 mm bore runs straight through the full length.

// ---------------- Parameters ----------------
reducer_length      = 41;   // total length (z = 0 to z = 41)
bore_d              = 3;    // through-bore diameter

// Lower section (z = 0..20): barbs for 8 mm tubing
lower_section_h     = 20;   // lower section height
barb_d_start        = 7.5;  // barb outer diameter at bottom of each barb
barb_d_top          = 9.5;  // barb outer diameter at top of each barb
barb_h              = 10;   // each barb height
barb_count          = 2;    // number of stacked barbs
barb_overlap        = 0;    // vertical overlap between barbs (none)

// Collar (z = 20..25)
collar_d            = 12;   // collar diameter
collar_h            = 5;    // collar height

// Upper section (z = 25..41): barbs for 5 mm tubing
upper_section_h     = 16;   // upper section height (25 to 41)
barb_d_start_u      = 6.5;  // barb outer diameter at bottom of each upper barb
barb_d_top_u        = 5.0;  // barb outer diameter at top of each upper barb
barb_h_u            = 8;    // each upper barb height
barb_count_u        = 2;    // number of stacked upper barbs
barb_overlap_u      = 0;    // vertical overlap between upper barbs

eps                  = 0.5;  // cutter overshoot past faces

$fn = 128;

// ---------------- Helpers ----------------
// Sawtooth outer diameter along Z: grows from start to top, then steps back
function saw_d(z, d_start, d_top, h) =
    (z < h * 0.8) ? d_start + (d_top - d_start) * z / (h * 0.8) :
                   d_start + (d_top - d_start) * 0.8;

// ---------------- Model ----------------
difference() {
    union() {
        // Lower section: stacked barbs
        for (i = [0 : barb_count - 1])
            translate([0, 0, i * (barb_h + barb_overlap)])
                cylinder(h = barb_h,
                         d = saw_d([0, barb_h],
                                  barb_d_start, barb_d_top, barb_h));

        // Collar
        translate([0, 0, lower_section_h])
            cylinder(h = collar_h, d = collar_d);

        // Upper section: stacked barbs
        for (i = [0 : barb_count_u - 1])
            translate([0, 0, lower_section_h + collar_h +
                       i * (barb_h_u + barb_overlap_u)])
                cylinder(h = barb_h_u,
                         d = saw_d([0, barb_h_u],
                                  barb_d_start_u, barb_d_top_u, barb_h_u));
    }

    // Through-bore
    translate([0, 0, -eps])
        cylinder(h = reducer_length + 2 * eps, d = bore_d);
}