# The Obstruction Game
The Obstruction Game is a 2 player pencil and paper game. The project was written in Lua using the LÖVE framework.

# Installation and Execution
This project requires the LÖVE framework which can be downloaded from [here](https://love2d.org/#download). After downloading LÖVE you can download or clone this repository. To run the game you need to open the main project folder and then you can drag the master folder onto a LÖVE executable or shortcut. More instructions on how to run LÖVE projects for specific platforms can be found [here](https://love2d.org/wiki/Getting_Started).

# How to Play the Game 
Each player takes turns marking a cell on a grid. The size of the grid does not matter but the default size for my project is a 6x6 grid. Once a cell is marked the surrounding cells are also marked as blocked. If all cells are marked the game is over and the player who cannot make a move loses. The game can be played with 2 players or 1 player against the computer player. 

Once running the game the default setting is 1 player mode where you will play against the computer player. Pressing the 1 or 2 number keys changes the game to 1 or 2 player mode respectivley. Pressing the N key allows you to start a new game. To make a move you can simply click on a cell. The game is solved for a 6x6 grid so try your best to beat the computer! 

A more detailed description of the game can be found [here](http://www.papg.com/show?2XMX). The Obstruction game on the website is one of the main references for my project and the website allows you to play their game as well as other popular paper and pencil games.

# License
This project uses the MIT license and the code as well as assets are free to use.

---

# More About the Project
There were many goals in mind when I worked on this project. The first goal was to create a project using the minimax algorithm using alpha-beta prunning to create a computer player to play the game perfectly. Secondly my experience with Lua is limitted and this is the first time using the love2d framework as well as using Github to share a project publicly. Feel free to critique the work and point out everything that needs improvement.

I found out about this game from [this](https://www.reddit.com/r/C_Programming/comments/hs6rj9/my_first_c_project/) post where reddit user xemeds wrote an Obstruction game using C ([here](https://github.com/xemeds/obstruction-game) is a link to their repo). This post inspired me to write my own project and I completed the project using C first but then wanted to try and use Lua and LÖVE as well to challenge myself.

There are many improvements I feel I should make but my main goal was to complete the project to get as much feedback as possible first. If you want to let me know how I can improve my work feel free to leave a comment [here](https://www.reddit.com/r/lua/comments/ixw7l6/the_obstruction_game/).
