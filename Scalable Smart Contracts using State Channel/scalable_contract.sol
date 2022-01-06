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
        
        require(playerTwo != address(0), '#1 The address of the player is invalid');
        require(playerMessage.length == 65, '#2 The length of the message is invalid');
        require(addressOfMessage == playerOne || 
        addressOfMessage == playerTwo, '#3 You must use a valid address of one of the players');

        uint256 escrowToUse = escrowOne;

        if(addressOfMessage == playerTwo)
            escrowToUse = escrowTwo;

        //Recreate the signed message for the first player
        //to verify that the parameters are correct
        bytes32 message = keccak256(abi.encodePacked("\x19Ethereum 
        Signed Message:\n32", keccak256(abi.encodePacked(playerNonce,
        playerCall, playerBet, playerBalance, playerSequence))));
        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(playerMessage, 32))
            s := mload(add(playerMessage, 64))
            v := byte(0, mload(add(playerMessage, 96)))
        }

        address originalSigner = ecrecover(message, v, r, s);
        require(originalSigner == addressOfMessage, '#4 The signer must be the original address');

        if(addressOfMessage == playerOne) {
            balanceOne = playerBalance;
            isPlayer1BalanceSetUp = true;
            betOne = playerBet;
            callOne = playerCall;
        } else {
            balanceTwo = playerBalance;
            isPlayer2BalanceSetUp = true;
            betTwo = playerBet;
            callTwo = playerCall;
        }

        if(isPlayer1BalanceSetUp && isPlayer2BalanceSetUp) {
            if(callOne == callTwo || block.timestamp > callTwo + 1 days) {
                finalBalanceTwo = balanceTwo + betTwo;
                finalBalanceOne = balanceOne - betTwo;
            } else {
                finalBalanceOne = balanceOne + betOne;
                finalBalanceTwo = balanceTwo - betOne;
            }

            playerOne.transfer(finalBalanceOne);
            playerTwo.transfer(finalBalanceTwo);
        }
    }
}