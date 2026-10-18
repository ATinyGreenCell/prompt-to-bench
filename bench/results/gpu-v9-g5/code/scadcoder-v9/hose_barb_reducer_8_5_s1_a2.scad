// Hose-barb reducer: 8 mm tubing end with two stacked barbs, 5 mm tubing end with two stacked barbs,
// and a cylindrical collar joining them. 3 mm through-bore.
// Print orientation: standing upright along Z (z = 0 at bottom).

$fn = 96;

// ---- 8 mm tubing barbs ----
t20      = 20;   // height of 8 mm barbs (z = 0 .. 20)
d20_bot  = 7.5;  // outer diameter at bottom of barbs
d20_top  = 9.5;  // outer diameter at top of barbs

// ---- 5 mm tubing barbs ----
t5       = 16;   // height of 5 mm barbs (z = 25 .. 41)
d5_bot   = 6.5;  // outer diameter at bottom of 5 mm barbs
d5_top   = 5.0;  // outer diameter at top of 5 mm barbs

// ---- Joining collar ----
tcoll    = 5;    // height of collar (z = 20 .. 25)
dcoll    = 12;   // outer diameter of collar

// ---- Misc ----
eps      = 0.5;  // overlap / overshoot for clean booleans
nbarbs   = 2;    // number of barbs per end (stacked)

// Barbs profile: outer diameter grows linearly from bottom to top, then steps back to bottom value.
module barb(h, d_bot, d_top) {
    hull() {
        cylinder(h = h + eps, d = d_bot);
        translate([0, 0, h])
            cylinder(h = eps, d = d_top);
        translate([0, 0, h + eps])
            cylinder(h = eps, d = d_bot);
    }
}

difference() {
    union() {
        // 8 mm end barbs
        for (i = [0 : nbarbs - 1])
            translate([0, 0, i * t20 / (nbarbs - 1 + 1)])
                barb(t20, d20_bot, d20_top);

        // 5 mm end barbs
        for (i = [0 : nbarbs - 1])
            translate([0, 0, tcoll + h5 + i * t5 / (nbarbs - 1 + 1)])
                barb(t5, d5_bot, d5_top);

        // Collar
        translate([0, 0, tcoll - eps])
            cylinder(h = tcoll + 2 * eps, d = dcoll);
    }

    // 3 mm through-bore
    translate([0, 0, -eps])
        cylinder(h = 46 + 2 * eps, d = 3);
}