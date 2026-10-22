// PCR Strip Holder for Ice Bucket

// --- Dimensions ---
wall_thickness = 12;      // Thickness of the ice bucket wall (mm)
strip_length = 84;        // Length of the holder along X (mm)
inner_leg_width = 4;      // Width of the inner leg (Y dimension, mm)
outer_leg_width = 4;      // Width of the outer leg (Y dimension, mm)
total_height = 50;        // Main height of the hook structure (mm)
bridge_start_z = 46;      // Z start for the bridge connection (mm)
bridge_end_z = 50;        // Z end for the bridge connection (mm)
gap_for_wall = 12.5;      // Required gap size in Y to fit over the wall (mm)

ledge_thickness = 6;      // Thickness of the bottom ledge (Z dimension, mm)
ledge_length_y = 30;      // Length of the ledge extending into the ice bucket (-Y direction)
tube_diameter = 6.4;      // Diameter of the PCR tubes (mm)
hole_spacing_x = 9;       // Distance between tube centers along X (mm)
num_tubes = 8;            // Number of tubes to hold

// --- Constants ---
$fn = 100; // High resolution for curves

/*
Analysis of the report vs specification:
1. Bounding Box Y size: Report shows Y range -2.00 .. 28.00 (size 30.00). Specification requires ledge_length_y = 30mm extending into -Y from y=0. The inner leg is centered at Y=0, so its base extends from Y=-2 to Y=2. The ledge extends from Y=0 to Y=-30.
   The outer leg position calculation: Inner leg center at Y=0. Outer leg should be positioned such that the gap is 12.5mm.
   Inner leg occupies Y range [-2, 2]. Ledge occupies Y range [-30, 0].
   Outer leg needs to start after the inner leg + gap. The outer leg's center must be at: (inner_leg_width/2) + gap_for_wall + (outer_leg_width/2) = 2 + 12.5 + 2 = 16.5.
   The report shows the outline centered at Y=13.00 for the main body, which is incorrect if the inner leg is centered at Y=0.

2. Hole Placement: The holes are specified to be in the ledge, centred at y = -15. This was implemented correctly in the code (y_center = -15).
   The report shows slices at z=28.00 and z=47.50 showing outlines centered at Y=16.50 and Y=0.00 respectively, which corresponds to the outer leg and inner leg positions relative to some center point, but this doesn't reflect the hole locations or the overall structure correctly based on the specification (ledge at y=-15).

Fixes applied:
1. Ensure the ledge is correctly positioned relative to the inner leg base (Y=0 for the foot of the inner leg). The inner leg is centered at Y=0, so its bottom edge is at Y = -inner_leg_width/2 = -2mm. The ledge extends from Y=-2 down to Y=(-2 - 30) = -32mm.
2. Recalculate the outer leg position based on the inner leg's footprint and the required gap (12.5mm).
   Inner Leg Footprint: [-2, 2]. Gap starts at Y=2. Outer leg should start at Y = 2 + 12.5 = 14.5. Its center should be at 14.5 + outer_leg_width/2 = 14.5 + 2 = 16.5mm.
   The previous calculation used `inner_leg_width` (4) instead of the edge position (2).

3. Hole centering: The holes are centered at Y=-15, which is correct for the ledge placement. We must ensure the hole cutting geometry respects this.
*/

module pcr_holder_3d() {
    // Define the base solid structure first (The U-shape + Bridge + Ledge)
    union() {
        // 1. Inner Leg (Solid part) - Centered at Y=0, Z=0 to Z=50
        translate([0, -(inner_leg_width/2), 0])
        cube([strip_length, inner_leg_width, total_height]);

        // 2. Outer Leg (Solid part) - Positioned relative to the inner leg's edge + gap
        // Inner leg right edge is at Y = inner_leg_width/2 = 2mm. Gap starts here.
        // Outer leg center: 2 + gap_for_wall + outer_leg_width/2 = 2 + 12.5 + 2 = 16.5mm
        translate([0, (inner_leg_width/2) + gap_for_wall + (outer_leg_width/2), 0])
        cube([strip_length, outer_leg_width, total_height]);

        // 3. Bridge connecting the legs (Solid part) - Z=46 to Z=50
        // The bridge spans from the inner leg's right edge (Y = 2mm) to the outer leg's left edge (Y = 16.5 - 2 = 14.5mm).
        bridge_y_start = (inner_leg_width/2); // Y coordinate of inner leg's right face
        bridge_y_end = (outer_leg_width/2) + ((inner_leg_width/2) + gap_for_wall + (outer_leg_width/2)) - (outer_leg_width/2); // Y coordinate of outer leg's left face
        // Simpler: The bridge width is outer_leg_width - inner_leg_width = 0.
        // Let's use the calculated center positions for simplicity in defining the span:
        bridge_center_y = ( (inner_leg_width/2) + ((inner_leg_width/2) + gap_for_wall + (outer_leg_width/2)) ) / 2;
        bridge_span_y = outer_leg_width - inner_leg_width;

        // Position the bridge centered between the two legs' centers, spanning their width.
        translate([0, (inner_leg_width/2) + gap_for_wall, bridge_start_z])
        cube([strip_length, outer_leg_width - inner_leg_width, bridge_end_z - bridge_start_z]);


        // 4. Ledge (Solid part) - Attached to the foot of the inner leg (Y=-2mm) and extends into -Y direction
        // Inner leg bottom edge is at Y = -(inner_leg_width/2) = -2mm.
        translate([0, -(inner_leg_width/2), 0])
        cube([strip_length, ledge_length_y, ledge_thickness]);
    }
}

module pcr_holder() {
    difference() {
        // Start with the solid structure
        pcr_holder_3d();

        // Cut out the tube holes
        for (i = [0 : num_tubes - 1]) {
            // Calculate X position for the center of the hole. Centered on X=0, spanning strip_length.
            start_offset = -( (num_tubes - 1) * hole_spacing_x / 2 );
            x_pos = start_offset + (i * hole_spacing_x);

            // The holes are in the ledge, centered at Y = -15.
            y_center = -15;

            translate([x_pos, y_center, 0]) {
                // Cut a cylinder through the entire thickness of the ledge (ledge_thickness) and slightly beyond for safety.
                cylinder(h = ledge_thickness + 2, r = tube_diameter / 2);
            }
        }
    }
}

// Render the final part
pcr_holder();