// Hose-barb reducer: 8 mm tubing -> 5 mm tubing
// Print orientation: standing upright along Z

$fn = 64;

// ---- 8 mm tubing barbs (z = 0 to 20) ----
barb_h_8 = 20;      // total height of stacked barbs
barb_od_bottom_8 = 7.5;  // outer diameter at bottom of barbs
barb_od_top_8 = 9.5;   // outer diameter at top of barbs
barb_count_8 = 2;     // two identical barbs, stacked

// ---- 5 mm tubing barbs (z = 25 to 41) ----
barb_h_5 = 16;      // total height of stacked barbs (8 mm each)
barb_od_bottom_5 = 6.5;  // outer diameter at bottom of barbs
barb_od_top_5 = 5.0;   // outer diameter at top of barbs
barb_count_5 = 2;     // two identical barbs, stacked

// ---- Collar (z = 20 to 25) ----
collar_od = 12;     // outer diameter of cylindrical collar
collar_h = 5;       // height of collar

// ---- Through bore ----
bore = 3;           // diameter of bore running full length

// ---- Derived ----
barb_w = 1.5;       // wall thickness (used for step-down / step-up)
step_od_8 = barb_od_bottom_8 - barb_w;   // OD after step down from 8 mm barbs
step_od_5 = barb_od_bottom_5 + barb_w;   // OD after step up to 5 mm barbs

// Offset between stacked barbs of different types
stack_offset = 10;

module hose_barb_reducer() {
    difference() {
        union() {
            // 8 mm tubing barbs
            for (i = [0 : barb_count_8 - 1]) {
                translate([0, 0, i * stack_offset])
                    linear_extrude(height = barb_h_8)
                        circle(d = barb_od_bottom_8);
            }

            // 5 mm tubing barbs
            for (i = [0 : barb_count_5 - 1]) {
                translate([0, 0, 25 + i * stack_offset])
                    linear_extrude(height = barb_h_5)
                        circle(d = step_od_5);
            }

            // Collar
            translate([0, 0, 20])
                cylinder(d = collar_od, h = collar_h);
        }

        // Through bore
        translate([0, 0, -1])
            cylinder(d = bore, h = 42);
    }
}

hose_barb_reducer();