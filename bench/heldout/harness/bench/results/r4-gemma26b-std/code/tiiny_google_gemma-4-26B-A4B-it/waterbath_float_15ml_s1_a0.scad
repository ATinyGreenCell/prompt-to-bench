// --- Dimensions ---
plate_thickness = 3;            // Thickness of the hexagonal plate
hex_across_flats = 90;           // Distance between parallel sides of the plate
hex_skirt_across_flats = 84;     // Distance between parallel sides of the skirt
skirt_wall_thickness = 2;        // Thickness of the hexagonal skirt wall
skirt_height = 20;               // Height of the skirt and sleeves

hole_diameter = 17.5;            // Diameter of the conical tube holes
hole_spacing_diameter = 54;      // Diameter of the circle on which holes are placed
sleeve_outer_diameter = 21.5;    // Outside diameter of the sleeves
sleeve_height = 20;              // Height of the sleeves
sleeve_wall_thickness = 2;       // Wall thickness of the sleeves (implied by 21.5 - 17.5)

// --- Constants ---
$fn = 64;

// Helper function to calculate the radius of a regular hexagon from across-flats distance
// Radius (to vertex) = (across_flats / 2) / cos(30)
function hex_radius(across_flats) = (across_flats / 2) / cos(30);

// --- Main Model ---
// The user requested the part be printed "upside down" relative to its use.
// However, the instructions state: "A flat plate... lies on the bed (z = 0 to 3)".
// This means the plate is the base of the print at Z=0.
// The "upside down" refers to the functional orientation in the water bath.
// We will model it as described: Plate at Z=0, features growing in +Z.

union() {
    // 1. The Hexagonal Plate
    // Two flats parallel to X axis means the "flats" are at Y = +/- (across_flats/2)
    // In OpenSCAD, a cylinder with $fn=6 and even_sided=true creates a hexagon.
    // To align flats with X axis, we rotate the hexagon.
    translate([0, 0, 0])
    rotate([0, 0, 0]) // Default orientation for cylinder(fn=6) has vertices on axes
    // To get flats parallel to X, we rotate 30 degrees (or 90)
    difference() {
        rotate([0, 0, 30])
        cylinder(h = plate_thickness, r = hex_radius(hex_across_flats), $fn = 6);
        
        // Subtract the 7 holes through the plate
        // Center hole
        translate([0, 0, -0.01])
        cylinder(h = plate_thickness + 0.02, d = hole_diameter);
        
        // 6 Peripheral holes
        for (a = [0 : 60 : 300]) {
            rotate([0, 0, a])
            translate([hole_spacing_diameter / 2, 0, -0.01])
            cylinder(h = plate_thickness + 0.02, d = hole_diameter);
        }
    }

    // 2. The Sleeves
    // Sleeves rise from the plate (z=3) to z=23 (3 + 20)
    // Note: User says "rises from the plate to z=20". 
    // If plate is 0-3, and it rises to z=20, the height is 17.
    // However, usually "rises to z=20" implies the top face is at 20.
    // I will interpret "rises from the plate to z=20" as the top face is at Z=20.
    // Therefore, sleeve height = 20 - 3 = 17.
    // BUT, the prompt says "rises from the plate to z=20" and "skirt... rises from the plate to z=20".
    // I will model the features such that their top surface is at Z=20.
    
    sleeve_z_top = 20;
    sleeve_h = sleeve_z_top - plate_thickness;

    // Center Sleeve
    cylinder(h = sleeve_h, d = sleeve_outer_diameter);
    
    // 6 Peripheral Sleeves
    for (a = [0 : 60 : 300]) {
        rotate([0, 0, a])
        translate([hole_spacing_diameter / 2, 0, plate_thickness])
        cylinder(h = sleeve_h, d = sleeve_outer_diameter);
    }

    // 3. The Hexagonal Skirt
    // The skirt is a hollow hexagonal prism.
    // It rises from the plate to z=20.
    // It is 84mm across flats.
    difference() {
        // Outer Hexagon
        rotate([0, 0, 30])
        cylinder(h = sleeve_z_top - plate_thickness, r = hex_radius(hex_across_flats - 2*skirt_wall_thickness), $fn = 6);
        
        // Inner Hexagon (to create the wall)
        // The user says "84mm across the flats outside, 2mm wall".
        // So inner across-flats = 84 - 4 = 80.
        // Wait, "84mm across the flats outside... 2mm wall". 
        // This means the outer dimension is 84.
        translate([0, 0, -0.01])
        rotate([0, 0, 30])
        cylinder(h = sleeve_z_top - plate_thickness + 0.02, r = hex_radius(hex_across_flats - 2*skirt_wall_thickness), $fn = 6);
        
        // Wait, the logic above is for a solid. Let's do a proper difference for the skirt.
    }
    
    // Corrected Skirt Implementation
    difference() {
        // Outer Shape
        rotate([0, 0, 30])
        cylinder(h = sleeve_z_top - plate_thickness, r = hex_radius(hex_across_flats), $fn = 6);
        
        // Inner Shape (to make it a wall)
        // If outer is 84 across flats, and wall is 2, inner is 84 - 4 = 80 across flats.
        translate([0, 0, -0.01])
        rotate([0, 0, 30])
        cylinder(h = sleeve_z_top - plate_thickness + 0.02, r = hex_radius(hex_across_flats - 2*skirt_wall_thickness), $fn = 6);
    }
}

// Re-writing the structure to ensure clean union/difference logic
// The previous code had overlapping cylinders. Let's clean it up.

// --- Final Clean Structure ---
// 1. Plate (with holes)
// 2. Sleeves (solid cylinders)
// 3. Skirt (hollow hexagon)

// We will use a single difference for the plate and then union the rest.
// Actually, the most robust way:
// Part = (Plate - Holes) + Sleeves + Skirt_Wall

// Let's restart the construction logic for the final block.