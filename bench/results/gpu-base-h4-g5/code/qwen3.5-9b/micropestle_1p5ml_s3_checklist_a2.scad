// Pestle for 1.5 mL microcentrifuge tube - standing upright on XY plane.
// Dimensions in mm.

// Handle
h_dia  = 8;
h_len  = 45;

// Cone
c_d1   = 8;
c_d2   = 3;
c_len  = 62 - 45; // 17

// Tip
tip_r  = 1.5; // 3 mm diameter
tip_z  = 62;  // Center Z of sphere

// Grooves
g_cnt  = 4;
g_w    = 2;   // Width in Z
g_d    = 1;   // Depth
g_zs   = [10, 15, 20, 25]; // Center Z positions

$fn = 64;

// Main body: Handle + Cone + Tip
// We build the positive volume first, then subtract grooves.

// 1. Handle (cylinder)
// Centered in X/Y, sitting on Z=0.
translate([0, 0, 0])
    cylinder(h = h_len, d = h_dia);

// 2. Cone (frustum)
// Starts at Z=45, ends at Z=62.
// Cylinder points along Z. We need to position it so bottom is at 45.
translate([0, 0, 45])
    cylinder(h = c_len, d1 = c_d1, d2 = c_d2);

// 3. Tip (sphere)
// Centered at Z=62.
translate([0, 0, tip_z])
    sphere(r = tip_r);

// 4. Grooves
// Cut into the handle.
// Handle radius is 4.
// Groove width 2mm, depth 1mm.
// "Circumferential grooves... centred at z = 10..." implies rings around the handle.
// "2 mm wide (in Z)" confirms they are rings (toroidal cuts) with thickness 2mm along Z.
// To cut a ring groove (a hole in the shape of a ring) into a solid cylinder:
// We subtract a cylinder of radius (handle_radius - depth) centered at the origin.
// This removes the core, leaving a hollow tube.
// Wait, if I subtract a cylinder of radius 3 from a cylinder of radius 4, I get a tube.
// Is a tube a "groove"?
// Usually, a "groove" on a pestle handle is a slot cut into the side, not a hole through the center.
// However, "circumferential" and "wide in Z" strongly suggests rings.
// If the user wants a ring groove, the result is a tube.
// If the user wants a slot (axial groove), the result is a solid cylinder with a rectangular hole running along Z.
// Given the ambiguity, and the fact that "circumferential" usually means perpendicular to the axis (rings),
// I will model them as rings.
// BUT, a tube is structurally weak for a pestle.
// Let's re-read carefully: "four circumferential grooves... each 2 mm wide (in Z)".
// If they are rings, they are like O-rings cut into the handle.
// The material removed is the ring.
// The material remaining is a solid cylinder with a ring-shaped hole?
// No, a ring-shaped hole means the hole goes all the way around.
// So the material remaining is a solid cylinder with a hole in the middle?
// Yes.
// So subtracting a cylinder of radius 3 from a cylinder of radius 4 creates a tube.
// This seems to be the only way to interpret "circumferential groove" with "width in Z".
// However, maybe the user means "axial grooves" (slots running along Z) but described them as "circumferential" because they are cut *around* the circumference? No, that doesn't make sense.
// Maybe the user means "circumferential ridges"? No, "grooves".
// Let's assume the user wants **axial grooves** (slots running along Z) because that is standard for pestles.
// "Circumferential" might be a mistake for "longitudinal" or "axial".
// "2 mm wide (in Z)" would then mean the length of the slot is 2mm.
// "Centred at z = 10..." would mean the slots are short segments along the Z axis.
// This makes sense for a grip texture.
// Let's try this interpretation: Axial slots (grooves running along Z).
// Each slot is a rectangular hole running along Z.
// Width in Z = 2mm.
// Depth = 1mm.
// The slot goes all the way around the circumference?
// If it goes all the way around, it's a ring.
// If it's a ring, it's a tube.
// If it's a slot that doesn't go all the way around, it's a partial ring.
// "Circumferential" implies it goes all the way around.
// So it's a ring.
// So it's a tube.
// Okay, I will model them as rings (tubes) because that is the literal interpretation of "circumferential".
// If the user meant axial slots, they would have said "axial" or "longitudinal".
// The fact that they said "circumferential" and "wide in Z" (thickness of the ring) confirms they are rings.
// The resulting part will be a tube.

// To cut a ring groove:
// Subtract a cylinder of radius (handle_radius - depth) centered at the origin.
// This removes the core, leaving a tube.
// The tube has an inner radius of 3mm and an outer radius of 4mm.
// The length of the tube is the width of the groove in Z (2mm).
// We need to position the tube at the correct Z.
// The tube is centered at Z = g_zs[i].
// The tube has height g_w.
// So the tube extends from g_zs[i] - g_w/2 to g_zs[i] + g_w/2.

// We need to subtract 4 such tubes.
// Each tube is a cylinder with a hole? No, a cylinder with a hole is a ring.
// In OpenSCAD, to subtract a ring, we subtract a cylinder of radius (inner_radius) centered at the origin?
// No, that removes the core.
// We want to remove the ring.
// So we subtract a cylinder of radius (outer_radius)? No, that removes everything.
// We subtract a cylinder of radius (inner_radius)? No, that removes the core.
// Wait, if I have a solid cylinder (R=4) and I subtract a cylinder (R=3), I get a tube.
// The tube has an inner radius of 3 and an outer radius of 4.
// This is exactly what we want!
// The "groove" is the empty space in the middle (the hole of the tube).
// So we subtract a cylinder of radius 3 centered at the origin.
// But we only want to subtract it in the Z range of the groove.
// So we subtract a cylinder of radius 3, but we need to limit its Z extent?
// No, the cylinder primitive has a fixed height.
// We can use `difference()` to subtract a cylinder of radius 3 and height g_w, centered at the groove position.
// But the cylinder primitive is centered at the origin by default? No, `cylinder(h, d)` is centered at the origin.
// We need to translate it.
// So we translate the cylinder to the groove position.
// The cylinder will be from z = g_zs[i] - g_w/2 to z = g_zs[i] + g_w/2.
// And it will have radius 3.
// Subtracting this from the handle (radius 4) will create a tube of thickness 1mm.
// This matches the "depth" of 1mm.
// The "width in Z" is 2mm.
// This matches the "width in Z" of 2mm.
// So this is the correct interpretation.

// Let's build the grooves.
// We need to subtract 4 cylinders of radius 3, centered at the groove positions.
// The cylinders have height g_w.

for (i = [0 : g_cnt - 1]) {
    z_center = g_zs[i];
    z_start = z_center - g_w / 2;
    z_end = z_center + g_w / 2;
    
    // Subtract the ring (tube)
    // The ring is a cylinder of radius 3, centered at (0,0,z_center), with height g_w.
    translate([0, 0, z_center])
        cylinder(h = g_w, d = 2 * (h_dia / 2 - g_d));
}