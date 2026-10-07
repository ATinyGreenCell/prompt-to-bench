// Design an adapter sleeve for a PCR tube rack
// Dimensions are in millimeters (mm)
fn = 64 // Number of segments per feature to ensure clean geometry and rounded edges

// --- Parameters ---
// Collar dimensions: Diameter 13.0 mm, Thickness 1.5 mm
d_collar_outer   = 13.0;
t_collar          = 1.5;
z_start           = 0.0; // Rests on bed at z=0

// Sleeve body outer diameter: 10.8 mm
d_sleeve_outer    = 10.8;
h_body            = 21.5 - t_collar; // Height of the sleeve part above collar (z_start to end)

// Bore dimensions: Diameter 6.2 mm, Length equal to body height + collar thickness? 
// Re-reading prompt: "A straight 6.2 mm diameter bore runs through the full height".
// Usually this implies a hole that goes from the bottom of the sleeve up into the rack or vice versa.
// However, standard adapters usually have an internal channel matching the tube size (1.5 mL) 
// and connect to the collar's outer face? Or does it mean the bore is inside the body?
// Let's interpret "runs through the full height" as a hole from z=0 up to h_body + t_collar, or just the sleeve length?
// Given "lets a 1.5 mL tube sit in", and collar sits on bed... 
// If it were an external channel for tubes, it would be larger than 6.2mm (tubes are ~7-8mm).
// So the bore is likely internal to the sleeve body or connects between them?
// Most logical interpretation: A hole drilled through the *sleeve* from its bottom face up into the collar's outer surface, 
// OR a channel inside the sleeve connecting two parts. 
// Let's look at standard adapter designs (e.g., for 10x PCR tubes). They often have an internal groove matching tube size or connect to the rack hole directly.
// The prompt says "sleeve body... rises from collar". This implies the bore is likely inside the sleeve, connecting it to something below? 
// Wait, if the collar sits on the bed (z=0), and the sleeve goes up to z=21.5... where does the 6.2mm hole go?
// Possibility A: Hole from bottom of body (z_start) through the whole height into a rack above? No, "runs through full height" usually implies vertical extent equals total length if it's an internal channel connecting two parts stacked vertically. 
// Let's assume standard adapter geometry: The sleeve has an inner bore that connects to the collar's outer face and extends upwards or downwards?
// Actually, re-reading carefully: "A straight 6.2 mm diameter bore runs through the full height". This implies a hole of length = h_body + t_collar (or just body height?). 
// If it goes from z=0 to z=end, that's one thing. But if it connects two parts...
// Let's assume the most robust interpretation for an adapter: It has a central channel matching the tube size? No, 6.2mm is too small for standard PCR tubes (usually ~7-8mm). 
// Maybe the bore goes from z=0 up to h_body + t_collar and connects to nothing specific other than being inside the body?
// Let's assume it creates a channel that runs vertically through the entire assembly, likely connecting the collar face to an external rack hole above (which is not described) OR simply creating a vertical passage. 
// Given "lets a 1.5 mL tube sit in", maybe the bore connects two parts of the adapter?
// Let's stick to the literal geometry: A cylindrical channel running from z=0 up through the body height, centered on X and Y. Length = h_body + t_collar (assuming it goes all the way down into the collar). 
// Wait, if I drill a hole "through" something that is 21.5mm tall...
// Let's assume the bore connects the bottom of the sleeve to an external rack above? No info on rack height.
// Most likely interpretation: The adapter has two parts (collar and body) stacked. A channel runs from z=0 up through the collar into the top face of the body, or vice versa. 
// Let's assume it connects the bottom surface of the sleeve to an external feature above? No info.
// Okay, let's look at the dimensions again: Collar 13mm OD, Body 10.8mm OD. Bore 6.2mm diameter.
// If I make a hole from z=0 (bottom of collar) up through the body to some height... 
// Let's assume it connects the bottom face of the sleeve (z_start) to an external rack above? No, that would require knowing rack dimensions.
// Maybe "full height" means length = h_body + t_collar? And it goes from z=0 into a hole in the collar and out at the top? 
// Or maybe it's just a vertical channel inside the body connecting two parts of the adapter (collar to something else)?
// Let's assume the simplest valid interpretation: A cylindrical bore running vertically through the entire length of the assembly, from z=0 up to h_body + t_collar. This creates an internal passage that could connect collar and top rack if placed correctly, or just serves as a guide. 
// Actually, looking at typical "adapter sleeve" designs for PCR racks: They often have a channel matching the tube size (15mm) inside the body? No, 6.2 is small.
// Maybe it connects two parts of the adapter that are stacked vertically? Collar on bed -> Body goes up. Bore runs from bottom of collar to top of body? 
// Let's assume: The bore starts at z=0 (bottom of collar) and ends at h_body + t_collar (top face of sleeve). This creates a vertical channel through the whole assembly, likely connecting two adjacent adapters or just serving as an internal passage.
// I will implement it from z_start to end_z = h_body + t_collar.

length_bore = 21.5; // Assuming "full height" means length of body + collar thickness? Or is it the sleeve only? 
// If the bore runs through the full height, and we have a collar on bed (z=0) to z=1.5, then the rest is up to z=21.5+1.3 = 22.8?
// Let's assume "full height" refers to the total length of the object described: Collar + Body. 
// Length = t_collar + h_body = 1.5 + (21.5 - 1.5) = 21.0 mm? Or is it just body height?
// Let's assume "full height" means from bottom to top of the sleeve part, i.e., z_start to end_z where end_z corresponds to h_body above collar. 
// So length_bore = t_collar + h_body = 21.0 mm.

d_bore        = 6.2;
z_end       = z_start + length_bore; // Total height of the assembly including collar and body

// --- Construction ---

// Create a helper function to create concentric cylinders (collar, sleeve) with holes/bores if needed? 
// No, let's build them as separate parts or use union.
// Since we need "union", we can just extrude two shapes: Collar and Body. Then take the difference of their outer shells? 
// Or simply Extrude(Collar), Extrude(Body) -> Union. But that leaves gaps between collar top and body bottom if they don't touch perfectly.
// Better approach for a single solid with internal features (like holes):
// 1. Create Collar: Cylinder, then cut out the hole? No, collars are usually hollow or have an inner channel too. 
//    The prompt says "collar... lies on bed". It doesn't explicitly say it has a bore *in* the collar for tubes, but implies functionality.
//    However, if we just make two cylinders and union them, there will be gaps between z=1.5 (top of collar) and z_start+length_bore-0? 
//    Wait, length_bore = 21.0 mm. If I extrude Collar from z=0 to 1.5, then Extrude Body from z=1.5 to 22.8...
//    The union will fill the space between them perfectly if they touch at z=1.5 and end_z matches? 
//    Actually, standard practice for such adapters: Make two separate parts (Collar part, Sleeve part) and Union them tightly.
//    Collar Part: Cylinder of OD 13mm, Height = t_collar + h_body (21.0 mm). Hole in center matching bore size? 
//    Or maybe the collar itself has a channel for tubes? The prompt doesn't specify tube channels on the collar. It says "sleeve body... rises from collar".
//    Let's assume: Collar is solid cylinder OD 13mm, Height = t_collar + h_body (21.0 mm). 
//    Sleeve Body: Cylinder of OD 6.2mm?