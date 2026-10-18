// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube
// Print orientation: standing upright, bottom on the bed (z = 0)

// ---------------- Parameters ----------------
handle_d      = 8;    // handle diameter (mm)
handle_h      = 45;   // handle height (mm), z = 0..45
cone_top_d    = 8;    // cone top diameter at z = 45 (mm)
cone_bot_d    = 3;    // cone bottom diameter at z = 62 (mm)
cone_h        = 17;   // cone height (mm), z = 45..62
tip_r         = 3;    // rounded tip radius (mm), sphere centred at z = 62
groove_count  = 4;    // number of circumferential grooves
groove_w      = 2;    // groove width in Z (mm)
groove_d      = 1;    // groove depth (mm)
overlap       = 0.5;  // overlap between adjacent segments (mm)
eps           = 0.5;  // cutter overshoot past faces (mm)

$fn = 96;

// ---------------- Derived ----------------
groove_start = [10, 15, 20, 25];   // groove centre heights (mm)

// ---------------- Model ----------------
module pestle() {
    union() {
        // Handle with grip grooves
        translate([0, 0, 0])
            difference() {
                cylinder(d = handle_d, h = handle_h);
                for (g = groove_start)
                    translate([0, 0, g - groove_w / 2])
                        cylinder(d = handle_d + 2 * eps, h = groove_w + eps);
            }

        // Tapered cone, extended past both end faces
        translate([0, 0, 44])
            linear_extrude(height = cone_h + eps)
                circle(d = cone_top_d);
        translate([0, 0, 62 - cone_h])
            linear_extrude(height = cone_h + eps)
                circle(d = cone_bot_d);

        // Rounded tip: 3 mm diameter sphere centred at z = 62
        translate([0, 0, 62 - tip_r])
            sphere(r = tip_r);
    }
}

pestle();