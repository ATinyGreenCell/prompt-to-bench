// Hotplate stirrer knob with 6mm D-shaft replacement

// === DIMENSIONS ===
knob_diameter = 30;        // Outer diameter (mm)
knob_height = 15;          // Height (mm)
d_diameter = 6.2;          // D-shaft circle diameter (mm)
d_radius = d_diameter / 2; // 3.1 mm
d_hole_depth = 12;         // D-hole depth from bottom (mm)
d_flat_distance = 1.6;     // Distance from flat to opposite edge (mm)
grip_grooves = 18;         // Number of grip grooves
groove_diameter = 2;       // Grip groove diameter (mm)
groove_radius = groove_diameter / 2; // 1 mm
indicator_width = 1.5;     // Top indicator groove width (mm)
indicator_depth = 1;       // Top indicator groove depth (mm)

$fn = 64;

difference() {
    // === MAIN BODY ===
    cylinder(h = knob_height, r = knob_diameter / 2);
    
    // === D-SHAPED HOLE ===
    // Cylindrical part of D
    cylinder(h = d_hole_depth + 0.5, r = d_radius);
    
    // Flat side of D (positioned to cut the entire hole depth)
    // Top edge at y = -1.6, bottom edge at y = -3.1
    // Centered at z = d_hole_depth/2 to extend from z = -0.5 to z = 12.5
    translate([0, -2.35, d_hole_depth / 2])
        cube([d_diameter, 1.5, d_hole_depth + 1], center = true);
    
    // === GRIP GROOVES (18 vertical half-cylinders around circumference) ===
    for (i = [0:grip_grooves - 1]) {
        angle = i * 360 / grip_grooves;
        rotate([0, 0, angle]) {
            translate([knob_diameter / 2, 0, knob_height / 2]) {
                // Create half-cylinder by removing half of a full cylinder
                difference() {
                    cylinder(h = knob_height + 1, r = groove_radius, center = true);
                    // Remove top half to create half-cylinder
                    translate([0, -groove_radius / 2, 0])
                        cube([groove_radius * 3, groove_radius, knob_height + 2], center = true);
                }
            }
        }
    }
    
    // === INDICATOR GROOVE (on top surface) ===
    // 1.5 mm wide, 1 mm deep, radial groove from center to edge
    // Oriented toward the flat side of D (negative Y direction)
    translate([0, -knob_diameter / 2 / 2, knob_height - indicator_depth / 2])
        cube([indicator_width, knob_diameter / 2, indicator_depth], center = true);
}