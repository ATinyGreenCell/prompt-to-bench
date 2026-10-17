// Buffer tank for a mini horizontal gel-electrophoresis box. Open-top rectangular tank with a
// solid raised platform for the gel tray that divides the bottom into two buffer chambers. Each
// end wall gets a 2 mm horizontal hole along X for the electrode wires.
//

tank_X = 120;
tank_Y = 70;
tank_Z = 40;
wall   = 3;
floor  = 3;
platform_X = 60;
platform_Z = 10;

$fn = 64;

inner_X = tank_X - 2 * wall;
inner_Z = tank_Z - floor;

difference() {
    cube([tank_X, tank_Y, tank_Z]);
    translate([wall, 0, floor]) cube([tank_X, tank_Y, tank_Z - floor]);     // hollow, open top
    translate([wall, wall, floor]) cube([inner_X, tank_Y, tank_Z - floor]); // remove floor -> open bottom

    translate([wall, wall, 0]) cube([inner_X, tank_Y, platform_Z]);                 // raised platform
    translate([wall, wall, platform_Z]) cube([platform_X, tank_Y, wall]);           // end blocks of the platform

    for (x = [tank_X / 2 - platform_X / 2, tank_X / 2 + platform_X / 2])
        translate([x, wall, 0]) cube([platform_X, tank_Y, wall]);                  // bridge the two chambers above the platform

    for (x = [tank_X / 2 - platform_X / 2, tank_X / 2 + platform_X / 2])
        translate([x, wall, 0]) cube([wall, tank_Y, tank_Z - floor]);               // end walls with the horizontal electrode holes
    for (x = [tank_X / 2 - platform_X / 2, tank_X / 2 + platform_X / 2])
        translate([x, wall, tank_Z - floor]) cylinder(h = wall, d = 2);            // electrode holes
}