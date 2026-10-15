// Round motor mount plate - a disk with a center bore and a bolt circle, to mount a round
// motor or bearing. NOVEL general part.
//
// @desc round motor mount plate with a center bore and a bolt circle
// @prompt Design a motor mount plate in OpenSCAD: a round plate {plate_d} mm across and {t} mm thick, with a {bore} mm center bore and {holes} bolt holes {screw} mm on a {bolt_circle} mm bolt circle. Reply with a single complete OpenSCAD file.
// @param plate_d     plate diameter, mm        [40:120]
// @param bore        center bore, mm           [8:40]
// @param bolt_circle bolt circle diameter, mm  [25:100]
// @param holes       number of bolt holes      [3:8:1]
// @param screw       bolt hole diameter, mm     [3:6]
// @param t           plate thickness, mm        [3:8]

plate_d     = 70;
bore        = 22;
bolt_circle = 50;
holes       = 4;
screw       = 4;
t           = 5;

$fn = 72;

difference() {
    cylinder(h = t, d = plate_d);
    translate([0, 0, -1]) cylinder(h = t + 2, d = bore);
    for (i = [0 : holes - 1])
        rotate([0, 0, i * 360 / holes]) translate([bolt_circle / 2, 0, -1]) cylinder(h = t + 2, d = screw);
}
