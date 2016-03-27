import processing.video.*;
int R, G, B, A;                      
import processing.sound.*;
Amplitude amp;
AudioIn in;

int ALL;
float randi;
float dia;
float goal;
//float rowY=6;
float rowY=40;
float wave;
Movie ourMovie;                         

void setup() {
  //size(1920, 1080, P3D);
  size(1280,720,P3D);
  randi=random(noise(0,3));
  //frameRate(30);
  ourMovie = new Movie(this, "leonardo.mp4"); 
  ourMovie.loop();                         
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);
}

void draw() {
  //background (0);
  background (255);
  
  //ourMovie.resize(width,height);
  float volume= amp.analyze(); 
  wave = map(volume,0,0.3,0,30);
  //rowY=map(mouseX,0,width,1,20);
  println(frameRate);
  ourMovie.loadPixels();                     
  for (int x = 0; x<ourMovie.width; x+=4) { //ROW DECREASE
    for (int y = 0; y<ourMovie.height; y+=rowY) {
      PxPGetPixel(x, y, ourMovie.pixels, ourMovie.width);  
      int grey = (R+B+G)/3; //color ratio
      dia = map(grey,0,255,20+randi+wave,0)+goal;
      //dia = map(grey,0,255,10+randi,0)+goal;
      // dia = map(grey,0,255,1+randi,0);
      strokeWeight(4);
      float posx = x*5;
      float posy =y*5;
      stroke(R,G,B);
      float Y1 = y-dia+rowY/2;
      float Y2 = y+dia+rowY/2;
      constrain(x,0,width-1);
      constrain(Y1,0,height-1);
      constrain(Y2,0,height-1);
      line(x,Y1,x,Y2);
    }
  }
  if(mousePressed){
      image(ourMovie, 0, 0);
  }
 //saveFrame("frames/####.tif");
}

void movieEvent(Movie m) {              
  m.read();
}



//Special thanks: Danny Rozin's(ITP faculty) getPixels function

void PxPGetPixel(int x, int y, int[] pixelArray, int pixelsWidth) {
  int thisPixel=pixelArray[x+y*pixelsWidth];     // getting the colors as an int from the pixels[]
  A = (thisPixel >> 24) & 0xFF;                  // we need to shift and mask to get each component alone
  R = (thisPixel >> 16) & 0xFF;                  // this is faster than calling red(), green() , blue()
  G = (thisPixel >> 8) & 0xFF;   
  B = thisPixel & 0xFF;
}

void PxPSetPixel(int x, int y, int r, int g, int b, int a, int[] pixelArray, int pixelsWidth) {
  a =(a << 24);                       
  r = r << 16;                       // We are packing all 4 composents into one int
  g = g << 8;                        // so we need to shift them to their places
  color argb = a | r | g | b;        // binary "or" operation adds them all into one int
  pixelArray[x+y*pixelsWidth]= argb;    // finaly we set the int with te colors into the pixels[]
}
