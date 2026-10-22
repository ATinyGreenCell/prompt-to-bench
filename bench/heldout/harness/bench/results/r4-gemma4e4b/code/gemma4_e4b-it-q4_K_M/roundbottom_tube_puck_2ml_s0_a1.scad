// --- Dimensions in mm ---

// Overall holder dimensions
holder_diameter = 80;      // Diameter of the main puck (XY plane)
holder_height = 26;        // Total height of the holder
cut_plane_x = 34;          // X coordinate where one side is cut off for labeling

// Tube seat dimensions
tube_hole_diameter = 11.2; // Diameter of the tube hole
tube_hole_radius = tube_hole_diameter / 2;
seat_center_circle_diameter = 50; // Diameter of the circle where seats are centered
seat_center_radius = seat_center_circle_diameter / 2;

// Seat depth and shape
lowest_point_z = 6;                  // Z coordinate of the lowest point of the seat bottom (Must be 6 mm)
half_sphere_height = tube_hole_radius; // Height of the half-sphere cut (matches hole radius)

// Derived geometry based on constraints:
// The top surface is at z = holder_height (26 mm).
// The lowest point must be at z = 6 mm. Depth = 20 mm.
// Center of sphere = Lowest Point + Radius
Z_center_sphere = lowest_point_z + tube_hole_radius; // 6 + 5.6 = 11.6 mm

// --- Constants ---
$fn = 100; // High resolution for curves

// --- Main Body ---
module holder_body() {
    difference() {
        // 1. Base Puck (Cylinder)
        cylinder(h = holder_height, r = holder_diameter / 2, center = false);

        // 2. Cut side for label (Plane at x=34). Extend slightly past the body to ensure clean cut.
        translate([cut_plane_x + 0.1, -holder_diameter/2 - 0.1, -0.1])
        cube([0.2, holder_diameter + 0.2, holder_height + 0.2]);
    }
}

// --- Seat Module ---
module tube_seat(center_x, center_y) {
    difference() {
        // 1. Cylindrical Hole (to define the opening and depth). Must cut through the entire height for subtraction to work correctly across Z.
        translate([center_x, center_y, -0.1])
        cylinder(h = holder_height + 0.2, r = tube_hole_radius, center = false);

        // 2. Spherical Cut (to form the bottom). Center is at Z_center_sphere relative to z=0 plane.
        translate([center_x, center_y, Z_center_sphere])
        sphere(r = tube_hole_radius);
    }
}

// --- Assembly ---
module holder() {
    difference() {
        // Start with the main body (Puck + Cut)
        holder_body();

        // Subtract all 8 seats
        for (i = [0 : 7]) {
            // Calculate angle: 360 / 8 = 45 degrees per seat. First one at +X axis (angle 0).
            angle = i * 45;
            
            // Polar to Cartesian coordinates for the center of the seat
            seat_x = seat_center_radius * cos(angle);
            seat_y = seat_center_radius * sin(angle);

            // Subtract the seat geometry
            tube_seat(seat_x, seat_y);
        }
    }
}

holder();