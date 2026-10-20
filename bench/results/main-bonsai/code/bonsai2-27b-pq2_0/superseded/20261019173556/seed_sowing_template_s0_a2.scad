// Sowing template for a 90 mm Petri dish
// Flat disc, 7x7 grid of through-holes, orientation notch on +Y rim

// --- Dimensions (mm) ---
dish_diameter   = 90;   // Petri dish inner diameter (context)
disc_diameter   = 85;   // Template disc diameter
disc_radius     = disc_diameter / 2;
disc_thickness  = 2;    // Disc thickness

hole_diameter   = 3;    // Through-hole diameter
hole_spacing    = 9;    // Centre-to-centre spacing
grid_size       = 7;    // 7 x 7 grid

notch_width     = 10;   // Notch width along X
notch_depth     = 4;    // Notch depth into rim from +Y side

// --- Print orientation ---
// Disc rests on XY plane at z = 0, centred on origin in X and Y.

// --- Main disc ---
disc = cylinder(d=disc_diameter, h=disc_thickness