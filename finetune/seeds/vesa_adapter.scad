// VESA adapter plate - a flat plate carrying two square bolt patterns, to mount a display
// or bracket drilled for one VESA size onto another. NOVEL general mount.
//
// @desc VESA adapter plate linking two square bolt patterns
// @prompt Design a VESA adapter plate in OpenSCAD: a flat plate {thick} mm thick carrying a {src} by {src} mm square bolt pattern and a {dst} by {dst} mm square bolt pattern, with {hole} mm holes, to adapt one VESA mount to another. Reply with a single complete OpenSCAD file.
// @param src   source VESA pitch, mm     [50:200]
// @param dst   target VESA pitch, mm     [50:200]
// @param thick plate thickness, mm       [3:8]
// @param hole  bolt hole diameter, mm     [3:8]

src   = 75;
dst   = 100;
thick = 4;
hole  = 5;

$fn = 48;

size = max(src, dst) + 2 * hole + 12;

difference() {
    translate([-size / 2, -size / 2, 0]) cube([size, size, thick]);
    for (p = [src, dst])
        for (x = [-p / 2, p / 2])
            for (y = [-p / 2, p / 2])
                translate([x, y, -1]) cylinder(h = thick + 2, d = hole);
}
