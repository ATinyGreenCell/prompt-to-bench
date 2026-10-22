// --- Dimensions in mm ---

// Base dimensions
base_diameter = 50;      // Diameter of the base disc
base_height = 4;          // Height of the base disc

// Cone dimensions (Base to Column)
cone_start_z = 4;         // Z where cone starts
cone_end_z = 14;          // Z where cone ends
cone_start_diameter = 50; // Diameter at z=4
cone_end_diameter = 22;   // Diameter at z=14

// Column dimensions (Cylinder section)
column_height = 33 - 14;  // Height of the main column (from z=14 to z=33)
column_diameter = 22;     // Diameter of the column

// Tube Seat dimensions
seat_start_z = 33;        // Z where tube seat starts
seat_end_z = 23;          // Z where tube seat ends
seat_diameter_top = 11;   // Diameter at z=33
seat_diameter_bottom = 3; // Diameter at z=6 (tip)

// Viewing Window dimensions
window_width = 4;         // Width of the viewing window in Y direction
window_start_z = 18;      // Start Z for window cut
window_end_z = 30;        // End Z for window cut

// Tolerance for cutting operations (to avoid coplanar faces)
tolerance = 0.5;


// --- Module Definitions ---

// Function to create a frustum (cone section)
module frustum(h, r1, r2, z_start) {
    linear_extrude(height = h)
    polygon(points=[[0, 0], [r1, 0], [r2, 0]]); // This is a simplification; we need to use hull or sweep for true frustum shape if not using CSG primitives directly.

    // Since OpenSCAD doesn't have a direct 'frustum' primitive, we approximate it using linear_extrude on a profile that changes radius linearly with height.
    // A better way is to define the shape by its bounding box and use hull or sweep, but for simplicity matching the description:

    // We will build this piece-wise using cylinders/cones if possible, or rely on CSG subtraction later.
}


// --- Main Assembly ---

difference() {
    // 1. Base Disc (Solid part)
    union() {
        // Base disc (Z=0 to Z=4)
        cylinder(h = base_height, r = base_diameter / 2, $fn = 64);

        // Cone section (Z=4 to Z=14) - Approximated using hull of two cylinders/disks for smooth transition
        hull() {
            translate([0, 0, cone_start_z]) sphere(r = cone_start_diameter / 2);
            translate([0, 0, cone_end_z]) sphere(r = cone_end_diameter / 2);
        }

        // Column section (Z=14 to Z=33) - Cylinder
        cylinder(h = column_height, r = column_diameter / 2, $fn = 64);

        // Tube Seat Section (Complex shape: Tapered cylinder/cone from z=33 down to z=6)
        // We model this as a single tapered section using hull for simplicity and smooth transition.
        hull() {
            translate([0, 0, seat_start_z]) sphere(r = seat_diameter_top / 2);
            translate([0, 0, seat_end_z - (seat_diameter_bottom/2) + 1]) sphere(r = seat_diameter_bottom / 2); // Adjust Z slightly to ensure the tip is captured correctly in hull
        }

    } // End of solid union

    // --- Subtractions (Holes and Windows) ---

    // 2. Tube Seat Cavity Cutout (Must be larger than the tube diameter, but we cut the shape defined by the seat itself to hollow it out)
    // The seat is a cavity *within* the stand structure. We subtract the volume occupied by the seat profile.
    translate([0, 0, seat_end_z - tolerance]) { // Start cutting slightly below the lowest point of the seat (Z=6)
        hull() {
            translate([0, 0, 0]) sphere(r = seat_diameter_top / 2);
            translate([0, 0, column_height + (seat_end_z - base_height)]) sphere(r = seat_diameter_bottom / 2); // Translate relative to the start of the hull operation
        }
    }


    // 3. Viewing Window Cutout (Through the main column wall)
    translate([column_diameter/2 + tolerance, 0, window_start_z]) { // Position cut on the +X side wall
        cube([tolerance * 2, window_width + tolerance*2, window_end_z - window_start_z + tolerance], center = true);
    }

    // Note: The tube seat cavity subtraction above is complex because it's a tapered hole.
    // A simpler approach for the tube holder: subtract a cylinder matching the required inner diameter (e.g., 10mm) through the entire relevant section.
    // Since the prompt implies the *seat* defines the shape, we use the hull subtraction above, assuming it carves out the necessary space.

}