/*
The problem: How do you draw small (800x600 72 dpi viewport) and save big (21" x 16" 300 dpi)?
The solution: Copy all vector-based objects onto a canvas at draw-time, then after draw-time,
			  copy the pixels to the viewport and scale up the canvas and copy high quality pixels off-stage.
*/

HCanvas brushLayer;
HCanvas canvasLayer;
HCanvas previewLayer;
PGraphics saveGraphics;

int canvasWidth = 800; 		 //viewport width
int canvasHeight = 600;		 //viewport height
int saveScaleUp = 8;		 //multiplier for the high quality sized saved image, 800 * 8 = 6400, 600 * 8 = 4800 = 6400px x 4800px image
float saveScaleDown = 0.125; //multiplier to return to normal scale ( 1 / saveScaleUp )

String renderer = JAVA2D;

Boolean dirty = false;

void setup() {

	size( canvasWidth, canvasHeight, renderer );
	H.init(this).background( #000000 ).autoClear( true );

	//saveGraphics will hold our high quality image.
	saveGraphics = createGraphics( canvasWidth*saveScaleUp, canvasHeight*saveScaleUp, renderer );
	saveGraphics.smooth();

	//previewLayer will be a low quality version of our patining, so we can see what we have done so far.
	previewLayer = new HCanvas( canvasWidth, canvasHeight, renderer ).autoClear( false );
	H.add( previewLayer );

	//canvasLayer is where vector ovjects get copied when they are drawn to the screen
	//then the vectors are drawn to previewLayer and saveGraphics (low and high quality).
	canvasLayer = new HCanvas( canvasWidth, canvasHeight, renderer ).autoClear( true );
	canvasLayer.transformsChildren(true);
	canvasLayer.graphics().smooth();
	H.add(canvasLayer);

	//brushLayer holds all of the visual things that can be used to paint to the canvasLayer,
	//these things are always visible but only drawn when the mouse is being held down.
	brushLayer = new HCanvas( canvasWidth, canvasHeight, renderer ).autoClear(true);
	brushLayer.graphics().smooth();
	H.add(brushLayer);


	//add some things to the brushLayer to draw with
	for( int i = 0; i < 50; i++ ) {
		HEllipse circle = new HEllipse( (int)random(1, 10) );
		circle.anchor( random(-50,50), random(-50,50) );
		circle.fill( (int)random(255), (int)random(255), (int)random(255), (int)random(127, 255) );
		HFollow follow = new HFollow().target( circle ).ease( random( 0.05, 0.09) ).spring( random( 0.6, 0.95 ) );
		brushLayer.add( circle );
	}

}


void draw() {

	//When holding down left mouse button
	if (mousePressed && (mouseButton == LEFT)) {
		drawToCanvas();
		dirty = true;
	}

	//When the mouse is lifted (done drawing) and there are new objects to save down (dirty)
	if( !mousePressed && dirty ) {
		saveDown();
		dirty = false;
	}

	H.drawStage();
}

//Draws things from the brushLayer to the canvasLayer
void drawToCanvas() {

	
	HDrawable child = brushLayer.firstChild();

	while(child != null) {
		canvasLayer.add( child.createCopy() );
		child = child.next();
	}
	
}

void saveDown() {
	//paint the viewport pixels
	canvasLayer.paintAll( previewLayer.graphics(), false, 1 );
		
	//scale up and paint the high quality graphic to pixels
	canvasLayer.scale( saveScaleUp );
	canvasLayer.paintAll( saveGraphics, false, 1 );
	canvasLayer.scale( saveScaleDown );

	//canvas no longer needs to retain it's current vector children, so clear it
	clearCanvas();
}

void clearCanvas() {
	//Clear out the canvas layer or else things will slow down with so many vector hogging up memory
	HDrawable child = canvasLayer.firstChild();
	HDrawable oldchild;
	while(child != null) {
		oldchild = child;
		child = child.next();
		canvasLayer.remove( oldchild );
	}
}

void keyReleased() {

	switch(key) {
		case 's':

			Date d = new Date();
			long timestamp = d.getTime();
			//Save the image file, this may take 5-10 seconds
			saveDown();
			saveGraphics.save( savePath(timestamp+"_highres.png") );

		break;
	}
}
