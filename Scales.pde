float wth = 960;  //width of window
float hgt = 540;  //height of window
float xBfr = 10;  //buffer near vertical edges
float yBfr = 10;  //buffer near horizontal edges
int xCt = 30;  //number of scales in a row
int yCt = 15;  //number of scales in a column
int sclType = 0;  //how to interpret input values; 0 -> Bezier
boolean stgr = true;  //Whether to stagger scales
float minFill = 55;  //minimum alpha for fill
float maxFill = 255;  //maximum alpha for fill
boolean breatheIn = false;  //whether currently breathing in or out
float[] sclSpecs = {0, 0, -20, 20, -20, 40, 0, 60, 255, 255, 255, 155, 0, 255, 0, 200}; //x, y for anchor point 1; x, y for control point 1; x, y for control point 2; x, y for anchor point 2; red, green, blue, alpha for fill; red, green, blue, alpha for the stroke

void setup(){
  windowResize((int)wth, (int)hgt);
}

void draw(){
  background(100);
  for(int i = 0; i < yCt; i++){  //loops through the rows
    for(int j = 0; j < xCt; j++){  //loops through individual scales in rows
      if(stgr && i%2 == 1){  //if staggering is on and row is odd, runs staggered version of scale and reduces number of scales by 1
        scaleStg((float)j, (float)i, sclSpecs);
        if(j + 2 == xCt){  //if just drew second to last scale, add 1 to j to skip the last one
          j++;
        }
      }
      else{  //otherwise, draw a normal scale
        scale((float)j, (float)i, sclSpecs);
      }
    }
  }
  if(breatheIn){
    if(sclSpecs[11] < maxFill){
      sclSpecs[11] += 5;
    }
    else{
      breatheIn = false;
    }
  }
  else{
    if(sclSpecs[11] > minFill){
      sclSpecs[11] -= 5;
    }
    else{
      breatheIn = true;
    }
  }
}

void mouseClicked(){
  sclSpecs[12] = (float)(Math.random() * 100 + 55);  //randomizes stroke color
  sclSpecs[13] = (float)(Math.random() * 100 + 55);
  sclSpecs[14] = (float)(Math.random() * 100 + 55);
  sclSpecs[8] = (float)(Math.random() * 100 + 100);  //randomizes fill color
  sclSpecs[9] = (float)(Math.random() * 100 + 100);
  sclSpecs[10] = (float)(Math.random() * 100 + 100);
}

void scale(float x, float y, float[] specs){  //draws a scale
  float xOff = xBfr + (specs[0] - specs[2]) + lerp(0, wth - 2 * xBfr - 2 * (specs[0] - specs[2]), norm(x, 0, xCt - 1));  //x offset for anchor point 1, = x buffer + distance between anchor point 1 and control point 1, then interpolates the columns between that starting point and the same distance from the far edge
  float yOff = yBfr + lerp(0, hgt - 2 * yBfr - (specs[7] - specs[1]), norm(y, 0, yCt - 1));  //y offset for anchor point 1, = y buffer, then lerps between y buffer on top and y buffer plus distance between the anchor points on the bottom
  fill(specs[8], specs[9], specs[10], specs[11]);
  stroke(specs[12], specs[13], specs[14], specs[15]);
  bezier(xOff + specs[0], yOff + specs[1], xOff + specs[2], yOff + specs[3], xOff + specs[4], yOff + specs[5], xOff + specs[6], yOff + specs[7]);  //draws left half of scale
  bezier(xOff + specs[0], yOff + specs[1], xOff - specs[2], yOff + specs[3], xOff - specs[4], yOff + specs[5], xOff + specs[6], yOff + specs[7]);  //draws right half of scale
}

void scaleStg(float x, float y, float[] specs){  //staggered version of scale
  float xOff = xBfr + (specs[0] - specs[2]) + lerp(0, wth - 2 * xBfr - 2 * (specs[0] - specs[2]) - lerp(0, wth - 2 * xBfr - 2 * (specs[0] - specs[2]), norm(1, 0, xCt - 1)), norm(x, 0, xCt - 2)) + lerp(0, wth - 2 * xBfr - 2 * (specs[0] - specs[2]), norm(1, 0, xCt - 1)) / 2;  //x offset for anchor point 1, = x buffer + 2 * distance between anchor point 1 and control point 1, then interpolates the columns between that starting point and the same distance from the far edge minus one column, then adds half the width of one column to create the staggering effect
  float yOff = yBfr + lerp(0, hgt - 2 * yBfr - (specs[7] - specs[1]), norm(y, 0, yCt - 1));  //y offset for anchor point 1, = y buffer, then lerps between y buffer on top and y buffer plus distance between the anchor points on the bottom
  fill(specs[8], specs[9], specs[10], specs[11]);
  stroke(specs[12], specs[13], specs[14], specs[15]);
  bezier(xOff + specs[0], yOff + specs[1], xOff + specs[2], yOff + specs[3], xOff + specs[4], yOff + specs[5], xOff + specs[6], yOff + specs[7]);  //draws left half of scale
  bezier(xOff + specs[0], yOff + specs[1], xOff - specs[2], yOff + specs[3], xOff - specs[4], yOff + specs[5], xOff + specs[6], yOff + specs[7]);  //draws right half of scale
}
