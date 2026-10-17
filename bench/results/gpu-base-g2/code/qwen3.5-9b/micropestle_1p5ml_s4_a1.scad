$fn = 128;

// --- Dimensions ---
// Handle
d_handle = 8;
h_handle = 45;
z_handle_start = 0;
z_handle_end = 45;

// Cone
d_cone_bottom = 8;
d_cone_top = 3;
h_cone = 17; // 62 - 45
z_cone_start = 45;
z_cone_end = 62;

// Tip (Sphere)
d_tip = 3;
z_tip_center = 62;

// Grooves
n_grooves = 4;
w_groove = 2; // Width in Z
d_groove = 1; // Depth
z_grooves = [10, 15, 20, 25]; // Center Z positions

// --- Main Body Construction ---
// 1. Handle
handle = cylinder(d = d_handle, h = h_handle, center = false);

// 2. Cone (Frustum)
cone = cylinder(d1 = d_cone_bottom, d2 = d_cone_top, h = h_cone, center = false);

// 3. Tip (Sphere)
tip = sphere(d = d_tip, center = [0, 0, z_tip_center]);

// Union Body
body = union(
    handle,
    cone,
    tip
);

// --- Groove Logic ---
// We create a "chisel" shape that is a cylinder with a flat face on the side to cut the groove.
// Actually, the simplest way to cut a circumferential groove is to create a cylinder 
// that represents the hole, but we need to position it on the surface.
// We will create a cylinder with radius = d_groove and height = w_groove.
// Then we will translate it to the surface of the handle (radius = d_handle/2) and rotate it.
// To ensure it cuts completely, we extend it slightly past the body boundaries.

// Define the groove cutter shape (a cylinder representing the void)
// We will generate 4 instances of this cutter, rotated around the Z axis.
// The cutter is a cylinder with radius = d_groove and height = w_groove.
// We place it at the surface of the handle.

groove_cutter = cylinder(d = d_groove, h = w_groove, center = false);

// We need to position the cutter on the surface of the handle.
// The handle radius is d_handle / 2 = 4.
// The cutter needs to be translated to X = 4, Y = 0.
// Then we rotate the whole assembly (body + cutters) or just the cutters?
// We will create the cutters in a loop, translate them to the surface, and then use difference.

// Since we are using difference(), we need to make sure the cutters extend slightly past the body.
// Body Z range: 0 to 63.5.
// Groove Z centers: 10, 15, 20, 25.
// Groove width (Z): 2. So it spans 1 unit above and below center.
// We add 0.1mm clearance to Z and X.

// Let's build the cutters list.
cutters = [];

for (i = [0 : n_grooves - 1]) {
    z_center = z_grooves[i];
    
    // Create the cutter shape
    // We need to cut a hole of depth d_groove.
    // The cutter is a cylinder of radius d_groove and height w_groove.
    // We position it at the surface of the handle.
    
    // Translate to surface: X = d_handle/2, Y = 0
    // Rotate around Z to distribute them evenly? No, the user specified specific Z positions.
    // The user said "four circumferential grooves... centred at z = 10, 15, 20 and 25".
    // This implies the grooves are at different heights, not necessarily rotated 90 degrees apart.
    // "Circumferential" usually means they go around the circle.
    // If they are at different Z, they are likely stacked vertically.
    // Let's assume they are all at the same angular position (e.g., at X=4, Y=0) but at different Z heights.
    // Or, they could be rotated 90 degrees apart.
    // Given "circumferential grooves", it's most likely they are stacked vertically at the same angle, 
    // or perhaps rotated. Without specific rotation angles, I will place them all at the same angle (X=4, Y=0)
    // to create a "ladder" of grooves, which is common for grip.
    // If the user meant rotated, they would usually specify angles.
    // However, "circumferential" might imply they are distributed around the circumference.
    // Let's re-read: "cut four circumferential grooves... centred at z = 10, 15, 20 and 25".
    // This phrasing strongly suggests they are stacked vertically.
    
    // Let's create the cutter.
    // We need to cut a hole. The hole is a cylinder of radius d_groove.
    // We place the center of the cutter at (d_handle/2, 0, z_center).
    // The cutter extends from z_center - w_groove/2 to z_center + w_groove/2.
    
    // To ensure clean cutting, we extend the cutter slightly past the body boundaries.
    // Body X boundary: 4. Cutter radius: 1. So cutter goes from X=3 to X=5.
    // Body Z boundary: 0 to 63.5.
    
    // We create a cylinder for the cutter.
    // We translate it to the surface.
    
    cutter_instance = translate([d_handle/2, 0, z_center]) 
        * cylinder(d = d_groove, h = w_groove, center = false);
    
    // Add a small extension to ensure it cuts through any rounding or misalignment
    // Extend Z by 0.1mm on both ends
    cutter_instance = translate([0, 0, -0.1]) * cutter_instance;
    cutter_instance = translate([0, 0, 0.1]) * cutter_instance; // This doesn't work as expected with chaining.
    
    // Correct way to extend:
    cutter_instance = translate([d_handle/2, 0, z_center - w_groove/2 - 0.1]) 
        * cylinder(d = d_groove, h = w_groove + 0.2, center = false);
    
    cutters.push(cutter_instance);
}

// Apply the cuts
final_part = difference() {
    body;
    union(cutters);
}

// Output the final part
final_part;