// Adapter: phone camera over microscope eyepiece (30 mm OD), printed phone-side down.
// Units: mm. Rests on XY plane at z=0, centred on origin in X/Y.

// --- Dimensions (measured with calipers) ---
plate_x   = 80;   // plate length along X
plate_y   = 60;   // plate width along Y
plate_z   = 3;    // plate thickness (z = 0..3)

cam_hole_d  = 12; // camera hole diameter
cam_hole_x  = -20;// camera hole centre X
cam_hole_y  = 10; // camera hole centre Y

sleeve_od   = 36.6; // sleeve outer diameter
sleeve_z0   = 3;    // sleeve base (top of plate)
sleeve_z1   = 11;   // bore step (stop)
sleeve_ztop = 31;   // sleeve open top
bore_d_low  = 22;   // bore diameter z=3..11 (sets eyepiece distance)
bore_d_high = 30.6; // bore diameter z=11..top (slides over 30 mm eyepiece)

screw_hole_d = 2.5; // radial M3 centring-screw hole diameter
screw_z      = 21;  // screw hole height
screw_count  = 3;   // radial holes, 120 deg apart, first at +X

// --- Print orientation: plate on bed, sleeve up (+Z) ---
$fn = 64;

module plate() {
    // 80 x 60 x 3 plate centred on origin, z = 0..3
    cube([plate_x, plate_y, plate_z], center=[0,0,plate_z/2]);
}

module camera_hole() {
    // 12 mm through-hole at (-20, 10), cut 0.5 mm past top/bottom
    translate([cam_hole_x, cam_hole_y, 0])
        cylinder(h = plate_z + 1, d = cam_hole_d, $fn = $fn);
}

module sleeve() {
    // Outer sleeve: 36.6 mm OD, z = 3..31
    translate([0, 0, sleeve_z0])
        cylinder(h = sleeve_ztop - sleeve_z0, d = sleeve_od, $fn = $fn);
}

module sleeve_bores() {
    // Lower bore 22 mm, z = 3..11 (stop)
    translate([0, 0, sleeve_z0])
        cylinder(h = sleeve_z1 - sleeve_z0, d = bore_d_low, $fn = $fn);
    // Upper bore 30.6 mm, z = 11..31 (open top)
    translate([0, 0, sleeve_z1])
        cylinder(h = sleeve_ztop - sleeve_z1, d = bore_d_high, $fn = $fn);
}

module screw_holes() {
    // 3 radial 2.5 mm holes through sleeve wall at z = 21, 120 deg apart, first at +X
    for (i = [0, 1, 2]) {
        angle = i * 120;
        translate([0, 0, screw_z])
            rotate([0, 0, angle])
                cylinder(h = 2, d = screw_hole_d, $fn = $fn);
    }
}

// --- Assemble ---
union() {
    difference() {
        union() {
            plate();
            sleeve();
        }
        camera_hole();
        sleeve_bores();
        screw_holes();
    }
}