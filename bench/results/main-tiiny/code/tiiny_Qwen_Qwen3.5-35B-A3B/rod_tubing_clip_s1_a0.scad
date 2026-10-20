// Units: millimetres
// Print orientation: Flat on XY plane (Z=0), builds upward (+Z)
// Part: Snap-on clip for 12.7mm rod + 6mm tubing

// --- Dimensions ---
// Rod dimensions
rod_diameter = 12.7;
rod_wall_thickness = 3;
rod_outer_diameter = rod_diameter + 2 * rod_wall_thickness;

// Tubing dimensions
tubing_diameter = 6;
tubing_wall_thickness = 2;
tubing_outer_diameter = tubing_diameter + 2 * tubing_wall_thickness;

// Bridge dimensions
bridge_width = 6;
bridge_x_start = 8;
bridge_x_end = 12;

// Clip height (extrusion depth)
clip_height = 10;

// --- Geometry Construction ---

// 1. Rod Ring (Centered at origin)
// Outer diameter: 18.7mm, Inner diameter: 12.7mm
// Cut out: x < 0 AND -5 < y < 5
rod_ring = difference() {
    // Main ring
    cylinder(d = rod_outer_diameter, h = clip_height, center = true);
    // Hole for rod
    cylinder(d = rod_diameter, h = clip_height + 0.01, center = true);
    // Cutout for snapping onto rod
    translate([-5, 0, 0])
        cube([10, 10, clip_height + 0.01], center = true);
}

// 2. Tubing Ring (Centered at x=15, y=0)
// Outer diameter: 10mm, Inner diameter: 6mm
// Cut out: x > 15 AND -2.25 < y < 2.25
tubing_ring = difference() {
    // Main ring
    translate([15, 0, 0])
        cylinder(d = tubing_outer_diameter, h = clip_height, center = true);
    // Hole for tubing
    translate([15, 0, 0])
        cylinder(d = tubing_diameter, h = clip_height + 0.01, center = true);
    // Cutout for tubing insertion
    translate([15 + 5, 0, 0])
        cube([10, 4.5, clip_height + 0.01], center = true);
}

// 3. Solid Bridge (Connects rings)
// Width 6mm (Y), X from 8 to 12
// Must not block the holes.
// Rod hole center: (0,0), radius 6.35. Bridge Y range: -3 to 3. Safe.
// Tubing hole center: (15,0), radius 3. Bridge Y range: -3 to 3. Safe.
bridge = translate([10, 0, 0])
    cube([4, 6, clip_height], center = true);

// Final Union
part = union() {
    rod_ring;
    tubing_ring;
    bridge;
}

// Render
render() {
    part;
}