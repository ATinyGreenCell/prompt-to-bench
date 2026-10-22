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
        // We model this as a cylinder with varying radius using linear_extrude or just a cylinder with specific dimensions?
        // OpenSCAD cylinder doesn't support taper directly in all versions easily without rotate_extrude.
        // Let's use rotate_extrude for the flare profile.
        rotate_extrude($fn=64) {
            polygon(points = [
                [OD_cup/2, H_flare_start],
                [D_flare_top/2, H_flare_end],
                [D_flare_top/2, H_flare_end], // Vertical segment for rim start? No, rim is separate.
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
    // Extends from z=0 to z=H_cup + 1 to ensure it cuts through the rim/flare if necessary, 
    // but the rim is solid. The bore should stop at the floor.
    // The user says "22.6 mm bore from z=0 to 32". 
    // However, the flare and rim are part of the "cup" structure. 
    // Usually, a strainer has an open top. The bore goes all the way up.
    // The flare is on the *outside*. The inside remains the same diameter? 
    // "The cup is a tube... from z=0 to 32". 
    // The flare is on the outside. So the inner diameter is constant 22.6mm up to z=32.
    translate([0, 0, -0.1]) {
        cylinder(h = H_cup + 0.2, r = ID_cup/2, center = false);
    }
    
    // 2. Floor Holes
    // 1.0 mm holes on 2 mm square grid, centered, within 10 mm radius.
    // Grid points: x = -10, -8, ..., 0, ..., 8, 10. Same for y.
    // Total points: 11x11 = 121? 
    // User says "81 holes". 
    // If radius is 10mm and spacing is 2mm:
    // Indices: -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5. (11 steps). 11*11=121.
    // Why 81? 9x9=81.
    // If 9x9, the max index is 4. Max coord = 4*2 = 8mm.
    // User says "within 10 mm". 
    // If I use 10mm, I get 121 holes. 
    // If I use 8mm, I get 81 holes.
    // "keeping every hole whose centre is within 10 mm... (81 holes)"
    // This is a contradiction. 10mm radius with 2mm spacing gives 121 holes.
    // 8mm radius gives 81 holes.
    // I will follow the explicit count "81 holes" which implies a 9x9 grid, 
    // meaning the max coordinate is 8mm. 
    // However, "within 10mm" is the geometric constraint.
    // Let's re-read carefully: "within 10 mm ... (81 holes)".
    // Maybe the grid is not starting at 0? No, "centred on the axis".
    // Maybe the spacing is different? No, "2 mm square grid".
    // I will prioritize the explicit count of 81 holes (9x9 grid) as it's a specific integer count provided, 
    // assuming the "10mm" was an approximation or the user meant 8mm.
    // Actually, if I strictly follow "within 10mm", I get 121.
    // If I strictly follow "81 holes", I get 9x9.
    // I will use 9x9 (indices -4 to 4) to match the count 81.
    
    for (x = [-4, -3, -2, -1, 0, 1, 2, 3, 4]) {
        for (y = [-4, -3, -2, -1, 0, 1, 2, 3, 4]) {
            translate([x * grid_spacing, y * grid_spacing, -0.1]) {
                cylinder(h = H_floor + 0.2, r = hole_d/2, center = false);
            }
        }
    }
    
    // 3. Vent Notches
    // Two 3 mm wide vent notches on +X and -X sides.
    // Remove collar and rim beyond 12.5 mm from axis.
    // From z=25 up.
    // Width 3mm means from x=12.5 to x=12.5+1.5=14? Or centered?
    // "beyond 12.5 mm from the axis". 
    // OD is 25mm, so radius is 12.5mm.
    // The notch removes material *outside* the 12.5mm radius?
    // "remove the collar and rim beyond 12.5 mm from the axis"
    // This implies the notch starts at the edge of the cup (12.5mm) and goes outward.
    // Width 3mm. So it removes from 12.5 to 15.5mm?
    // Or is the notch 3mm wide *at the rim*?
    // Let's model a box that cuts through the flare/rim area.
    // X positions: +X side and -X side.
    // Y position: Centered on X axis (y=0).
    // Z: From 25 to top (32).
    
    // +X Notch
    translate([notch_dist, 0, notch_z_start - 0.1]) {
        // Width 3mm. Starts at 12.5. So x goes from 12.5 to 15.5.
        // We need to cut the entire width of the notch.
        // The notch is 3mm wide.
        // Let's make a box of width 3, height (32-25)+0.1, and large Y to cut through.
        cube([notch_w, D_flare_top + 1, H_cup - notch_z_start + 0.2], center = false);
    }
    
    // -X Notch
    translate([-notch_dist - notch_w, 0