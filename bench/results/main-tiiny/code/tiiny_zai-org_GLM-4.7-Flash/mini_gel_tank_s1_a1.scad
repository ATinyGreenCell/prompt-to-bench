// Buffer Tank for Mini Horizontal Gel-Electrophoresis Box
// Units: mm

// --- Dimensions ---
tank_outer_x = 120;  // Outer length
tank_outer_y = 70;   // Outer width
tank_outer_z = 40;   // Outer height
wall_thickness = 3;  // Thickness of walls and floor
hole_diameter = 2;   // Diameter for electrode wires
hole_z_pos = 30;     // Height of electrode holes
platform_x_len = 60; // Length of the raised platform
platform_height = 10;// Height of the raised platform
inner_floor_z = 3;   // Height of the inner floor (wall thickness)

// Derived Dimensions
tank_inner_x = tank_outer_x - (2 * wall_thickness);
tank_inner_y = tank_outer_y - (2 * wall_thickness);
tank_inner_z = tank_outer_z - wall_thickness; // Top is open

platform_x_offset = (tank_outer_x - platform_x_len) / 2;
platform_z_pos = inner_floor_z + platform_height;

// --- Rendering ---
$fn = 64;

// 1. Base and Walls (Outer Shell)
union() {
    // Floor
    translate([0, 0, 0])
    cube([tank_outer_x, tank_outer_y, wall_thickness], center=false);
    
    // Side Walls (Left, Right, Front, Back)
    // Left Wall
    translate([0, 0, wall_thickness])
    cube([wall_thickness, tank_outer_y, tank_inner_z], center=false);
    
    // Right Wall
    translate([tank_outer_x - wall_thickness, 0, wall_thickness])
    cube([wall_thickness, tank_outer_y, tank_inner_z], center=false);
    
    // Front Wall
    translate([wall_thickness, 0, wall_thickness])
    cube([tank_inner_x, wall_thickness, tank_inner_z], center=false);
    
    // Back Wall
    translate([wall_thickness, tank_outer_y - wall_thickness, wall_thickness])
    cube([tank_inner_x, wall_thickness, tank_inner_z], center=false);
}

// 2. Inner Void (The Tank Cavity)
// We subtract the inner space from the outer shell.
difference() {
    union() {
        // Floor
        translate([wall_thickness, wall_thickness, 0])
        cube([tank_inner_x, tank_inner_y, wall_thickness], center=false);
        
        // Side Walls (Left, Right, Front, Back)
        // Left Wall
        translate([wall_thickness, wall_thickness, wall_thickness])
        cube([wall_thickness, tank_inner_y, tank_inner_z], center=false);
        
        // Right Wall
        translate([tank_outer_x - (2 * wall_thickness), wall_thickness, wall_thickness])
        cube([wall_thickness, tank_inner_y, tank_inner_z], center=false);
        
        // Front Wall
        translate([wall_thickness, wall_thickness, wall_thickness])
        cube([tank_inner_x, wall_thickness, tank_inner_z], center=false);
        
        // Back Wall
        translate([wall_thickness, tank_outer_y - (2 * wall_thickness), wall_thickness])
        cube([tank_inner_x, wall_thickness, tank_inner_z], center=false);
    }
    
    // Inner Void
    translate([wall_thickness, wall_thickness, wall_thickness])
    cube([tank_inner_x, tank_inner_y, tank_inner_z], center=false);
}

// 3. Raised Platform
// The platform is a solid block that sits inside the void.
translate([platform_x_offset, wall_thickness, platform_z_pos])
cube([platform_x_len, tank_inner_y, wall_thickness], center=false);

// 4. Electrode Holes
// We drill holes through the front and back walls.
// We extend the drill bit slightly past the face to ensure clean cuts.
drill_depth = 5; // How far the drill bit extends past the wall face

// Front Wall Holes
for (i = [-1, 1]) {
    translate([wall_thickness + (tank_inner_x / 2), wall_thickness, hole_z_pos])
    cylinder(h = wall_thickness + drill_depth, d = hole_diameter, center = true);
}

// Back Wall Holes
for (i = [-1, 1]) {
    translate([wall_thickness + (tank_inner_x / 2), tank_outer_y - wall_thickness, hole_z_pos])
    cylinder(h = wall_thickness + drill_depth, d = hole_diameter, center = true);
}