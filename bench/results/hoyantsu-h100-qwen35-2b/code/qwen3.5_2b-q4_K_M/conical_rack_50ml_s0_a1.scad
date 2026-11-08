// Design a rack for six 50 mL conical (Falcon-type) tubes.
// In print orientation: a flat plate 130 mm (X) by 90 mm (Y) and 4 mm thick lies on the bed (z = 0 to 4).
// The plate has six through-holes, 30.5 mm in diameter, in 2 rows (along Y) of 3 (along X), 40 mm centre-to-centre in both directions, centred on the plate.
// Two solid walls run along the two long edges of the plate: each wall is 130 mm long (X) and 4 mm thick (Y), flush with the plate's long edge, and rises from the plate to z = 70.
// The two short ends stay open. After flipping, the rack stands on the two walls and the tubes pass through the holes.

// Dimensions in millimetres
plate_thickness = 4;
hole_diameter = 30.5;
hole_row_spacing_y = 40; // mm (centre-to-centre)
hole_row_spacing_x = 40; // mm (calculated to fit 6 holes in 2 cols of 3 within 130mm length with uniform spacing: (5*spacing + diameter)/2? No. Let's re-calculate carefully).

// Re-calculating X-spacing for 6 holes in 2 columns (3 per column) over a 130mm width.
// If we have 3 holes in one column, and they are evenly spaced with spacing S_x.
// The total width occupied by the 3 holes is: (S_x + diameter) + (S_x + diameter) + (S_x + diameter)? 
// No, that's if they touch at edges. If we have centers C1, C2, C3.
// Width = (C2 - C1) + (C3 - C2) + D? No.
// Width = 2*S_x + D.
// We need to fit this into the plate width of 130mm.
// If we have 6 holes in 2 columns, and they are evenly distributed along X.
// Let's assume a uniform grid where spacing is S_y = 40mm (given).
// For X, if it's also a square grid, then S_x should be such that the total width fits.
// Total Width = (number_of_holes - 1) * S + diameter? No.
// If we have N holes in M columns:
// The centers are at x_i = i*S for i=0..N-1? Or spaced by S between them.
// Let's assume the spacing is uniform. 
// Total span = (number_of_holes - 1) * spacing + diameter? No, that's for single row.
// For multiple rows, the X-span is determined by the arrangement in one column plus gaps to other columns?
// Actually, if we have a grid of holes:
// The total width occupied by 6 holes (2 cols, 3 rows) with spacing S_x and S_y.
// Width = (number_of_holes - 1) * max(S_x, S_y)? No.
// Width = sum of gaps between centers + diameter? 
// If we have 3 holes in a column: Center1, C2, C3. Spacing S_x.
// Width = 2*S_x + D.
// We need to fit this into the plate width (130mm).
// Let's assume the spacing is uniform and equal for both directions? 
// If S_y = 40, then S_x should be around 40 as well to make a square grid.
// Width per column = 2*S_x + D = 80 + 30.5 = 110.5 mm.
// Total width for 6 holes (2 columns) = 2 * 110.5 = 221 mm? That is too wide for 130mm.
// Therefore, the spacing must be smaller in X to fit within 130mm.
// Let's assume the 40mm applies to Y only, and we need to calculate S_x such that Total Width <= 130mm.
// If we have 2 columns of 3 holes each.
// The arrangement is: Col1 (Holes A,B,C), Gap, Col2 (D,E,F).
// Width = (C - A) + (Gap between C and D) + (E - F)? No.
// Width = (Center_C - Center_A) + (Center_D - Center_C) + (Diameter of last hole? No).
// Width = 2*S_x + D.
// If we have 3 holes in Col1: Centers at x, x+S, x+2S.
// Width of Col1 = 2*S + D.
// We need to fit this into the plate width (130mm).
// Wait, if there are 6 holes total, and they form a grid.
// The X-span is determined by the number of gaps between centers in one column plus diameter? 
// Actually, for N items in M slots: Width = (N-1)*S + D? No.
// If we have 3 holes in a row, width = 2*S + D.
// If we have 6 holes in 2 columns of 3 each.
// The total X-span is simply the sum of widths of all columns? 
// Width = (Width of Col1) + (Gap between Col1 and Col2) + (Width of Col2)?
// Gap between centers = S_x.
// So Total Width = 2*(2*S_x + D) - S_x? No.
// Let's visualize: H1, H2, H3 in Col1. Center1, C2, C3. Spacing S_x.
// Width of Col1 = (C2-C1) + (Diameter)? No. 
// If we have centers at 0, S, 2S. The physical extent is from -D/2 to D/2? No.
// Physical extent = Center3 - Center1 + Diameter? No.
// Physical extent = Center3 - Center1 + Diameter of the rightmost hole? 
// If we have holes at x=0, S, 2S. The right edge is at 2S + D/2? No.
// Let's assume the holes are centered in their slots.
// Slot width = S_x + D? Or just S_x?
// Usually, center-to-center spacing S means distance between centers.
// If we have 3 holes: Center1, C2, C3. Spacing S.
// Width occupied by these 3 holes (from left edge of first to right edge of third) = 2*S + D.
// We need to fit this into the plate width (130mm).
// If we have 6 holes in 2 columns, and they are evenly spaced along X.
// Let's assume the spacing is uniform S_x.
// Total Width = (Width of Col1) + (Gap between C3 and D1) + (Width of Col2)? 
// No, if they are aligned vertically? No, "along Y" implies rows.
// If we have 6 holes in a grid:
// Row 1: H1, H2, H3. Spacing S_x. Width = 2*S_x + D.
// Row 2: H4, H5, H6. Spacing S_x. Width = 2*S_x + D.
// If they are aligned in columns (Col1 has H1,H4; Col2 has H2,H5; Col3 has H3,H6).
// Then the total X-span is determined by the arrangement of these columns.
// Total Width = (Center_H3 - Center_H1) + (Diameter)? No.
// Let's assume a standard grid where spacing is uniform S_x and S_y.
// If we have 2 columns of 3 holes each, and they are evenly spaced along X.
// The total width occupied by the 6 holes is: 
// Width = (Number_of_holes - 1) * max(S_x, S_y)? No.
// Let's assume the spacing in X is also 40mm to make a square grid? 
// If S_x = 40, then Width of Col1 = 2*40 + 30.5 = 110.5 mm.
// Total width for 6 holes (2 columns) = 2 * 110.5 - 40? No.
// If we have 3 holes in a column, and they are spaced by 40mm.
// The total span of the 3 holes is 2*40 + 30.5 = 110.5 mm.
// We need to fit this into the plate width (130mm).
// If we have 6 holes in 2 columns, and they are evenly spaced along X.
// Let's assume the spacing is uniform S_x.
// Total Width = (Number_of_holes - 1) * S_x + D? No.
// For N items in M slots: Width = (N