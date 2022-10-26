// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.7.6;


contract testContract {

    //basic struct for project info
    struct Project {
        string description;
        address initiator;
        uint goalAmt;
        uint finishtime;
        bool claimed;
    }

    mapping(address => uint256) public AddresstoDonatedamt;
    address[] public donors;

    Project project;

    constructor(address payable initiator, uint256 lastsFor, uint256 goal, string memory projectDescription) {
        project.description = projectDescription;
        project.initiator = initiator;
        project.finishtime = block.timestamp + (lastsFor * 1 days);
        project.goalAmt = goal;
    }

    function donate() public payable {
        require(block.timestamp < project.finishtime);
        require(project.claimed == false, "This fundraising has already ended.");

        AddresstoDonatedamt[msg.sender] += msg.value;
        donors.push(msg.sender);
    }

    function TransferOut() public {
        uint256 totalAmt = 0;
        for (uint i = 0; i < donors.length; i++) {
            address temp = donors[i];
            require(AddresstoDonatedamt[temp] > 0);
            totalAmt += AddresstoDonatedamt[temp];
        }
        payable(project.initiator).transfer(totalAmt);
    }
}

//todo timing
//only the initiator can transferout