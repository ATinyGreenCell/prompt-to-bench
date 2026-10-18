// Snap-on clip: holds tubing next to a 12.7 mm lab stand rod
// Print orientation: flat on bed, extruded up in +Z

// ---- Dimensions (mm) ----
rod_id     = 12.7;  // rod inner diameter
rod_wall   = 3;     // rod ring wall thickness
rod_od     = rod_id + 2 * rod_wall;   // rod ring outer diameter (18.7)

tub_id     = 6;     // tubing inner diameter
tub_wall   = 2;     // tubing ring wall thickness
tub_od     = tub_id + 2 * tub_wall;   // tubing ring outer diameter (10)

bridge_w   = 6;     // bridge width along Y
bridge_x1  = 8;     // bridge start X
bridge_x2  = 12;    // bridge end X

opening_w  = 10;    // rod ring opening width on -X side

eps        = 0.5;   // cutter overshoot past faces
$fn        = 96;    // curve resolution

// ---- 2D profile in XY ----
profile = union() {
    // Rod ring with -X opening
    difference() {
        translate([0, 0]) circle(d = rod_od);
        translate([0, -eps])
            linear_extrude(height = opening_w + 2 * eps)
                polygon([[-rod_id / 2, 0], [-rod_id / 2 - eps, 0],
                          [-rod_id / 2 - eps, opening_w / 2 + eps],
                          [-rod_id / 2 - eps, -opening_w / 2 - eps]]);
    }

    // Tubing ring with +X opening, centred at x = 15, y = 0
    translate([15, 0])
        difference() {
            circle(d = tub_od);
            translate([tub_id / 2 - eps, 0])
                linear_extrude(height = opening_w + 2 * eps)
                    polygon([[0, -opening_w / 2], [0, opening_w / 2],
                              [-opening_w - 2 * eps, opening_w / 2],
                              [-opening_w - 2 * eps, -opening_w / 2]]);
        }

    // Solid bridge between x = 8 and x = 12
    translate([bridge_x1, -bridge_w / 2])
        cube([bridge_x2 - bridge_x1, bridge_w, 1]);
}

// ---- Extrude to 10 mm height ----
translate([0, 0, 0])
    linear_extrude(height = 10)
        profile;