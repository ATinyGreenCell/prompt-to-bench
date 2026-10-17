// Reservoir - a buffer tank for a mini horizontal gel electrophoresis box, with a raised gel
// tray platform and horizontal electrode holes. NOVEL general part.
//

L   = 120;
W   = 70;
H   = 40;
wall = 3;
floor = 3;
platform_L = 60;
platform_z = 13;

$fn = 64;

inner_W = W - 2 * wall;
inner_H = H - floor;

difference() {
    cube([L, W, H]);
    translate([0, 0, floor]) cube([L, W, H - inner_H]);     // remove everything above the floor
    translate([wall, wall, floor]) cube([L - 2 * wall, W - 2 * wall, floor]);  // re-add the floor

    platform_z0 = floor + platform_z;
    translate([wall, wall, platform_z0])
        cube([platform_L, W - 2 * wall, wall]);              // left chamber floor under the platform
    translate([L - platform_L + wall, wall, platform_z0])
        cube([platform_L, W - 2 * wall, wall]);              // right chamber floor under the platform

    for (x = [L / 2, L])
        translate([x - L / 2, 0, -1])
            cylinder(h = H + 2, d = 2);                     // horizontal electrode holes
}