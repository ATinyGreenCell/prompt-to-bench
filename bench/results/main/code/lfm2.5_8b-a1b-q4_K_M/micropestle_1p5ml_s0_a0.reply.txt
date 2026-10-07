<think>
We need to produce an OpenSCAD script that builds a pestle part as described.

Constraints:

- Units in mm.
- Named variables at top with dimensions and comments.
- Model orientation: rests on XY plane at z=0, building upward (+Z). Center on origin in X and Y (so handle centered at (0,0)).
- Use only built-in OpenSCAD primitives: cube, cylinder, sphere, polygon, circle, square, linear_extrude, rotate_extrude, translate, rotate, mirror, union, difference, intersection, hull, for loops.
- No include or external libs.

We need to create a solid part that includes:

1. Cylindrical handle: diameter 8 mm, height from z=0 to z=45. So radius = 4 mm. Height = 45 mm. Use cylinder with radius 4 and height 45, placed at origin (centered). That's straightforward.

2. A cone that tapers from 8 mm diameter at z=45 to 3 mm diameter at z=62. This is a frustum of a cone? Actually it's a conical shape: base radius = 4 mm at lower end, top radius = 1.5 mm at upper end (since 3 mm diameter). Height = 62 - 45 = 17 mm. So we need to create a cone with those dimensions. In OpenSCAD, we can use cylinder extrude and then subtract something? Or we can define a cone using the "cone" primitive: cone(radius, height, point). Actually there is a built-in function `cone` that takes radius, height, point (center of base?). Let's recall: In OpenSCAD, `cone(r, h, p)` creates a cone with its apex at point p and base radius r. The base is perpendicular to the line from p to origin? Actually typical usage: `cone(5,10,0)` gives a cone with apex at (0,0,0) and base radius 5 at z=10. So we can use that.

Thus we need to define coordinates for the lower end of the frustum at z=45. The lower end is a circle of radius 4 mm in XY plane. At z=45, we have apex? Actually the handle ends at z=45 with a circular face of diameter 8 mm (radius 4). Then above that, the cone starts: its base radius is 4 mm at z=45, and top radius is 1.5 mm at z=62. So we can create a frustum by taking a cylinder of height 17 mm and then subtract a smaller cone? Or easier: define a cone with apex at (0,0,45) and base radius 4 at z=45, but that would have zero height if apex at same plane. Not correct.

Better: Use two cones: one from apex to lower end, and another inverted? Actually we can create the frustum directly using `cylinder` extruded with a truncated shape? There's no direct frustum primitive. But we can use `difference()` between a larger cone and a smaller cone.

Define:

- Lower cone: radius 4 mm, height 45 mm, apex at (0,0,0). That would produce a cone that ends at z=45 with base radius 4. Then define a second cone with same apex but height 17 mm? Actually we need the top of the handle to be at z=45 with radius 4. So we can have a larger cone from apex (0,0,0) to z=45 (height 45). Then cut away the part above z=45? Wait we want the handle to be only up to z=45. The top of handle is flat circular face at z=45 radius 4. So we can have a cylinder of height 45 and radius 4, then on top of that, we need to taper down from radius 4 at z=45 to radius 1.5 at z=62. That's a frustum with lower radius 4, upper radius 1.5, height 17.

Thus we can create the frustum directly using `cylinder` and then subtract a smaller cone? Actually we can define a larger cone that extends beyond the handle (height >45) and cut it off at z=45. Or use `difference()` between a cylinder of radius 4 and height 62, and a smaller cone of same base radius but lower height? Let's think.

Simplify: Use two steps:

- Create a cylinder of radius 4 mm, height 62 mm (so extends from z=0 to z=62). Then cut away the top part above z=45 using `difference()` with a cone that has apex at (0,0,45) and base radius 4? Actually we need to remove material above z=45. So define a cone with radius 4, height 17 mm, apex at (0,0,45). Then subtract that from the cylinder.

Thus handle = union of cylinder (z=0-62) minus cone (apex at (0,0,45), base radius 4, height 17). That yields a shape with flat bottom at z=0, cylindrical part up to z=45, then frustum taper up to z=62.

Thus we need to define the cylinder: `cylinder(radius=4, height=62, $color="black")` (or any color). Then define cone: `cone(r=4, h=17, p=(0,0,45))`. Use `difference(handle, cone)`.

But note that the bottom of the handle is at z=0, and we want it to rest on XY plane. So after union, we have shape.

3. Rounded tip: a 3 mm diameter sphere centered at z = 62. So radius = 1.5 mm. Place sphere at (0,0,62). Use `sphere(radius=1.5, $color="white")`.

Now the grooves on the handle: four circumferential grooves each 2 mm wide in Z and 1 mm deep, centered at z = 10, 15, 20, 25. So we need to cut four slots around the circumference of the handle at those heights. Each groove is a rectangular channel (like a slot) that goes through the handle thickness? The handle extends from z=0 to z=45. At each specified z-level, there is a groove that goes through the entire cross-section (i.e., depth 1 mm). So we need to create four channels around the circumference.

Simplify: For each angle (0°, 90°, etc.) we can use `translate` and `rotate_extrude`? Actually we can use `for` loop over angles, and for each angle extrude a rectangular groove of width 2 mm in Z direction (depth) and length equal to the handle diameter (8 mm). But need to cut through the entire thickness of the handle. Since the handle is a solid cylinder, we can create a cylindrical hole? Actually we want a slot that goes from bottom (z=0) up to top (z=45)? Or just depth 1 mm into the material, i.e., a groove that removes material in Z direction only, leaving side walls. So we need to cut a rectangular channel of width 2 mm and depth 1 mm, with length equal to the handle diameter (8 mm). The channel should be centered at each z-level.

Thus we can define a function that creates a slot: `slot(width=2, depth=1, length=8)` extruded along X? Actually we need to cut through the cylinder. Use `cylinder` with radius 4, height = something? Wait we want a rectangular cross-section, not circular. In OpenSCAD, you can create a rectangular channel using `box` and then subtract? But we cannot use box? We have only allowed primitives: cube, cylinder, sphere, polygon, circle, square, linear_extrude, rotate_extrude, etc. There's no "rectangle" primitive directly, but we can define a shape using `cylinder` with radius small and then extrude? Actually we could create a rectangular groove by using `cylinder` of radius 0 (line) and then offset? Not possible.

Alternative: Use `hole` function? Not allowed. However we can use `difference()` between a cylinder representing the full handle cross-section and a cylinder representing the material to be removed. For each groove, define a small cylinder that occupies the region of the groove: radius = 1 mm (half width) because width 2 mm, depth = 1 mm, length = 8 mm (full diameter). Place it at appropriate z-level.

Thus we can create four such cylinders and subtract them from the handle. However we need to ensure they are centered on the axis? Actually each groove is circumferential, meaning around the circumference. So for a given angle, the cylinder's axis should be offset radially outward by 1 mm (half of width) from the central axis? Wait the groove is a channel that goes through the handle thickness, not radial cut. The description: "four circumferential grooves into the handle, each 2 mm wide (in Z) and 1 mm deep, centred at z = 10, 15, 20 and 25." Means each groove is a rectangular slot that runs around the circumference of the handle (i.e., like a channel that goes through the entire length of the handle). So for each angle, we have a cylinder whose axis is parallel to Z, located at radius = (1 mm) from center?