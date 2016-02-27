import "api.sol";
contract EthereumParty 
{

    struct Participant {
        address etherAddress;
        uint amount;
    }

    Participant[] public participants;

    uint public payoutIdx = 0;
    uint public collectedFees;
    uint public balance = 0;
	uint public maxSeats = 5;
	uint public roll;


    address public owner;

    // simple single-sig function modifier
    modifier onlyowner { if (msg.sender == owner) _ }

    // this function is executed at initialization and sets the owner of the contract
    function EthereumParty() {
        owner = msg.sender;
    }

    // fallback function - simple transactions trigger this
    function() {
        enter();
    }
    
// check to make sure participant sends exactly 10 ether
    function enter() {
    if (msg.value < 10 ether) {
        msg.sender.send(msg.value);
        return;
    }
		uint amount;
		if (msg.value > 10 ether) {
			msg.sender.send(msg.value - 10 ether);	
			amount = 10 ether;
    }
		else {
			amount = msg.value;
		}
	}

      	// add a new participant to array
        uint idx = participants.length;
        participants.length += 1;
        participants[idx].etherAddress = msg.sender;
        participants[idx].amount = msg.value;
        
        // collect 5% fee and update contract balance
        if (idx != 0) {
            collectedFees += msg.value / 10;
            balance += msg.value;
        } 	
		
		//Check to see if six players exist
		if (particpants.length == maxSeats)
		{
			
		// Set payout schedule
		uint secondPlaceAmount = collectedFees * 2;
		uint firstPlaceAmount = collectedFees * 7;
			
		// Play the game
								
			// Roll dice and pay 2nd place winner
			rollDice();
			uint secondPlaceWinner = roll;
			participants[secondPlaceWinner].etherAddress.send(secondPlaceAmount);
			balance -= secondPlaceAmount;
						
			//Roll dice again until we have a second winner
			while (roll == secondPlaceWinner) {
				rollDice();
			}
									
			// Pay 1st place winner
			uint firstPlaceWinner = roll;
			participants[firstPlaceWinner].etherAddress.send(firstPlaceAmount);
			balance -= firstPlaceAmount;

			// Reset game for next round
			participants.length=0;
			idx=0;
			delete participants;
		
		}
    }

    function collectFees() onlyowner {
        if (collectedFees == 0) return;

        owner.send(collectedFees);
        collectedFees = 0;
    }

    function setOwner(address _owner) onlyowner {
        owner = _owner;
    }
	
	function rollDice() {
			roll = oraclize_query(0, "WolframAlpha", "random number between 1 and 5");
		}
	
}
