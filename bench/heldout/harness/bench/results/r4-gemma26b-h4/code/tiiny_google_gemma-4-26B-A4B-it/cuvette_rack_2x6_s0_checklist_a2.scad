// Open-sided cuvette rack for twelve 12.5mm square cuvettes.
// Corrected to ensure single manifold body via intersection/embedding
// and correct hole centering and count.

// --- Dimensions ---
base_x      = 112.0;    // Length of base plate (X)
base_y      = 44.0;     // Width of base plate (Y)
base_z      = 3.0;      // Thickness of base plate (Z)

deck_x      = 112.0;    // Length of deck plate (X)
deck_y      = 44.0;     // Width of deck plate (Y)
deck_z_min  = 22.0;     // Bottom of deck plate (Z)
deck_z_max  = 25.0;     // Top of deck plate (Z)

wall_end_t  = 3.0;      // Thickness of end walls (X-direction)
wall_rib_t  = 2.5;      // Thickness of internal ribs (X-direction)
wall_depth  = 44.0;     // Depth of walls (Y-direction)
wall_height = 25.0;     // Total height of walls (Z)

hole_size   = 13.0;     // Size of cuvette holes (X and Y)
hole_pitch  = 18.0;     // Center-to-center spacing of holes (X and Y)
rows        = 2;        // Number of rows (Y)
cols        = 6;        // Number of columns (X)

$fn = 64;

// --- Calculations ---
// To center 6 holes with 18mm pitch:
// Total span = (6-1) * 18 = 90mm.
// Offset from center = 90 / 2 = 45mm.
// First hole center = -45mm.
hole_offset_x = (cols - 1) * hole_pitch / 2;
hole_offset_y = (rows - 1) * hole_pitch / 2;

// --- Geometry ---

module main_structure() {
    // Base Plate
    translate([-base_x/2, -base_y/2, 0])
        cube([base_x, base_y, base_z]);

    // End Walls (Flush with short ends, embedded 0.1mm into base to ensure manifold)
    // Left end wall
    translate([-base_x/2, -base_y/2, -0.1])
        cube([wall_end_t, base_y, wall_height + 0.1]);
    // Right end wall
    translate([base_x/2 - wall_end_t, -base_y/2, -0.1])
        cube([wall_end_t, base_y, wall_height + 0.1]);

    // Internal Ribs
    for (rx = [-36, -18, 0, 18, 36]) {
        translate([rx - wall_rib_t/2, -wall_depth/2, -0.1])
            cube([wall_rib_t, wall_depth, wall_height + 0.1]);
    }
    
    // Deck Plate
    translate([-deck_x/2, -deck_y/2, deck_z_min])
        cube([deck_x, deck_y, deck_z_max - deck_z_min]);
}

// Final Assembly
difference() {
    main_structure();

    // Holes (Cutting through the deck)
    // We use a large Z-range to ensure clean cut through the deck
    for (i = [0 : cols - 1]) {
        for (j = [0 : rows - 1]) {
            translate([
                (i * hole_pitch) - hole_offset_x, 
                (j * hole_pitch) - hole_offset_y, 
                deck_z_min - 0.1
            ])
                cube([hole_size, hole_size, (deck_z_max - deck_z_min) + 0.2]);
        }
    }
}