// Hose-barb reducer: joins 8 mm ID tubing to 5 mm ID tubing
// Print orientation: standing upright along +Z
// Units: mm

// ---------------- Parameters ----------------
reducer_length_8mm   = 20;   // z = 0 to 20: barbs for 8 mm tubing
reducer_length_coll  = 5;    // z = 20 to 25: cylindrical collar
reducer_length_5mm   = 16;   // z = 25 to 41: barbs for 5 mm tubing

barb_height_8mm      = 10;   // each 8 mm barb height
barb_d_start_8mm     = 7.5;  // barb outer diameter at bottom
barb_d_top_8mm       = 9.5;  // barb outer diameter at top (before step back)

barb_height_5mm      = 8;    // each 5 mm barb height
barb_d_start_5mm     = 6.5;  // barb outer diameter at bottom
barb_d_top_5mm       = 5.0;  // barb outer diameter at top (before step back)

bore_d               = 3;    // through-bore diameter
eps                  = 0.5;  // overshoot for clean boolean cuts

$fn = 96;

// ---------------- Modules ----------------
module sawtooth_barb(h, d_start, d_top) {
    // Barb: diameter grows linearly, then steps straight back to start
    d_step = d_start;  // diameter after the step (same as bottom)
    linear_extrude(d_step)
        hull() {
            translate([0, 0, 0])
                cylinder(h = h, d1 = d_start, d2 = d_top);
            translate([0, 0, h])
                cylinder(h = eps, d1 = d_top, d2 = d_step);
        }
}

module through_bore(d) {
    translate([0, 0, -eps])
        cylinder(h = reducer_length_8mm + reducer_length_coll + reducer_length_5mm + 2*eps,
                 d = d);
}

// ---------------- Part ----------------
difference() {
    union() {
        // 8 mm tubing barbs (stacked)
        for (i = [0 : 1])
            translate([0, 0, i * barb_height_8mm])
                sawtooth_barb(barb_height_8mm, barb_d_start_8mm, barb_d_top_8mm);

        // Cylindrical collar
        translate([0, 0, reducer_length_8mm])
            cylinder(h = reducer_length_coll, d = 12);

        // 5 mm tubing barbs (stacked)
        z0 = reducer_length_8mm + reducer_length_coll;
        for (i = [0 : 1])
            translate([0, 0, z0 + i * barb_height_5mm])
                sawtooth_barb(barb_height_5mm, barb_d_start_5mm, barb_d_top_5mm);
    }

    // Central through-bore
    through_bore(bore_d);
}