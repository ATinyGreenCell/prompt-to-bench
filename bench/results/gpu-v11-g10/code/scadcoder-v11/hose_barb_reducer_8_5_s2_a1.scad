// Hose-barb reducer: 8 mm OD barb (z = 0..20) to 5 mm OD barb (z = 25..41)
// Print orientation: standing upright along +Z
// Units: mm

// ---------------- Parameters ----------------
bore          = 3;    // through-bore diameter (full length)

// 8 mm tubing barb (lower section)
barb_8_h      = 10;   // barb height
barb_8_od_bot = 7.5;  // outer diameter at bottom (z = 0)
barb_8_od_top = 9.5;  // outer diameter at top (z = 20)

// Collar (transition between sections)
collar_od     = 12;   // collar diameter
collar_h      = 5;    // collar height (z = 20..25)

// 5 mm tubing barb (upper section)
barb_5_h      = 8;    // barb height
barb_5_od_bot = 6.5;  // outer diameter at bottom (z = 25)
barb_5_od_top = 5.0;  // outer diameter at top (z = 41)

eps           = 0.5;  // overlap / extension for clean booleans
$fn           = 96;   // curve resolution

// ---------------- Derived ----------------
z0      = 0;                    // start of 8 mm barb
z20     = z0 + barb_8_h;        // top of 8 mm barb
z25     = z20 + collar_h;       // top of collar
z41     = z25 + barb_5_h;       // top of 5 mm barb
length  = z41 - z0;             // overall length

// ---------------- Model ----------------
difference() {
    union() {
        // 8 mm barb: sawtooth profile in XZ, extruded along Y (rotationally symmetric)
        // Profile: (r=barb_8_od_bot/2, z=0) -> (r=barb_8_od_top/2, z=20) -> (r=barb_8_od_bot/2, z=20)
        rotate([90, 0, 0])
            linear_extrude(height = barb_8_h)
                polygon(points = [
                    [-barb_8_od_bot / 2, 0],
                    [ barb_8_od_top / 2, 20],
                    [ barb_8_od_bot / 2, 20]
                ]);

        // Cylindrical collar
        translate([0, 0, z20])
            cylinder(d = collar_od, h = collar_h);

        // 5 mm barb: cone shape, then a step back out to the same diameter (zero-height flare)
        // Profile: (r=barb_5_od_bot/2, z=25) -> (r=barb_5_od_top/2, z=41) -> (r=barb_5_od_bot/2, z=41)
        rotate([90, 0, 0])
            linear_extrude(height = barb_5_h)
                polygon(points = [
                    [-barb_5_od_bot / 2, z25],
                    [ barb_5_od_top / 2, z41],
                    [ barb_5_od_bot / 2, z41]
                ]);
    }

    // Through-bore along Z
    translate([0, 0, -eps])
        cylinder(d = bore, h = length + 2 * eps);
}