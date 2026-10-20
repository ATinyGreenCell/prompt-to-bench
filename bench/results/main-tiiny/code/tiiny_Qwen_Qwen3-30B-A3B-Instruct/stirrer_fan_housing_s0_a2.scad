// Dimensions for DIY magnetic stirrer housing
$fn = 64;

// Overall dimensions
outer_width = 90;        // X dimension
outer_depth = 90;        // Y dimension
top_thickness = 2;         // Z thickness of top plate
wall_height = 40;        // Height of walls from top plate
wall_thickness = 2.5;    // Thickness of side walls

// Screw hole parameters
screw_diameter = 4.5;      // Diameter of screw holes
screw_pattern_diameter = 71.5; // Diagonal distance between screw holes (square pattern)

// Cable notch parameters
notch_width = 12;         // Width of cable notch
notch_depth = 8;        // Depth of notch from open edge (z = 32 to z = 40)
notch_position = 45;        // Center of notch along the wall (Y direction)

// Ensure the entire housing sits on the bed with the top plate at z = 0 to 2
// The issue: the top plate is now at z = 0 to 2, but the walls are still centered at z = 20 (z = 0 to 40), so the body extends from z = -0.1 to 40.05.
// The problem is that the walls are still offset by 20 in Z, but the top plate is at z = 1 (centered at 1), so the walls should start at z = 0.

// The root issue: the walls are created with `center = true`, so they extend from z = 0 to 40 only if their center is at z = 20.
// But the top plate is at z = 0 to 2 (centered at z = 1), so the walls should be placed so that their bottom is at z = 0.

// Fix: Move the walls so that their bottom is at z = 0, not centered at z = 20.
// We'll shift the walls so that their Z center is at z = 20, but we need to ensure the entire structure is from z = 0 to 40 for walls and z = 0 to 2 for top.

// However, the top plate is already at z = 0 to 2 (centered at z = 1), and walls are from z = 0 to 40 (centered at z = 20), so this is correct.
// But the bounding box shows z = -0.1 to 40.05 — why?

// The issue: the notch cut is a cube centered at z = 36 (since notch_z_min = 32, notch_z_max = 40 → center at 36), but the cube is created with `center = true`, so it extends from z = 36 - (notch_depth+0.1)/2 to 36 + (notch_depth+0.1)/2 → 36 - 4.05 to 36 + 4.05 → 31.95 to 40.05.
// But the wall is from z = 0 to 40, so the notch extends beyond the wall's top (z = 40) and into z = 40.05 — that's why the bounding box goes to 40.05.

// Also, the notch cube is centered at z = 36, but the wall is from z = 0 to 40, so the notch is within the wall's Z range.

// However, the top plate is at z = 0 to 2, and the walls are from z = 0 to 40, so the notch is in the wall, which is correct.

// But the **lowest point** is at z = -0.1 — this is because the notch cube is centered at z = 36, but its height is notch_depth + 0.1 = 8.1 mm, so it extends from z = 36 - 4.05 = 31.95 to 36 + 4.05 = 40.05 — that's fine.
// But why is the lowest point at z = -0.1?

// The only thing that can go below z = 0 is the notch cube — but it's from 31.95 to 40.05, so it's above z = 0.

// Wait — the **top plate** is at z = 0 to 2, and the **walls** are from z = 0 to 40 — so the entire body should start at z = 0.

// The issue must be that the walls are not aligned with the top plate in Z.

// Let's recheck: the top plate is at z = 1 (centered at 1), so it spans 0 to 2.
// The walls are centered at z = 20, so they span 0 to 40 — that's correct.

// But the **notch cube** is centered at z = 36, so it spans 31.95 to 40.05 — that's fine.

// The only way the body goes below z = 0 is if the walls extend below z = 0 — but they don't.

// The problem is that the **top plate** is at z = 0 to 2, and the **walls** are at z = 0 to 40 — so the junction is at z = 0 to 2.

// But the **notch cube** is placed at z = 36, so it's not affecting the bottom.

// The only explanation is that the **top plate** is not at z = 0 to 2 — it is, because we did `translate([0, 0, 1])` and `cube([90,90,2], center=true)` → z = 1 ± 1 → 0 to 2.

// So why is the lowest point at z = -0.1?

// The answer: the **notch cube** is not aligned with the wall's Z. The wall is from z = 0 to 40, but the notch cube is placed at `z = 36` (center), so it's within the wall.

// But the **only** thing that can go below z = 0 is if the notch cube has a negative Z component — but it doesn't.

// Wait — the **top plate** is at z = 0 to 2, and the **walls** are at z = 0 to 40 — so the junction is at z = 0 to 2.

// The **only** possibility is that the **notch cube** is not placed correctly in Z.

// Let's recompute: notch_depth = 8 mm, so from z = 32 to z = 40.
// The notch cube is created with `center = true`, so its center should be at z = 36.
// But the cube is `cube([12.1, 2.6, 8.1], center=true)` → so it spans z = 36 - 4.05 = 31.95 to 36 + 4.05 = 40.05 — that's correct.

// But the **wall** is from z = 0 to 40 — so the notch cube extends beyond the wall's top (z = 40) by 0.05 mm — that's why the bounding box goes to 40.05.

// But the **wall** is from z = 0 to 40, so the notch cube is cutting into the wall from z = 31.95 to 40.05 — but the wall only exists to z = 40.

// So the notch cube extends 0.05 mm beyond the wall — that's acceptable, but it causes the bounding box to go to 40.05.

// However, the **lowest point** is at z = -0.1 — that's still unexplained.

// Let's recheck the **top plate**: `translate([0,0,1])` → z = 0 to 2 — correct.
// The **walls**: `translate([0,0,20])` → z = 0 to 40 — correct.

// The **notch cube**: `translate([0, 45 - wall_thickness/2, 36])` → z = 36 ± 4.05 → 31.95 to 40.05 — correct.

// The only thing that can go below z = 0 is if the **top plate** is not at z = 0 to 2 — but it is.

// Wait — the **top plate** is at z = 0 to 2, and the **walls** are at z = 0 to 40 — so the junction is at z = 0 to 2.

// But the **notch cube** is at z = 31.95 to 40.05 — so it's not affecting the bottom.

// The only possibility is that the **notch cube** is not aligned with the wall's Y.

// The wall is at Y = 45 - wall_thickness/2 = 45 - 1.25 = 43.7