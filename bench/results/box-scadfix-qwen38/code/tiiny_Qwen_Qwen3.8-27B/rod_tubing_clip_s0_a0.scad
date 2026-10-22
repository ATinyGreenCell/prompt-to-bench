// Snap-on clip for 12.7 mm lab stand rod, holding 6 mm ID tubing
// Printed flat: 10 mm tall extrusion (Z) of a 2-D profile in XY.

// --- Dimensions (mm) ---
rod_id   = 12.7;   // inner diameter of rod ring
rod_wall = 3.0;    // wall thickness of rod ring
rod_od   = rod_id + 2 * rod_wall;   // 18.7 outer diameter

tube_id  = 6.0;    // inner diameter of tubing ring
tube_wall= 2.0;    // wall thickness of tubing ring
tube_od  = tube_id + 2 * tube_wall; // 10.0 outer diameter

rod_cx   = 0.0;    // rod ring centre X
rod_cy   = 0.0;    // rod ring centre Y

tube_cx  = 15.0;   // tubing ring centre X
tube_cy  = 0.0;    // tubing ring centre Y

rod_open_w = 10.0; // width of rod ring opening (Y)
rod_open_h = 5.0;  // half-height of rod ring opening (Y)

tube_open_w = 4.5; // width of tubing ring opening (Y)
tube_open_h = 2.25;// half-height of tubing ring opening (Y)

bridge_x0 = 8.0;   // bridge start X
bridge_x1 = 12.0;  // bridge end X
bridge_w  = 6.0;   // bridge width (Y)

extrude_h = 10.0;  // print height (Z)

$fn = 64;

// --- 2-D profile in XY ---
profile = union() {
    // (1) Rod ring (annulus) at origin
    difference() {
        circle(d = rod_od);
        circle(d = rod_id);
    }

    // (2) Tubing ring (annulus) at x = 15
    translate([tube_cx, tube_cy]) {
        difference() {
            circle(d = tube_od);
            circle(d = tube_id);
        }
    }

    // (3) Solid bridge joining the two rings
    translate([(bridge_x0 + bridge_x1) / 2, 0]) {
        square([bridge_x1 - bridge_x0, bridge_w], center = true);
    }
};

// --- Cut the snap openings (extend 1 mm past the faces they cut) ---
profile = difference() {
    profile;

    // Rod ring opening on -X side: x < 0, -5 < y < 5
    translate([-1, 0]) {
        square([1, rod_open_w], center = true);
    }

    // Tubing ring opening on +X side: x > 15, -2.25 < y < 2.25
    translate([tube_cx + 1, 0]) {
        square([1, tube_open_w], center = true);
    }
};

// --- Extrude 10 mm in Z, resting on z = 0 ---
linear_extrude(height = extrude_h, center = false) {
    profile;
}