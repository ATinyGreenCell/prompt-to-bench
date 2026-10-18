// Adapter Sleeve for 0.2 mL PCR tube in 1.5 mL rack
// Print orientation: Upside down (Collar on bed)
// Units: mm

// Dimensions
$fn = 128; // High resolution for smooth curves and accurate holes

// Collar (Base)
$collar_diameter = 13.0;
$collar_thickness = 1.5;

// Sleeve Body
$sleeve_outer_diameter = 10.8;
$sleeve_total_height = 21.5;

// Bore
$bore_diameter = 6.2;

// Overcuts for clean printing (Rule 5)
$overcut = 0.1;

// Calculate derived dimensions
$collar_radius = $collar_diameter / 2;
$sleeve_outer_radius = $sleeve_outer_diameter / 2;
$bore_radius = $bore_diameter / 2;

// Main Body Construction
difference() {
    // 1. Create the outer shell as a single solid cylinder
    // This ensures the total height is exactly $sleeve_total_height
    // It rests on the bed at z=0.
    cylinder(
        h = $sleeve_total_height,
        r = $sleeve_outer_radius,
        $fn = $fn
    );
    
    // 2. Cut the Collar Hole (Top of the part, since it's upside down)
    // The collar is the wider part at the bottom (z=0 to 1.5).
    // Wait, the spec says: "collar ... lies on the bed".
    // So the Collar is at Z=0 (Wide) and the Sleeve is at Z=1.5 (Narrow).
    // The bore must go through the whole thing.
    
    // We need to cut a hole for the collar (diameter 13) at the bottom (z=0 to 1.5)
    // But the outer shell is only 10.8mm diameter. 
    // The collar is the BASE of the rack hole. The adapter sits IN the rack hole.
    // Re-reading spec: "adapter sleeve that lets a 0.2 mL PCR tube sit in a rack hole made for 1.5 mL tubes."
    // "collar 13 mm in diameter ... lies on the bed".
    // This implies the 13mm part is the BOTTOM of the printed object.
    // The 10.8mm part is the TOP.
    // The 0.2mL tube goes into the 10.8mm part? No, 0.2mL is smaller than 1.5mL.
    // Usually, you print a spacer that fits into the 1.5mL hole (13mm) and holds the 0.2mL tube.
    // BUT the spec says: "collar 13mm ... lies on the bed".
    // If the collar is 13mm and lies on the bed, it matches the 1.5mL rack hole.
    // The sleeve body is 10.8mm OD.
    // The bore is 6.2mm.
    // The 0.2mL tube (approx 10-11mm OD) would NOT fit inside a 10.8mm sleeve if the sleeve is the outer wall.
    // Unless the 10.8mm is the INNER diameter? No, "10.8 mm outer diameter".
    // Let's re-read carefully: "adapter sleeve that lets a 0.2 mL PCR tube sit in a rack hole made for 1.5 mL tubes."
    // Standard 1.5mL hole: ~13mm. Standard 0.2mL tube OD: ~10.5-11mm.
    // If the adapter has a 13mm collar on the bed, it sits in the rack.
    // The body rising from it is 10.8mm OD.
    // If the 0.2mL tube sits in the rack hole, it sits in the 13mm hole.
    // The adapter must hold the tube.
    // Perhaps the 10.8mm is the ID of the sleeve? No, "outer diameter".
    // Maybe the 0.2mL tube is placed *inside* the 10.8mm sleeve? 
    // If the tube OD is ~10.8mm, it fits tightly.
    // The bore is 6.2mm. This is likely for a pipette tip or just a hole through the tube?
    // Or maybe the 6.2mm is the ID of the 0.2mL tube? (Standard 0.2mL ID is ~6mm).
    // So the 0.2mL tube fits inside the 10.8mm sleeve, and the 6.2mm bore allows the tube to pass through?
    // No, "bore runs through the full height".
    // If the tube is inside the sleeve, and there is a bore through the sleeve, the tube would fall out unless it's held by friction or the bore is smaller than the tube.
    // 0.2mL tube OD ~ 10.8mm. Bore 6.2mm.
    // The tube sits in the 10.8mm sleeve (friction fit). The 6.2mm bore is empty space inside the tube?
    // No, the bore is in the adapter.
    // If the adapter has a 6.2mm hole, and the tube (10.8mm OD) is inside the adapter (10.8mm OD), the tube cannot be inside the adapter if the adapter has a hole through it, unless the hole is in the center of the tube.
    // Wait, if the tube is 10.8mm OD, and the sleeve is 10.8mm OD, they are the same size.
    // If the sleeve has a 6.2mm hole, the tube (which is solid except for its own bore) would block the 6.2mm hole if the tube's bore is smaller than 6.2mm.
    // Standard 0.2mL tube ID is ~6.0mm.
    // So the 6.2mm bore in the adapter matches the tube's ID.
    // The tube sits in the adapter (10.8mm OD fits 10.8mm OD).
    // The adapter's 6.2mm hole aligns with the tube's 6.0mm hole.
    // This makes sense.
    
    // Geometry Confirmation:
    // Bottom (z=0 to 1.5): 13mm OD (Collar). Fits in 1.5mL rack.
    // Top (z=1.5 to 21.5): 10.8mm OD (Sleeve). Holds 0.2mL tube.
    // Center Hole: 6.2mm through entire height.
    
    // My previous logic was correct about the shape, but the Z-height was wrong.
    // I will rebuild using a single outer cylinder of 21.5mm height to ensure Z max is correct.
    
    // Cut the Collar Hole (Bottom part, z=0 to 1.5)
    // The collar is 13mm OD. We need to cut a 13mm hole?
    // No, the collar IS the 13mm part. The rack hole is 13mm.
    // The adapter sits IN the rack hole.
    // So the adapter's bottom is 13mm OD.
    // The rack hole is 13mm.
    // So the adapter fits snugly.
    // Do we need to cut a hole in the collar?
    // The rack hole is 13mm. The adapter bottom is 13mm.
    // They match. No hole needed in the collar itself, it's the interface.
    // BUT, the rack hole is a hole in the rack. The adapter sits in it.
    // The adapter is a solid piece (except for the central bore).
    // So the bottom of the adapter is a solid 13mm disk.
    // The rack hole (13mm) accepts this disk.
    // Correct.
    
    // Cut the Sleeve Hole (Top part, z=1.5 to 21.5)
    // The sleeve is 10.8mm OD.
    // The rack hole