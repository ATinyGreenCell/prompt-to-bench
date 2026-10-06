// Snap-on clip: rod ring + tubing ring joined by a bridge
$fn = 96;

h = 10;               // extrusion height (Z)

rod_id = 12.7;        // rod ring inner diameter
rod_wall = 3;         // rod ring wall thickness
rod_open_w = 10;      // rod ring opening width (Y), on -X side

tube_id = 6;          // tubing ring inner diameter
tube_wall = 2;        // tubing ring wall thickness
tube_x = 15;          // tubing ring centre X
tube_open_w = 4.5;    // tubing ring opening width (Y), on +X side

bridge_w = 6;         // bridge width (Y)
bridge_x0 = 8;        // bridge start X
bridge_x1 = 12;       // bridge end X

ext = 1;              // cutter overshoot

rod_od = rod_id + 2*rod_wall;
tube_od = tube_id + 2*tube_wall;

module profile() {
    difference() {
        union() {
            circle(d = rod_od);
            translate([tube_x, 0]) circle(d = tube_od);
            translate([bridge_x0, -bridge_w/2])
                square([bridge_x1 - bridge_x0, bridge_w]);
        }
        // holes
        circle(d = rod_id);
        translate([tube_x, 0]) circle(d = tube_id);
        // rod ring opening: x < 0, |y| < rod_open_w/2
        translate([-rod_od/2 - ext, -rod_open_w/2])
            square([rod_od/2 + ext, rod_open_w]);
        // tubing ring opening: x > tube_x, |y| < tube_open_w/2
        translate([tube_x, -tube_open_w/2])
            square([tube_od/2 + ext, tube_open_w]);
    }
}

linear_extrude(height = h) profile();