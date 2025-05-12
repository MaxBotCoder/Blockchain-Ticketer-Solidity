//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract InitializationContract{

    //Total amount of money stored within the smartcontract itself.
    uint public totalbalance;

    //Transfers ticket purchasing system configuration over to ticker smart contract.
    ticketer public ticketermaker;
    function deployticketer (uint _1stclassprice, uint _2ndclassprice, uint _3rdclassprice, uint _1stQuantity, uint _2ndQuantity, uint _3rdQuantity) public {
        ticketermaker = new ticketer(msg.sender, _1stclassprice, _2ndclassprice, _3rdclassprice, _1stQuantity, _2ndQuantity, _3rdQuantity);
    }

    //Configures the value of total balance variable
    fallback() external payable {
        totalbalance = msg.value;
    }
}

contract ticketer{
    
    /*Mappings for temporary value to prevent double dipping and getting multiple tickets
    from a single purchase. Mapping for class determination system. 
    Permanent storage for creator address aswell as storage variable for total value.*/
    mapping(address => uint) passthroughvalue;
    mapping(address => uint) public currentvalue;
    mapping(address => uint) Class;
    uint totalvalue;
    uint public _3rdclassprice;
    uint public _2ndclassprice;
    uint public _1stclassprice;
    uint public AmountofFirstClassAvailable;
    uint public AmountofSecondClassAvailable;
    uint public AmountofThirdClassAvailable;
    address public CreatorAddress;

    //Constuctor for setting ticket price aswell as setting the creator address.
    constructor(address creator, uint _1stprice, uint _2ndprice, uint _3rdprice, uint _1stQuantity, uint _2ndQuantity, uint _3rdQuantity) {
        CreatorAddress = creator;
        _3rdclassprice = _3rdprice;
        _2ndclassprice = _2ndprice;
        _1stclassprice = _1stprice;
        AmountofFirstClassAvailable = _1stQuantity;
        AmountofSecondClassAvailable = _2ndQuantity;
        AmountofThirdClassAvailable = _3rdQuantity;
    }

    /*Struct to save ticketing info, this only saves class however the capabilities can be
    expanded to store additional and or alternative ticketing information.*/
    struct Ticketer {
        uint class;
     }
     
     //Mapping for setting struct value and or values depending on struct configuration.
     mapping(address => Ticketer) public ticket;
     
     /*Function to purchase a ticket. Which also allows ticket purchaser
     to select their class aswell. Will only set desired struct data 
     if and only if the purchasing conditions are made.*/
     function buyticket(uint class) payable public {
        totalvalue = msg.value;
        passthroughvalue[msg.sender] += msg.value;
        currentvalue[msg.sender] += passthroughvalue[msg.sender];
        passthroughvalue[msg.sender] = 0;
        if(currentvalue[msg.sender] == _3rdclassprice && class == 3) {
            ticket[msg.sender] = Ticketer(class = 3);
            AmountofThirdClassAvailable--;
            payable(CreatorAddress).call{value: currentvalue[msg.sender]}("");
        } else if (currentvalue[msg.sender] == _2ndclassprice && class == 2) {
            ticket[msg.sender] = Ticketer(class = 2);
            AmountofSecondClassAvailable--;
            payable(CreatorAddress).call{value: currentvalue[msg.sender]}("");
        } else if (currentvalue[msg.sender] == _1stclassprice && class == 1) {
            ticket[msg.sender] = Ticketer(class = 1);
            AmountofFirstClassAvailable--;
            payable(CreatorAddress).call{value: currentvalue[msg.sender]}("");
        } else {
            payable(msg.sender).call{value: currentvalue[msg.sender]}("");
        }
    }
}
