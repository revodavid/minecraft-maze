## functions to create and print a random maze using the 
## recursive backtracking algorithm

## A maze is represented by a H x W x 4 logical array
## H x W represents cells in the maze
## third dim represents passage presence in cardinal directions: up, left, down, right
##   FALSE: passage from this cell is blocked in that direction
##   TRUE: open passage in that direction

## Adapted from this Ruby implementation by Jamis Buck:
## http://weblog.jamisbuck.org/2010/12/27/maze-generation-recursive-backtracking

## Usage:
## maze <- make_maze(10,15)
## print_maze(maze)

blank_maze <- function(height, width) {
  ## returns a "blank" maze with all cells blocked in each direction
  cardinals <- c("up", "left", "down", "right")
  maze <- array(FALSE, c(height, width, 4))
  dimnames(maze) <- list(1:height, 1:width, cardinals)
  maze
}

carve_passages_from <- function(maze, cy, cx)  {
  cardinals <- c("up", "left", "down", "right")
  dx <- c(0, -1, 0, 1); names(dx) <- cardinals
  dy <- c(-1, 0, 1, 0); names(dy) <- cardinals
  opposite <- c("down","right", "up", "left"); names(opposite) <- cardinals
  
  dirs <- sample(cardinals)
  
  d <- dim(maze)
  mazeH <- d[1]
  mazeW <- d[2]
  
  for(i in dirs) {
    ## location of next cell to check
    nx <- cx + dx[i]
    ny <- cy + dy[i]
    
    ## if cell in range, and cell has not been touched, carve a passage
    if(nx>0 && ny>0 && nx<=mazeW && ny<=mazeH && !any(maze[ny,nx,])) {
      maze[cy,cx,i] <- TRUE
      maze[ny,nx,opposite[i]] <- TRUE
      maze <- carve_passages_from(maze, ny, nx)
    }
  }  
  maze
}

make_maze <- function(height, width, doors=TRUE) {
  ## create a maze of desired width and height
  ## doors: create an entry and exit at the top-left and bottom-right corners
  m <- blank_maze(height,width)
  m <- carve_passages_from(m, 1, 1)
  m[1,1,"up"] <- TRUE
  m[height, width, "down"] <- TRUE
  m
}

print_maze <- function(maze, print=TRUE) {
  ## print a maze created by make_maze to the terminal
  ## also returns an invisible HxW character matrix, using the
  ## characters below to represent walls and passages
  block <- "#"
  space <- " "
  d <- dim(maze)
  mazeW <- d[2]
  mazeH <- d[1]

  output <- matrix(block, ncol=2*mazeW+1, nrow=2*mazeH+1)
  
  cardinals <- c("up", "left", "down", "right")
  dx <- c(0, -1, 0, 1); names(dx) <- cardinals
  dy <- c(-1, 0, 1, 0); names(dy) <- cardinals
  
  for (cx in 1:mazeW)
    for (cy in 1:mazeH) {
      nx <- 2*cx
      ny <- 2*cy
      output[ny,nx] <- space

      for(d in cardinals) {
        nx <- 2*cx+dx[d]
        ny <- 2*cy+dy[d]
        if(maze[cy,cx,d]) output[ny,nx] <- space
      }
  
  }
  
  if(print) cat(t(output), sep="", fill=2*mazeW+1)

  invisible(output)
}


