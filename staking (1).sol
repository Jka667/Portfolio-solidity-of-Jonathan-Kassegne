// SPDX-License-Identifier: GPL-3.0


pragma solidity ^0.8.7;

contract Staking {
    uint256 public totalStaked;
    uint256 public distributed;
    uint256 public minAmount;
    uint256 public maxAmount;
    uint256 public unstakingFee;
    uint256 public duration;
    uint256 public reward;
    address public owner; 
    mapping (address => uint256) public stakes;
    mapping (address => uint256) public rewards;

    constructor( uint256 _totalStaked, uint256 _distributed, uint256 _duration, uint256 _minAmount, uint256 _maxAmount , uint256 _unstakingFee) {
        totalStaked = _totalStaked;
        distributed = _distributed;
        minAmount = _minAmount;
        maxAmount = _maxAmount;
        unstakingFee = _unstakingFee;
        duration = _duration;
        owner = msg.sender;
    }

    function stake(uint256 _amount) public {
        require(_amount >= minAmount && _amount <= maxAmount && _amount <= totalStaked, "Invalid staking amount");
        totalStaked -= _amount;
        stakes[msg.sender] += _amount;
    }

    function unstake(uint256 _amount) public {
        require(block.timestamp >= duration * 24 hours, "Cannot unstake before 7 days");
        uint256 fee = (_amount * unstakingFee) / 100;
        require(stakes[msg.sender] >= _amount + fee, "Insufficient staked amount");
        stakes[msg.sender] -= _amount + fee;
        rewards[msg.sender] -= _amount + fee;
        totalStaked += _amount + fee;
    }

    function claimDIG() public {
        require(block.timestamp >= duration * 24 hours, "Cannot claim before 7 days");
        reward = rewards[msg.sender];
       
        
    }

    function claimBTC() public {
        // code to convert DIG to BTC
    }

    function claimETH() public {
        // code to convert DIG to ETH
    }


    function getAPR() public view returns (uint256) {
        return (distributed * 365) / (totalStaked * duration);
    }
}
