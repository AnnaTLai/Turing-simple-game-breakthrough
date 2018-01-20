%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Programmer: Anna Lai 
%Program Name: Escape ball. Lovely breakout 
%File name: BetterMain.t
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
        
        % Music.PlayFile("Sounds/littleidea.MP3")
        
        if gameBackgroundmusicOpen = false  then
            Music.PlayFileStop
            
            
        elsif gameBackgroundmusicOpen = true and quitGame = false then
            
            Music.PlayFile("Sounds/littleidea.MP3")
            
        elsif quitGame = true or winningGame = true then
            
            Music.PlayFileStop
            exit 
        end if  
        
        %exit when quitGame = true
    end loop
    
end playGameBGmusic 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Get the position of the mouse
process Position 
    
    loop
        
        Mouse.Where(mouseX, mouseY, mouseButton) % get the location of the mouse
        
        exit when quitGame = true 
        
    end loop 
    
end Position 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Winning check 
%check if all the bricks are gone in every loop 
process WinCheck 
    
    loop 
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
            quitGame := true
            
        end if 
        
        exit when winningGame = true
    end loop 
    
end WinCheck
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Timer

process Timer
    var  exTimeRunning:=0  % the previous game time
    
    loop
        
        delay (60) % there is a delay in the main loop as wells
        if quitGame = false then
            
            clock (timeRunning)
            nowTime := timeRunning - exTimeRunning
            
            
        elsif quitGame = true or winningGame = true then
            
            exTimeRunning:=timeRunning
            % stop time 
            exit
            
        end if 
        
    end loop 
    
    if nowTime div 1000 > bestTime then % the best mark (Time) is generated here xdxd
        
        bestTime:= timeRunning div 1000
        
    end if 
    
end Timer

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
        
        ballX += xChange 
        ballY += yChange 
        
        
        %%%%%%%%%%%% Brick to ball
        var boxX1b,boxY1b,boxX2b,boxY2b : int 
        
        for decreasing i: upper (bricks, 1) .. 1% rows
            for w: 1.. upper (bricks, 2) %columns
                
                % The brick range (each brick has its own range!)
                %%These values have to be reset here, since they are not linked together 
                boxX1b:= brickSpace + (w-1)*brickWidth + (w-1)* brickXseparate
                boxY1b:= maxy - brickSpace - (i-1)* brickHeight - (i-1)*brickYseparate
                boxX2b:= brickSpace + brickWidth + (w-1)*brickWidth + (w-1)* brickXseparate 
                boxY2b:= maxy - brickSpace - brickHeight - (i-1)* brickHeight - (i-1)*brickYseparate
                
                %%%%%%%%% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    
                if bricks (i,w) = 1 then % if the brick is not hit 
                    % and the ball is inside the brick range 
                    if ballY + radius >= boxY2b and ballY <= boxY1b then % check if the base of the brick is touched
                        if ballX <= boxX2b and ballX >= boxX1b then % check if it is inside the x range 
                            
                            yChange := -yChange 
                            
                            bricks (i,w) := 0  
                            winningCount := winningCount +1 
                            
                            %% check win? 
                            if winningCount = upper (bricks,1)* upper (bricks,2) then
                                
                                winningGame := true
                                quitGame := true
                                
                            end if 
                            %%%
                            
                        end if
                    end if 
                    
                elsif bricks (i,w) ~= 1 then % the brick is hit before
                    
                    
                    bricks (i,w):=0 
                    
                    
                end if
                
            end for 
        end for
            
        %%%%%%%%%%% Brick to ball  
        
        %% normal boundary and the base reflection 
        if ballX < radius or ballX > maxx - radius then % horizontal  boundary
            xChange := -xChange 
        end if 
        
        if ballY > maxy - radius then % vertical upper boundary
            yChange := -yChange 
            
            % elsif ballY <= baseHeight + baseY + radius and ballY >= baseY + radius + baseHeight - yChange then % vertical lower boundary 
        elsif ballY <= baseHeight + baseY + radius then % vertical lower boundary 
            
            %Draw.Line(0,baseHeight + baseY+radius,maxx,baseHeight + baseY+radius,black)%%%
            %Draw.Line(0,baseHeight + baseY+radius- yChange,maxx,baseHeight + baseY+radius- yChange,black)%%%
            % yChange := - yChange
            
            
            
            % by looking at the base (The horixontal boundaries)
            %if  ballX <= mouseX + baseWidth div 3  and ballX >= mouseY - baseWidth div 3  then % if the inner base is here
                %put "in the inner con"
               % yChange := - yChange - extraChange% more change is made to the ball 
                
            if ballX <= mouseX + baseWidth and ballX >= mouseY - baseWidth then % if the base is here
                % put "in the outter con"
                yChange := - yChange
                speed:= speed - 2 % the ball speeds up xd (less delay time)
                
                
                % if you can't catch the ball, then the ball will fade away.  And you lose haha xd 
                
            elsif ballY <= radius then % if the ball goes beyond the lower y then of course you lose xd 
                
                ballX:= ballX % stop the ball 
                ballY:= 0 - radius
                
                quitGame :=true 
                gameover:= true
                
            end if
            
            
            %%%%%%%%%%%%
            
        end if 
        
        exit when quitGame = true 
    end loop 
    
