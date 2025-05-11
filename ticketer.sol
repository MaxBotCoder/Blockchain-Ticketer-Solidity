//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract InitializationContract{
    ticketer public ticketermaker;
    function deployticketer (uint _1stclassprice, uint _2ndclassprice, uint _3rdclassprice) public {
        ticketermaker = new ticketer(msg.sender, _1stclassprice, _2ndclassprice, _3rdclassprice);
    }
}

contract ticketer{

    mapping(address => uint) passthroughvalue;
    mapping(address => uint) currentvalue;
    mapping(address => uint) Class;
    uint totalvalue;
    uint public _3rdclassprice;
    uint public _2ndclassprice;
    uint public _1stclassprice;
    address CreatorAddress;

    constructor(address creator, uint _1stprice, uint _2ndprice, uint _3rdprice) {
        CreatorAddress = creator;
        _3rdclassprice = _3rdprice;
        _2ndclassprice = _2ndprice;
        _1stclassprice = _1stprice;
    }

    struct Ticketer {
        uint class;
     }

     mapping(address => Ticketer) public ticket;

     function buyticket(uint class) payable public {
        totalvalue = msg.value;
        passthroughvalue[msg.sender] + msg.value;
        currentvalue[msg.sender] + passthroughvalue[msg.sender];
        passthroughvalue[msg.sender] = 0;
        if(currentvalue[msg.sender] == 15 && class == _3rdclassprice) {
            ticket[msg.sender] = Ticketer(class = 3);
        } else if (currentvalue[msg.sender] == 30 && class == _2ndclassprice) {
            ticket[msg.sender] = Ticketer(class = 2);
        } else if (currentvalue[msg.sender] == 45 && class == _1stclassprice) {
            ticket[msg.sender] = Ticketer(class = 1);
        } else {
            payable(msg.sender).call{value: currentvalue[msg.sender]}("");
        }
     }

}
