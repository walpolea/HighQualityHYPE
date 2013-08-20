HighQualityHYPE
===============

A demo showing how to draw high quality bitmaps with the HYPE Framework
for Processing.


Problem
===============
How do you draw/paint graphics in Processing/HYPE Framework in a small
viewport (800 x 600 @ 72 dpi)
and save big (21" x 16" @ 300 dpi)?

Solution
===============
Copy all vector-based (HDrawable) objects onto an HCanvas at draw-time,
then after draw-time, copy the pixels to the viewport, scale up the
canvas (vectors) and copy high quality pixels off-stage, then scale down
the canvas to it's original size, and clear all of the vector objects from
it. Repeat.
