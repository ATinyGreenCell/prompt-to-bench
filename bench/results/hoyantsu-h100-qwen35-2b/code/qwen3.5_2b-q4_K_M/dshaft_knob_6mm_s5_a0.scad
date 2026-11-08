// Design: Hotplate Stirrer Knob Replacement
// Units: Millimeters

// Define dimensions based on user measurements
const float D_SHaft = 6.0;      // Diameter of the shaft (D-shaft)
const float Knob_Diameter = 30.0; // Outer diameter of knob
const float Knob_Height = 15.0;  // Total height of knob

// Define the D-shaped blind bore geometry relative to the bottom face
const float Bore_Start_Z = 0.0;     // Z position where D-shape starts (bottom of knob)
const float Bore_Diameter = 6.2;    // Diameter of the D-shape hole
const float Bore_Radius = Bore_Diameter / 2.0;

// Define grip groove geometry relative to outer surface
const float Groove_Width = 2.0;     // Width of one half-cylinder groove
const float Knob_Height_Grooves = Knob_Height; // Height of the knob where grooves are cut

// Define pointer groove geometry on top face
const float Pointer_Wide = 1.5;     // Width of the pointer groove
const float Pointer_Deep = 1.0;     // Depth of the pointer groove (from bottom)
const float Knob_Height_Pointer = Knob_Height - Pointer_Deep;

// Set number of fillets for smooth rounded holes and grooves
fn = 64;

// Create the main cylindrical body of the knob
// It starts at z=0, goes up to z=Knob_Height
cylinder(Knob_Diameter / 2.0, Knob_Height, Knob_Height);

// Cut the D-shaped blind bore starting from bottom (z=0)
// The cut extends past the face by 0.01mm for safety as per rule 5
translate([0.0, 0.0, Bore_Start_Z])
rotate_extrude(PI / 2, [Bore_Diameter, Knob_Height - Bore_Radius + 0.01]);

// Cut the vertical grip grooves around the outside of the knob
// We iterate through angles to place them evenly
for (i = 0; i < 18; i++) {
    // Calculate angle in radians: 2PI / 18
    float Angle = 2.0 * PI / 18.0;
    
    // Rotate the entire knob assembly by this angle so we can cut along the circumference
    rotate(Angle);

    // Cut a half-cylinder groove centered on the outer surface
    // The radius of the groove is Knob_Diameter / 2 - Groove_Width / 2
    float Groove_Radius = Knob_Diameter / 2.0 - Groove_Width / 2.0;
    
    // Use polygon to create a half-cylinder (180 degrees) centered on the surface
    // The 'z' dimension of the polygon represents the height of the groove cut
    translate([Groove_Radius, Knob_Diameter / 2.0 - Groove_Width / 2.0, 0.0])
    rotate_extrude(PI / 2, [Groove_Width * 1.5, Knob_Height_Grooves]); // Extend slightly past face

    // Rotate back to original orientation for the next iteration
    rotate(-Angle);
}

// Cut the pointer groove on the top face (z = Knob_Height)
// The cut starts from z=Knob_Height - Pointer_Deep and goes down to 0.01mm depth
translate([0.0, 0.0, Knob_Height_Pointer])
rotate_extrude(PI / 2, [Pointer_Wide * 1.5, Knob_Height_Pointer]);

// Add a small fillet at the junction of the D-shape and the groove for smoothness (optional but good practice)
translate([Bore_Radius + Bore_Diameter/4.0, Knob_Diameter / 2.0 - Bore_Diameter/4.0, 0.0])
rotate_extrude(PI / 2, [1.5, Knob_Height_Grooves]);

// Add a small fillet at the junction of the pointer groove and the knob body for smoothness
translate([Bore_Radius + Bore_Diameter/4.0, Knob_Diameter / 2.0 - Pointer_Wide/2.0, Knob_Height_Pointer])
rotate_extrude(PI / 2, [1.5, Knob_Height_Pointer]);

// Add a small fillet at the junction of the groove and the pointer groove for smoothness
translate([Bore_Radius + Bore_Diameter/4.0, Knob_Diameter / 2.0 - Pointer_Wide/2.0, Knob_Height_Pointer], [Pointer_Wide * 1.5, 0.0])
rotate_extrude(PI / 2, [1.5, Knob_Height_Pointer]);

// Add a small fillet at the junction of the groove and the pointer groove for smoothness (second side)
translate([Bore_Radius + Bore_Diameter/4.0, Knob_Diameter / 2.0 - Pointer_Wide/2.0, Knob_Height_Pointer], [Pointer_Wide * 1.5, 0.0])
rotate_extrude(PI / 2, [1.5, Knob_Height_Pointer]);

// Add a small fillet at the junction of the groove and the pointer groove for smoothness (third side)
translate([Bore_Radius + Bore_Diameter/4.0, Knob_Diameter / 2.0 - Pointer_Wide/2.0, Knob_Height_Pointer], [Pointer_Wide * 1.5, 0.0])
rotate_extrude(PI / 2, [