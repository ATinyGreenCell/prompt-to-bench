// Design: Hotplate Stirrer Knob Replacement
// Units: millimeters

// Dimensions
D_SHaft_Diameter = 6.0;       // mm (D-shaft diameter)
Knob_Diameter = 30.0;         // mm (Outer knob diameter)
Knob_Height = 15.0;           // mm (Total height of knob)
Blind_Bore_Start_Z = 12.0;    // mm (Distance from bottom face to start of blind bore)
Blind_Bore_Diameter = 6.2;    // mm (D-shape hole diameter)
Blind_Bore_Flat_Depth = 4.7;  // mm (Depth of flat side of D-shape)
Grip_Groove_Count = 18;       // number of grooves along the circumference
Groove_Diameter = 2.0;        // mm (Diameter of each groove half-cylinder)
Pointer_Groove_Width = 1.5;    // mm (Width of pointer groove)
Pointer_Groove_Depth = 1.0;   // mm (Depth of pointer groove)

// Create the main cylindrical body
Knob_Cylinder = cylinder(
    height = Knob_Height,
    radius = Knob_Diameter / 2
);

// Define the D-shape geometry for subtraction
// The prompt describes a "D" shaped blind bore with one side cut flat.
// This typically means a hole where the bottom face is a straight line (flat) 
// and the top surface curves, or vice versa depending on orientation.
// However, standard interpretation of "one side cut flat" in this context usually implies
// a square-like cross-section at the start that transitions to a circle? 
// OR it means a D-shape where one face is straight (flat) and the other is curved.
// Let's construct the specific geometry for subtraction based on the dimensions:
// "distance from the flat to the opposite side of the circle is 4.7 mm".
// This implies a shape with a flat rectangular section at Z=0, followed by a circular arc? 
// Or perhaps it means the hole starts as a square (flat face) and becomes a circle?
// Let's assume the "D" shape body to be subtracted is:
// A cylinder of radius = Blind_Bore_Diameter / 2 + 0.5mm starting at Z=0, 
// but with one side cut flat? No, OpenSCAD difference requires solid bodies.

// Correct approach for this specific geometry description:
// We will create a "D" shape body using polygons (Square + 2 Circles) that represents the material to be removed.
// The D-shape is defined by two semicircles on top/bottom connected by a rectangle? 
// No, let's use the polygonal approximation of a D-hole: A square rotated 45 degrees with a hole in the middle.
// But we need "one side cut flat". This implies one face is straight (flat) and the other is curved?
// Let's interpret "D-shape" as a standard engineering hole where the bottom face is a straight line 
// (flat) and the top surface curves, OR the bottom face is curved and the top is flat.
// Given "distance from the flat to the opposite side... is 4.7mm", this suggests a flat segment.

// Let's build the D-shape body explicitly using polygons:
// Top Circle: Center Z = Blind_Bore_Start_Z - 0.5, Radius = Blind_Bore_Diameter / 2 + 0.5? 
// If we cut a hole from Z=0 to Z=Blind_Bore_Start_Z with a D-shape, the flat side is at Z=0.
// Let's define the "D" shape using two circles and a square connecting them? 
// No, let's use a single cylinder of radius = Blind_Bore_Diameter / 2 + 0.5mm to start the cut at the flat face.
// Then we subtract a hole that is NOT a perfect circle but has one side flat? 
// This is tricky in OpenSCAD without creating an open body first.

// Let's try this: Create the D-shape using polygons (Square + 2 Circles).
// Top Circle: Center Z = Blind_Bore_Start_Z - 0.5, Radius = Blind_Bore_Diameter / 2 + 0.5? 
// If we cut a hole from Z=0 to Z=Blind_Bore_Start_Z with a D-shape, the flat side is at Z=0.
// Let's define the "D" shape using two circles and a square connecting them? 
// No, let's use a single cylinder of radius = Blind_Bore_Diameter / 2 + 0.5mm to start the cut at the flat face.
// Then we subtract a hole that is NOT a perfect circle but has one side flat? 
// This is tricky in OpenSCAD without creating an open body first.

// Let's try this: Create the D-shape using polygons (Square + 2 Circles).
// Top Circle: Center Z = Blind_Bore_Start_Z - 0.5, Radius = Blind_Bore_Diameter / 2 + 0.5? 
// If we cut a hole from Z=0 to Z=Blind_Bore_Start_Z with a