end Ball 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Process draw the bricks 
process DrawBricks
    var paint := Rand.Int(1,maxcolor) % the colour variable 
    loop
        
        for i:1..upper (bricks, 1)% rows
            paint:= Rand.Int(1,maxcolor) % the color of each row is different and they are changing xd pretty? 
            for w: 1.. upper (bricks, 2) %columns
                
                if bricks (i,w) ~= 0 then % if the brick is not hit, draw it out 
                    
                    boxX1:= brickSpace + (w-1)*brickWidth + (w-1)* brickXseparate
                    boxY1:= maxy - brickSpace - (i-1)* brickHeight - (i-1)*brickYseparate
                    boxX2:= brickSpace + brickWidth + (w-1)*brickWidth + (w-1)* brickXseparate 
                    boxY2:= maxy - brickSpace - brickHeight - (i-1)* brickHeight - (i-1)*brickYseparate
                    
                    Draw.FillBox (boxX1,boxY1,boxX2, boxY2, paint)
                    
                end if
                
            end for 
        end for
            
        delay (60) % there is a delay in the main loop as well 
        
        exit when quitGame= true or winningGame = true
    end loop
end DrawBricks
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
    setscreen("noecho,graphics:600;400")
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% background picture 
    var fileNameGame : string
    fileNameGame := "Images/gameBG.JPG"
    var gameID : int
    
    gameID := Pic.FileNew (fileNameGame)
    gameID:= Pic.Scale (gameID,winX,winY) % new size 
    Pic.Draw(gameID, 0, 0, picUnderMerge)
    
    
    
    fork playGameBGmusic 
    fork Position
    %fork DrawBricks
    %fork WinCheck
    
    %//////////////////////////////////////////////////////////////////////////////////////////////////////
    % create Buttons here 
    var gamebgMusicButton := GUI.CreateButton (maxx - 82,maxy - 22, 20, "Music Off", GamebgMusicButtonPressed)
    GUI.SetColor (gamebgMusicButton, brightblue)
    var exitGameButton := GUI.CreateButton (maxx - 95,maxy - 45, 20, "Exit Game :(", ExitGameButtonPresed)
    GUI.SetColor (exitGameButton, brightblue)
    
    fork Ball 
    fork Timer
    
    
    loop   
        
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
            
        else % the noraml drawing 
            
            Draw.FillOval(mouseX,baseY,baseWidth,baseHeight,yellow)
            delay (60)
            %Draw.FillOval(mouseX,baseY,baseWidth,baseHeight,white)
            Pic.Draw(gameID, 0, 0, picCopy)
            
        end if 
        
        locatexy (10,10) % It is always in the same place 
        put "Timer: ", nowTime div 1000, " Seconds"
        
        
        %%%%%%%%%% Draw bricks 
        var paint := Rand.Int(1,maxcolor) % the colour variable 
        
        for i:1..upper (bricks, 1)% rows
            paint:= Rand.Int(1,maxcolor) % the color of each row is different and they are changing xd pretty? 
            for w: 1.. upper (bricks, 2) %columns
                
                if bricks (i,w) ~= 0 then % if the brick is not hit, draw it out 
                    
                    boxX1:= brickSpace + (w-1)*brickWidth + (w-1)* brickXseparate
                    boxY1:= maxy - brickSpace - (i-1)* brickHeight - (i-1)*brickYseparate
                    boxX2:= brickSpace + brickWidth + (w-1)*brickWidth + (w-1)* brickXseparate 
                    boxY2:= maxy - brickSpace - brickHeight - (i-1)* brickHeight - (i-1)*brickYseparate
                    
                    Draw.FillBox (boxX1,boxY1,boxX2, boxY2, paint)
                    
                end if
                
            end for 
        end for
            %%%%%%%%% Brick  
        
        GUI.Refresh % redraw the buttons 
        
        
        
        exit when quitGame = true or winningGame = true 
        
    end loop 
    
    GUI.Dispose (gamebgMusicButton)
    GUI.Dispose (exitGameButton)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% wining or losing the game 
    cls
    setscreen("noecho,graphics:600;400")
    
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
        %%%%%%%% music
        
        Music.PlayFile("Sounds/halloween.MP3")
        
        
    elsif winningGame = true then 
        
        var fileNameWin: string
        fileNameWin := "Images/winningScreen.JPG"
        var winID : int
        
        winID := Pic.FileNew (fileNameWin)
        winID:= Pic.Scale (winID,winX,winY) % new size 
        Pic.Draw(winID, 0, 0, picCopy)
        
        Pic.Free(winID)
        %% poster 
        fileNameWin:= "Images/winningSign.GIF"
        winID := Pic.FileNew (fileNameWin)
        winID:= Pic.Scale (winID,winX*3 div 5,winY*3 div 5) % new size 
        Pic.Draw(winID, 140, 130 , picMerge)
        %%%%%%%%%%%play again sign 
        var font : int
        font := Font.New ("serif:22:bold") % I want a nice front :)
        assert font > 0
        var width : int:= Font.Width ("This is in a serif font", font)
        var height, ascent, descent, internalLeading : int
        Font.Sizes (font, height, ascent, descent, internalLeading)
        Draw.Text ("~ You WIN ~" , maxx div 4, maxy div 3, font, blue)
        Draw.Text ("Your best record: " + intstr(bestTime)+ " Seconds" , 1, maxy div 4, font, black)
        Draw.Text ("Play Again? Yes(Y/y) or No(N/n) ", 1, maxy div 5, font, black)
        Font.Free (font) 
        
        %%%%%%%% music
        
        Music.PlayFile("Sounds/goodjob.MP3")
        
    end if 
    
    var key : string (1)
    
    getch (key)
    exit when key = "N" or key = "n"
    
end loop


