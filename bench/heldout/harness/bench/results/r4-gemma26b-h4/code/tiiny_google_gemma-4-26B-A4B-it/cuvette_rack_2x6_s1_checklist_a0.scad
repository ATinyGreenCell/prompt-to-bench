// Cuvette Rack for 12 standard 12.5mm square cuvettes
// Designed for FDM printing, standing on the base plate.

// --- Dimensions ---
base_x      = 112.0;   // Base plate length (X)
base_y      = 44.0;    // Base plate width (Y)
base_z      = 3.0;     // Base plate thickness
deck_z_min  = 22.0;    // Bottom of deck plate (Z)
deck_z_max  = 25.0;    // Top of deck plate (Z)
wall_thick  = 3.0;     // Thickness of end walls
rib_thick   = 2.5;     // Thickness of internal ribs
wall_height = 25.0;    // Total height of walls

// Hole dimensions
hole_size   = 13.0;    // Square hole size (X and Y)
hole_pitch  = 18.0;    // Center-to-center distance for holes (X and Y)
rows        = 2;       // Number of rows (Y direction)
cols        = 6;       // Number of columns (X direction)

// Rib positions (X coordinates)
rib_x_pos   = [-36, -18, 0, 18, 36];

$fn = 64;

// --- Helper Modules ---

module base_plate() {
    translate([-base_x/2, -base_y/2, 0])
        cube([base_x, base_y, base_z]);
}

module deck_plate() {
    translate([-base_x/2, -base_y/2, deck_z_min])
        cube([base_x, base_y, deck_z_max - deck_z_min]);
}

module end_wall() {
    // Flush with short ends (Y direction)
    cube([wall_thick, base_y, wall_height]);
}

module rib() {
    // Centered ribs
    cube([rib_thick, base_y, wall_height]);
}

module hole() {
    // Square through-hole for the cuvette
    // We use a small offset to ensure it cuts through the deck cleanly
    translate([-hole_size/2, -hole_size/2, deck_z_min - 0.1])
        cube([hole_size, hole_size, (deck_z_max - deck_z_min) + 0.2]);
}

// --- Main Assembly ---

difference() {
    // Positive Geometry
    union() {
        base_plate();
        deck_plate();
        
        // End walls (flush with short ends)
        translate([base_x/2 - wall_thick, -base_y/2, 0]) end_wall();
        translate([-base_x/2, -base_y/2, 0]) end_wall();
        
        // Internal ribs
        for (x_pos = rib_x_pos) {
            translate([x_pos - rib_thick/2, -base_y/2, 0]) rib();
        }
    }

    // Negative Geometry (Holes in the deck)
    // Calculate starting position to center the grid of holes on the deck
    // The grid is (cols-1)*pitch wide. 
    // Offset = (Total Width / 2) - (Grid Width / 2)
    grid_width_x = (cols - 1) * hole_pitch;
    grid_width_y = (rows - 1) * hole_pitch;
    
    start_x = (-grid_width_x / 2) + (hole_pitch / 2); // Error in logic? No, let's use the loop below.
    
    // Corrected centering logic:
    // The center of the first hole in the grid should be at:
    // (Center of plate) - (Total distance from center to first hole center)
    // Total distance from center to first hole center = (cols-1)*pitch / 2
    
    for (i = [0 : cols - 1]) {
        for (j = [0 : rows - 1]) {
            // Calculate center of current hole relative to origin
            cx = (i - (cols - 1) / 2) * hole_pitch;
            cy = (j - (rows - 1) / 2) * hole_pitch;
            
            translate([cx, cy, 0]) hole();
        }
    }
}