// Float for 7 x 15 mL conical tubes, printed upside down (plate on bed, z=0..3)
$fn = 64;

// Plate (regular hexagon, 90 mm across flats, two flats parallel to X)
plate_af   = 90;   // across flats
plate_t    = 3;    // plate thickness (z 0..3)
plate_ap   = plate_af / 2;   // apothem = 45
plate_r    = plate_af / sqrt(3); // circumradius = 51.9615

// Holes: 17.5 mm through, 1 centre + 6 on 54 mm dia circle (first on +X)
hole_d     = 17.5;
hole_r     = hole_d / 2;   // 8.75
ring_d     = 54;
ring_r     = ring_d / 2;   // 27

// Sleeves: 2 mm wall -> 21.5 mm OD, rise to z=20
sleeve_od  = 21.5;
sleeve_r   = sleeve_od / 2; // 10.75
sleeve_h   = 20;

// Hexagonal skirt: 2 mm wall, 84 mm across flats outside (3 mm in from plate edge)
skirt_af   = 84;
skirt_ap   = skirt_af / 2;  // 42
skirt_r    = skirt_af / sqrt(3); // 48.4973
skirt_h    = 20;

// Helper: regular hexagon polygon (flat sides parallel to X, vertices at 0,60,...)
module hexagon(r) {
    polygon(points = [for (i = [0:5]) [r * cos(i * 60), r * sin(i * 60)]]);
}

// Hole centre positions (centre + 6 on 54 mm dia circle, first on +X)
hole_pos = [
    [0, 0],
    [ring_r, 0],
    [ring_r * cos(60),  ring_r * sin(60)],
    [ring_r * cos(120), ring_r * sin(120)],
    [ring_r * cos(180), ring_r * sin(180)],
    [ring_r * cos(240), ring_r * sin(240)],
    [ring_r * cos(300), ring_r * sin(300)]
];

// Cuts: each extends 1 mm past the faces it cuts (z -1 .. 21)
module hole_cut() {
    translate([0, 0, -1])
        cylinder(h = 22, r = hole_r, $fn = 64);
}

module sleeve_cut() {
    translate([0, 0, -1])
        cylinder(h = 22, r = sleeve_r, $fn = 64);
}

module skirt_cut() {
    translate([0, 0, -1])
        linear_extrude(height = 22)
            hexagon(skirt_r);
}

// Bored plate: plate minus 7 through-holes (skirt bore NOT applied here,
// so it cannot swallow the sleeves that sit inside the skirt)
module bored_plate() {
    difference() {
        translate([0, 0, 0])
            linear_extrude(height = plate_t)
                hexagon(plate_r);
        for (p = hole_pos)
            translate([p[0], p[1], 0])
                hole_cut();
    }
}

// Final float:
//  1) plate with 7 through-holes
//  2) 7 sleeves (21.5 OD, z 0..20) each bored to 17.5
//  3) hexagonal skirt (84 AF, z 0..20) bored to 84 AF (cuts only the plate rim)
union() {
    bored_plate();

    for (p = hole_pos)
        difference() {
            translate([p[0], p[1], 0])
                cylinder(h = sleeve_h, r = sleeve_r, $fn = 64);
            translate([p[0], p[1], 0])
                sleeve_cut();
        }

    difference() {
        translate([0, 0, 0])
            linear_extrude(height = skirt_h)
                hexagon(skirt_r);
        skirt_cut();
    }
}