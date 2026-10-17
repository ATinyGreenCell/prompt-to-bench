// Hose-barb Reducer Design
// Units: millimetres
// Orientation: Standing upright along Z, resting on XY plane at z=0

// --- Dimensions ---
// Main bore diameter (constant through the part)
$main_bore_d = 3.0;

// Upper Section (z=0 to z=20): 8mm Tubing Barbs
$upper_start_z = 0;
$upper_end_z = 20;
$upper_barb_count = 2;
$upper_barb_height = 10;
$upper_barb_bottom_od = 7.5;
$upper_barb_top_od = 9.5;
$upper_collar_od = 12.0;
$upper_collar_height = 5.0; // From z=20 to z=25

// Lower Section (z=25 to z=41): 5mm Tubing Barbs
$lower_start_z = 25;
$lower_end_z = 41;
$lower_barb_count = 2;
$lower_barb_height = 8;
$lower_barb_bottom_od = 6.5;
$lower_barb_top_od = 5.0;
$lower_collar_od = 12.0; 
$lower_collar_height = 6.0; 

// --- Helper Functions ---

// Function to create a single barb profile using linear_extrude
// Parameters:
//   z_start: Start Z of the barb
//   z_end: End Z of the barb
//   bottom_od: Outer diameter at z_start
//   top_od: Outer diameter at z_end
//   bore_d: Inner diameter of the bore
function create_barb(z_start, z_end, bottom_od, top_od, bore_d) =
    linear_extrude(height = z_end - z_start, center = true)
    difference() {
        // Outer shape: Trapezoid profile (Linear growth then step back)
        // Points: Bottom radius -> Top radius -> Bottom radius (vertical step)
        polygon(points = [
            [bottom_od/2, 0],
            [top_od/2, z_end - z_start],
            [bottom_od/2, z_end - z_start]
        ]);
        
        // Inner Bore (Hole)
        circle(r = bore_d/2);
    });

// --- Main Construction ---

module hose_barb_reducer() {
    // 1. Main Body (12mm OD, 3mm ID)
    // Total height needed: 41mm (0 to 41)
    translate([0, 0, 0]) {
        difference() {
            cylinder(h = 41, r = $upper_collar_od/2, center = false);
            cylinder(h = 41, r = $main_bore_d/2, center = false);
        }
    }
    
    // 2. Upper Barbs (z=0 to z=20)
    // Two barbs stacked.
    // Barb 1: z=0 to z=10
    // Barb 2: z=10 to z=20
    
    for (i = [0, 1]) {
        translate([0, 0, i * $upper_barb_height]) {
            create_barb(
                z_start = i * $upper_barb_height,
                z_end = (i + 1) * $upper_barb_height,
                bottom_od = $upper_barb_bottom_od,
                top_od = $upper_barb_top_od,
                bore_d = $main_bore_d
            );
        }
    }
    
    // 3. Lower Barbs (z=25 to z=41)
    // Two barbs stacked.
    // Barb 1: z=25 to z=33
    // Barb 2: z=33 to z=41
    
    for (i = [0, 1]) {
        translate([0, 0, $lower_start_z + i * $lower_barb_height]) {
            create_barb(
                z_start = $lower_start_z + i * $lower_barb_height,
                z_end = $lower_start_z + (i + 1) * $lower_barb_height,
                bottom_od = $lower_barb_bottom_od,
                top_od = $lower_barb_top_od,
                bore_d = $main_bore_d
            );
        }
    }
}

hose_barb_reducer();