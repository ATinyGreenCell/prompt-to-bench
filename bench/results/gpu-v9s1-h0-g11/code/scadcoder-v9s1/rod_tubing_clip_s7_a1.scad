// Snap-on tubing clip for a 12.7 mm lab stand rod
// Print orientation: flat on bed, extrusion along +Z

// ---- Dimensions (mm) ----
rod_id     = 12.7;   // stand rod diameter
ring_w     = 3;      // stand rod ring wall thickness
ring_od    = rod_id + 2 * ring_w;    // 18.7 mm outer diameter of rod ring
opening_w  = 10;     // width of opening cut from -X side of rod ring

tub_id     = 6;      // tubing inner diameter
tub_w      = 2;      // tubing ring wall thickness
tub_od     = tub_id + 2 * tub_w;     // 10 mm outer diameter of tubing ring
tub_x      = 15;     // tubing ring centre X position
tub_opening = 4.5;   // width of opening cut from +X side of tubing ring

bridge_x0  = 8;      // bridge start X
bridge_x1  = 12;     // bridge end X
bridge_w   = bridge_x1 - bridge_x0;  // 6 mm bridge width (X)
bridge_h   = 10;     // extrusion height (Z)

eps        = 0.5;    // cutter overshoot past faces

$fn = 96;

// ---- 2-D profile in XY ----
profile = union() {
    // Rod ring with -X opening
    difference() {
        circle(d = ring_od);
        translate([-ring_od/2 - eps, -opening_w/2, 0])
            cube([opening_w + 2*eps, opening_w, 1]);
    }

    // Tubing ring with +X opening
    translate([tub_x, 0])
        difference() {
            circle(d = tub_od);
            translate([tub_opening/2 - eps, -tub_opening/2, 0])
                cube([tub_opening + 2*eps, tub_opening, 1]);
        }

    // Solid bridge joining the two rings
    translate([bridge_x0, -bridge_w/2, 0])
        cube([bridge_w, bridge_w, 1]);
};

// ---- Extruded part ----
translate([0, 0, 0])
    linear_extrude(height = bridge_h)
        profile;