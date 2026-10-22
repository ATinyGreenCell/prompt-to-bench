// Float for 7 x 15 mL conical tubes, printed upside down (plate on bed, z=0..3)
// All dimensions in mm, taken from the spec.

$fn = 64;

// --- Plate (regular hexagon, 90 mm across flats, 2 flats parallel to X) ---
plate_af   = 90;   // across flats
plate_t    = 3;    // plate thickness (z 0..3)
plate_ap   = plate_af / cos(30); // across corners = 103.923
plate_r    = plate_ap / 2;       // circumradius of hexagon

// --- Holes & sleeves ---
hole_d     = 17.5;  // through-hole diameter
hole_r     = hole_d / 2;
sleeve_od  = 21.5;  // sleeve outside diameter (2 mm wall)
sleeve_r   = sleeve_od / 2;
sleeve_h   = 20;    // sleeve top height (z = 20)
ring_d     = 54;    // diameter of the 6-hole circle
ring_r     = ring_d / 2;

// --- Hexagonal skirt (2 mm wall, 84 mm across flats outside, 3 mm in from plate edge) ---
skirt_af   = 84;    // across flats outside
skirt_t    = 2;     // wall thickness
skirt_af_i = skirt_af - 2 * skirt_t; // across flats inside = 80
skirt_ap   = skirt_af / cos(30);     // across corners outside
skirt_ap_i = skirt_af_i / cos(30);   // across corners inside
skirt_h    = 20;    // skirt top height (z = 20)

// --- Helper: regular hexagon with 2 flats parallel to X (flat-top) ---
module hexagon(af) {
    r = af / cos(30) / 2;
    polygon([
        [ r, 0 ],
        [ r/2,  r*sin(60) ],
        [ -r/2,  r*sin(60) ],
        [ -r, 0 ],
        [ -r/2, -r*sin(60) ],
        [  r/2, -r*sin(60) ]
    ]);
}

// --- Hole positions: 1 at centre + 6 on 54 mm circle, first on +X, 60 deg apart ---
hole_pos = [
    [0, 0],
    [ ring_r, 0 ],
    [ ring_r*cos(60),  ring_r*sin(60) ],
    [ -ring_r*cos(60),  ring_r*sin(60) ],
    [ -ring_r, 0 ],
    [ -ring_r*cos(60), -ring_r*sin(60) ],
    [  ring_r*cos(60), -ring_r*sin(60) ]
];

// --- Build the float (print orientation: plate on bed, features up +Z) ---
difference() {
    union() {
        // Solid plate
        linear_extrude(plate_t) hexagon(plate_af);

        // Skirt: 2 mm wall (outer hexagon minus inner hexagon), z 0..20
        difference() {
            linear_extrude(skirt_h) hexagon(skirt_af);
            linear_extrude(skirt_h) hexagon(skirt_af_i);
        }

        // Sleeves: 2 mm wall (outer cylinder minus hole cylinder), z 0..20
        for (p = hole_pos)
            difference() {
                translate([p[0], p[1], 0])
                    cylinder(h = sleeve_h, r = sleeve_r, $fn = $fn);
                translate([p[0], p[1], 0])
                    cylinder(h = sleeve_h, r = hole_r, $fn = $fn);
            }
    }

    // Cut: 7 through-holes (extend 1 mm past both faces so no coplanar faces)
    for (p = hole_pos)
        translate([p[0], p[1], -1])
            cylinder(h = sleeve_h + 2, r = hole_r, $fn = $fn);
}