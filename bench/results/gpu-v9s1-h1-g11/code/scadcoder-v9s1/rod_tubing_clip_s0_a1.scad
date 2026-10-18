// Snap-on clip: stand rod ring + tubing ring + bridge
// Print orientation: flat on bed, extrusion builds up in +Z

// ---------- Parameters ----------
stand_id     = 12.7;   // stand rod diameter
stand_wall   = 3;      // stand ring wall thickness
stand_od     = stand_id + 2 * stand_wall;  // stand ring outer diameter
stand_open   = 10;     // stand ring opening width (Y)

tube_id      = 6;      // tubing inner diameter
tube_wall    = 2;      // tubing ring wall thickness
tube_od      = tube_id + 2 * tube_wall;    // tubing ring outer diameter
tube_open    = 4.5;    // tubing ring opening width (Y)
tube_x       = 15;     // tubing ring centre X

bridge_w     = 6;      // bridge width (Y)
bridge_x1    = 8;      // bridge start X
bridge_x2    = 12;     // bridge end X

eps          = 0.5;    // cutter overshoot past faces
height       = 10;     // extrusion height (Z)
$fn          = 96;     // circle resolution

// ---------- Profile ----------
profile = union() {
    // Stand rod ring with -X side opening
    difference() {
        translate([0, 0, height])
            cylinder(d = stand_od, h = height);
        translate([-stand_od / 2 - eps, -stand_open / 2, 0])
            cube([stand_open + 2 * eps, stand_open, height]);
    }

    // Tubing ring with +X side opening
    translate([tube_x, 0, height])
        difference() {
            cylinder(d = tube_od, h = height);
            translate([tube_open / 2 - eps, -tube_open / 2, 0])
                cube([tube_open + 2 * eps, tube_open, height]);
        }

    // Solid bridge between the two rings
    translate([bridge_x1, -bridge_w / 2, height])
        cube([bridge_x2 - bridge_x1, bridge_w, height]);
};

// ---------- Clip ----------
translate([0, 0, 0])
    rotate([90, 0, 0])
        linear_extrude(height = height)
            profile;