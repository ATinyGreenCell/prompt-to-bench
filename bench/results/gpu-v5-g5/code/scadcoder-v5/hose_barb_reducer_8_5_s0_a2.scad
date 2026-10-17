// Hose-barb reducer: joins 8 mm ID silicone tubing to 5 mm ID silicone tubing
// Print orientation: standing upright along +Z, base on XY plane
// Units: mm. Rotational symmetry about Z axis.

// ---------------- Parameters ----------------
reducer_d      = 12;   // central bore diameter (through full length)
barb8_base_d   = 7.5;  // 8 mm tubing barb outer diameter at bottom
barb8_top_d    = 9.5;  // 8 mm tubing barb outer diameter at top
barb8_height   = 10;   // 8 mm tubing barb height
barb8_pitch    = 1.5;  // vertical spacing between stacked 8 mm barbs
barb8_overlap  = 0.5;  // overlap of stacked barbs for a solid union

collar_d       = 12;   // cylindrical collar diameter (z = 20 to 25)

barb5_base_d   = 6.5;  // 5 mm tubing barb outer diameter at bottom
barb5_top_d    = 5.0;  // 5 mm tubing barb outer diameter at top
barb5_height   = 8;    // 5 mm tubing barb height
barb5_pitch    = 1.5;  // vertical spacing between stacked 5 mm barbs
barb5_overlap  = 0.5;  // overlap of stacked 5 mm barbs for a solid union

total_length   = 41;   // overall part length (z = 0 to z = 41)
eps            = 0.5;  // cutter overshoot past faces

$fn = 96;              // curve resolution

// ---------------- Derived ----------------
barb8_bottom_z = 0;
barb8_top_z    = barb8_bottom_z + barb8_height;
barb8_step_z   = barb8_top_z + barb8_pitch - barb8_overlap;  // profile steps back here
barb8_total_h  = barb8_step_z + barb5_height + barb5_pitch - barb5_overlap;

barb5_bottom_z = barb8_step_z;
barb5_top_z    = barb5_bottom_z + barb5_height;
barb5_step_z   = barb5_top_z + barb5_pitch - barb5_overlap;  // profile steps back here
barb5_total_h  = barb5_step_z + barb5_height + barb5_pitch - barb5_overlap;

// ---------------- Model ----------------
difference() {
    union() {
        // 8 mm tubing barbs (sawtooth profile)
        for (i = [0 : 1]) {
            translate([0, 0, barb8_bottom_z + i * barb8_pitch])
                linear_extrude(height = barb8_height)
                    hull() {
                        cylinder(d = barb8_base_d);
                        translate([0, 0, barb8_overlap])
                            cylinder(d = barb8_top_d);
                    }
        }

        // Cylindrical collar
        translate([0, 0, 20])
            cylinder(d = collar_d, h = 5);

        // 5 mm tubing barbs (sawtooth profile)
        for (i = [0 : 1]) {
            translate([0, 0, barb5_bottom_z + i * barb5_pitch])
                linear_extrude(height = barb5_height)
                    hull() {
                        cylinder(d = barb5_base_d);
                        translate([0, 0, barb5_overlap])
                            cylinder(d = barb5_top_d);
                    }
        }
    }

    // Central bore through full length
    translate([0, 0, -eps])
        cylinder(d = reducer_d, h = total_length + 2 * eps);
}