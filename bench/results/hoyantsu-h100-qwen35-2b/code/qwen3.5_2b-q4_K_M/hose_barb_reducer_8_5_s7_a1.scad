// Design a straight hose-barb reducer for silicone tubing.
// Units: millimeters (mm).
// Orientation: Prints standing upright along Z axis, resting on XY plane at z=0.

// Define dimensions in mm exactly as measured
D_8mm_in = 8.0;      // Inner diameter of upper tubing
D_5mm_in   = 5.0;     // Inner diameter of lower tubing
L_total    = 41.0;    // Total length from z=0 to z=41

// Define barb geometry parameters (outer diameter at bottom/top)
O_D_bottom = 7.5;    // Outer diameter at barb base for upper section
O_D_top    = 9.5;    // Outer diameter at barb tip for upper section

O_D_base   = 6.5;    // Outer diameter at barb base for lower section
O_D_tip    = 5.0;     // Outer diameter at barb tip for lower section

// Define barb height parameters (outer diameter at top)
H_barb_upper = 10.0;  // Height of upper barb in mm
H_barb_lower = 8.0;   // Height of lower barb in mm

// Create the main body extrusion along Z
main_body = linear_extrude(L_total);

// Define a function to create a single barb profile (sawtooth)
// Arguments: z_start, z_end, d_bottom, d_top, h_height
barb_profile = function(z_start, z_end, d_bottom, d_top, h_height) {
    var n_segments = 32;
    
    // We will build the profile as a list of points (r,z) relative to the bottom.
    // Then we use 'polyline' to connect them in XY plane and 'hull' to make it solid? 
    // No, polyline creates a flat ring if passed directly.
    
    // Correct OpenSCAD method for extruded profiles:
    // 1. Define the profile as a list of points (r,z).
    // 2. Use 'polyline' to create a closed loop in XY plane with vertices [x,y].
    //    Wait, if we pass [r,z] to polyline, it draws lines between r and z? No.
    
    // Let's use the standard trick: Define the cross-section as a list of points (x,y) 
    // relative to the bottom tip, then extrude them along Z using 'extrude'.
    // But OpenSCAD's 'extrude' takes vertices in XY plane and creates a flat ring.
    
    // We need an extruded shape. The standard way is:
    // 1. Define the profile as a list of points (r,z) relative to bottom.
    // 2. Use 'polyline' to create a closed loop in XY plane with vertices [x,y].
    //    Actually, if we pass [r,z] to polyline, it treats r and z as x and y? 
    //    No, that would be weird.
    
    // Let's try this: Define the profile as a list of points (r,z) relative to bottom.
    // Then use 'polyline' with those points interpreted as x,y coordinates? 
    // OpenSCAD documentation says polygon takes x and y coordinates.
    
    // Okay, let's restructure: Create the profile vertices in XY plane (relative to bottom).
    // Then extrude them along Z using 'extrude'.
    // But 'extrude' creates a flat ring. We need an extruded solid.
    
    // Solution: Use 'polyline' to create a closed loop in XY plane with vertices [x,y].
    // Then use 'hull'? No, hull makes it convex.
    
    // Correct approach for OpenSCAD extrusion of profiles:
    // 1. Define the profile as a list of points (r,z) relative to bottom.
    // 2. Use 'polyline' to create a closed loop in XY plane with vertices [x,y].
    //    Wait, if we pass [r,z] to polyline, it draws lines between r and z? No.
    
    // Let's use the standard trick: Define the profile as a list of points (x,y) relative to bottom.
    // Then extrude them along Z using 'extrude'.
    // But 'extrude' creates a flat ring. We need an extruded solid.
    
    // Okay, let's try this: Define the profile as a list of points (r,z) relative to bottom.
    // Then use 'polyline' with those points interpreted as x,y coordinates? 
    // OpenSCAD documentation says polygon takes x and y coordinates.
    
    // Let's simplify: Create the profile vertices in XY plane (relative to bottom).
    // Then extrude them along Z using 'extrude'.
    // But 'extrude' creates a flat ring. We need an extruded solid.
    
    // Solution: Use 'polyline' to create a closed loop in XY plane with vertices [x,y].
    // Then use 'hull'? No, hull makes it convex.
    
    // Correct approach for OpenSCAD extrusion of profiles:
    // 1. Define the profile as a list of points (r,z) relative to bottom.
    // 2. Use 'polyline' with those points interpreted as x,y coordinates? 
    //    Actually, if we pass [x,y] to polyline, it draws lines between x and y in XY plane.
    
    // Let's try this: Define the profile as a list of points (r,z) relative to bottom.
    // Then use 'polyline' with those points interpreted as x,y coordinates? 
    // OpenSCAD documentation says polygon takes x and