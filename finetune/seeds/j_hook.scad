// J-hook wall hook - a backplate with mounting holes and a projecting hook with an upturned
// tip. NOVEL general part.
//
// @desc wall J-hook with a backplate and two mounting holes
// @prompt Design a wall hook in OpenSCAD: a {plate_w} mm wide backplate with two {screw} mm mounting holes, and a hook that projects {reach} mm then turns up {lip} mm. Reply with a single complete OpenSCAD file.
// @param plate_w backplate width, mm      [20:50]
// @param reach   hook projection, mm      [20:70]
// @param lip     upturn height, mm        [8:30]
// @param screw   screw hole diameter, mm  [3:6]

plate_w = 30;
reach   = 40;
lip     = 18;
screw   = 4;

$fn = 48;

plate_h = 50;
t       = 5;
arm     = 8;

difference() {
    union() {
        cube([plate_w, t, plate_h]);                                              // backplate
        translate([plate_w / 2 - arm / 2, 0, plate_h * 0.25]) cube([arm, reach, arm]);           // arm
        translate([plate_w / 2 - arm / 2, reach - arm, plate_h * 0.25]) cube([arm, arm, lip]);   // upturned tip
    }
    for (z = [plate_h * 0.25, plate_h * 0.75])
        translate([plate_w / 2, -1, z]) rotate([-90, 0, 0]) cylinder(h = t + 2, d = screw);
}
