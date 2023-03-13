// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MyToken {
// Variables
string private name;
string private symbol;
uint8 private decimals;
uint256 private totalSupply;
mapping(address => uint256) private balances;
mapping(address => mapping(address => uint256)) private allowed;
uint256 private constant INITIAL_SUPPLY = 1000000 * 10 ** 18; // 1,000,000 tokens
uint256 private constant REWARD_RATE = 5 * 10 ** 16; // 5% reward rate (per year)
uint256 private lastUpdateTime;
uint256 private rewardPerTokenStored;
mapping(address => uint256) private rewards;

// Events
event Transfer(address indexed from, address indexed to, uint256 value);
event Approval(address indexed owner, address indexed spender, uint256 value);
event RewardPaid(address indexed user, uint256 reward);

// Constructor
constructor() {
    name = "MyToken";
    symbol = "MTK";
    decimals = 18;
    totalSupply = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
    lastUpdateTime = block.timestamp;
}

// Functions
function transfer(address to, uint256 value) public returns (bool) {
    require(to != address(0), "Invalid address");
    require(value <= balances[msg.sender], "Insufficient balance");
    _updateReward(msg.sender);
    _updateReward(to);
    balances[msg.sender] -= value;
    balances[to] += value;
    emit Transfer(msg.sender, to, value);
    return true;
}

function approve(address spender, uint256 value) public returns (bool) {
    require(spender != address(0), "Invalid address");
    allowed[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
}

function transferFrom(address from, address to, uint256 value) public returns (bool) {
    require(to != address(0), "Invalid address");
    require(value <= balances[from], "Insufficient balance");
    require(value <= allowed[from][msg.sender], "Not allowed to transfer");
    _updateReward(from);
    _updateReward(to);
    balances[from] -= value;
    balances[to] += value;
    allowed[from][msg.sender] -= value;
    emit Transfer(from, to, value);
    return true;
}

function balanceOf(address owner) public view returns (uint256) {
    require(owner != address(0), "Invalid address");
    return balances[owner];
}

function allowance(address owner, address spender) public view returns (uint256) {
    require(owner != address(0), "Invalid address");
    require(spender != address(0), "Invalid address");
    return allowed[owner][spender];
}

function rewardPerToken() public view returns (uint256) {
    if (totalSupply == 0) {
        return rewardPerTokenStored;
    }
    uint256 now_ = block.timestamp;
    if (now_ == lastUpdateTime) {
        return rewardPerTokenStored;
    }
    uint256 duration = now_ - lastUpdateTime;
    return rewardPerTokenStored + (duration * REWARD_RATE * 10 ** decimals / totalSupply);
}

function _updateReward(address account) internal {
    rewardPerTokenStored = rewardPerToken();
    rewards[account] = earned(account);
    lastUpdateTime = block.timestamp;
}

  function earned(address account) public view returns (uint256) {
    return balances[account] + rewardPerTokenStored;
  }

}
