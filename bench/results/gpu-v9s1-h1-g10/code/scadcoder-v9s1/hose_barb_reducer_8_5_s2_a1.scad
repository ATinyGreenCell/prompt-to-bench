// Hose-barb reducer: 8 mm ID tubing to 5 mm ID tubing
// Print orientation: standing upright along +Z, centred on origin in X/Y

// ---------------- Parameters ----------------
reducer_d      = 12;   // collar diameter (z = 20 to 25)
bore_d         = 3;    // central through-bore diameter
eps            = 0.5;  // overcut for clean differences

// 8 mm tubing barbs: z = 0 to 20
nb_8            = 2;   // number of barbs
hb_8            = 10;  // barb height
od_8_bottom     = 7.5; // outer diameter at bottom of barbs
od_8_top        = 9.5; // outer diameter at top of barbs

// 5 mm tubing barbs: z = 25 to 41
nb_5            = 2;   // number of barbs
hb_5            = 8;   // barb height
od_5_bottom     = 6.5; // outer diameter at bottom of barbs
od_5_top        = 5.0; // outer diameter at top of barbs

// ---------------- Derived ----------------
function f8(z) = z < 10 ? od_8_bottom + (od_8_top - od_8_bottom) * z / 10 :
                   z > 10 ? od_8_bottom :
                   reducer_d;   // overlap into collar for a solid union
function f5(z) = z < 34.5 ? od_5_bottom :
                   z > 34.5 ? od_5_bottom + (od_5_top - od_5_bottom) * (z - 34.5) / 8 :
                   reducer_d;   // overlap into collar for a solid union

// ---------------- Model ----------------
union() {
    // 8 mm barbs
    for (i = [0 : nb_8 - 1])
        translate([0, 0, i * hb_8])
            cylinder(h = hb_8 + 0.01, r = f8(z = (i * hb_8 + hb_8 / 2)));

    // Collar
    translate([0, 0, 20])
        cylinder(h = 5, d = reducer_d);

    // 5 mm barbs
    for (i = [0 : nb_5 - 1])
        translate([0, 0, 25 + i * hb_5])
            cylinder(h = hb_5 + 0.01, r = f5(z = (25 + i * hb_5 + hb_5 / 2)));

    // Through-bore
    translate([0, 0, -eps])
        cylinder(h = 41 + 2 * eps, d = bore_d);
}