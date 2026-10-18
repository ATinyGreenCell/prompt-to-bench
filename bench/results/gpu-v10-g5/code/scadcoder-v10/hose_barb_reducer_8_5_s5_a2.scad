// Straight hose-barb reducer: 8 mm tubing (z = 0..20) -> 5 mm tubing (z = 25..41)
// Print orientation: standing upright along +Z, centred on the origin in X/Y.
// Units: mm. Bore: 3 mm through the full length.

// ---------------- Parameters ----------------
reducer_in_d     = 8;    // inlet tubing inner diameter
reducer_out_d    = 5;    // outlet tubing inner diameter
reducer_bore_d   = 3;    // through-bore diameter
reducer_barb_n   = 2;    // number of barbs per end (stacked)
reducer_len_in   = 20;   // inlet section length (z = 0..20)
reducer_len_out  = 16;   // outlet section length (z = 25..41)
reducer_collar_d = 12;   // collar diameter (z = 20..25)
reducer_overlap  = 0.5;  // overlap/step depth so adjacent shapes fuse cleanly

$fn = 96;                // curve resolution

// ---------------- Derived ----------------
in_r      = reducer_in_d / 2;      // 4.0 mm
out_r     = reducer_out_d / 2;     // 2.5 mm
collar_r  = reducer_collar_d / 2;  // 6.0 mm

// Barb radii at the key z positions (bottom -> top)
in_b_r0   = (in_r - reducer_overlap) / 2;   // bottom of inlet barbs
in_b_r1   = in_r + reducer_overlap / 2;     // top of inlet barbs
out_b_r0  = (out_r - reducer_overlap) / 2;  // bottom of outlet barbs
out_b_r1  = out_r + reducer_overlap / 2;    // top of outlet barbs

// ---------------- Model ----------------
difference() {
    union() {
        // Inlet barbs: z = 0..20
        for (i = [0 : reducer_barb_n - 1])
            translate([0, 0, i * reducer_len_in / reducer_barb_n])
                cylinder(h = reducer_len_in / reducer_barb_n,
                           r1 = in_b_r0, r2 = in_b_r1);

        // Collar: z = 20..25
        translate([0, 0, reducer_len_in])
            cylinder(h = reducer_collar_d, r = collar_r);

        // Outlet barbs: z = 25..41
        for (i = [0 : reducer_barb_n - 1])
            translate([0, 0, reducer_len_in + reducer_overlap + i * reducer_len_out / reducer_barb_n])
                cylinder(h = reducer_len_out / reducer_barb_n,
                           r1 = out_b_r0, r2 = out_b_r1);
    }

    // Through-bore: 3 mm diameter, full length (extends past top and bottom faces)
    translate([0, 0, -1])
        cylinder(h = reducer_len_in + reducer_collar_d + reducer_len_out + 2, d = reducer_bore_d);
}