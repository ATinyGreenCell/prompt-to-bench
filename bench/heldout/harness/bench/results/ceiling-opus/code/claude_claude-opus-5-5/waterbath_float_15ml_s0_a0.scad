// Seven-tube float for 15 mL conical tubes (printed upside down)

// ---------------- Parameters ----------------
plate_flat    = 90;     // plate hexagon, across flats
plate_t       = 3;      // plate thickness
total_h       = 20;     // top of sleeves and skirt
hole_d        = 17.5;   // tube through-hole diameter
sleeve_wall   = 2;      // sleeve wall thickness
sleeve_od     = hole_d + 2*sleeve_wall; // 21.5 mm
ring_d        = 54;     // diameter of the outer hole circle
n_ring        = 6;      // holes on the ring
ring_start    = 0;      // first hole angle (+X)
skirt_flat    = 84;     // skirt outside, across flats
skirt_wall    = 2;      // skirt wall thickness
eps           = 0.5;    // cut overlap
$fn           = 96;

// circumradius from across-flats (vertex on +X, so flats parallel to X)
function hex_r(flat) = (flat/2) / cos(30);

// hole centres
hole_pts = concat([[0,0]],
    [for (i = [0:n_ring-1])
        [ring_d/2 * cos(ring_start + i*360/n_ring),
         ring_d/2 * sin(ring_start + i*360/n_ring)]]);

module hex_prism(flat, h, z0 = 0) {
    translate([0, 0, z0])
        cylinder(r = hex_r(flat), h = h, $fn = 6);
}

difference() {
    union() {
        // base plate
        hex_prism(plate_flat, plate_t);

        // sleeves
        for (p = hole_pts)
            translate([p[0], p[1], 0])
                cylinder(d = sleeve_od, h = total_h);

        // skirt
        difference() {
            hex_prism(skirt_flat, total_h);
            hex_prism(skirt_flat - 2*skirt_wall, total_h, plate_t - eps + 0.01 + eps); // starts at plate top
            hex_prism(skirt_flat - 2*skirt_wall, eps + 0.01, total_h - 0.01);           // ensure open top
        }
    }

    // through-holes
    for (p = hole_pts)
        translate([p[0], p[1], -eps])
            cylinder(d = hole_d, h = total_h + 2*eps);
}