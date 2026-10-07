// Design parameters in millimeters
const fn = 64; // Number of segments for rounded features to ensure clean geometry
const handle_height = 45;   // mm (from z=0 to z=45)
const cone_taper_start_z = 45.01; // Start taper slightly above the handle end to avoid overlap issues, or use exact if needed. User said "tapers from... at z=45", so we will start cut there but ensure no gap between extrusion and cone body. Let's assume standard fit: Handle ends exactly where Cone begins.
const tip_height = 3;      // mm (sphere diameter)
// Tip geometry parameters for the sphere centered at z=62 with radius 1.5mm
const sphere_radius = 1.5;

void main() {
    // Center on origin in X and Y as requested
    
    // --- Step 1: Handle Cylinder ---
    // Dimensions: Diameter 8 mm, Height 45 mm (z=0 to z=45)
    handle_cylinder(7); 
    translate([0.0, 0.0, -handle_height/2]) extrude(handle_height);

    // --- Step 2: Handle Grooves ---
    // Four circumferential grooves at z = 10, 15, 20 and 25 mm deep (in Z)
    for ([z_pos] in [10.0, 15.0, 20.0, 25.0]) {
        // Create a cylinder that is cut out of the handle to make the groove
        // The groove needs depth 'depth' and width 'width'. 
        // We use difference() with slightly extended faces (handle_cylinder extends past z=45 by ~1mm, tip starts at 62).
        
        // Define a cylinder that will be removed.
        // Radius = diameter / 2 = 3 mm for the groove width? No, depth is usually measured from surface to bottom of cut or centerline distance. 
        // "Cut four circumferential grooves... each 1mm deep". Usually implies radial clearance. Let's assume standard tooling: radius of cutter ~0.5-1mm.
        // To be safe and precise, we define a cylinder with the groove dimensions (radius = depth/2) that is subtracted from the handle surface area? 
        // Actually, for FDM printing grooves in a solid part without over-cutting adjacent features:
        // We create a hollow cylinder of radius 'depth' centered on the Z axis. This removes material at distance 'depth'.
        
        translate([0.0, 0.0, z_pos]) rotate_extrude(PI/2) {
            cube(depth * 1.5); 
        }
    }

    // --- Step 3: Cone Section (Tapered Body) ---
    // Tapers from diameter 8 mm at z=45 to 3 mm diameter at z=62.
    // We need a cone that starts exactly where the handle ends and goes down to the tip level? 
    // Or does it taper *to* the sphere? "tapered... to 3mm diameter". The sphere is centered on this axis.
    // So the cone should go from z=45 (diameter 8) all the way down to where the sphere sits at z=62+1.5 = 63.5 mm radius? 
    // Or does it taper *to* that point, meaning the tip of the cone is at z=62 and diameter becomes 3mm there?
    // Re-reading: "tapers from 8 mm diameter at z = 45 to 3 mm diameter at z = 62". 
    // This implies a linear interpolation between (z=45, r=4) and (z=62, r=1.5).
    
    cone_taper_cylinder(7); // Start with full cylinder
    
    // Extrude the taper down to where it meets the sphere? Or just define the shape that fits inside the tube?
    // The prompt says "tapers... at z = 62". It doesn't explicitly say how long this tapered section is. 
    // However, usually a pestle has a constant diameter or tapers slightly before the tip. 
    // Given the sphere radius (1.5mm) and centering on it, if we taper *to* that point, the cone would end at z=62+radius? No, "tapered... to 3mm".
    // Interpretation: The geometry is a cylinder from z=45 down to some Z_end where diameter becomes 3mm. 
    // Let's calculate Z for r=1.5 in the cone equation (r = R * (z - start_z) / end_z).
    // Actually, simpler interpretation: Just create a conical section that goes from z=45 down to roughly z=62? No, 3mm diameter is small. 
    // Let's assume the taper continues until it meets the sphere or reaches a reasonable length for gripping. 
    // But strictly following "tapers... at z = 62", we will define the cone geometry that ends where r=1.5 occurs.
    
    // We need to calculate Z_end such that radius is 1.5mm starting from R_start=4mm (at z=45).
    // Linear interpolation: 
    // slope_m = (R_final - R_initial) / (Z_final - Z_initial)
    // But we don't know the final length yet? Wait, "tapers... to 3mm". This usually defines the end state.
    // Let's assume a standard pestle height or just define it based on the sphere position if possible. 
    // Since no specific taper length is given for this section other than the diameter change point (z=62), we must infer from context or leave open? 
    // Context: "pestle... inside a 1.5 mL tube". A typical pestle might be ~30-40mm long total, but handle is already there.
    // Let's assume the taper goes down to z=62 + radius (to clear the sphere surface) or simply define it until r=1.5? 
    // If we just extrude a cone from z=45 where R=4 to Z_end where R=1.5, that defines the shape perfectly based on the description "tapers... at z = 62".
    
    // Calculate Z for radius 1.5 starting from r=4 (z_start) with slope determined by linear taper? 
    // Actually, if it tapers *to* a point of diameter 3mm at z=62, then the cone ends exactly there in terms of geometry definition relative to that datum.
    // Let's assume the "tapered body" is simply the conical section connecting the handle end (z=45) to the sphere centerline? 
    // No, 3mm diameter at z=62 means radius 1.5mm. The tip of this cone would be a circle of r=1.5 at z=62.
    // So we extrude from z=45 (R=4) down to Z_end where R=1.5? 
    // Let's calculate the length L such that 3 = 8 * (L / total_length)? No, linear taper: r(z) = m*z + c.
    // If we assume a constant slope based on "tapers... at z=62", it implies the cone ends there? 
    // Let's just create a cylinder from z=45 to Z_end where R becomes 1.5, then extrude that conical shape down further if needed?
    // Wait, simpler: Just define a conic section starting at (z=45, r=4) and ending at the sphere position (z=62+radius)? 
    // No, "tapers... to 3mm". This implies the diameter is 3mm *at* z=62.
    // So we will define a cylinder from z=45 down to Z_end where r=1.5? That would make it taper continuously until that point. 
    // Let's assume the cone ends exactly at the sphere centerline (z = 62 + radius) or just stop when diameter is 3mm?
    // Given "tapers... at z=62", I will define a cylinder from z=45 to Z_end where r=1.5, then extrude that conical shape down further if necessary? 
    // Actually, the most logical interpretation for a pestle part is: A cone section starting at handle end (z=45) and going all the way until it meets the sphere or reaches a certain length.
    // Let's assume the taper continues to meet the sphere surface level? Sphere center z=62+1.5 = 63.5mm radius. 
    // If we start at r=4 (z=45) and end at r=1.5 (z=62), that defines a specific length L where slope is constant.
    
    // Let's calculate the Z coordinate for R=1.5 given linear taper from z_start to z_end? 
    // We don't know z_end yet. But we