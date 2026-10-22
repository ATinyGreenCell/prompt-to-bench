// --- Parameters ---
puck_diameter = 80;          // Diameter of the main puck
puck_height = 26;            // Total height of the puck
label_cut_x = 34;            // The X coordinate where the side is cut flat

tube_hole_diameter = 11.2;   // Diameter of the tube hole
tube_seat_radius = tube_hole_diameter / 2;
tube_depth_total = 20;       // Depth from top face to the bottom of the hemisphere
tube_center_circle_dia = 50; // Diameter of the circle where tubes are placed
num_tubes = 8;               // Number of tube seats

// --- Constants ---
$fn = 64;

// --- Calculations ---
puck_radius = puck_diameter / 2;
tube_center_radius = tube_center_circle_dia / 2;

// The user specified:
// 1. Top face is at Z = 26.
// 2. Lowest point of the seat is at Z = 6.
// 3. Total depth of seat is 20mm (26 - 6 = 20).
// 4. The bottom is a half-sphere of diameter 11.2.
//    A half-sphere (hemisphere) with diameter 11.2 has a radius of 5.6.
//    If the bottom of the hemisphere is at Z = 6, the center of the sphere must be at Z = 6 + 5.6 = 11.6.
//    The cylindrical part of the hole must then extend from the top (Z = 26) down to the sphere center (Z = 11.6).
//    Cylinder height = 26 - 11.6 = 14.4.

// --- Main Model ---
difference() {
    // The main puck body
    // Centered on XY, resting on Z=0
    cylinder(h = puck_height, d = puck_diameter, center = false);

    // The label cut (removes everything beyond x = 34)
    // We extend the cube in X, Y, and Z to ensure a clean cut
    translate([label_cut_x, -puck_radius - 1, -1])
        cube([puck_radius + 2, puck_radius * 2 + 2, puck_height + 2]);

    // The eight tube seats
    for (i = [0 : num_tubes - 1]) {
        // Calculate angle: first tube on +X axis (0 degrees)
        angle = i * (360 / num_tubes);
        
        // Position of the tube center
        tx = tube_center_radius * cos(angle);
        ty = tube_center_radius * sin(angle);
        
        // Position the seat at the top face (Z=26)
        translate([tx, ty, 26]) {
            // 1. The cylindrical hole
            // Extends from Z=26 down to the sphere center at Z=11.6
            // We use a slightly larger height to ensure it cuts through the top face
            cylinder(h = 14.4 + 0.1, d = tube_hole_diameter);
            
            // 2. The hemispherical bottom
            // The sphere is centered at Z = 11.6 relative to the origin.
            // Relative to the translate([0,0,26]), the center is at Z = 11.6 - 26 = -14.4.
            // However, to make the bottom of the sphere sit at Z=6, 
            // the center of the sphere must be at Z = 6 + 5.6 = 11.6.
            // Relative to the translate([0,0,26]), the center is at 11.6 - 26 = -14.4.
            // Let's re-verify: 
            // Top = 26. 
            // Sphere center = 11.6. 
            // Sphere bottom = 11.6 - 5.6 = 6.0. (Correct)
            // Sphere top = 11.6 + 5.6 = 17.2.
            // Cylinder must cover from Z=26 down to Z=11.6.
            
            translate([0, 0, -14.4])
                sphere(d = tube_hole_diameter);
        }
    }
}