// Tubing clip for 12.7 mm (1/2 inch) lab stand rod
// Print orientation: flat, extruded along Z (z = 0 to 10)

// ---------- Parameters ----------
extrusion_height = 10;      // Z height of the part
rod_d            = 12.7;    // stand rod inner diameter
rod_wall         = 3;       // stand rod ring wall thickness
rod_opening_w    = 10;      // width of the -X side opening in the rod ring
tubing_d         = 6;       // tubing inner diameter
tubing_wall      = 2;       // tubing ring wall thickness
tubing_opening_w = 4.5;     // width of the +X side opening in the tubing ring
bridge_w         = 6;       // solid bridge width (Y)
bridge_x0        = 8;       // bridge start (X)
bridge_x1        = 12;      // bridge end (X)
eps              = 0.5;     // cutter overshoot past faces

$fn = 96;

// ---------- Derived ----------
rod_outer = rod_d + 2 * rod_wall;
tubing_outer = tubing_d + 2 * tubing_wall;
tubing_opening_y = (tubing_opening_w / 2) - eps;  // y limit for opening

// ---------- Model ----------
difference() {
    union() {
        // Rod ring
        cylinder(d = rod_outer, h = extrusion_height);
        // Tubing ring
        translate([15, 0, 0])
            cylinder(d = tubing_outer, h = extrusion_height);
        // Solid bridge
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, extrusion_height]);
    }

    // Cut the -X opening in the rod ring
    translate([-rod_outer, -rod_opening_w / 2, -eps])
        cube([rod_opening_w, rod_opening_w, extrusion_height + 2 * eps]);

    // Cut the +X opening in the tubing ring
    translate([15, -tubing_opening_y, -eps])
        cube([tubing_opening_w, 2 * tubing_opening_y, extrusion_height + 2 * eps]);
}