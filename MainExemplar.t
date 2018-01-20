%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Programmer: Anna Lai
%Program Name: Escape ball (breakout)
%Date: 27/5/2016
%Course:  ICS3CU1  Final Project 15%
%Teacher:  Mr. Huang
%Descriptions: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% files/code folder
include "files/code/includes.t"

%  This is an exemplar of a main program file for Connect 4.  The main program is not complete
%  for example it does not handle the case where the gameboard is full and therefore no winner.
%  It will not run because variables have not been declared and subprograms have not been written.

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
    put "Do you wish to see instructions?  (Y/N or y/n) " ..
    get YesToInstructions

    if YesToInstructions = "y" or YesToInstructions = "Y" then
	displayInstructionWindow   % The Instruction screen will display and pause the porgram
    end if

    % C. (Steps for connect 4 game itself)
    % 1.      draw game board (grid) on the screen
    drawGameBoard
    % 2.      determine which column player 1 selects with the mouse
    loop
	Mouse.ButtonWait ("downup", x, y, btnNumber, btnUpDown)

	% a.      if the column has empty cell(s) continue, otherwise go back to 2
	if isInGameBoard (x, y) then
	    getRowColumn (row, column)
	    exit when not isColumnFull (column)
	end if
    end loop
    % b.      drop a red disk (animated) from the top of the grid.  It will land in the lowest unoccupied cell in the selected column
    dropDisk (red, column)
    % 3.      determine if player 1 is a winner - if so, then display message and "Play Again" prompt
    if isPlayerOneWinner then
	displayVictoryMessage (1)
	exit
    end if

    loop
	Mouse.ButtonWait ("downup", x, y, btnNumber, btnUpDown)

	% a.      if the column has empty cell(s) continue, otherwise go back to 2
	if isInGameBoard (x, y) then
	    getRowColumn (row, column)
	    exit when not isColumnFull (column)
	end if
    end loop
    % b.      drop a red disk (animated) from the top of the grid.  It will land in the lowest unoccupied cell in the selected column
    dropDisk (white, column)
    % 3.      determine if player 2 is a winner - if so, then display message and "Play Again" prompt
    if isPlayerTwoWinner then
	displayVictoryMessage (2)
	% 6.      go back to step 2 if there is no winner
    end if

end loop
cls
var key : string (1)
put "Play Again? (y/n) " ..
getch (key)
exit when key = "N" or key = "n"

end loop


displayExitScreenAndExit
