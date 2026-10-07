// Dimensions in mm
rod_inner = 12.7;
rod_wall = 3;
tube_inner = 6;
tube_wall = 2;
bridge_width = 6; // Y dimension of bridge

// Outer diameters
rod_outer = rod_inner + 2*rod_wall; // 18.7 mm
tube_outer = tube_inner + 2*tube_wall; // 10 mm

// Rod ring frame (extruded)
rod_frame = linear_extrude(
    {-rod_outer/2, -rod_outer/2, -rod_outer/2, rod_outer/2},
    {0, 10}
);

// Remove inner hole from rod ring
hole_rod = linear_extrude(
    {-5, 0, -5, 0, 0, 10},
    {0, 10}
);
rod_frame_no_hole = difference(rod_frame, hole_rod);

// Tube ring frame (extruded)
tube_frame = linear_extrude(
    {15 - tube_outer/2, 15 - tube_outer/2, -tube_outer/2, tube_outer/2},
    {0, 10}
);
// Remove inner hole from tube ring
hole_tube = linear_extrude(
    {15, 19.5, -2.25, 2.25},
    {0, 10}
);
tube_frame_no_hole = difference(tube_frame, hole_tube);

// Bridge (solid)
bridge = linear_extrude(
    {8, 12, -3, 3},
    {0, 10}
);

// Combine all parts
part = union([
    rod_frame_no_hole,
    tube_frame_no_hole,
    bridge
]);

show(part);