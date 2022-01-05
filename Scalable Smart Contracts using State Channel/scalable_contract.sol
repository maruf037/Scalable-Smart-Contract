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

        playerOne = payable(msg.sender);
        escrowOne = msg.value;
    }
    
    
    function setupPlayerTwo() public payable {
        require(msg.sender != playerOne);
        require(msg.value > 0);

        playerTwo = payable(msg.sender);
        escrowTwo = msg.value;
    }

    function exitStateChannel(
        bytes memory playerMessage,
        uint256 playerCall,
        uint256 playerBet,
        uint256 playerBalance,
        uint256 playerNonce,
        uint256 playerSequence,
        address addressOfMessage) public {
        
        require(playerTwo != address(0), '#1 The address
        of the player is invalid');
        require(playerMessage.length == 65, '#2 The length
        of the message is invalid');
        require(addressOfMessage == playerOne || 
        addressOfMessage == playerTwo, "#3 You must use a
        valid address of one of the players');

        uint256 escrowToUse = escrowOne;

        if(addressOfMessage == playerTwo)
            escrowToUse = escrowTwo;

        //Recreate the signed message for the first player
        //to verify that the parameters are correct
        bytes32 message = keccak256(abi.encodePacked)
    }
}