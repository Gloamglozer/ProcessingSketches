//THINGS TO FIX:

//glitch that makes groups that capture have too many liberties--need to change order of liberty spreading with taking
//should evaluate liberties again after all capturing is over. Maybe the 0 liberties ko think is not great. It should be possible without looking at 
// the previous gamestate. that would make it slow

//- make ko work --currently does not because of simplistic islegal neighbor checking 
// Does not work whenever there is a stone adjacent to the ko'd eye that only has one liberty

//- FIXED(Can currently play in places that would result in immediate death for a surrounded
//  group of the player's pieces-- amend islegal to exclude places that are completely
//  surrounded by enemy pieces or pieces on your side with no liberties.)

//?Use something better than "immunity" boolean for exemption from being removed for newly-placed pieces.?

//implement record for taking back moves and saving game (maybe have slideshow function showing progress of game after it is over?)

//clean up functions and make things more organized, find some way around magic numbers?

int width = 1000;
int height = 600;
gamestate Game; 
int board = 500;
int gridsize = 9; //max gridsize 100
int step = board/(gridsize+1);
int incher = step;
int xoffset = width/2-board/2+step/2;
int yoffset = height/2-board/2+step/2;

void setup()
{
  Game = new gamestate();
  Game.step = step;
  Game.size = gridsize;
  Game.player1 = color(0);
  Game.player2 = color(255);
  Game.begin();
  size(1000, 600);
  //surface.setResizable(true);
  Game.drawboard();
  
  textFont(createFont("Arial",16,true));
}
void draw()
{
  //At beginning of turn find illegal plays
  //Mouseover (snap opaque stone to closest intersection if move is legal)
  //
  
}

void mouseClicked()
{
  pushMatrix();
  translate(xoffset, yoffset);
  int x = (mouseX-xoffset)/step;
  int y = (mouseY-yoffset)/step;
  if ((x<gridsize&&x>=0)&&(y<gridsize&&y>=0))
  {
    if (Game.pieces[x][y].islegal)
    {
      Game.pieces[x][y].status = Game.whoseturn;  
      AddToGroup(Game.pieces,x,y,Game);
      Game.pieces[x][y].immunity= true;
      Game.endturn();
      Game.pieces[x][y].immunity=false;
    }
  }
  popMatrix();
  Game.drawboard();
  Game.drawpieces();
}  

void keyPressed()
{
  if(key=='r'||key=='R')
  {
    Game.begin();
    Game.drawboard();
  }
}

void AddToGroup(intersection pieces[][], int x, int y,gamestate Game)
  {
    int whichgroup=0,oldgroup[] = {-1,-1,-1};
    boolean consolidate = false;
    try                                                 //checking right
    {                                                   //this is the first check, so if it detects a stone of the same color as it, 
      if(pieces[x+1][y].status==pieces[x][y].status)    //it will automatically join that group and set whichgroup to that group,
      {                                                 //which will change any connected groups to the group number at whichgroup
        pieces[x][y].group = pieces[x+1][y].group;
        whichgroup = pieces[x+1][y].group;
      }
    }catch(ArrayIndexOutOfBoundsException e){}
    try                                                  //checking above
    {
      if(pieces[x][y-1].status==pieces[x][y].status)
      {
        if(whichgroup==0)
        {
          pieces[x][y].group = pieces[x][y-1].group;
          whichgroup = pieces[x][y-1].group;
        }
        else if(pieces[x][y-1].group!=whichgroup) //if this is not another part of the same group, we must join the groups
        {
          oldgroup[0]= pieces[x][y-1].group;      //store the number of the second group to be consolidated into the first group
          consolidate = true;
        }
      }
    }catch(ArrayIndexOutOfBoundsException e){}
    try                                                //checking left
    {
      if(pieces[x-1][y].status==pieces[x][y].status)
      {
        if(whichgroup==0)
        {
          pieces[x][y].group = pieces[x-1][y].group;
          whichgroup = pieces[x-1][y].group;
        }
        else if(pieces[x-1][y].group!=whichgroup)
        {
          oldgroup[1]= pieces[x-1][y].group;
          consolidate = true; 
        }
      }
    }catch(ArrayIndexOutOfBoundsException e){}
    try
    {
      if(pieces[x][y+1].status==pieces[x][y].status)
      {
        if(whichgroup==0)
        {
          pieces[x][y].group = pieces[x][y+1].group;
          whichgroup = pieces[x][y+1].group;
        }
        else if(pieces[x][y+1].group!=whichgroup)
        {
          oldgroup[2]= pieces[x][y+1].group;
          consolidate = true;
        }
      }
    }catch(ArrayIndexOutOfBoundsException e){}
    
    if(consolidate)                           ///if two groups were joined, make them one big group
      ConsolidateGroups(pieces, whichgroup,oldgroup,pieces[x][y].status);
    
    if(pieces[x][y].group==0)
    {
      if(pieces[x][y].status==1)
      {
        pieces[x][y].group = Game.blackgroup;
        Game.blackgroup++;
      }
      else
      {
        pieces[x][y].group = Game.whitegroup;
        Game.whitegroup++;
      }
    }
  }
  
  void ConsolidateGroups(intersection pieces[][],int whichgroup,int oldgroup[],int stat )
  {                                     //if you see a designated group, change it to the new group. 
    for(int m = 0; m<gridsize; m++){
      for(int n = 0; n< gridsize; n++){
        if((pieces[m][n].group == oldgroup[0]||pieces[m][n].group == oldgroup[1]||pieces[m][n].group == oldgroup[2])&&(pieces[m][n].status==stat))
        {
          pieces[m][n].group=whichgroup; 
        }
      }
    }
  }