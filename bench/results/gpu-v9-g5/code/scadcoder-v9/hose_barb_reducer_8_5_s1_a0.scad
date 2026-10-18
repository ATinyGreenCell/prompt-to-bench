// Straight hose-barb reducer: 8 mm ID tubing end (z = 0..20) to 5 mm ID tubing end (z = 25..41)
// Print orientation: standing upright along +Z, centred on the Z axis.

$fn = 96;

// ---------------- Dimensions (mm) ----------------
t20      = 20;    // height of the 8 mm tubing barbs
t5       = 25;    // height of the 5 mm tubing barbs (z = 25..41)
tcoll    = 5;     // height of the cylindrical collar (z = 20..25)

d20_bot  = 7.5;   // barb outer diameter at the bottom of each section
d20_top  = 9.5;   // barb outer diameter at the top of the 8 mm section
d5_bot   = 6.5;   // barb outer diameter at the bottom of each section
d5_top   = 5.0;   // barb outer diameter at the top of the 5 mm section

overlap  = 0.5;   // overlap between stacked barbs and between barbs/collar
eps      = 0.5;   // cutter overshoot past faces

// Derived
d20_avg = (d20_bot + d20_top) / 2;   // 8.5 mm
d5_avg  = (d5_bot  + d5_top)  / 2;   // 5.75 mm

// ---------------- Model ----------------
union() {
    // 8 mm tubing end: two stacked barbs with a sawtooth profile
    for (i = [0, 1]) {
        translate([0, 0, i * t20 - (i - 1) * overlap])
            hull() {
                cylinder(d = d20_bot, h = t20 + overlap);   // bottom (7.5 mm)
                cylinder(d = d20_top, h = overlap);          // top step (9.5 mm)
                translate([0, 0, t20])
                    cylinder(d = d20_bot, h = overlap);      // step back down (7.5 mm)
            }
    }

    // Cylindrical collar joining the two ends
    translate([0, 0, t20 - overlap])
        cylinder(d = 12, h = tcoll + overlap);

    // 5 mm tubing end: two stacked barbs with a shrinking profile
    for (i = [0, 1]) {
        translate([0, 0, t5 + i * t5 - (i - 1) * overlap])
            hull() {
                cylinder(d = d5_bot, h = t5 + overlap);       // bottom (6.5 mm)
                cylinder(d = d5_top, h = overlap);            // top (5.0 mm)
                translate([0, 0, t5 + overlap])
                    cylinder(d = d5_bot, h = overlap);        // step back out (6.5 mm)
            }
    }
}

// ---------------- Bore ----------------
// 3 mm through-bore along Z, clean with a final overshoot cut
difference() {
    model() = self();
    translate([0, 0, -eps])
        cylinder(d = 3, h = t20 + t5 + tcoll + 2 * eps);
}