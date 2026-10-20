// Hose-barb reducer: 8mm ID to 5mm ID silicone tubing
// Print orientation: standing upright on XY plane, builds in +Z

// --- Dimensions (mm) ---
bore_d = 3;                // Straight bore diameter
total_h = 41;              // Total height

barb1_h = 10;              // Height of each 8mm barb
barb1_od_bot = 7.5;        // Bottom OD of 8mm barbs
barb1_od_top = 9.5;        // Top OD of 8mm barbs

collar_h = 5;              // Height of cylindrical collar
collar_od = 12;            // Diameter of cylindrical collar

barb2_h = 8;               // Height of each 5mm barb
barb2_od_bot = 6.5;        // Bottom OD of 5mm barbs
barb2_od_top = 5.0;        // Top OD of 5mm barbs

// --- Derived Radii ---
bore_r = bore_d / 2;
barb1_r_bot = barb1_od_bot / 2;
barb1_r_top = barb1_od_top / 2;
collar_r = collar_od / 2;
barb2_r_bot = barb2_od_bot / 2;
barb2_r_top = barb2_od_top / 2;

// --- Profile Polygon (XY plane: x=radius, y=height) ---
// Traced around the outer perimeter, starting from bottom center
profile = [
  [0, 0],
  [0, total_h],
  [barb2_r_top, total_h],
  [barb2_r_top, barb1_h * 2 + collar_h + barb2_h], // z = 33
  [barb2_r_bot, barb1_h * 2 + collar_h],           // z = 25
  [collar_r, barb1_h * 2 + collar_h],              // z = 25
  [collar_r, barb1_h * 2],                         // z = 20
  [barb1_r_top, barb1_h * 2],                      // z = 20
  [barb1_r_top, barb1_h],                          // z = 10
  [barb1_r_bot, barb1_h],                          // z = 10
  [barb1_r_bot, 0],
  [0, 0]
];

// Outer rotational shape
outer_shape = rotate_extrude($fn = 64) polygon(profile);

// Bore cylinder (extends slightly past faces to avoid coplanar faces)
bore_cyl = cylinder(r = bore_r, h = total_h + 0.2, $fn = 64);

// Final part: subtract bore from outer shape
difference() {
  outer_shape;
  translate([0, 0, -0.1]) bore_cyl;
}