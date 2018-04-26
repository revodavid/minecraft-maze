#library(devtools)
#install_github("ropenscilabs/miner")
#install_github("ropenscilabs/craft")
#source("genmaze.R)

library(miner)
library(craft)

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
mazeSize <- 5

## using the functions in genmaze.R:
m <- print_maze(make_maze(mazeSize,mazeSize), print=FALSE)
nmaze <- ncol(m) # dimensions
m[nmaze,nmaze-1] <- "!" ## end of the maze. We'll place a torch here.

## materials for the maze
id_floor=find_item("Lapis Lazuli Block")[1,"id"]
id_exit=find_item("Brick Slab")[1,"id"]
id_wall=find_item("Gold Block")[1,"id"]

## get the current player position 
v <- getPlayerPos(id, TRUE)

## we will place the maze to the southeast of the player, 3 blocks away
## works best in a fairly flat area

altitude <- -1 ## height offset of maze
mc <- v+c(3, altitude, 3) # corner
mc2 <- mc + c(nmaze, 0, nmaze) # opp corner

## clean up some space around the maze and 8 blocks high
setBlocks(mc[1],mc[2],mc[3], mc2[1]+1, mc2[2]+8, mc2[3]+1, 0)
## add floor
setBlocks(mc[1], mc[2], mc[3], mc2[1]+1, mc2[2], mc2[3]+1, id_floor)

## render the maze in Minecraft
## 3 blocks tall maze walls
for (i in 1:nrow(m)) {
 for (j in 1:ncol(m)) {
  blocktype <- switch(m[i,j],
                      "#"=id_wall,
                      "|"=id_wall,
                      "!"=id_exit,
                      0)
  setBlock(mc[1]+i, mc[2]+1, mc[3]+j, blocktype)
  setBlock(mc[1]+i, mc[2]+2, mc[3]+j, blocktype)
  setBlock(mc[1]+i, mc[2]+3, mc[3]+j, blocktype)
 }
}



