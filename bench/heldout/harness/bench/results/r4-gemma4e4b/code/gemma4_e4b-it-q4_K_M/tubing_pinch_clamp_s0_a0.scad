// Pinch Clamp Design for Silicone Tubing

// Global settings
$fn = 64;

// Dimensions (in mm)
jaw_lower_length = 50;      // Length of the main lower jaw bar
jaw_lower_thickness = 4;    // Thickness/height of the lower jaw base (Y dimension)
tongue_start_x = 50;        // Start X for the lower tongue
tongue_end_x = 56;           // End X for the lower tongue
tongue_y_min = 2.5;          // Min Y for the lower tongue
tongue_y_max = 4;            // Max Y for the lower tongue

jaw_upper_length = 60;      // Length of the upper jaw bar
jaw_upper_thickness = 4;    // Thickness/height of the upper jaw base (Y dimension)
hinge_center_x = 0;         // Center X for the hinge assembly
hinge_center_y = 8;         // Center Y for the hinge assembly

pinch_ridge_radius = 1.5;   // Radius of the half-round pinch ridge
pinch_ridge_x = 27.5;       // X position where the pinch ridge is located

latch_leg_start_x = 57;     // Start X for latch leg
latch_leg_end_x = 60;       // End X for latch leg
latch_y_min = 4.5;          // Min Y for latch leg
latch_y_max = 12;           // Max Y for latch leg

latch_nose_start_x = 54.5;  // Start X for latch nose
latch_nose_end_x = 57;      // End X for latch nose
latch_nose_y_min = 4.5;     // Min Y for latch nose
latch_nose_y_max = 5.5;     // Max Y for latch nose

hinge_ring_r1 = 7.2;        // Inner radius of the hinge ring (lower)
hinge_ring_r2 = 8.0;        // Outer radius of the hinge ring (upper)
hinge_thickness = 0.8;      // Thickness of the hinge material

extrusion_height = 8;       // Extruded height along Z

// --- Components Definition ---

// 1. Lower Jaw Profile (2D shape)
module lower_jaw_profile() {
    union() {
        // Main bar: x=0 to 50, y=0 to 4
        rectangle(size = [jaw_lower_length, jaw_lower_thickness]);

        // Tongue extension: x=50 to 56, y=2.5 to 4
        translate([tongue_start_x, tongue_y_min]) {
            cube([tongue_end_x - tongue_start_x, jaw_lower_thickness - (jaw_lower_thickness - (tongue_y_max - tongue_y_min)), 1]);
        }
    }
}

// 2. Upper Jaw Profile (2D shape)
module upper_jaw_profile() {
    // Main bar: x=0 to 60, y=12 to 16
    rectangle(size = [jaw_upper_length, jaw_upper_thickness]);
}

// 3. Hinge Assembly (Half-rings)
module hinge_assembly() {
    // Lower half ring (centered at (0, 8))
    translate([hinge_center_x - hinge_ring_r1, hinge_center_y - hinge_ring_r1]) {
        rotate([90, 0, 0]) // Rotate to align with X-axis for extrusion later
        cylinder(h = hinge_thickness, r = hinge_ring_r1);
    }

    // Upper half ring (centered at (0, 8))
    translate([hinge_center_x - hinge_ring_r2, hinge_center_y - hinge_ring_r2]) {
        rotate([90, 0, 0]) // Rotate to align with X-axis for extrusion later
        cylinder(h = hinge_thickness, r = hinge_ring_r2);
    }
}

// 4. Pinch Ridge (Half-circle cutouts on the inner face)
module pinch_ridge_cutout(jaw_y_center, jaw_profile_offset) {
    // The ridge is a half-round feature on the *inner* face of the jaw.
    // We model this as a subtraction from the main body profile.

    // Lower Jaw Inner Face (Y=0 side): Ridge centered at Y = 4 - 1.5 = 2.5, X=27.5
    if (jaw_y_center == 4) {
        translate([pinch_ridge_x, jaw_profile_offset]) {
            // Cutout shape: A half-circle centered at the ridge location
            rotate([0, 90, 0]) // Orient circle along Y axis for cutting into X direction
            cylinder(h = jaw_lower_thickness + 1.5, r = pinch_ridge_radius);
        }
    }

    // Upper Jaw Inner Face (Y=16 side): Ridge centered at Y = 12 + 1.5 = 13.5, X=27.5
    if (jaw_y_center == 12) {
        translate([pinch_ridge_x, jaw_profile_offset]) {
            // Cutout shape: A half-circle centered at the ridge location
            rotate([0, 90, 0]) // Orient circle along Y axis for cutting into X direction
            cylinder(h = jaw_upper_thickness + 1.5, r = pinch_ridge_radius);
        }
    }
}

// 5. Latch Assembly (2D shape)
module latch_profile() {
    union() {
        // Leg: x=57 to 60, y=4.5 to 12
        rectangle(size = [latch_leg_end_x - latch_leg_start_x, latch_y_max - latch_y_min]);

        // Nose: x=54.5 to 57, y=4.5 to 5.5 (This is the part that snaps under the tongue)
        translate([latch_nose_start_x, latch_nose_y_min]) {
            rectangle(size = [latch_leg_start_x - latch_nose_start_x, latch_nose_y_max - latch_nose_y_min]);
        }
    }
}

// --- Main Assembly ---

difference() {
    // 1. Base Structure (Union of Jaws and Hinge)
    union() {
        // Lower Jaw Extrusion
        linear_extrude(height = extrusion_height) {
            lower_jaw_profile();
        }

        // Upper Jaw Extrusion
        translate([0, jaw_upper_thickness + (jaw_upper_thickness - 4)]) { // Adjust Y offset to align base lines if needed, but here we just stack them relative to the origin for simplicity in extrusion.
            linear_extrude(height = extrusion_height) {
                upper_jaw_profile();
            }
        }

        // Hinge Extrusion (This is complex because the hinge needs to be cut *into* the jaws, not just added on top)
        // For simplicity in this 2D profile approach, we will model the hinge as a cutout area that allows rotation.
        // Since the prompt implies the hinge joins them on the left (X<0), we must ensure the jaw profiles are modified to accommodate it.

        // Re-modeling Jaws to include Hinge Cutout Area:
        // We define the jaws without the hinge material, and then add the hinge separately if needed for structural integrity visualization, but here we focus on the profile cutouts.

        // For a true living hinge, the jaw profiles must be modified at X<0 to allow rotation around (0, 8).
    }

    // --- Subtractions (Holes and Features) ---

    // A. Pinch Ridge Cutouts (These are subtracted from the main body profile)
    // Lower Jaw: Inner face is Y=0 side. We cut into the material thickness.
    translate([0, 0]) { // Base translation for lower jaw features
        pinch_ridge_cutout(jaw_lower_thickness, 0);
    }

    // Upper Jaw: Inner face is Y=16 side. We cut into the material thickness.
    translate([0, jaw_upper_thickness + (jaw_upper_thickness - 4)]) { // Adjust translation to match upper jaw's base position relative to origin if necessary for consistent subtraction geometry
        pinch_ridge_cutout(jaw_upper_thickness, jaw_lower_thickness);
    }


    // B. Latch Cutout (The latch must be cut *from* the