*   "Use only built-in OpenSCAD".
    *   "Difference cuts extend 0.01-1 mm".
    *   "$fn = 64".
    *   "For loops".

15. **One detail on Gussets:**
    *   "flush with the left and right edges (x = -25 to -20 and x = 20 to 25)".
    *   This implies the Gusset X range is [-25, -20] and [20, 25].
    *   The Base X range is [-25, 25].
    *   So the Gussets are part of the Base width.
    *   The Vertical Plate X range is [-25, 25].
    *   So the Gussets are aligned with the Vertical Plate edges.
    *   This is consistent.

16. **One detail on Holes:**
    *   "In difference(), make every cutting shape extend 0.01-1 mm past the faces it cuts".
    *   Base Z: 0 to 5. Hole Z: -0.1 to 5.1.
    *   Vertical Y: 0 to 5. Hole Y: -0.1 to 5.1.
    *   This ensures clean cuts.

17. **One detail on Orientation:**
    *   "Base plate lies on the bed".
    *   "Base plate: ... z from 0 to 5".
    *   So Z is up.
    *   "Vertical motor plate ... z from 0 to 50".
    *   So Z is up.
    *   "standing on the back edge".
    *   If Base is Y[0, 45], and Vertical is Y[0, 5].
    *   They share the Y[0, 5] region.
    *   This means the Vertical