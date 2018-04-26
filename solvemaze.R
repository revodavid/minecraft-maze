## Script to move the player around to solve a maze

## find the closest cardinal direction the player is facing
playerDir <- function(id) {
 d <- as.integer(round((getPlayerRotation(id)%%360)/90))
 if(d==0) { d <- 4 }
 c("west","north","east","south")[d]
}

## two functions to transform cardinal directions
rotateLeft <- function(r) {
 c(north="west", west="south", south="east", east="north")[r]
}
rotateRight <- function(r) {
 c(north="east", west="north", south="west", east="south")[r]
}

## move the player one tile in a cardinal direction
playerStep <- function(id, d) {
 dx <- c(north=0, west=-1, south=0, east=1)
 dz <- c(north=-1, west=0, south=1, east=0)
 
 v <- getPlayerPos(id)
 setPlayerPos(v[1]+dx[d], v[2], v[3]+dz[d])
} 

## return a block next to the player in the direction d
## if d not specified, use the direction the player is facing
blockNear <- function(id, d) {
 dx <- c(north=0, west=-1, south=0, east=1)
 dz <- c(north=-1, west=0, south=1, east=0)
 
 if (missing(d)) d <- playerDir(id)
 v <- getPlayerPos(id)
 getBlock(v[1]+dx[d], v[2], v[3]+dz[d], TRUE)["typeID"]
}

## check on options ahead, right and left, given player heading
choices <- function(id, d) {
 ahead <- blockNear(id, d)==0
 d <- rotateLeft(d)
 left <- blockNear(id, d)==0
 d <- rotateLeft(d)
 behind <- blockNear(id, d)==0
 d <- rotateLeft(d)
 right <- blockNear(id, d)==0
 c(left=left, ahead=ahead, right=right, behind=behind)
}

## Traverse the maze using left-hand rule
## Look for the object marking the end of the maze
## Move the player to the beginning of the maze first!
solved <- FALSE
botheading <- playerDir(id)

while(!solved) {
 rc(FALSE) # avoid disconnects while solving
 moves <- choices(id, botheading)
 code <- sum(c(4,2,1,0)[moves])
 botheading <- switch(as.character(code),
        "0"=rotateLeft(rotateLeft(botheading)), #blocked Left, Ahead, Right
        "1"=rotateRight(botheading), #blocked left, ahead
        "2"=botheading, #blocked left, right
        "3"=botheading, #blocked left
        rotateLeft(botheading))
 playerStep(id,botheading) 
 solved <- blockNear(id, botheading)==id_exit || 
           blockNear(id, rotateLeft(botheading))==id_exit ||
           blockNear(id, rotateRight(botheading))==id_exit
}
chatPost("Solved the maze!")


while(TRUE) { print(playerDir(id)); Sys.sleep(1)}
