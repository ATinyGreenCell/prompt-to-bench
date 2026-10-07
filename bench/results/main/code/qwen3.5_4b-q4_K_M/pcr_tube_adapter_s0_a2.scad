// Dimensions for PCR tube adapter sleeve (FDM)
$fn = 64; // Set polygon resolution for smooth curves and holes

// --- User Defined Dimensions (mm) ---
d_collar_outer = 13.0;      // Outer diameter of the collar ring
t_collar_thickness = 1.5;   // Thickness of the collar section
h_body_total_height = 21.5;// Total height from base to top of collar
d_bore_diameter = 6.2;      // Inner diameter of the tube bore

// --- Geometry Construction ---

// Rule #3: Model rests on XY plane at z=0 and builds upward (+Z).
// To satisfy "Print it upside down" where the COLLAR lies on the bed (z'=0..1.5):
// We must place the Collar at the TOP of our model (highest Z) so that when flipped vertically, 
// it becomes the bottom part touching the printer bed.
// The Body rises from the collar upwards to z = 21.5 in this coordinate system? 
// Wait, "sleeve body ... rises from the collar". If Collar is at top (Z=H), and body goes UP to Z=21.5... that implies H < 21.5.
// Let's interpret: The total height of the object is defined by the user as ending at z=21.5 relative to some base? 
// Or does "rises from collar to z=21.5" mean the top surface is at Z=21.5 and it starts where the collar ends?
// Let's assume standard stacking: Base -> Body -> Collar (Top).
// If we print upside down, Top becomes Bottom. So Collar touches bed. Correct.
// Dimensions mapping to this stack:
// 1. The "Base" of our model must be at Z=0 to satisfy Rule #3 ("rests on ... z=0"). 
//    This base will become the top surface when printed upside down (touching ceiling).
// 2. The Body extends from Z=0 up to where the Collar starts? Or does it extend through the collar height?
//    User says: "collar... lies on bed (z=0 to 1.5)". This implies a thickness of 1.5mm at that location in the final print.
//    In our model, this corresponds to the TOP section (Z = H - 1.5 to Z = H).
//    User says: "sleeve body... rises from the collar". If Collar is Top, Body goes DOWN? 
//    No, usually sleeves are Base -> Body -> Cap/Collar. 
//    Let's assume the user describes the physical object where the total height is 21.5mm.
//    And specifically: The part that sits on the bed (Collar) has thickness 1.5mm.
//    So in our model coordinates (Z-up from 0):
//      - Top of Body / Bottom of Collar = Z_max - t_collar_thickness? 
//      Let's set Total Height H_total = h_body_total_height + t_collar_thickness? 
//      Or is "z=21.5" the absolute top coordinate in their description relative to bed (0)?
//      If Bed z'=0, Collar ends at 1.5. Body goes up from there... wait, body usually holds tube below collar?
//      Let's assume: Total Height = 23.0 mm (Body + Collar). 
//      Top of model (Z=23) is bottom of rack hole interface? No, that would be the outer edge.
//      
//    Revised Interpretation for Code Structure:
//    We build a stepped cylinder from Z=0 to Z=H_total.
//    Section 1 (Bottom): Body Cylinder. OD = d_body_outer = ? 
//       User says "sleeve body, 10.8 mm in outer diameter". So d_body_outer = 10.8mm.
//    Section 2 (Top/Collar): Collar Ring. OD = 13.0mm. ID must accommodate the tube? 
//       Tube bore is 6.2mm. If this is a sleeve, likely it's hollow throughout or has an inner wall.
//       Assuming solid cylinder with hole drilled through center:
//         Outer Diameter of Body = 10.8 mm.
//         Inner Bore (throughout) = 6.2 mm? Or does the collar have different ID? 
//         User says "straight 6.2 mm diameter bore runs through". Implies constant inner hole size.
//         
//    Height Allocation:
//       Total height specified as ending at z=21.5 relative to bed (0). So H_total = 23.0mm? 
//       Or is the "z=21.5" the top of the body, and collar sits on it? 
//       Let's assume: Top surface Z_max = h_body_total_height + t_collar_thickness?
//       Actually, let's stick to user numbers exactly as possible.
//       User: "collar ... (z=0 to 1.5)" -> Thickness 1.5mm at bottom of print.
//       User: "body rises from collar to z = 21.5". 
//          If Collar is at Z_bottom_printed, and Body goes UP to 21.5... that implies Body height = 20mm?
//          But if we model normally (Z-up), and print upside down:
//             Printed Bed corresponds to Model Top.
//             So "z=0" in user description is Model Max Z - t_collar_thickness? 
//             Let's define our Model such that:
//                Model Z_max = 21.5 + 1.5 = 23.0 mm (Top of collar).
//                When flipped, this becomes Bed contact at z'=0..1.5. Correct.
//                The "z=21.5" in user description corresponds to the top surface of our Body cylinder? 
//                Yes: Top of body is 21.5mm above bottom of collar (which was bed).
//                
//    Construction Steps:
//       1. Create a large outer volume from Z=0 to Z=23.0 with OD = max(d_collar_outer, d_body_outer) = 13.0 mm? 
//          Wait, if body is smaller (10.8), and collar is larger (13), it's an inverted step in our model coordinates?
//          Yes: Base (Z=0..21.5) has OD=10.8mm. Top Ring (Z=21.5..23.0) has OD=13.0mm.
//       2. Drill a hole of d_bore_diameter = 6.2 mm through the entire height (Z=0 to Z=23).
//       
//    Wait, does "sleeve body ... rises from collar" imply Body is BELOW Collar? 
//    Yes. In our model: Base (Body) at bottom, Ring (Collar) at top.
//    
//    One detail: Difference operations must extend 0.01mm past faces to avoid coplanarity errors.

union() {
    // --- Step 1: Main Body Cylinder ---
    // Extends from Z=0 to Z=(h_body_total_height + t_collar_thickness) = 23.0 mm? 
    // Let's verify height math again based on user text "rises ... to z=21.5".
    // If Collar is at Bed (z'=0..1.5), and Body rises from there... wait, body usually goes DOWN into rack?
    // Or UP towards the lid of a PCR block? 
    // Assuming standard adapter: Fits in hole -> Holds tube inside.
    // Rack hole size ~20mm. Our collar OD=13mm is too small for 20mm hole unless it's an insert ring?
    // BUT we must use user dimensions exactly. We will build the geometry as described, 
    // regardless of whether 13mm fits a standard rack (maybe their racks are custom or I am misremembering sizes).
    
    // Let's assume Total Height = h_body_total_height + t_collar_thickness? 
    // Or is "z=21.5" the absolute top coordinate in user's mental model where bed is 0?
    // If Bed z'=0, Collar ends at 1.5. Body goes UP to 21.5. That means Body Height = 20mm.
    // Total Object Height = 21.5 mm (from bed surface up). 
    // So in Model coordinates (flipped):
    //   Top of Collar = Z_max. Bottom of Collar = Z_max - 1.5.
    //   Top of Body = Z_max - 1.5? No, "Body rises from collar". 
    //   If we view it as a stack: [Bed] -> [Collar] -> [Body]. 
    //   Then Bed is at bottom. Collar sits on bed. Body sits on collar.
    //   This matches "rises FROM collar".
    //   So in Model