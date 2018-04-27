## You will need the "miner" package for this. You can install
## it with the commands below:

#library(devtools)
#install_github("ropenscilabs/miner")

library(miner)

source("genmaze.R")   # functions for generating a maze
source("solvemaze.R") # functions to build a maze in the world, and solve it

## Launch the Spigot server with RaspberryJuice pl
## For instructions, see: 
## https://ropenscilabs.github.io/miner_book/installation-and-configuration.html#docker

## The IP address of your server
## This is the same IP you will use to log into 
## a multiplayer server using Minecraft (Java edition)

MCserverIP <- "52.170.156.222"

## A function to connect to the server an print a message to confirm
## Minecraft disconnects every now and again, so you might need 
## to call it again later if you get errors.
rc <- function(msg=TRUE) {
 try(mc_close(), silent=TRUE)
 mc_connect(MCserverIP)
 if(msg) chatPost("Connected from R")
}

## connect to server
rc()

## Get a player ID. Works best if there's only one player in the game,
## so you know whose it is
id <- getPlayerIds()
if(length(id)>1) warning("Multiple players in instance")
id <- id[1]

## Maze dimensions (we'll create a square maze)
mazeSize <- 8

## using the functions in genmaze.R:
m <- print_maze(make_maze(mazeSize,mazeSize), print=FALSE)
nmaze <- ncol(m) # dimensions
m[nmaze,nmaze-1] <- "!" ## end of the maze. We'll place the exit here.

## we will place the maze to the southeast of the player, 3 blocks away
## works best in a fairly flat area

## get the current player position 
v <- getPlayerPos(id, TRUE)
altitude <- -1 ## height offset of maze
pos <- v+c(3, altitude, 3) # corner

## Build a maze near the player
buildMaze(m, pos, id)

## Move the player into the start of the maze, and then
solveMaze(id)



