$fn = 64;

// Dimensions in millimeters
spine_length = 70.0;      // Length of the spine (X direction)
spine_width = 12.0;      // Width of the spine (Y direction)
tooth_width = 5.0;         // Width of each tooth (X direction)
tooth_length = 12.0;       // Length of each tooth (Y direction, extending in -Y)
gap = 1.5;               // Gap between adjacent teeth (X direction)
thickness = 1.5;           // Thickness of the comb (Z direction)

// Total Y dimension: spine_width (Y positive) + tooth_length (Y negative)
total_Y = spine_width + tooth_length;

// Center the comb at the origin in X and Y
translate([ -spine_length/2, -total_Y/2, 0 ])
    cube([spine_length, total_Y, thickness]);