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

// Helper function for rectangle (since OpenSCAD doesn't have a built-in one, we use cube/difference)
module rectangle(size=[w, h]) {
    cube([w, h, 1]);
}


// 1. Lower Jaw Profile (2D shape)
module lower_jaw_profile() {
    union() {
        // Main bar: x=0 to 50, y=0 to 4
        rectangle(size = [jaw_lower_length, jaw_lower_thickness]);

        // Tongue extension: x=50 to 56, y=2.5 to 4
        translate([tongue_start_x, tongue_y_min]) {
            cube([tongue_end_x - tongue_start_x, tongue_y_max - tongue_y_min, 1]);
        }
    }
}

// 2. Upper Jaw Profile (2D shape)
module upper_jaw_profile() {
    // Main bar: x=0 to 60, y=12 to 16
    rectangle(size = [jaw_upper_length, jaw_upper_thickness]);
}

// 3. Hinge Cutout Area (To allow rotation)
module hinge_cutout() {
    // This area must be subtracted from both jaws where they meet at X<0.
    union() {
        // Lower Jaw cutout area (centered around Y=8, spanning R1 to R2)
        translate([hinge_center_x - hinge_ring_r2, hinge_center_y - hinge_ring_r2]) {
            circle(r = hinge_ring_r2);
        }
        // Upper Jaw cutout area (centered around Y=8, spanning R1 to R2)
        translate([hinge_center_x - hinge_ring_r2, hinge_center_y - hinge_ring_r2]) {
            circle(r = hinge_ring_r1);
        }
    }
}

// 4. Pinch Ridge Cutout (Half-circle cutouts on the inner face)
module pinch_ridge_cutout() {
    // Lower Jaw Inner Face (Y=0 side): Ridge centered at Y = 2.5, X=27.5
    // The cutout must be subtracted from the volume of the lower jaw extrusion.
    translate([pinch_ridge_x, jaw_lower_thickness - pinch_ridge_radius]) {
        rotate([0, 90, 0]) // Orient circle along Y axis for cutting into X direction (relative to the profile)
        cylinder(h = jaw_lower_thickness + 1.5, r = pinch_ridge_radius);
    }

    // Upper Jaw Inner Face (Y=16 side): Ridge centered at Y = 13.5, X=27.5
    // The cutout must be subtracted from the volume of the upper jaw extrusion.
    translate([pinch_ridge_x, jaw_upper_thickness + pinch_ridge_radius]) {
        rotate([0, 90, 0]) // Orient circle along Y axis for cutting into X direction (relative to the profile)
        cylinder(h = jaw_upper_thickness + 1.5, r = pinch_ridge_radius);
    }
}

// 5. Latch Profile (The part that is removed from the upper jaw)
module latch_cutout() {
    union() {
        // Leg: x=57 to 60, y=4.5 to 12
        translate([latch_leg_start_x - 0.01, latch_y_min]) { // Extend slightly past the jaw end (X=60)
            cube([latch_leg_end_x - latch_leg_start_x + 0.02, latch_y_max - latch_y_min, 1]);
        }

        // Nose: x=54.5 to 57, y=4.5 to 5.5 (This is the part that snaps under the tongue)
        translate([latch_nose_start_x - 0.01, latch_nose_y_min]) { // Extend slightly past X=57
            cube([latch_leg_start_x - latch_nose_start_x + 0.02, latch_nose_y_max - latch_nose_y_min, 1]);
        }
    }
}


// --- Main Assembly ---

difference() {
    // 1. Base Structure (Union of Jaws)
    union() {
        // Lower Jaw Extrusion
        linear_extrude(height = extrusion_height) {
            lower_jaw_profile();
        }

        // Upper Jaw Extrusion
        // Offset Y: jaw_lower_thickness + gap (assuming 4mm base thickness for both, they are separated by the hinge area)
        translate([0, jaw_lower_thickness + 2]) { // Separating them slightly to allow hinge action visualization
             linear_extrude(height = extrusion_height) {
                upper_jaw_profile();
            }
        }
    }

    // --- Subtractions ---

    // A. Hinge Cutout (Must be subtracted from both jaws to allow rotation)
    // We apply the hinge cutout subtraction across the entire Z height, centered around the joint area.
    translate([0, 0]) { // Apply relative to origin for simplicity in this complex union/difference setup
        linear_extrude(height = extrusion_height + 1) { // Extend slightly past Z=0 and Z=8
            hinge_cutout();
        }
    }

    // B. Pinch Ridge Cutouts (Subtracted from the material volume)
    translate([0, 0]) {
        pinch_ridge_cutout();
    }

    // C. Latch Cutout (Removed from the upper jaw profile area)
    // Translate to match the position of the upper jaw extrusion base
    translate([0, jaw_lower_thickness + 2]) {
        linear_extrude(height = extrusion_height + 1) {
            latch_cutout();
        }
    }
}