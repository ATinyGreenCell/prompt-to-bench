// Dimensions for the Snap-On Clip Design

// Overall part height
height_z = 10; // Total extrusion height in Z direction (mm)

// Rod Ring dimensions (Ring 1)
rod_ring_inner_diameter = 12.7; // Inner diameter of the rod ring (mm)
rod_ring_wall_thickness = 3;     // Wall thickness of the rod ring (mm)
rod_ring_outer_diameter = rod_ring_inner_diameter + 2 * rod_ring_wall_thickness; // Calculated outer diameter (18.7 mm)

// Tubing Ring dimensions (Ring 2)
tubing_ring_inner_diameter = 6;  // Inner diameter of the tubing ring (mm)
tubing_ring_wall_thickness = 2;  // Wall thickness of the tubing ring (mm)
tubing_ring_center_x = 15;       // Center X position for the tubing ring (mm)
tubing_ring_center_y = 0;        // Center Y position for the tubing ring (mm)

// Bridge dimensions (Solid Connector)
bridge_width_y = 6;              // Width of the solid bridge in the Y direction (mm)
bridge_start_x = 8;              // Start X position of the bridge (mm)
bridge_end_x = 12;               // End X position of the bridge (mm)

// Cutout dimensions for Ring 1 (Rod Snap)
rod_cutout_width = 10;           // Width of the opening cut out on the -X side (mm)
rod_cutout_y_range = [-5, 5];     // Y range for the cutout on Ring 1

// Cutout dimensions for Ring 2 (Tubing Alignment)
tubing_cutout_width = 4.5;        // Width of the opening cut out on the +X side (mm)
tubing_cutout_y_range = [-2.25, 2.25]; // Y range for the cutout on Ring 2

// Tolerance for cuts (to ensure separation)
tolerance = 0.1; // Small offset for cutting operations

// --- Module Definitions ---

module rod_ring() {
    difference() {
        // Base ring shape (Outer circle)
        cylinder(h = height_z, r = rod_ring_outer_diameter / 2, $fn = 64);

        // Cutout for snapping onto the rod (on the -X side)
        translate([-(rod_ring_outer_diameter / 2) - tolerance, 0, 0]) {
            cube([rod_cutout_width + 2 * tolerance, 10, height_z]); // Cut a block extending past the edge
        }
    }
}

module tubing_ring() {
    difference() {
        // Base ring shape (Outer circle)
        cylinder(h = height_z, r = tubing_ring_inner_diameter / 2, $fn = 64);

        // Cutout for tubing alignment (on the +X side)
        translate([tubing_ring_center_x + tubing_ring_wall_thickness + tolerance, 0, 0]) {
            cube([tubing_cutout_width + 2 * tolerance, 10, height_z]); // Cut a block extending past the edge
        }
    }
}

module bridge() {
    // Solid rectangular bridge connecting the rings
    cube([bridge_end_x - bridge_start_x, bridge_width_y, height_z], center = true);
}

// --- Main Assembly ---

union() {
    rod_ring();
    tubing_ring();
    bridge();
}

// Apply translation to lift the entire assembly so its lowest point is at Z=0.
// Based on the report showing a lowest point at -5, we translate by 5 mm.
translate([0, 0, 5]) {
    union() {
        rod_ring();
        tubing_ring();
        bridge();
    }
}