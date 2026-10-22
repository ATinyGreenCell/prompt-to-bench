// Float for seven 15 mL conical tubes, printed upside down.
// Rests on the XY plane at z = 0 and builds upward (+Z).
// Centred on the origin in X and Y.

$fn = 64;

// --- Named dimensions (mm) ---
plate_across_flats = 90;   // hexagon plate, across the flats
plate_thickness    = 3;    // plate z = 0 to 3
hole_d             = 17.5; // through-hole diameter
sleeve_wall        = 2;    // sleeve wall thickness
sleeve_outside     = 21.5; // sleeve outside diameter (17.5 + 2*2)
sleeve_height      = 20;   // sleeve top z
skirt_wall         = 2;    // skirt wall thickness
skirt_outside_af   = 84;   // skirt outside across the flats (3 mm in from plate edge)
skirt_inside_af    = 80;   // skirt inside across the flats (84 - 2*2)
skirt_height       = 20;   // skirt top z
ring_diameter      = 54;   // circle on which six outer holes sit
n_outer            = 6;    // number of outer holes

// --- Helper: regular hexagon polygon (across flats = 2*r) ---
module hexagon(af) {
    r = af / 2;
    polygon(points = [
        [ r,  0 ],
        [ r/2,  r * sqrt(3)/2 ],
        [ -r/2, r * sqrt(3)/2 ],
        [ -r,  0 ],
        [ -r/2, -r * sqrt(3)/2 ],
        [ r/2, -r * sqrt(3)/2 ]
    ]);
}

// --- Helper: one sleeve (outer cylinder minus through-hole) ---
module sleeve() {
    difference() {
        cylinder(h = sleeve_height, d = sleeve_outside);
        cylinder(h = sleeve_height + 1, d = hole_d); // extends 1 mm past top
    }
}

// --- Helper: hexagonal skirt (outer minus inner, both 1 mm past top) ---
// Rotated 30 deg so its flats are parallel to the plate's flats.
module skirt() {
    difference() {
        rotate([0, 0, 30]) linear_extrude(height = skirt_height + 1) hexagon(skirt_outside_af);
        rotate([0, 0, 30]) linear_extrude(height = skirt_height + 1) hexagon(skirt_inside_af);
    }
}

// --- Hole centre positions: one at origin, six on 54 mm circle ---
hole_positions = [
    [0, 0],
    for (i = [0 : n_outer - 1])
        [ ring_diameter/2 * cos(i * 60),
          ring_diameter/2 * sin(i * 60) ]
];

// --- Assemble the float ---
difference() {
    union() {
        // Flat hexagonal plate, z = 0 to 3
        linear_extrude(height = plate_thickness) hexagon(plate_across_flats);

        // Seven sleeves rising from the plate to z = 20
        for (p = hole_positions)
            translate([p[0], p[1], 0]) sleeve();

        // Hexagonal skirt rising from the plate to z = 20
        skirt();
    }

    // Seven through-holes, each cut 1 mm past the top and 1 mm below the bed
    for (p = hole_positions)
        translate([p[0], p[1], -1])
            cylinder(h = sleeve_height + 1, d = hole_d);
}