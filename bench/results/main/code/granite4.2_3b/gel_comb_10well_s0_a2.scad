// Dimensions in millimeters
spine_length = 70;      // length of the straight spine along X direction (mm)
spine_width = 12;       // width of the spine along Y direction (mm)
comb_thickness = 1.5;   // thickness of the whole comb (Z) (mm)
tooth_width = 5.0;       // width of each tooth in X direction (mm)
tooth_length = 12;       // length of each tooth in Y direction (mm, along spine edge)
gap_between_teeth = 1.5;  // gap between neighboring teeth along the spine edge (mm)
num_teeth = 10;          // number of rectangular teeth hanging from one long edge of the spine

// Build the comb as a flat plate lying on the XY plane at z=0, building upward (+Z).
// The comb rests with its spine centered in X and Y.
// Spine runs along X from -spine_length/2 to +spine_length/2, spans Y from -spine_width/2 to +spine_width/2.
// Teeth hang downward (-Y direction) from the top edge of the spine (Y = spine_width/2).
// Each tooth is a rectangular prism: width = tooth_width in X, length = tooth_length in Y (downward), thickness = comb_thickness along Z.
// Gaps between teeth are gap_between_teeth measured perpendicular to teeth edges (i.e., along X direction).
// The row of teeth is centered on the spine in X.

// Define base rectangle for the spine plate (central region) using cube, centered at origin.
spine_plate = cube([spine_length, spine_width, comb_thickness]);

// For each tooth, create a rectangular prism extending downward from the spine edge.
for (i = [0 : num_teeth - 1]) {
    // Spacing between tooth edges along X direction: tooth_width + gap_between_teeth.
    spacing = tooth_width + gap_between_teeth;
    
    // Position of the i-th tooth center along X, centered on the spine edge line (Y = spine_width/2).
    // The centers are placed symmetrically about X=0 with equal spacing between adjacent tooth edges.
    x_center = - (spine_length / 2) + (i * spacing) / 2;
    
    // Y coordinate: the tooth hangs from the top edge of the spine, so its base is at Y = spine_width/2 (the top half of the spine width).
    // The tooth extends downward (-Y direction) by tooth_length.
    y_base = spine_width / 2;   // starting Y coordinate for the tooth's base edge
    
    // Create a rectangular prism representing the tooth:
    // - X range: [x_center - tooth_width/2, x_center + tooth_width/2]
    // - Y range: [y_base - tooth_length, y_base]   (since it extends downward by tooth_length)
    // - Z range: [0, comb_thickness]  (the whole comb thickness along Z; the tooth sits on top of the spine plate? Actually the spine plate already covers up to z=comb_thickness, so we need to avoid overlap.)
    
    // Better: define the tooth as a prism that starts at y = y_base - tooth_length and ends at y = y_base.
    // The spine plate occupies Y from -spine_width/2 to +spine_width/2 for all Z up to comb_thickness.
    // So the tooth should be placed on top of the spine plate? But the problem says the whole comb is a flat plate 1.5 mm thick, and teeth hang from one long edge.
    // Typically in such designs, the spine plate covers the entire thickness along Z; the teeth extend downward from its top edge (Y = spine_width/2) within the same Z-thickness region? Actually the comb is a flat plate of thickness 1.5 mm; the teeth are part of that plate, extending laterally downward (-Y).
    // So we should model the tooth as a prism that occupies the full Z range [0, comb_thickness] and spans in X and Y appropriately without overlapping with spine plate.
    
    // To avoid overlap, define the tooth region using translate on a cube that covers exactly the tooth shape:
    //   - X extent: from x_center - tooth_width/2 to x_center + tooth_width/2 (width = tooth_width)
    //   - Y extent: from y_base - tooth_length to y_base (height in Y direction downward, length = tooth_length)
    //   - Z extent: full thickness comb_thickness.
    
    // Use cube with appropriate dimensions and translate so that the tooth sits on top of the spine plate edge? But the spine plate already occupies up to z=comb_thickness across its entire XY footprint (including where teeth are). So we must not double-count.
    // Instead, define the comb as union of:
    //   - The spine plate covering the central rectangular region including the top edge line where teeth hang? Actually the spine plate is a solid rectangle; if we add tooth prisms that extend downward from its top edge, they will overlap with the spine plate along the overlapping area.
    
    // To avoid overlap, define the comb as:
    //   - The spine plate covers only up to Y = spine_width/2 (the top half of the spine width), leaving the bottom half empty? But the problem says the whole comb is a flat plate 1.5 mm thick; it's a single solid plate with teeth protruding downward from one edge.
    //   - Standard interpretation: The comb is a solid plate of thickness 1.5 mm, and along its top surface (Y = spine_width/2) there are rectangular teeth that extend downward into the plate by tooth_length, so the overall shape includes both the base rectangle and the teeth protruding from its edge.
    //   - Therefore we should model the comb as a single solid: take the spine plate covering the full XY footprint (size [spine_length, spine_width] in X-Y), then carve out or add tooth prisms that extend downward from the top edge without overlapping with the base rectangle's interior.
    
    // Simpler and correct approach: build the comb as union of two parts:
    //   - A central rectangular prism (the spine plate) covering the entire XY footprint up to Z = comb_thickness, but only for Y in [-spine_width/2, spine_width/2] and X in [-spine_length/2, spine_length/2].
    //   - For each tooth, add a prism that extends downward from the top edge (Y = spine_width/2) by tooth_length, with shape: 
    //        X range: [x_center - tooth_width/2, x_center + tooth_width/2]
    //        Y range: [y_base - tooth_length, y_base]   (where y_base = spine_width/2)
    //        Z range: [0, comb_thickness]   but this will overlap with the spine plate in the region where Y is between y_base - tooth_length and y_base? Actually the spine plate occupies all Y from -spine_width/2 to spine_width/2 for all Z up to comb_thickness.
    //        So if we add a prism that covers Y down to y_base - tooth_length, it will overlap with the spine plate in the overlapping region (Y between y_base - tooth_length and y_base).
    
    // To avoid overlap, define the spine plate only for the part where Y is above y_base - tooth_length? But that's messy.
    
    // Better: model the comb as a single solid using difference or union without overlapping by defining each region with proper Z bounds per XY slice.
    // Since we are building in OpenSCAD and will use union, we can define the spine plate only for the central part where it doesn't conflict, but that's complex.
    
    // Simpler solution: redefine the comb shape as a solid using linear_extrude on a polygonal cross-section? But we have constraints to use only basic primitives.
    
    // We'll model the comb by taking the spine plate covering the entire XY footprint up to Z = comb_thickness, and then for each tooth, carve out or add a protrusion that is disjoint from the base rectangle's interior in Y direction.
    // Actually we want the teeth to extend downward from the top edge of the spine plate, so they should be part of the same solid without overlap: i.e., the comb shape includes both the base rectangle and the tooth prisms as a single solid where the tooth prisms are carved out of the base? No, they are protrusions.
    
    // Standard way in OpenSCAD for such designs is to use union of:
    //   - The spine plate covering only up to Y = spine_width/2 (i.e., exclude the bottom half where teeth hang), and then add tooth prisms that extend downward from the top edge, which will fill the missing region without overlap because they are disjoint in Y