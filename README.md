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

How do I test this thing?
===============
1. Install Processing from Processing.org
2. Create a HighQualityDrawingDemo Folder on your computer
3. Save HighQualityDrawingDemo.pde and HYPE.pde (or get the latest from hypeframework.org) to that folder.
4. Open HighQualityDrawingDemo.pde in Processing and hit the Run button.

Notes
===============
If you have memory errors you will want to go into the processing settings
and let your app use more memory, like 2048mb.

With memory allocation limits I have only been able to export
9000 x 7200 px @ 72 dpi png images, which ain't half bad.
