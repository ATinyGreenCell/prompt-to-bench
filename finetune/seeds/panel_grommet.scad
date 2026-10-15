// Panel grommet / bushing - lines a round panel hole with a flange and a bore to protect a
// cable passing through sheet material. NOVEL general part.
//
// @desc panel grommet / bushing that lines a round hole to protect a passing cable
// @prompt Design a panel grommet in OpenSCAD: a bushing for a {panel_d} mm panel hole with a {bore} mm bore for the cable, a flange that overhangs the hole by {flange} mm, for a panel {panel_t} mm thick. Reply with a single complete OpenSCAD file.
// @param panel_d panel hole diameter, mm   [10:40]
// @param bore    cable bore diameter, mm    [3:28]
// @param flange  flange overhang, mm        [2:8]
// @param panel_t panel thickness, mm        [1:6]

panel_d = 20;
bore    = 12;
flange  = 4;
panel_t = 2;

$fn = 72;

flange_t = 1.5;

difference() {
    union() {
        cylinder(h = flange_t, d = panel_d + 2 * flange);              // flange
        cylinder(h = flange_t + panel_t + 1.5, d = panel_d);           // tube through the panel
    }
    translate([0, 0, -1]) cylinder(h = flange_t + panel_t + 4, d = bore);   // bore
}
