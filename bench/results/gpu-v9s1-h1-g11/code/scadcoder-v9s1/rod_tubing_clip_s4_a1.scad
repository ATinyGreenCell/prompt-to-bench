// Snap-on tubing clip for a 12.7 mm (1/2 inch) lab stand rod
// Printed flat: 2-D profile in XY, extruded 10 mm in Z

// ---------------- Parameters ----------------
rod_id      = 12.7;   // rod ring inner diameter
rod_wall    = 3;      // rod ring wall thickness
rod_od      = rod_id + 2 * rod_wall; // rod ring outer diameter (18.7)
rod_opening = 10;     // rod ring opening width (along Y)

tub_id      = 6;      // tubing ring inner diameter
tub_wall    = 2;      // tubing ring wall thickness
tub_od      = tub_id + 2 * tub_wall; // tubing ring outer diameter (10)
tub_x       = 15;     // tubing ring centre X
tub_opening = 4.5;    // tubing ring opening width (along Y)

bridge_w    = 6;      // bridge width (along Y)
bridge_x1   = 8;      // bridge start X
bridge_x2   = 12;     // bridge end X

eps         = 0.5;    // cutter overshoot past faces
$fn         = 128;    // curve resolution

// ---------------- Profile ----------------
module profile() {
    union() {
        // Rod ring with -X side opening
        difference() {
            translate([0, 0]) circle(d = rod_od);
            // cut out everything with x < 0 and -5 < y < 5
            translate([-rod_od - eps, -5])
                cube([rod_od + 2 * eps, 10, 1]);
        }

        // Tubing ring with +X side opening
        translate([tub_x, 0])
            difference() {
                circle(d = tub_od);
                // x > 15 and -2.25 < y < 2.25
                translate([tub_x - eps, -tub_opening / 2])
                    cube([tub_opening / 2 + eps, tub_opening, 1]);
            }

        // Solid bridge between the two rings
        translate([bridge_x1, -bridge_w / 2])
            cube([bridge_x2 - bridge_x1, bridge_w, 1]);
    }
}

// ---------------- Part ----------------
difference() {
    translate([0, 0, 0])
        linear_extrude(height = 10)
            profile();
    // No support removal needed: all cutters overshoot the top and bottom faces.
}