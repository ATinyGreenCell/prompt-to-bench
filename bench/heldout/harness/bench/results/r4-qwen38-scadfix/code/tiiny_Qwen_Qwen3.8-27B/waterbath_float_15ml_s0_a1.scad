// Float for seven 15 mL conical tubes, printed upside down.
// It rests on the XY plane at z = 0 and builds upward (+Z).
// When flipped for use, the skirt and sleeves trap air under the plate.

$fn = 64;

// ---- Plate (regular hexagon, 90 mm across the flats, 3 mm thick) ----
plate_af  = 90;   // across the flats of the plate hexagon
plate_t   = 3;    // plate thickness (z = 0 to 3)
plate_ap  = plate_af * 2 / sqrt(3);  // across the corners = 103.923

// ---- Seven 17.5 mm through-holes: one at centre, six on a 54 mm circle ----
hole_d    = 17.5; // hole diameter
hole_r    = hole_d / 2;
ring_d    = 54;   // diameter of the circle carrying the six outer holes
ring_r    = ring_d / 2;

// ---- Sleeves: 2 mm wall, 21.5 mm outside, rising from the plate to z = 20 ----
sleeve_od = 21.5; // sleeve outside diameter
sleeve_id = sleeve_od - 2 * 2; // sleeve inside diameter (17.5)
sleeve_h  = 20;   // sleeve top height (z = 0 to 20)

// ---- Hexagonal skirt: 2 mm wall, 84 mm across the flats outside ----
skirt_af  = 84;   // across the flats of the skirt (outside)
skirt_ap  = skirt_af * 2 / sqrt(3); // across the corners of the skirt
skirt_h   = 20;   // skirt top height (z = 0 to 20)

// ---- Helper: regular hexagon polygon (flat sides parallel to X axis) ----
module hexagon(af) {
    ap = af * 2 / sqrt(3);
    polygon(points=[
        [ ap,  0],
        [ ap/2,  af/2],
        [-ap/2,  af/2],
        [-ap,   0],
        [-ap/2, -af/2],
        [ ap/2, -af/2]
    ]);
}

// ---- Hole centre positions (one at origin, six on the 54 mm circle) ----
hole_pos = [
    [0, 0],
    [ring_r, 0],
    [ring_r * cos(60), ring_r * sin(60)],
    [ring_r * cos(120), ring_r * sin(120)],
    [ring_r * cos(180), ring_r * sin(180)],
    [ring_r * cos(240), ring_r * sin(240)],
    [ring_r * cos(300), ring_r * sin(300)]
];

// ---- Build the float ----
difference() {
    // Union of all solid material
    union() {
        // Flat hexagonal plate (z = 0 to 3)
        linear_extrude(plate_t) hexagon(plate_af);

        // Seven sleeves (z = 0 to 20)
        for (p = hole_pos) {
            translate([p[0], p[1], 0])
                cylinder(h = sleeve_h, d = sleeve_od, $fn = $fn);
        }

        // Hexagonal skirt (z = 0 to 20)
        linear_extrude(skirt_h) hexagon(skirt_af);
    }

    // Cut the seven 17.5 mm through-holes (extend 1 mm past each face)
    for (p = hole_pos) {
        translate([p[0], p[1], -1])
            cylinder(h = sleeve_h + 2, d = hole_d, $fn = $fn);
    }

    // Cut the skirt wall: remove the interior of the skirt hexagon (z = 0 to 20)
    // The 1 mm overhangs ensure no coplanar faces with the plate or sleeve tops.
    translate([0, 0, -1])
        linear_extrude(skirt_h + 2)
        hexagon(skirt_af - 2 * 2); // 80 mm across the flats (inside of the 2 mm wall)
}