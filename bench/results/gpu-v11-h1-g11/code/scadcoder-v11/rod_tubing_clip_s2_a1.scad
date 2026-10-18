// Tubing clip for 12.7 mm (1/2 inch) lab stand rod
// Print orientation: flat on bed, extruded up in +Z

// ---- Rod ring ----
rod_id   = 12.7;   // inner diameter of rod ring
rod_wall  = 3;     // wall thickness
rod_od   = rod_id + 2 * rod_wall; // outer diameter = 18.7
rod_open  = 10;    // width of opening cut from -X side

// ---- Tubing ring ----
tube_id   = 6;     // inner diameter of tubing ring
tube_wall = 2;     // wall thickness
tube_od  = tube_id + 2 * tube_wall; // outer diameter = 10
tube_x   = 15;    // centre x position
tube_open = 4.5;   // width of opening cut from +X side

// ---- Bridge ----
bridge_x0 = 8;     // bridge start in X
bridge_x1 = 12;    // bridge end in X
bridge_w  = 6;     // bridge width (Y)

// ---- Misc ----
eps = 0.5;         // cutter overshoot past faces
$fn = 128;         // curve resolution

difference() {
    union() {
        // Rod ring
        cylinder(d = rod_od, h = 10);
        // Tubing ring
        translate([tube_x, 0, 0])
            cylinder(d = tube_od, h = 10);
        // Solid bridge
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, 10]);
    }
    // Rod ring opening: removes x < 0, -5 < y < 5
    translate([-rod_open / 2, -5, -eps])
        cube([rod_open, 10, 10]);
    // Tubing ring opening: removes x > 15, -2.25 < y < 2.25
    translate([tube_x, -tube_open / 2, -eps])
        cube([tube_open, tube_od + tube_open, 10]);
}