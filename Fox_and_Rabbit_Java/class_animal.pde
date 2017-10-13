class animal
{
  public PVector pos, lastpos, vel, acc;
  public int rad;
  public color col;

  animal(float x, float y, float vx, float vy, float ax, float ay, int r, color c)
  {
    lastpos = new PVector(x, y);
    pos = new PVector(x, y);
    vel = new PVector(vx, vy);
    acc = new PVector(ax, ay);
    rad = r;
    col = c;
  }

  void update()
  {
    pos.add(vel);
    vel.add(acc);

    if (pos.x<rad)
    {
      pos.x = rad;
      vel.x *=-1;
    }
    if (pos.x>width-rad)
    {
      pos.x = width-rad;
      vel.x *=-1;
    }
    if (pos.y<rad)
    {
      pos.y = rad;
      vel.y *=-1;
    }
    if (pos.y>height-rad)
    {
      pos.y = height-rad;
      vel.y *=-1;
    }
  }

  void show()
  {
    stroke(col);
    fill(col);
    ellipse(pos.x, pos.y, 2*rad, 2*rad);
  }
  void showline()
  {
    //stroke(col);
    //fill(col);
    line((int)lastpos.x,(int)lastpos.y,(int)pos.x,(int)pos.y);
    lastpos = pos.copy();
  }
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

  