// Spur gear (simplified teeth) - a flat gear with a hub and a central bore. The teeth are a
// trapezoidal approximation (not a true involute) but they print and mesh for light use.
// NOVEL general mechanical part.
//
// @desc spur gear with a central bore (simplified trapezoidal teeth)
// @prompt Design a spur gear in OpenSCAD with {teeth} teeth, a module of {mod} mm, {thick} mm thick, and a {bore} mm central bore. Reply with a single complete OpenSCAD file.
// @param teeth number of teeth     [8:40:1]
// @param mod   gear module, mm     [1:4:0.5]
// @param thick thickness, mm       [3:12]
// @param bore  central bore, mm    [2:12]

teeth = 16;
mod   = 2;
thick = 6;
bore  = 5;

$fn = 96;

pitch_r = mod * teeth / 2;
root_r  = pitch_r - 1.25 * mod;
tw      = mod * 1.4;                 // tooth width near the pitch line

difference() {
    union() {
        cylinder(h = thick, r = root_r);
        for (i = [0 : teeth - 1])
            rotate([0, 0, i * 360 / teeth])
                translate([pitch_r, 0, 0])
                    linear_extrude(thick)
                        polygon([[-1.5 * mod, -tw / 2], [-1.5 * mod, tw / 2],
                                 [mod, tw / 3],          [mod, -tw / 3]]);
    }
    translate([0, 0, -1]) cylinder(h = thick + 2, d = bore);
}
