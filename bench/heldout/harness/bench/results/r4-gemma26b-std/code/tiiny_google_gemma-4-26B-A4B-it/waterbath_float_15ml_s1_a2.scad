// --- Dimensions ---
plate_thickness = 3;            // Thickness of the hexagonal plate
hex_across_flats = 90;           // Distance between parallel sides of the plate
hex_skirt_across_flats = 84;     // Distance between parallel sides of the skirt
skirt_wall_thickness = 2;        // Thickness of the hexagonal skirt wall
skirt_height_total = 20;         // Total height of the part (Z=0 to Z=20)

hole_diameter = 17.5;            // Diameter of the conical tube holes
hole_spacing_diameter = 54;      // Diameter of the circle on which holes are placed
sleeve_outer_diameter = 21.5;    // Outside diameter of the sleeves
sleeve_height_total = 20;        // Total height of the sleeves (Z=0 to Z=20)

// --- Constants ---
$fn = 64;

// Helper function to calculate the radius of a regular hexagon from across-flats distance
// Radius (to vertex) = (across_flats / 2) / cos(30)
function hex_radius(across_flats) = (across_flats / 2) / cos(30);

// --- Construction Logic ---
// The part is built as a single solid by unioning the plate, sleeves, and skirt,
// then subtracting the holes and the inner void of the skirt.

difference() {
    // 1. THE SOLID MASS
    union() {
        // The Hexagonal Plate (Z=0 to Z=3)
        // Rotate 30 degrees so that two flats are parallel to the X axis.
        rotate([0, 0, 30])
        cylinder(h = plate_thickness, r = hex_radius(hex_across_flats), $fn = 6);

        // The Sleeves (Z=3 to Z=20)
        // Center sleeve
        cylinder(h = skirt_height_total - plate_thickness, d = sleeve_outer_diameter);
        
        // 6 Peripheral sleeves
        for (a = [0 : 60 : 300]) {
            rotate([0, 0, a])
            translate([hole_spacing_diameter / 2, 0, plate_thickness])
            cylinder(h = skirt_height_total - plate_thickness, d = sleeve_outer_diameter);
        }

        // The Hexagonal Skirt (Z=3 to Z=20)
        // Outer shell: 84mm across flats
        rotate([0, 0, 30])
        cylinder(h = skirt_height_total - plate_thickness, r = hex_radius(hex_skirt_across_flats), $fn = 6);
    }

    // 2. THE SUBTRACTIONS
    
    // A. The 7 Holes (through the plate and through the sleeves)
    // Center hole
    translate([0, 0, -0.01])
    cylinder(h = skirt_height_total + 0.02, d = hole_diameter);
    
    // 6 Peripheral holes
    for (a = [0 : 60 : 300]) {
        rotate([0, 0, a])
        translate([hole_spacing_diameter / 2, 0, -0.01])
        cylinder(h = skirt_height_total + 0.02, d = hole_diameter);
    }

    // B. The Skirt Inner Void (to create the 2mm wall)
    // The skirt is 84mm across flats. The inner void is 84 - (2 * 2) = 80mm across flats.
    // This void starts at the plate (Z=3) and goes to the top (Z=20).
    translate([0, 0, plate_thickness])
    rotate([0, 0, 30])
    cylinder(h = skirt_height_total - plate_thickness + 0.01, r = hex_radius(hex_skirt_across_flats - 2 * skirt_wall_thickness), $fn = 6);
}