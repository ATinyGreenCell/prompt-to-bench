// Hose-barb reducer: joins 8 mm ID tubing to 5 mm ID tubing
// Print orientation: standing upright along Z, centred on origin in X/Y

$fn = 96;

// ---- Dimensions (mm) ----
eps      = 0.5;         // cutter overshoot past faces
barb8_h  = 10;          // height of each 8 mm tubing barb
barb8_od_bottom = 7.5;  // outer diameter of 8 mm barb at bottom
barb8_od_top    = 9.5;  // outer diameter of 8 mm barb at top
barb5_h  = 8;           // height of each 5 mm tubing barb
barb5_od_bottom = 6.5;  // outer diameter of 5 mm barb at bottom
barb5_od_top    = 5.0;  // outer diameter of 5 mm barb at top
collar_d  = 12;         // diameter of cylindrical collar
length    = 41;         // total length of part (z = 0 to z = 41)
bore_d    = 3;          // through-bore diameter

// ---- Derived ----
barb8_step_z = 20;      // z where 8 mm barbs end and collar begins
barb5_step_z = 25;      // z where collar ends and 5 mm barbs begin

// ---- Model ----
difference() {
    union() {
        // 8 mm tubing barbs: sawtooth profile, stacked
        for (i = [0 : 1]) {
            translate([0, 0, i * barb8_h])
                linear_extrude(height = 1)
                    polygon([
                        [- barb8_od_bottom / 2, 0],
                        [ barb8_od_bottom / 2, 0],
                        [ 0, barb8_h],
                        [ - barb8_od_bottom / 2, barb8_h]
                    ]);
        }
        // collar
        translate([0, 0, barb8_step_z])
            cylinder(d = collar_d, h = 5);
        // 5 mm tubing barbs: shrinking profile, stacked
        for (i = [0 : 1]) {
            translate([0, 0, barb5_step_z + i * barb5_h])
                linear_extrude(height = 1)
                    polygon([
                        [ barb5_od_bottom / 2, 0],
                        [ - barb5_od_bottom / 2, 0],
                        [ 0, barb5_h],
                        [ - barb5_od_top / 2, barb5_h],
                        [ barb5_od_top / 2, barb5_h]
                    ]);
        }
    }
    // through-bore
    translate([0, 0, -eps])
        cylinder(d = bore_d, h = length + 2 * eps);
}