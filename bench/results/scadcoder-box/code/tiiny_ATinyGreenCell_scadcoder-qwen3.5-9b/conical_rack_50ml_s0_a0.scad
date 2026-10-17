// Tube rack - a flat plate with a regular grid of tube holes and two solid wall guides along the
// long edges. NOVEL general part (a generic hole grid, not any one labware item). Teaches a regular
// (grid) hole pattern, a wall built up from a base plate, and a part that is intentionally
// upside-down for the print: it rests on the bed then is flipped over so the walls stand on the
// surface it was printed against.
//

cols   = 3;
rows   = 2;
tube_d = 30.5;
pitch  = 40;
plate_l = 130;
plate_w = 90;
base_t = 4;
wall_h = 70;

$fn = 6;

col_pitch = pitch;
row_pitch = pitch;

difference() {
    cube([plate_l, plate_w, base_t]);
    for (x = [-(cols - 1) * col_pitch / 2 : col_pitch : (cols - 1) * col_pitch / 2],
        y = [-(rows - 1) * row_pitch / 2 : row_pitch : (rows - 1) * row_pitch / 2]) {
        translate([x, y, 0]) cylinder(h = base_t + 1, d = tube_d);     // through-holes
    }
    // two solid walls along the long edges (X = +/- L/2), e.g. for the tubes to lean against
    for (x = [-plate_l / 2, plate_l / 2]) {
        translate([x, -1, 0]) cube([plate_l, 4, wall_h]);
    }
}