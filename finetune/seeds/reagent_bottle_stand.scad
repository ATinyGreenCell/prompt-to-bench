// Reagent bottle stand - a weighted base with a C-shaped wall that cradles a round
// reagent bottle upright on the bench, with an open front so the bottle slides in.
// A NOVEL part: deliberately not one of the 16 benchmark tasks.
//
// Parametric for augmentation. Ranges are the sane envelope a variant may be drawn from:
// @param bottle_d   outer diameter of the bottle to cradle, mm   [30:120]
// @param wall_h     height of the cradling wall, mm              [10:45]
// @param clearance  radial gap around the bottle, mm            [0.4:2.0]
// @param base_t     thickness of the base disk, mm              [3:10]
// @param wall_t     wall thickness, mm                          [2:5]
// @desc reagent bottle stand - an open-front cradle that holds a round reagent bottle upright
// @prompt Design a reagent bottle stand in OpenSCAD. It has a weighted circular base and a C-shaped wall that cradles a round bottle {bottle_d} mm in diameter upright on the bench; the wall is {wall_h} mm tall with an open front so the bottle slides in. Reply with a single complete OpenSCAD file.

bottle_d  = 54;   // e.g. a 100 mL round media bottle
wall_h    = 20;
clearance = 0.8;
base_t    = 5;
wall_t    = 3;

$fn = 96;

inner_r = bottle_d / 2 + clearance;
outer_r = inner_r + wall_t;
base_r  = outer_r + 4;              // the base overhangs the wall for tip stability

difference() {
    union() {
        cylinder(h = base_t, r = base_r);                 // base disk
        cylinder(h = base_t + wall_h, r = outer_r);       // cradling wall
    }
    translate([0, 0, base_t])
        cylinder(h = wall_h + 1, r = inner_r);            // pocket the bottle sits in
    // open the front: remove the +y half of the wall above the lower third,
    // leaving a C-shaped cradle the bottle slides into
    translate([-(inner_r + 1), 0, base_t + wall_h / 3])
        cube([2 * (inner_r + 1), base_r + 2, wall_h + 1]);
}
