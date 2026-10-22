// Parameters (all in mm)
size = 90;                // outer X and Y dimension
height = 40;             // total height of the housing
top_thick = 2;           // thickness of the top plate
wall_thick = 2.5;        // thickness of each wall
inner_size = size - 2*wall_thick;   // inner cavity size (X and Y)
hole_dia = 4.5;          // diameter of the M4 mounting holes
hole_spacing = 71.5;     // spacing of the mounting holes (square pattern)
notch_width = 12;        // width of the power‑cable notch
notch_depth = 8;         // depth of the notch from the open edge (z = 32 → 40)
notch_start_z = height - notch_depth; // z‑position where the notch begins
extra = 0.02;            // clearance to avoid coplanar faces

$fn =