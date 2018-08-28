var boardPos = [Int]()
var width = 3
var input : String
var terminate = false

// fills board positions, assuming a square
//
for _ in 0..<(width * width){
    boardPos.append(0)
}

// repeats a string many times and returns as a single string on one line
// use '\n' for spaces as it acts as a character
func repString(toRepeat: String, times: Int) -> String{
    return Array(repeating: toRepeat, count: times).reduce("", {$0 + $1})
}

func mark(x: Int) -> String{
    // for the spaces in a board and other uses
    // returns X or O if applicable, or the number of the square. floats to 00X, thus allowing up to 999, ie 001, 029, or 137
    switch(boardPos[x]){
    case 1: return " X "
    case 2: return " O "
    default: if(String(x).count == 3){
                 return String(x)
             } else if(String(x).count == 2){
                 return "0" + String(x)
             } else {
                 return "00" + String(x)
             }
    }
}

func board(messages: Int){
    print(repString(toRepeat: "\n", times: 30))
    // this part: "          ------------"; top of board
    print(repString(toRepeat: " ", times: 9) + repString(toRepeat: "-", times: 1 + width * 4), terminator: "\n" + repString(toRepeat: " ", times: 9))
    // iterating though every row, then every column within
    for index in 0..<width{
        for square in 0..<width{
            print("|" + mark(x: index * width + square), terminator: "")
        }
        // inbetween "-----"s
        print("|\n" + repString(toRepeat: " ", times: 9) + repString(toRepeat: "-", times: 1 + width * 4), terminator: "\n" + repString(toRepeat: " ", times: 9))
    }
    print(repString(toRepeat: "\n", times: 20 - messages))
}

func winCheck(player: Int) -> Bool{
    var win = false

    
    for x in 0..<width{
        // starts at 0; each matching space adds 1. should amount to width of full column, if so, is a win
        var vertical = 0
         // iterating through all x values, then all y values within, thus checking each column
        for y in 0..<width{
            // going left to right, top to bottom, so x + width * y gives array pos
            if(player == boardPos[x + width * y]){
                vertical+=1
            }
        }
        if(vertical == width){
            win = true
        }
    }

    for y in 0..<width{
        var horizontal = 0
        var leftTop = 0
        var leftBottom = 0
        
        for x in 0..<width{
            if(player == boardPos[x + width * y]){
                horizontal+=1
            }
            if(player == boardPos[x + width * x]){
                leftTop += 1
            }
            if(player == boardPos[width - x + width * x]){
                leftBottom += 1
            }
        }
        if(horizontal == width || leftTop == width || leftBottom == width){
            win = true
        }
    }

    return win
}

// Function used to determine which space the AI moves to each turn
func aiMove() -> Int{
    return 0
}

// immediately renders board
board(messages: 1)

// max number of turns is equal to spaces, thus width * width. two turns per "round," ie i move for 1 turn then you move for the other 1 turn of the round
for turn in 0..<(width * width){
    var move = -1
    // move starts at -1. it is set to the value of the grid square when an int is properly submitted, thus exiting the loop
    while(move == -1 && !terminate){
        print("Player \(turn % 2 + 1)'s Turn: ", terminator:"")
        input = readLine()!
        if let choice = Int(input){
            // if board space is unfilled and between the values possible
            if(choice > -1 && choice < (width * width) && boardPos[choice] == 0){
                move = choice
            } else {
                board(messages: 2)
                print("Please input an int greater than/equal to 0 and less than \(width * width)")
            }
            // if not possible, or not an int, then the loop is done again, printing the board each time
        } else if(input != "stop"){
            board(messages: 2)
            print("Please input an int")
        } else {
            terminate = true
            // if you type 'stop', then you end the program, shown by terminate being true
        }
    }

    if(!terminate){
        // turn % 2 + 1 will return 1 for player 1 and 2 for player 2 based on who should be playing each round
        boardPos[move] = turn % 2 + 1
        board(messages: 2)
        if(winCheck(player: turn % 2 + 1)){
            // check for wins by current player, terminate if won, and give message
            board(messages: 3)
            terminate = true
            print("Player \(turn % 2 + 1) has won!!!")
        }
        print("Player \(turn % 2 + 1) has chosen space \(move)")
    }
}
