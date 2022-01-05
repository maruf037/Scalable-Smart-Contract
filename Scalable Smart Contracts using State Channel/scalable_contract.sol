pragma solidity 0.8.11;

contract stateChannel {

    address payable public playerOne;
    address payable public playerTwo;
    uint256 public escrowOne;
    uint256 public escrowTwo;

    //Variables to end the game
    uint256 public betOne;
    uint256 public betTwo;
    uint256 public balanceOne;
    uint256 public balanceTwo;
    uint256 public callOne;
    uint256 public callTwo;
    bool public isPlayer1BalanceSetUp;
    bool public isPlayer2BalanceSetUp;
    uint256 public finalBalanceOne;
    uint256 public finalBalanceTwo;
    
    constructor() public payable {
        require(msg.value > 0);

        playerOne = msg.sender;
        escrowOne = msg.value;
    }
    
    
    function setupPlayerTwo() public payable {
        require(msg.sender != playerOne);
        require(msg.value > 0);

        playerTwo = msg.sender;
        escrowTwo = msg.value;
    }

    function exitStateChannel() public {}
}