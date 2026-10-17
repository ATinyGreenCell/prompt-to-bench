// Hose-barb reducer: joins 8 mm ID silicone tubing to 5 mm ID silicone tubing
// Print orientation: standing upright along +Z
// Units: mm

// ---------------- Parameters ----------------
reducer_length_8mm   = 20;   // z = 0 to 20: barbs for 8 mm tubing
reducer_length_5mm   = 16;   // z = 25 to 41: barbs for 5 mm tubing (8 mm tall each, 2 stacked)
reducer_collar_length = 5;    // z = 20 to 25: cylindrical collar
reducer_bore         = 3;     // through-bore diameter

// 8 mm tubing barbs
barb_8mm_height      = 10;
barb_8mm_d0          = 7.5;   // outer diameter at bottom of barb
barb_8mm_d1          = 9.5;   // outer diameter at top of barb

// 5 mm tubing barbs
barb_5mm_height      = 8;
barb_5mm_d0          = 6.5;   // outer diameter at bottom of barb
barb_5mm_d1          = 5.0;   // outer diameter at top of barb

// ---------------- Helpers ----------------
eps = 0.5;   // overshoot for clean boolean cuts

// Sawtooth profile: diameter grows from d0 to d1 over height h, then steps back to d0
function sawtooth_d(h, d0, d1) = d0 + (d1 - d0) * z / h + eps * (d1 - d0) / h;

// ---------------- Model ----------------
difference() {
    union() {
        // 8 mm tubing barbs (z = 0 to 20)
        for (i = [0, 1])
            translate([0, 0, i * barb_8mm_height])
                linear_extrude(height = barb_8mm_height)
                    circle(r = sawtooth_d(barb_8mm_height, barb_8mm_d0, barb_8mm_d1) / 2, $fn = 64);

        // Collar (z = 20 to 25)
        translate([0, 0, reducer_length_8mm])
            cylinder(h = reducer_collar_length, r = 12 / 2, $fn = 64);

        // 5 mm tubing barbs (z = 25 to 41)
        for (i = [0, 1])
            translate([0, 0, reducer_length_8mm + reducer_collar_length + i * barb_5mm_height])
                linear_extrude(height = barb_5mm_height)
                    circle(r = sawtooth_d(barb_5mm_height, barb_5mm_d0, barb_5mm_d1) / 2, $fn = 64);
    }

    // Through-bore
    translate([0, 0, -eps])
        cylinder(h = reducer_length_8mm + reducer_collar_length + 2 * barb_5mm_height + 2 * eps,
                 r = reducer_bore / 2, $fn = 64);
}