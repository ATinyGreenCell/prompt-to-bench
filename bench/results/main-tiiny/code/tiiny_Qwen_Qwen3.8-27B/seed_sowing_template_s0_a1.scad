// Sowing template for a 90 mm Petri dish
// Flat disc, 7x7 grid of 3 mm through-holes, orientation notch on +Y rim

// --- Dimensions (mm) ---
disc_diameter = 85;          // outer diameter of the template disc
disc_radius   = disc_diameter / 2;   // 42.5 mm
disc_thickness = 2;          // thickness of the flat disc

hole_diameter = 3;           // diameter of each sowing hole
hole_radius   = hole_diameter / 2;   // 1.5 mm

grid_n = 7;                  // 7 x 7 grid of holes
grid_spacing = 9;            // centre-to-centre spacing between adjacent holes

notch_width = 10;            // width of the orientation notch (X direction)
notch_depth = 4;             // depth of the notch into the rim (Y direction)

// --- Curvature quality ---
$fn = 64;

// --- Base disc, centred on origin, resting on z = 0 ---
base = cylinder(h = disc_thickness, r = disc_radius, $fn = $fn);

// --- 7 x 7 grid of 3 mm through-holes, centred on the disc ---
// Holes span from z = -1 to z = disc_thickness + 1 (extend past both faces)
hole_cut = cylinder(h = disc_thickness + 2, r = hole_radius, $fn = $fn);

grid_holes = for (i = [0 : grid_n - 1], j = [0 : grid_n - 1])
    translate([
        (i - (grid_n - 1) / 2) * grid_spacing,   // X offset, centred
        (j - (grid_n - 1) / 2) * grid_spacing,   // Y offset, centred
        -1                                       // start 1 mm below z=0
    ])
    hole_cut;

// --- Rectangular orientation notch on the +Y rim ---
// Notch is 10 mm wide (X) and 4 mm deep (Y, measured inward from the rim)
// It extends 1 mm past the rim and 1 mm past the top/bottom to ensure clean cuts
notch_cut = translate([0, disc_radius - notch_depth, -1])
    cube([notch_width, notch_depth + 1, disc_thickness + 2], center = [true, false, false]);

// --- Final part: disc minus holes and notch ---
difference() {
    base;
    grid_holes;
    notch_cut;
}