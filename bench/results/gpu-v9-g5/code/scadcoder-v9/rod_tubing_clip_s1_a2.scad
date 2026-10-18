// Snap-on tubing clip for a 12.7 mm lab stand rod
// Print orientation: flat on the bed, extruded in +Z

// ---------- Parameters ----------
ring_d      = 12.7;   // rod ring inner diameter (1/2 inch)
ring_w      = 3;      // rod ring wall thickness
ring_od     = ring_d + 2 * ring_w;  // rod ring outer diameter (18.7 mm)
ring_open   = 10;     // width of the -X side opening on the rod ring
cut_extra   = 0.5;    // overshoot for clean boolean cuts

tube_d      = 6;      // tubing ring inner diameter
tube_w      = 2;      // tubing ring wall thickness
tube_od     = tube_d + 2 * tube_w;  // tubing ring outer diameter (10 mm)
tube_x      = 15;     // tubing ring centre X
tube_open   = 4.5;    // width of the +X side opening on the tubing ring

bridge_w    = 6;      // solid bridge width in Y (x = 8 to x = 12)
bridge_h    = 10;     // bridge height in Z
$fn         = 96;     // curve resolution

// ---------- Model ----------
union() {
    // Rod ring with -X opening
    difference() {
        translate([0, 0, 0])
            cylinder(d = ring_od, h = ring_h);
        translate([-(ring_od / 2 + cut_extra), 0, 0])
            rotate([0, 90, 0])
                cube([ring_open, ring_od / 2 + cut_extra, ring_h]);
    }

    // Tubing ring with +X opening
    difference() {
        translate([tube_x, 0, 0])
            cylinder(d = tube_od, h = ring_h);
        translate([tube_x + cut_extra, -tube_open / 2, 0])
            rotate([0, 90, 0])
                cube([cut_extra, tube_open, ring_h]);
    }

    // Solid bridge between the two rings
    translate([8, -bridge_w / 2, 0])
        cube([bridge_w, bridge_w, bridge_h]);
}