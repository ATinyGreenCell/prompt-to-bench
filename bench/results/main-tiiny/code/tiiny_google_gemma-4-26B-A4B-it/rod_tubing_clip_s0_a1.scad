// --- Dimensions ---
rod_inner_dia = 12.7;      // Inner diameter of the rod ring (mm)
rod_wall = 3.0;            // Wall thickness of the rod ring (mm)
rod_opening_width = 10.0;  // Width of the gap in the rod ring (mm)
rod_opening_height = 10.0; // Height of the gap in the rod ring (mm)
rod_extrusion_z = 10.0;    // Total height of the part (Z) (mm)

tube_inner_dia = 6.0;      // Inner diameter of the tubing ring (mm)
tube_wall = 2.0;           // Wall thickness of the tubing ring (mm)
tube_opening_width = 4.5;  // Width of the gap in the tubing ring (mm)
tube_opening_height = 10.0; // Height of the gap in the tubing ring (mm)
tube_offset_x = 15.0;      // X-offset for the tubing ring center (mm)

bridge_width_y = 6.0;      // Width of the bridge along the Y axis (mm)
bridge_x_start = 8.0;       // Start of the bridge along X axis (mm)
bridge_x_end = 12.0;        // End of the bridge along X axis (mm)

// --- Constants ---
$fn = 64;

// --- Calculations ---
rod_outer_dia = rod_inner_dia + (2 * rod_wall);
tube_outer_dia = tube_inner_dia + (2 * tube_wall);

// --- Main Construction ---
// The part is built from Z=0 upwards. 
// To ensure the part rests on the XY plane at Z=0, we do not use center=true for the extrusion.
// Instead, we translate the cylinders so their base is at Z=0.

union() {
    // 1. The Rod Ring
    difference() {
        // Outer cylinder (Base at Z=0)
        cylinder(h = rod_extrusion_z, d = rod_outer_dia);
        
        // Inner hole (Rod)
        // We use a slightly larger height to ensure a clean cut through the top/bottom
        translate([0, 0, -0.01])
            cylinder(h = rod_extrusion_z + 0.02, d = rod_inner_dia);
        
        // Rod Opening (cut from -X side)
        // Prompt: "everything with x < 0 and -5 < y < 5 is removed"
        // We use a large cube to ensure it cuts through the entire ring.
        translate([-rod_outer_dia - 1, -5.01, -0.01])
            cube([rod_outer_dia + 2, 10.02, rod_extrusion_z + 0.02]);
    }

    // 2. The Tubing Ring
    difference() {
        // Outer cylinder (Base at Z=0)
        translate([tube_offset_x, 0, 0])
            cylinder(h = rod_extrusion_z, d = tube_outer_dia);
        
        // Inner hole (Tube)
        translate([tube_offset_x, 0, 0])
            cylinder(h = rod_extrusion_z + 0.02, d = tube_inner_dia);
        
        // Tubing Opening (cut from +X side)
        // Prompt: "x > 15 and -2.25 < y < 2.25 is removed"
        // We use a large cube to ensure it cuts through the entire ring.
        translate([tube_offset_x + 0.01, -2.26, -0.01])
            cube([tube_outer_dia + 1, 4.52, rod_extrusion_z + 0.02]);
    }

    // 3. The Solid Bridge
    // Prompt: "6 mm wide (Y) between x = 8 and x = 12"
    // This joins the two rings.
    translate([bridge_x_start, -bridge_width_y/2, 0])
        cube([bridge_x_end - bridge_x_start, bridge_width_y, rod_extrusion_z]);
}

// Final check: The part is centered on X and Y. 
// The rod ring is at (0,0), tube ring is at (15,0).
// The bridge is at x=8 to 12.
// The rod ring outer diameter is 18.7, so it spans X from -9.35 to 9.35.
// The tube ring outer diameter is 10, so it spans X from 10 to 20.
// The bridge (8 to 12) connects them.