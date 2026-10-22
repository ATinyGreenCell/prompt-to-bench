// Coarse Cell Strainer for 50 mL Conical Tube
// Designed to hang in the mouth of a 50 mL tube, printed upright.

// --- Dimensions (measured with calipers) ---
OD_cup = 25;           // Outer diameter of the main cup body
wall = 1.2;            // Wall thickness
ID_cup = OD_cup - 2*wall; // Inner diameter (bore) = 22.6 mm
H_cup = 32;            // Total height of the cup structure
H_floor = 1.2;         // Thickness of the floor
H_flare_start = 26;    // Height where the flare begins
H_flare_end = 30;      // Height where the flare ends (rim starts)
D_flare_top = 33;      // Outer diameter of the rim
H_rim = H_cup - H_flare_end; // Height of the vertical rim section = 2 mm

// Hole grid parameters
hole_d = 1.0;          // Diameter of floor holes
grid_spacing = 2;      // Spacing of the square grid
grid_radius = 10;      // Max distance from center for hole centers

// Vent notch parameters
notch_w = 3;           // Width of the vent notch (total width)
notch_dist = 12.5;     // Distance from axis where notch starts (half of OD)
notch_z_start = 25;    // Height where notches begin

// --- Rendering Settings ---
$fn = 64;              // Resolution for curved shapes

// --- Main Structure ---
difference() {
    union() {
        // 1. Main Cup Body (Tube)
        // Outer cylinder
        cylinder(h = H_cup, r = OD_cup/2, center = false);
        
        // 2. Flare (Cone)
        // From z=26 (r=12.5) to z=30 (r=16.5)
        rotate_extrude($fn=64) {
            polygon(points = [
                [OD_cup/2, H_flare_start],
                [D_flare_top/2, H_flare_end],
                [D_flare_top/2, H_flare_end], 
                [OD_cup/2, H_flare_start]
            ]);
        }
        
        // 3. Rim (Vertical cylinder on top of flare)
        translate([0, 0, H_flare_end]) {
            cylinder(h = H_rim, r = D_flare_top/2, center = false);
        }
    }
    
    // --- Subtractions ---
    
    // 1. Inner Bore (Hollow out the cup)
    translate([0, 0, -0.1]) {
        cylinder(h = H_cup + 0.2, r = ID_cup/2, center = false);
    }
    
    // 2. Floor Holes
    // 81 holes (9x9 grid), indices -4 to 4
    for (x = [-4, -3, -2, -1, 0, 1, 2, 3, 4]) {
        for (y = [-4, -3, -2, -1, 0, 1, 2, 3, 4]) {
            translate([x * grid_spacing, y * grid_spacing, -0.1]) {
                cylinder(h = H_floor + 0.2, r = hole_d/2, center = false);
            }
        }
    }
    
    // 3. Vent Notches
    // +X Notch
    translate([notch_dist, 0, notch_z_start - 0.1]) {
        cube([notch_w, D_flare_top + 1, H_cup - notch_z_start + 0.2], center = false);
    }
    
    // -X Notch
    translate([-notch_dist - notch_w, 0, notch_z_start - 0.1]) {
        cube([notch_w, D_flare_top + 1, H_cup - notch_z_start + 0.2], center = false);
    }
}