%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Programmer: Anna Lai 
%Program Name: Escape ball. Lovely breakout 
%File name: Main.t
%Date: 27/5/2016
%Course:  ICS3CU1  Final Project 15%
%Teacher:  Mr. Huang
%Descriptions:  In my game, Breakout.lovely game, there will be a little block moving according to the movement of your mouse. Three balls will be given to the player. one ball at a time, the ball will always be bouncing up and down between the tile on top of the screen and the block you are controling, you should not let the ball fall beyong the block. Each time the balls hit a tile, the tile will disapperar and you gain scoucers on it. The properties of the tiles varies. The game will be timed, if you cannot clear all the tile on time, or you missed all three balls, the progoamme will go to gameover mode, yet marks will still be calculated. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% files/code folder 
include "files/code/includes.t"
%  This is an exemplar of a main program file for Connect 4.  The main program is not complete
%  for example it does not handle the case where the gameboard is full and therefore no winner.
%  It will not run because variables have not been declared and subprograms have not been written.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% background music 
process playGameBGmusic
    
    loop
	
	Music.PlayFile("Sounds/littleidea.MP3")
	
	if gameBackgroundmusicOpen = false  then
	    Music.PlayFileStop
	    
	    
	elsif gameBackgroundmusicOpen = true then
	    
	    Music.PlayFile("Sounds/littleidea.MP3")
	    
	elsif quitGame = true then
	    
	    Music.PlayFileStop
	    exit 
	    
	    
	end if  
	
    end loop
    
end playGameBGmusic 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% The ball
process Ball % the ball and the base have to move at the same time 
    
    var ballX, ballY: int % start in position and the variable
    var xChange, yChange := 10
    var speed := 50 % speed of the ball !!
    var extraChange := 5
    
    ballX:= Rand.Int (radius, maxx - radius)
    ballY := Rand.Int(baseWidth+baseHeight+radius,maxy - brickSpace - brickHeight - (upper (bricks,1)-1)* brickHeight - (upper (bricks,1)-1)*brickYseparate - radius)
    
    loop 
	Draw.FillOval (ballX, ballY, radius,radius, black) 
	Time.Delay (speed) 
	Draw.FillOval (ballX, ballY, radius, radius, grey) 
	%locate (1,1)
	%put "mouseX", mouseX
	
	ballX += xChange 
	ballY += yChange 
	
	
	%%%%%%%%%%%% Brick
	var boxX1b,boxY1b,boxX2b,boxY2b : int 
	
	for  i: 1.. upper (bricks, 1)% rows
	    for w: 1.. upper (bricks, 2) %columns
		
		
		%%These values have to be reset here, since they are not linked together 
		boxX1b:= brickSpace + (w-1)*brickWidth + (w-1)* brickXseparate
		boxY1b:= maxy - brickSpace - (i-1)* brickHeight - (i-1)*brickYseparate
		boxX2b:= brickSpace + brickWidth + (w-1)*brickWidth + (w-1)* brickXseparate 
		boxY2b:= maxy - brickSpace - brickHeight - (i-1)* brickHeight - (i-1)*brickYseparate
		
		if bricks (i,w) ~= 0 then % if the brick is not hit
		    if ballY + radius >= boxY2b then % check if the base of the brick is touched
			if ballX <= boxX2b and ballX >= boxX1b then % check if it is inside the x range 
			    
			    yChange := -yChange 
			    
			    bricks (i,w) := 0  
			end if
		    end if 
		    
		    
		else 
		    
		end if
		
	    end for 
	end for
	    
	%%%%%%%%%%% Brick to ball 
	
	if ballX < radius or ballX > maxx - radius then % horizontal  boundary
	    xChange := -xChange 
	end if 
	
	if ballY > maxy - radius then % vertical upper boundary
	    yChange := -yChange 
	    
	elsif ballY - radius <= baseHeight + baseY and ballY - radius >= baseY then % vertical lower boundary 
	    % by looking at the base
	    if  ballX <= mouseX + baseWidth div 3  and ballX >= mouseY - baseWidth div 3  then % if the inner base is here
		%put "in the inner con"
		yChange := - yChange - extraChange% more change is made to the ball 
		
	    elsif ballX <= mouseX + baseWidth and ballX >= mouseY - baseWidth then % if the base is here
		% put "in the outter con"
		yChange := - yChange
		speed:= speed + 2 % the ball speeds up xd
		
	    else 
		
		% if you can't catch the ball, then the ball will fade away. 
		
	    end if 
	end if 
	
	%%%%%%%%%%%%
	if ballY < radius then % if the ball goes beyond the lower y then of course you lose xd 
	    quitGame :=true 
	    gameover:= true
	end if 
	
	exit when quitGame = true 
    end loop 
    
