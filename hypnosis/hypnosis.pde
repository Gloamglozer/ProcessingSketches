float t = 0;
float speed = .3;
float wavelength = 10.0;
void setup()
{
  size(700,700);
  surface.setResizable(false);
  
}

void draw()
{
  
  loadPixels();
  int x,y;
  for(int i=0; i<width;i++)
  {
    for(int j=0; j<height;j++)
    {
      x = (i-width/2);
      y = (j-height/2);
      pixels[i+j*width] = stripes(.5+ .5*cos((1/wavelength)*(2*wavelength*atan((float)x/y)+sqrt((x*x +y*y)) - (t))));
    }
  }
  updatePixels();
  t += TWO_PI*speed;
  //if(t>TWO_PI)
  //  t = 0.0;
}

color Rainbow(float p)
{
    if(p>=0.0&&p<1.0/6)
    {
      return color(255,(int)(6*p*255),0);
    }
    else if(p>=1.0/6&&p<2.0/6)
    {
      return color((int)(255-6*(p-1.0/6)*255),255,0);
    }
    else if(p>=1.0/3&&p<.5)
    {
      return color(0,255,(int)(6*(p-2.0/6)*255));
    }
    else if(p>=.5&&p<2.0/3)
    {
      return color(0,(int)(255-6*(p-3.0/6)*255),255);
    }
    else if(p>=2.0/3&&p<5.0/6)
    {
      return color((int)(6*(p-4.0/6)*255),0,255);
    }
    else if(p>=5.0/6&&p<=1.0)
    {
      return color(255,0,(int)(255-6*(p-5.0/6)*255));
    }
    else
    {
      return color(255,255,255);
    }
}

color stripes(float a)
{
  if(a>=0.0&&a<=.5)
    return(color(0));
  else
    return(color(255));
}