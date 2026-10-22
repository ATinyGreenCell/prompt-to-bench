// Dimensions (mm)
puck_diameter = 80;
puck_radius = puck_diameter / 2;
puck_height = 26;
label_cut_x = 34; // Everything beyond x = 34 is removed

// Tube seat dimensions
seat_diameter = 11.2;
seat_radius = seat_diameter / 2;
seat_circle_diameter = 50;
seat_circle_radius = seat_circle_diameter / 2;
num_seats = 8;
seat_depth = 20; // Depth from top face to lowest point of half-sphere
top_z = puck_height;

// Derived values
half_sphere_depth = seat_radius; // Depth of the hemispherical bottom
cylindrical_part_depth = seat_depth - half_sphere_depth; // Depth of the cylindrical part above the hemisphere

// Quality
$fn = 64;

// Main puck body
difference() {
    // Base cylinder
    translate([0, 0, 0])
        cylinder(h = puck_height, r = puck_radius, center = false);
    
    // Label cut: remove everything beyond x = label_cut_x
    // We create a large box that covers the region x > label_cut_x
    translate([label_cut_x, -puck_radius - 1, -1])
        cube([puck_radius + 1, 2 * puck_radius + 2, puck_height + 2]);
    
    // Tube seats
    for (i = [0 : num_seats - 1]) {
        angle = i * (360 / num_seats);
        // Position on the circle
        x = seat_circle_radius * cos(angle);
        y = seat_circle_radius * sin(angle);
        
        translate([x, y, 0]) {
            // Cylindrical part of the seat
            // Starts from top_z and goes down to (top_z - seat_depth + half_sphere_depth)
            // The cylinder extends slightly past to ensure clean cut
            translate([0, 0, top_z])
                cylinder(h = cylindrical_part_depth + 1, r = seat_radius, center = false);
            
            // Hemispherical bottom
            // The hemisphere is centered at z = top_z - seat_depth + half_sphere_depth
            // We use a sphere and translate it so its bottom is at the correct depth
            translate([0, 0, top_z - seat_depth + half_sphere_depth])
                sphere(r = seat_radius);
        }
    }
}