end Ball 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

loop
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % procedure to set all initial global variable with file scope
    % even if already set (located in MyGlobalVars.t)
    setInitialGameValues
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % A.      display title screen
    displayIntroWindow
    %
    %
    % B.      Ask user if they want instructions displayed on the screen
    /*put "Do you wish to see instructions?  Yes(Y/y) or No(N/n) " ..
    getch (YesToInstructions)
    
    if YesToInstructions = "y" or YesToInstructions = "Y" then
    displayInstructionWindow   % The Instruction screen will display and pause the porgram
    end if*/
    
    if inInstructionOpen = true then
	displayInstructionWindow
    end if 
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Main Game here
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cls
    
    fork playGameBGmusic 
    setscreen("noecho,graphics:600;400")
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% background picture 
    var fileNameGame : string
    fileNameGame := "Images/gameBG.JPG"
    var gameID : int
    
    gameID := Pic.FileNew (fileNameGame)
    gameID:= Pic.Scale (gameID,winX,winY) % new size 
    Pic.Draw(gameID, 0, 0, picUnderMerge)
    
    %///////////////////////////////////////////////////////////////////////////////////////////////
    
    % create Buttons here 
    var gamebgMusicButton := GUI.CreateButton (maxx - 82,maxy - 22, 20, "Music Off", GamebgMusicButtonPressed)
    var exitGameButton := GUI.CreateButton (maxx - 95,maxy - 45, 20, "Exit Game :(", ExitGameButtonPresed)
    fork Ball 
    
    loop  
	
	%%%%% Timer
	clock (timeRunning)
	if quitGame = false then
	    
	    locate (maxrow,1)
	    put "Timer: ", timeRunning div 1000, " Seconds"
	    
	elsif quitGame = true or winningGame = true then
	    timeRunning := timeRunning
	    locate (maxrow,1)
	    put "Timer: ", timeRunning div 1000, " Seconds"
	    
	    
	    if timeRunning div 1000 > bestTime then
		
		bestTime:= timeRunning div 1000
		
	    end if 
	    
	    
	    exit
	end if 
	%%%%%
	
	Mouse.Where(mouseX, mouseY, mouseButton) % get the location of the mouse
	
	
	
	if mouseX > maxx then% if you go beyond the window
	    
	    
	    Draw.FillOval(maxx,baseY,baseWidth,baseHeight,yellow)
	    delay (60)
	    %Draw.FillOval(maxx,baseY,baseWidth,baseHeight,white)
	    Pic.Draw(gameID, 0, 0, picCopy)
	    
	elsif mouseX < 0  then% if you go beyond the window
	    
	    Draw.FillOval(0,baseY,baseWidth,baseHeight,yellow)
	    delay (60)
	    %Draw.FillOval(0,baseY,baseWidth,baseHeight,white)
	    Pic.Draw(gameID, 0, 0, picCopy)
	    
	else
	    
	    Draw.FillOval(mouseX,baseY,baseWidth,baseHeight,yellow)
	    delay (60)
	    %Draw.FillOval(mouseX,baseY,baseWidth,baseHeight,white)
	    Pic.Draw(gameID, 0, 0, picCopy)
	    
	end if 
	
	%%%%%%%%%%%Bricks Draw
	var paint := Rand.Int(1,maxcolor) % the colour variable 
	
	for i:1..upper (bricks, 1)% rows
	    paint:= Rand.Int(1,maxcolor) % the color of each row is different and they are changing xd pretty? 
	    for w: 1.. upper (bricks, 2) %columns
		
		if bricks (i,w) ~= 0 then % if the brick is not hit
		    
		    boxX1:= brickSpace + (w-1)*brickWidth + (w-1)* brickXseparate
		    boxY1:= maxy - brickSpace - (i-1)* brickHeight - (i-1)*brickYseparate
		    boxX2:= brickSpace + brickWidth + (w-1)*brickWidth + (w-1)* brickXseparate 
		    boxY2:= maxy - brickSpace - brickHeight - (i-1)* brickHeight - (i-1)*brickYseparate
		    
		    Draw.FillBox (boxX1,boxY1,boxX2, boxY2, paint)
		    
		else 
		    
		end if
		
	    end for 
	end for
	    
	
	%%%%%%%%% check if all the bricks are gone in every loop 
	
	for i:1..upper (bricks, 1)% rows
	    for w: 1.. upper (bricks, 2) %columns
		
		if bricks (i,w) = 0 then% the brick is not there 
		    
		    winningCount := winningCount +1 
		    
		end if
		
	    end for 
	end for
	    
	%% check win? 
	if winningCount = upper (bricks,1)* upper (bricks,2) then
	    winningGame := true
	end if 
	%%%%%%%%%%%Bricks
	
	
	
	
	
	GUI.Refresh % redraw the buttons 
	exit when quitGame = true or winningGame = true 
	
    end loop 
    
    GUI.Dispose (gamebgMusicButton)
    GUI.Dispose (exitGameButton)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% wining or losing the game 
    cls
    
    if gameover = true then 
	
	var fileNameOver: string
	fileNameOver := "Images/gameOver.JPG"
	var overID : int
	
	overID := Pic.FileNew (fileNameOver)
	overID:= Pic.Scale (overID,winX,winY) % new size 
	Pic.Draw(overID, 0, 0, picCopy)
	
	%%%%%%%%%%%play again sign 
	var font : int
	font := Font.New ("serif:22:bold") % I want a nice front :)
	assert font > 0
	var width : int:= Font.Width ("This is in a serif font", font)
	var height, ascent, descent, internalLeading : int
	Font.Sizes (font, height, ascent, descent, internalLeading)
	Draw.Text ("Play Again? Yes(Y/y) or No(N/n) ", 1, maxy div 5, font, black)
	Font.Free (font) 
	%%%%%%%%
	
	
    elsif winningGame = true then 
	
	var fileNameWin: string
	fileNameWin := "Images/winningScreen.JPG"
	var winID : int
	
	winID := Pic.FileNew (fileNameWin)
	winID:= Pic.Scale (winID,winX,winY) % new size 
	Pic.Draw(winID, 0, 0, picUnderMerge)
	
	Pic.Free(winID)
	%% poster 
	fileNameWin:= "Images/winningSign.GIF"
	winID := Pic.FileNew (fileNameWin)
	winID:= Pic.Scale (winID,winX div 3,winY div 3) % new size 
	Pic.Draw(winID, 250, 300 , picCopy)
	%%%%%%%%%%%play again sign 
	var font : int
	font := Font.New ("serif:22:bold") % I want a nice front :)
	assert font > 0
	var width : int:= Font.Width ("This is in a serif font", font)
	var height, ascent, descent, internalLeading : int
	Font.Sizes (font, height, ascent, descent, internalLeading)
	Draw.Text ("Play Again? Yes(Y/y) or No(N/n) ", 1, maxy div 5, font, black)
	Font.Free (font) 
	%%%%%%%%
	
	
    end if 
    
    var key : string (1)
    
    getch (key)
    exit when key = "N" or key = "n"
    
end loop


