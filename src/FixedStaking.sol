// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FixedStaking is ERC20{
    address public  owner;

    constructor()ERC20("Fixed Staking","IX"){
        owner = msg.sender;
        
    }
    //modifier onlyOwner
    modifier onlyOwner(){
        _;
        require(msg.sender ==owner, "not Owner");

    }

    //mapping to keep track of staking time per address
    mapping(address => uint)public stakeTM;

    //mapinng of keeping track amount stake by user
    mapping(address => uint)public stakeAmount;
    //function to mint

    function mint(address _receiver,uint256 _amount)public onlyOwner{
        require(_amount > 0,"amount < 0");
        _mint(_receiver, _amount);
    }


    //function stake
    function stake(uint256 _amount)external{
        require(_amount > 0,"amount < 0");
        _transfer(msg.sender,address(this), _amount);

       

        if(stakeAmount[msg.sender] > 0){
            claim();
        }
         stakeAmount[msg.sender] += _amount;
        stakeTM[msg.sender] = block.timestamp;


    }


    


    //function unstake

    function unstake(uint256 _amount)external{
         require(_amount > 0,"amount < 0");
         require(stakeAmount[msg.sender] > 0, "amount < 0");
         _transfer(address(this),msg.sender, _amount);
         stakeAmount[msg.sender] -=_amount;
         claim();


    }

    ///function claim

    function claim()internal{
        uint256 timeStake = block.timestamp - stakeTM[msg.sender];
        uint rewards = stakeAmount[msg.sender] * timeStake/3.154e7;

        _mint(msg.sender,rewards);
    }

    function claimIt()external {
        claim();
    }

}