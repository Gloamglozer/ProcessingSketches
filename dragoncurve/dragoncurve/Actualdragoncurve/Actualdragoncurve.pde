// Use J and K to go to the next iteration of the dragon curve

IntList turns,junklist;
int iterations=0,x0=276,y0=500; 
float x,y;
float vectorlength;
PVector linevector;
color begin, end;

void setup()
{
  size(1024,1024,OPENGL);
  frame.setResizable(true);
  turns = new IntList();
  turns.clear();
  turns = dragoncurve(iterations,turns);
  
  
  linevector = new PVector(vectorlength,0);
  background(0);
}

void draw()
{
    
  background(0);
  //begin = color(242,131,164);
  //end = color(16,30,100);
  stroke(Rainbow(0));
  
  vectorlength = .5*width;
  linevector.set(vectorlength*pow(1/sqrt(2),iterations),0);
  linevector.rotate(-iterations*HALF_PI/2);
  x = width*.29;
  y = height*.66;
  
  line(x,y,x + linevector.x,y + linevector.y);
  x += linevector.x;
  y += linevector.y;
  
  beginShape(LINES);
  for(int j = 0; j<turns.size();j++)
  {
    Rotate(linevector,turns.get(j));
    stroke(Rainbow(((float)j)/turns.size()));
    //stroke(Rainbow(((float)iterations)/20));
    vertex(x,y);
    vertex(x + linevector.x,y + linevector.y);
    x += linevector.x;
    y += linevector.y;
  }
  endShape();
}


IntList dragoncurve(int iter,IntList turnlist) //recursive function that creates a list of left and right turns
{
  if(iter>0)
  {
    IntList revturnlist = turnlist.copy();
    revturnlist.reverse();
    for(int i = 0; i<turnlist.size();i++)
    {
      revturnlist.set(i,revturnlist.get(i)*-1);
    }
    turnlist.append(1);
    turnlist.append(revturnlist);
    iter--; 
    
    dragoncurve(iter,turnlist);
    return turnlist;
  }
  return turnlist;
}

void keyTyped()//using 'j' and 'k' to increment or decrement the number of iterations shown
{
  if(key=='k')
    iterations++;
  else if(key=='j'&&iterations>0)
    iterations--; 
  else if(key=='s')
    saveFrame("background###.tif");
    
  println(iterations);
  
  turns.clear();
  turns = dragoncurve(iterations,turns);
}

PVector Rotate(PVector vector, int rotationfactor) //positive 1 rotates left, negative 1 rotates right. 
{
    float holdover = vector.x;
    vector.x = -(vector.y*rotationfactor);
    vector.y = holdover*rotationfactor;
    return vector;
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

  