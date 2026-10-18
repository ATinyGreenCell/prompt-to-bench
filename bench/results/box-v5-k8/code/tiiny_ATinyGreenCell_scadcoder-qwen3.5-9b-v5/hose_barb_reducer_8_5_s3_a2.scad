// Tubing barb reducer - joins two silicone tubing sizes
// Print orientation: standing upright along +Z

// ---------------- Parameters ----------------
reducer_length   = 41;   // total length of the part (mm)
bore_d           = 3;    // through-bore diameter (mm)

barb_8_base_d    = 7.5;  // outer diameter of 8 mm tubing barbs at bottom (mm)
barb_8_top_d     = 9.5;  // outer diameter of 8 mm tubing barbs at top (mm)
barb_8_height    = 10;   // height of each 8 mm barb (mm)
barb_8_count     = 2;    // number of stacked 8 mm barbs (mm)
barb_8_overlap   = 0.5;  // overlap between stacked barbs so the union fuses cleanly (mm)

barb_5_base_d    = 6.5;  // outer diameter of 5 mm tubing barbs at bottom (mm)
barb_5_top_d     = 5.0;  // outer diameter of 5 mm tubing barbs at top (mm)
barb_5_height    = 8;    // height of each 5 mm barb (mm)
barb_5_count     = 2;    // number of stacked 5 mm barbs (mm)
barb_5_overlap   = 0.5;  // overlap between stacked 5 mm barbs (mm)

collar_d         = 12;   // diameter of the central collar (mm)
collar_h         = 5;    // height of the central collar (mm)

eps              = 0.5;  // cutter overshoot past faces (mm)

$fn = 96;

// ---------------- Model ----------------
difference() {
    union() {
        // 8 mm tubing barbs, stacked from z = 0 to z = 20
        for (i = [0 : barb_8_count - 1]) {
            translate([0, 0, i * barb_8_height - (i > 0 ? barb_8_overlap : 0)])
                cylinder(h = barb_8_height, d1 = barb_8_base_d, d2 = barb_8_top_d);
        }

        // Central collar from z = 20 to z = 25
        translate([0, 0, 20])
            cylinder(h = collar_h, d = collar_d);

        // 5 mm tubing barbs, stacked from z = 25 to z = 41
        for (i = [0 : barb_5_count - 1]) {
            translate([0, 0, 25 + i * barb_5_height - (i > 0 ? barb_5_overlap : 0)])
                cylinder(h = barb_5_height, d1 = barb_5_base_d, d2 = barb_5_top_d);
        }
    }

    // Straight through-bore
    translate([0, 0, -eps])
        cylinder(h = reducer_length + 2 * eps, d = bore_d);
}