class record
{
  int status;
  boolean immunity;
  record()
  {
    
  }
}
class intersection
{
  boolean islegal;
  boolean immunity;
  int status; // int variable 0: no stone 1: black stone -1: white stone.
  int liberties;
  color col; 
  int group; 
  
  intersection()
  {
    islegal = true;
    status = 0;
    liberties = 0;
    col = color(255, 0, 0);
    group = 0; 
    immunity = false;
  }
  void die()
  {
    if(immunity==false)
    {
      islegal = true;
      status = 0;
      liberties = 0;
      group = 0;
    }
  }
  boolean thisNeighborMakesItLegal(int whoseturn)
  {
    if(status==0||(status==whoseturn&&liberties!=1)||(status==whoseturn*-1&&liberties==1))
      return true;
    else 
      return false;
  }
  boolean isblack()
  {
    if(status == 1)
      return true;
    else 
      return false;
  }
  
  boolean iswhite()
  {
    if(status == -1)
      return true;
    else
      return false;
  }
  boolean isempty()
  {
    if(status==0)
      return true;
    else
      return false;
    
  }
}

//UNUSED
class groupedstones // list of all intersections by group. 
{
  int index[];
  intersection pieces[][];
  intersection groupedpieces[][];
  
  groupedstones()
  {
  }
}


class gamestate
{
  int size, step, piecediameter, turn=0, whoseturn=1,whitegroup=1,blackgroup=1;
  intersection pieces[][];
  record rec[][];
  char homology[];
  color player1, player2;
  
  color whosecolor()
  {
    if (whoseturn == 1)
    {
      return player1;
    } else
      return player2;
  }
  
  void begin() /// creates array of intersection objects in default state.
  {            /// initializes variable piecediameter which is dependent on step.
    turn=0; whoseturn=1;whitegroup=1;blackgroup=1;
    pieces = new intersection[size][size];
    for (int n = 0; n < size; n++) {
      for (int m = 0; m < size; m++) {
        pieces[n][m] = new intersection();
      }
    }
    piecediameter = step -5;
  }
  
  void drawboard()   /// Drawing Board.
  {
    pushMatrix();
    fill(255, 195, 0);
    stroke(0);
    rectMode(CENTER);
    rect(width/2, height/2, board, board);
    translate(width/2 - board/2, height/2 - board/2);
    incher = step;
    for (int i = 0; i<gridsize; i++)
    {
      line(step, incher, board-step, incher);
      line(incher, step, incher, board-step);
      incher += step;
    }
    translate(step, step); //Origin at top and leftmost intersection
  
    fill(0);//Drawing Star points
    stroke(0);
    switch(gridsize)
    {
    case 19:
      for (int i=3; i<19; i+=6)
      {
        ellipse(3*step, i*step, 5, 5);
        ellipse(9*step, i*step, 5, 5);
        ellipse(15*step, i*step, 5, 5);
      }
      break;
    }
    popMatrix();
  }
  

  void drawpieces()  ///Expects origin at top left liberty
  {
    pushMatrix();
    translate(width/2-board/2+step, height/2-board/2+step);
    for (int i=0; i<size; i++)
    {
      for (int j=0; j<size; j++)
      {
        switch(pieces[i][j].status)
        {
        case 1:
          stroke(player1);
          fill(player1);
          ellipse(step*i, step*j, piecediameter, piecediameter);
          break;
        case -1 :
          stroke(player2);
          fill(player2);
          ellipse(step*i, step*j, piecediameter, piecediameter);
          break;
        case 2:
          stroke(0);
          fill(whosecolor());
          ellipse(step*i, step*j, piecediameter, piecediameter);
          break;
        }
        fill(255,0,0);
        text(pieces[i][j].liberties,step*i,step*j);
      }
    }
    popMatrix();
  }

  void endturn()  /// toggles whoseturn and adjusts islegal attribute of intersection
                  /// object for next turn.                    
  {
    turn++;
    FindIndividualLiberties(); // occupied stones already made illegal
    SpreadLibertiesRemoveStones();//do liberty spreading across groups here: each group has as many liberties as the stone 
    //remove groups with no liberties 
    //store most recent move in string based record of game
    //add plays inside eyes and those that would cause ko to illegal plays
    FindIndividualLiberties();
    SpreadLibertiesRemoveStones();
    
    whoseturn *= -1;
    SetLegality();
  }
  
