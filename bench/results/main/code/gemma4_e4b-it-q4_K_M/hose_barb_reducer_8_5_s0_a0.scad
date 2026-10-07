// Hose-Barb Reducer Design

// Global settings
$fn = 100; // High resolution for smooth curves

// --- Dimensions (in mm) ---

// Overall dimensions
total_height = 41;     // Total height of the part
bore_diameter = 3;     // Diameter of the central bore
bore_radius = bore_diameter / 2;

// Section 1: 8mm Barb Side (Z=0 to Z=20)
hose_in_id = 8;         // Inner diameter for large tubing
barb_height_large = 10; // Height of one large barb
num_barbs_large = 2;   // Number of barbs on the large side
z_start_large = 0;     // Start Z for large barb section
z_end_large = 20;      // End Z for large barb section

// Large Barb Profile (Sawtooth)
barb_bottom_od_large = 7.5; // Outer diameter at the base of the sawtooth profile
barb_top_od_large = 9.5;    // Outer diameter at the peak of the sawtooth profile
step_back_width_large = 10; // Width of the step back (height of the barb)

// Section 2: Collar (Z=20 to Z=25)
collar_diameter = 12;  // Diameter of the collar section
collar_radius = collar_diameter / 2;
z_start_collar = z_end_large; // Start Z for collar
z_end_collar = 25;        // End Z for collar

// Section 3: 5mm Barb Side (Z=25 to Z=41)
hose_out_id = 5;        // Inner diameter for small tubing
barb_height_small = 8;  // Height of one small barb
num_barbs_small = 2;    // Number of barbs on the small side
z_start_small = z_end_collar; // Start Z for small barb section
z_end_small = total_height; // End Z for small barb section

// Small Barb Profile (Sawtooth)
barb_bottom_od_small = 6.5; // Outer diameter at the base of the sawtooth profile
barb_top_od_small = 5.0;    // Outer diameter at the peak of the sawtooth profile
step_back_width_small = 8; // Width of the step back (height of the barb)

// --- Helper Functions ---

// Function to create a single large barb segment (sawtooth profile)
module large_barb_segment(z_offset, is_top_barb) {
    // The barb structure is defined by its cross-section extruded along Z.
    // We model the sawtooth shape in the XY plane and extrude it up to step_back_width_large.

    // 1. Define the profile (Sawtooth shape)
    module sawtooth_profile() {
        difference() {
            // Base rectangle for the barb body
            cube([barb_bottom_od_large, barb_bottom_od_large, step_back_width_large + 0.5]);

            // Cut out the top section (the ramp)
            translate([0, 0, 0]) {
                linear_extrude(height = step_back_width_large + 1)
                polygon(points=[
                    [0, barb_bottom_od_large/2], // Bottom left corner of the base rectangle (relative to center)
                    [barb_top_od_large/2, barb_bottom_od_large/2], // Top right corner of the ramp start
                    [barb_top_od_large/2, barb_top_od_large/2]  // Top right corner of the peak (this is simplified for extrusion)
                ]);
            }

            // A simpler approach using hull or union might be cleaner, but sticking to basic primitives:
            // Let's define the shape by two stacked cylinders and a connecting piece.

            // Base cylinder (bottom part of the sawtooth step)
            cylinder(h = step_back_width_large * 0.5 + 1, r = barb_bottom_od_large/2);

            // Top ramp section (approximated by two cylinders for simplicity in this complex profile)
            // Since a true linear taper requires sweeping or advanced geometry, we approximate the sawtooth using stacked shapes:
            union() {
                // Lower cylinder part of the step
                cylinder(h = step_back_width_large * 0.5 + 1, r = barb_bottom_od_large/2);

                // Upper tapered section (approximated by a frustum or two cylinders)
                // We use hull to create the smooth transition between the base and top ODs over the height step_back_width_large
                hull() {
                    translate([0, 0, step_back_width_large * 0.5]) sphere(r = barb_bottom_od_large/2);
                    translate([0, 0, step_back_width_large * 0.5 + step_back_width_large]) sphere(r = barb_top_od_large/2);
                }
            }
        }
    }

    // Since the sawtooth profile is complex to define purely with difference/union for a perfect taper,
    // we will model it as two stacked sections: a base cylinder and a tapered section (approximated by hull).

    module barb_shape() {
        // Base section (bottom of the step)
        cylinder(h = step_back_width_large * 0.5 + 1, r = barb_bottom_od_large/2);

        // Tapered section (the ramp up to the peak OD)
        hull() {
            translate([0, 0, step_back_width_large * 0.5]) sphere(r = barb_bottom_od_large/2);
            translate([0, 0, step_back_width_large * 0.5 + step_back_width_large]) sphere(r = barb_top_od_large/2);
        }

        // Step back section (the return to the base OD) - This is simplified as a cylinder for structural integrity in printing
        cylinder(h = step_back_width_large * 0.5 + 1, r = barb_bottom_od_large/2);
    }


    translate([0, 0, z_offset]) {
        // The barb is centered on the Z axis. We need to ensure it's positioned correctly relative to its neighbors.
        // Since we are stacking them, we just translate the shape up by the required offset.
        barb_shape();
    }
}

// Function to create a single small barb segment (sawtooth profile)
module small_barb_segment(z_offset) {
    module barb_shape() {
        // Base section (bottom of the step)
        cylinder(h = step_back_width_small * 0.5 + 1, r = barb_bottom_od_small/2);

        // Tapered section (the ramp up to the peak OD)
        hull() {
            translate([0, 0, step_back_width_small * 0.5]) sphere(r = barb_bottom_od_small/2);
            translate([0, 0, step_back_width_small * 0.5 + step_back_width_small]) sphere(r = barb_top_od_small/2);
        }

        // Step back section (the return to the base OD)
        cylinder(h = step_back_width_small * 0.5 + 1, r = barb_bottom_od_small/2);
    }

    translate([0, 0, z_offset]) {
        barb_shape();
    }
}


// --- Main Assembly ---

difference() {
    // 1. Outer Shape (The main body)
    union() {
        // Section 1: Large Barb Area (Z=0 to Z=20)
        translate([0, 0, z_start_large]) {
            for (i = [0 : num_barbs_large - 1]) {
                // Stacked barbs. The first barb starts at the base of the section.
                // We offset each subsequent barb by its height + a small gap for separation/printing ease.
                translate([0, 0, i * (barb_height_large + 0.5)]) {
                    large_barb_segment(0, true); // Z offset is handled inside the module relative to the start of the section
                }
            }

            // The main body connecting the barbs in this section (cylinder)
            cylinder(h = z_end_large - z_start_large, r = barb_bottom_od_large/2 + 1.5); // Slightly larger radius to encompass barbs and provide structure
        }