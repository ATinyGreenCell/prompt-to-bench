// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Print orientation: standing upright on the bed, builds up +Z

// ---------- Dimensions (mm) ----------
handle_d      = 8;    // handle diameter
handle_h      = 45;   // handle length (z = 0 to 45)
cone_top_d    = 8;    // cone diameter where it meets the handle
cone_bot_d    = 3;    // cone diameter at its tip end
cone_h        = 17;   // cone height (z = 45 to 62)
tip_d         = 3;    // rounded tip diameter
tip_h         = 1.5;  // tip height above cone tip (z = 62 to 63.5)
groove_count  = 4;    // number of circumferential grip grooves
groove_w      = 2;    // groove width along Z
groove_d      = 1;    // groove depth into the handle wall
groove_z      = [10, 15, 20, 25]; // groove centre heights

// ---------- Modelling helpers ----------
eps   = 0.01;         // small overlap so cutters pass through faces
$fn   = 96;           // curve resolution

// ---------- Combined handle diameter for groove cutters ----------
// The cutter must span the full handle diameter plus the walls it removes.
max_groove_z = max(groove_z);
cutter_d    = handle_d + 2 * (groove_d + eps);

// ---------- Model ----------
union() {
    // 1. Cylindrical handle
    translate([0, 0, 0])
        cylinder(d = handle_d, h = handle_h);

    // 2. Tapered cone (8 mm at z = 45 down to 3 mm at z = 62)
    translate([0, 0, handle_h])
        cylinder(d1 = cone_top_d, d2 = cone_bot_d, h = cone_h);

    // 3. Rounded tip (sphere centred at z = 62, extends to z = 63.5)
    translate([0, 0, tip_h])
        cylinder(d = tip_d, h = tip_h + eps);
}

// 4. Grip grooves, cut through the handle only
for (z = groove_z)
    translate([0, 0, z - groove_w / 2])
        cylinder(d = cutter_d, h = groove_w + 2 * eps, $fn = 96);