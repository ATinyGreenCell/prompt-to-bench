// --- Dimensions ---

shelf_thickness = 18;      // Thickness of the shelf to clamp onto (mm)
spine_length_x = 5;        // Length of the spine along X (mm)
spine_height_y = 28.4;     // Height of the spine/top jaw in Y (mm)
bottom_jaw_width_x = 25;   // Width of the bottom jaw in X (mm)
bottom_jaw_height_y = 5;    // Height of the bottom jaw in Y (mm)
arm_length_x = 65;         // Total length of the top arm in X (mm)
shelf_gap = 18.4;          // Required gap for the shelf (mm)

pipette_hole_diameter = 20; // Diameter of pipette holes (mm)
pipette_hole_centers_y[] = [17.5, 52.5, 87.5]; // Y coordinates for the three holes

// --- Global Settings ---
$fn = 64;

// --- Profile Definition (in XY plane, extruded along Z/Y in use) ---
// The profile is defined in the X-Z plane of the 2D drawing, but since it's extruded along Y (+Y is up),
// we define the shape in X vs a dimension perpendicular to extrusion.
// Given the description: "extruded 105 mm along Z (in use, +Y is up and +X points away from the shelf)."
// This means the profile is drawn in the X-Z plane, and it is extruded along Y.

// Let's re-interpret based on standard CAD practice for extrusion:
// If it's extruded 105mm along Z (the direction of printing/extrusion), then the profile is in XY.
// However, the description says "+Y is up" and "extruded 105 mm along Z". This implies the final part dimension is 105mm along Z.
// Let's assume the 2D profile is in X-Y plane, and it is extruded along Z (the depth/thickness of the clamp).

// Re-reading: "extruded 105 mm along Z (in use, +Y is up and +X points away from the shelf)."
// This means the final part has a dimension of 105mm in the Z direction. The profile must be defined in X-Y plane.

// Clamp geometry definition:
// Spine: x = 0 to 5, y = 0 to 28.4 (This seems like a vertical line segment if Y is up)
// Bottom Jaw: x = -25 to 5, y = 0 to 5
// Top Jaw/Arm: x = -25 to 65, y = 23.4 to 28.4

module profile_shape() {
    difference() {
        // Base shape (Union of the three parts)
        union() {
            // 1. Spine (Vertical element connecting jaws)
            cube([spine_length_x, spine_height_y, shelf_thickness + 0.5]); // Extruded thickness is handled by final extrusion

            // 2. Bottom Jaw
            translate([-bottom_jaw_width_x/2, -bottom_jaw_height_y/2, 0])
            cube([bottom_jaw_width_x, bottom_jaw_height_y, shelf_thickness + 0.5]);

            // 3. Top Jaw and Arm (This is the main structure)
            translate([-arm_length_x/2, spine_height_y - (spine_height_y - 28.4)/2, 0]) // Centering Y for the arm section relative to the top jaw height
            cube([arm_length_x, spine_height_y - 23.4 + 1, shelf_thickness + 0.5]); // Simplified representation of the arm area

            // A more precise union based on coordinates:
            union() {
                // Spine (X=0 to 5, Y=0 to 28.4) -> Let's model this as a block for simplicity in extrusion
                translate([0, 0, 0]) cube([spine_length_x, spine_height_y, shelf_thickness + 1]);

                // Bottom Jaw (X=-25 to 5, Y=0 to 5)
                translate([-bottom_jaw_width_x/2, -bottom_jaw_height_y/2, 0]) cube([bottom_jaw_width_x, bottom_jaw_height_y, shelf_thickness + 1]);

                // Top Jaw and Arm (X=-25 to 65, Y=23.4 to 28.4)
                translate([-arm_length_x/2, spine_height_y - 28.4 + 23.4, 0]) cube([arm_length_x, 5, shelf_thickness + 1]); // Height difference is 5mm (28.4-23.4)
            }
        }

        // Cutout for the shelf gap (The clamp must leave an 18.4 mm gap where it meets the shelf edge)
        // The spine/jaw structure spans from X=-25 to X=65 in total length, but the clamping action is on one side.
        // Assuming the clamping happens along the Y-axis direction (the depth of the clamp).
        // Since the profile is extruded 105mm along Z, we cut a slot through the structure.

        // The gap is required where the jaw meets the shelf edge. Let's assume this cutout runs along the X dimension near the spine/jaw intersection.
        // We need to remove material corresponding to the thickness of the shelf (18mm) plus clearance.
        translate([0, 0, -0.5]) // Cut through the entire structure in the Z direction (the extrusion axis)
        cube([arm_length_x + 2, spine_height_y + 2, shelf_thickness + 2]);

    }
}


// --- Final Assembly and Features ---

// The profile is defined in X-Y plane. It is extruded along Z by 105mm.
module holder() {
    difference() {
        // 1. Main Body (Extruded Profile)
        linear_extrude(height = 105, center = false) {
            profile_shape();
        }

        // 2. Pipette Holes (Cutouts through the arm section along Y)
        // The holes are centered at X=42 and specific Y values. They must pass through the entire Z extrusion length (105mm).
        for (y_center = pipette_hole_centers_y) {
            translate([42, y_center, 0])
            cylinder(h = 106, r = pipette_hole_diameter / 2); // +1 clearance for cutting
        }
    }
}

holder();