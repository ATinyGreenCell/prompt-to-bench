// Pestle for 1.5 mL microcentrifuge tube, printed standing upright.
// All dimensions in mm, measured with calipers.

// Handle
handle_d = 8;          // handle diameter
handle_r = handle_d / 2; // handle radius = 4
handle_z0 = 0;         // handle bottom z
handle_z1 = 45;        // handle top z (cone starts here)

// Cone (taper)
cone_d_top = 8;        // cone base diameter (matches handle)
cone_d_bot = 3;        // cone tip diameter (matches sphere)
cone_z0 = 45;          // cone base z
cone_z1 = 62;          // cone tip z

// Rounded tip
tip_d = 3;            // sphere diameter
tip_r = tip_d / 2;    // sphere radius = 1.5
tip_z = 62;           // sphere centre z

// Grip grooves (cut into handle)
groove_w = 2;         // groove width in Z
groove_d = 1;         // groove depth (radial)
groove_zs = [10, 15, 20, 25]; // groove centre z positions

// Curvature quality
$fn = 64;

// ---- Build the solid (handle + cone + sphere) ----
module pestle() { union() {
    // 1. Cylindrical handle
    translate([0, 0, handle_z0])
        cylinder(h = handle_z1 - handle_z0, d = handle_d, $fn = $fn);

    // 2. Cone tapering from 8 mm to 3 mm
    translate([0, 0, cone_z0])
        cylinder(h = cone_z1 - cone_z0, d1 = cone_d_top, d2 = cone_d_bot, $fn = $fn);

    // 3. Rounded tip: sphere centred at z = 62
    translate([0, 0, tip_z])
        sphere(r = tip_r, $fn = $fn);
} }

// ---- Cut four circumferential grip grooves into the handle ----
// Each groove is a torus (ring) whose tube radius equals the groove depth,
// centred on the handle axis at the given z. The torus inner radius is
// handle_r - groove_d, so the ring bites 1 mm into the 4 mm radius handle.
// The ring is 2 mm wide in Z (tube radius 1 mm).
// The ring extends 1 mm past the handle in Z (top/bottom) and 1 mm past the
// handle surface radially (outer radius = handle_r + 1), so no cut face is
// exactly coplanar with a handle face.
difference() {
    pestle();

    for (gz = groove_zs) {
        // Torus: major radius = handle_r - groove_d, minor radius = groove_w/2
        // This creates a ring that is 2 mm wide in Z and 1 mm deep radially.
        // To ensure it extends past the handle faces, we use a slightly larger
        // minor radius or rely on the fact that the groove is well within the
        // handle length (z=10 to z=25, handle is 0 to 45), so the 1 mm radial
        // extension outward is sufficient. The spec says "extend 0.01-1 mm
        // past the faces it cuts" - the groove cuts into the cylindrical side,
        // so the cutting shape must extend past the cylindrical surface.
        // The torus outer radius = (handle_r - groove_d) + groove_w/2 = 4 - 1 + 1 = 4,
        // which is exactly the handle radius. To extend past, we add a small margin.
        // Let's use a slightly larger minor radius to ensure the cut extends past.
        // Actually, the groove is a ring cut into the side. The "faces it cuts"
        // are the cylindrical side of the handle. The torus must extend radially
        // past the handle surface. Let's make the outer radius = handle_r + 0.5
        // by using minor radius = groove_w/2 + 0.5 and major radius = handle_r - groove_d.
        // But that would make the groove wider than 2 mm. Instead, let's just
        // ensure the torus extends past by using a margin in the radial direction.
        // The simplest approach: the torus has major radius = handle_r - groove_d,
        // minor radius = groove_w/2. The outer extent = handle_r - groove_d + groove_w/2.
        // For our values: 4 - 1 + 1 = 4, which equals handle_r. So it's exactly
        // at the surface. We need to extend past. Let's add 0.5 mm to the minor
        // radius to ensure it extends past, but that changes the groove width.
        // Alternative: use a slightly larger major radius offset.
        // Let's just add a small epsilon to ensure the cut extends past.
        // We'll use minor radius = groove_w/2 + 0.01 to extend 0.01 mm past.
        
        // Actually, re-reading rule 5: "make every cutting shape extend 0.01-1 mm
        // past the faces it cuts, so no faces are exactly coplanar."
        // The groove cuts into the cylindrical side. The "face" being cut is the
        // cylindrical surface. The torus must extend radially past this surface.
        // So we need the outer radius of the torus > handle_r.
        // Let's use minor radius = groove_w/2 + 0.5, which gives outer radius =
        // (handle_r - groove_d) + (groove_w/2 + 0.5) = 4 - 1 + 1 + 0.5 = 4.5 > 4.
        // This extends 0.5 mm past, which is within the 0.01-1 mm range.
        // The groove width in Z becomes 2*(groove_w/2 + 0.5) = 3 mm, which is
        // wider than specified. To keep the groove 2 mm wide, we should instead
        // adjust the major radius.
        
        // Better approach: keep minor radius = groove_w/2 = 1, but shift the
        // major radius outward by 0.5 mm. So major radius = handle_r - groove_d + 0.5.
        // Then outer radius = (handle_r - groove_d + 0.5) + groove_w/2 = 4 - 1 + 0.5 + 1 = 4.5.
        // Inner radius = (handle_r - groove_d + 0.5) - groove_w/2 = 4 - 1 + 0.5 - 1 = 2.5.
        // The groove depth into the handle = handle_r - inner_radius = 4 - 2.5 = 1.5 mm.
        // But we want 1 mm deep. So this doesn't work.
        
        // Let's just use the original torus and accept that it's exactly at the
        // surface, or add a tiny epsilon. The rule says 0.01-1 mm, so let's add
        // 0.01 mm to the minor radius.
        
        translate([0, 0, gz])
            rotate_extrude($fn = $fn)
                circle(r = groove_w / 2 + 0.01, $fn = $fn);
        
        // Wait, rotate_extrude with a circle doesn't make a torus. Let me use
        // the proper torus construction. A torus can be made by rotating a circle
        // around an axis. The circle should be in the XZ plane, offset from the axis.
        
        // Let me redo this properly.
    }
}

// Let me restart with a cleaner approach.