  void FindIndividualLiberties()
  {
    println(turn,"___________");
     for (int i=0; i<size; i++)
    {
      for (int j=0; j<size; j++)
      {
        if (pieces[i][j].status!=0)
        {
          pieces[i][j].islegal = false;
          pieces[i][j].liberties =0;
          try
          {
            if(pieces[i+1][j].isempty())
              pieces[i][j].liberties++;
          }catch(ArrayIndexOutOfBoundsException e){}
          try
          {
            if(pieces[i][j-1].isempty())
              pieces[i][j].liberties++;
          }catch(ArrayIndexOutOfBoundsException e){}
          try
          {
            if(pieces[i-1][j].isempty())
              pieces[i][j].liberties++;
          }catch(ArrayIndexOutOfBoundsException e){}
          try
          {
            if(pieces[i][j+1].isempty())
              pieces[i][j].liberties++;
          }catch(ArrayIndexOutOfBoundsException e){}
          
          println("X:",i,"Y:",j, ":::", pieces[i][j].group);

        }
      }
    }
  }
  
  void SpreadLibertiesRemoveStones() //give each group the sum of all the liberties that all the individual stones have
  {
    int biggest = max(blackgroup,whitegroup);
    int[] blacksums;
    int[] whitesums;
    blacksums = new int[biggest+1];
    whitesums = new int[biggest+1];
    
  for(int i =0; i<=biggest;i++) // initializing maximum arrays has as many entries as number of groups plus one as zero is not used
    {
      blacksums[i]=0;
      whitesums[i]=0;
    }
    for (int n = 0; n < size; n++) {
      for (int m = 0; m < size; m++) {
        if(pieces[m][n].isblack())
        {
          blacksums[pieces[m][n].group] += pieces[m][n].liberties;
        }
        if(pieces[m][n].iswhite())
        {
          whitesums[pieces[m][n].group] += pieces[m][n].liberties;
        }
      }
    } 
    for (int n = 0; n < size; n++) {
      for (int m = 0; m < size; m++) { //spreads liberties and removes stones if max liberties in group is zero
        if(pieces[m][n].isblack())
        {
          pieces[m][n].liberties = blacksums[pieces[m][n].group];
          if(pieces[m][n].liberties == 0)
            pieces[m][n].die();
        }
        if(pieces[m][n].iswhite())
        {
          pieces[m][n].liberties = whitesums[pieces[m][n].group];
          if(pieces[m][n].liberties == 0)
            pieces[m][n].die();
        }
      }
    }
  }
  
  void SetLegality()
  {
  for(int i = 0;i<size;i++)
  {
    for(int j =0; j<size;j++)
    {                             //fixed issue of being able to play in a groups last liberty and subsequently kill it. 
      if(pieces[i][j].isempty()) // for each space where there is no stone, check all around it--if there is another opening next to it or a stone of the same color (that does not have only one liberty left)
      {                           // or a stone of the opposite color which only has one liberty, then it is okay to play there
        pieces[i][j].islegal =true;
          try //I should really make a function for this kind of thing that checks all adjacent spaces... 
          {
            if(pieces[i+1][j].thisNeighborMakesItLegal(whoseturn))
              continue;
          }catch(ArrayIndexOutOfBoundsException e){}
          try
          {
            if(pieces[i][j-1].thisNeighborMakesItLegal(whoseturn))
              continue;
          }catch(ArrayIndexOutOfBoundsException e){}
          try
          {
            if(pieces[i-1][j].thisNeighborMakesItLegal(whoseturn))
              continue;
          }catch(ArrayIndexOutOfBoundsException e){}
          try
          {
            if(pieces[i][j+1].thisNeighborMakesItLegal(whoseturn))
              continue;
          }catch(ArrayIndexOutOfBoundsException e){}
          pieces[i][j].islegal=false;
      }
      
    }
  }
  }
  
}