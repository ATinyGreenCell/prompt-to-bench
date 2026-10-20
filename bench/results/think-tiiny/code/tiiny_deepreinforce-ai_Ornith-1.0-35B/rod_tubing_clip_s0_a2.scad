$fn = 64;

// Rod ring parameters
rod_id = 12.7;              // Rod inner diameter (mm)
rod_wall = 3;               // Rod ring wall thickness (mm)
rod_od = rod_id + 2 * rod_wall; // Rod ring outer diameter (mm)

// Tubing ring parameters
tube_id = 6;                // Tubing inner diameter (mm)
tube_wall = 2;              // Tubing ring wall thickness (mm)
tube_od = tube_id + 2 * tube_wall; // Tubing ring outer diameter (mm)

// Bridge parameters
bridge_x_start = 8;         // Bridge start X (mm)
bridge_x_end = 12;          // Bridge end X (mm)
bridge_width_y = 6;         // Bridge width in Y (mm)
bridge_x_mid = (bridge_x_start + bridge_x_end) / 2;

// Opening parameters
rod_opening_y_half = 5;     // Half-width of rod ring opening in Y (mm)
tube_opening_y_half = 2.25; // Half-width of tubing ring opening in Y (mm)

// Extrusion height
extrude_height = 10;       // Print height / extrusion depth (mm)

// 2D Profile construction
rod_ring = difference() {
    circle(r = rod_od / 2);
    circle(r = rod_id / 2);
};

tube_ring = difference() {
    translate([15, 0]) circle(r = tube_od / 2);
    translate([15, 0]) circle(r = tube_id / 2);
};

bridge = translate([bridge_x_mid, 0]) square([bridge_x_end - bridge_x_start, bridge_width_y], center = true);

profile = union() {
    rod_ring;
    tube_ring;
    bridge;
};

// Openings (extended past the rings to ensure clean cuts)
rod_opening = translate([-50, 0]) square([100, rod_opening_y_half * 2], center = true);
tube_opening = translate([50, 0]) square([100, tube_opening_y_half * 2], center = true);

final_profile = difference() {
    profile;
    rod_opening;
    tube_opening;
};

// Extrude to 3D
linear_extrude(height = extrude_height) {
    final_profile;
}