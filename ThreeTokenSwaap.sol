pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol"

contract MultiTokenSwap {
    address public owner;  // The owner of the contract
    IERC20 public tokenA;
    IERC20 public tokenB;
    IERC20 public tokenC;

    constructor(address _tokenA, address _tokenB, address _tokenC) {
        owner = msg.sender;
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        tokenC = IERC20(_tokenC);
    }

    function swapTokens() public {
        // Define the fixed exchange rates
        uint256 exchangeRateA = 2;  // 1 TokenA = 2 ETH
        uint256 exchangeRateB = 3;  // 1 TokenB = 3 ETH
        uint256 exchangeRateC = 4;  // 1 TokenC = 4 ETH

        // Calculate the total ETH value
        uint256 totalETH = (exchangeRateA * tokenA.balanceOf(msg.sender) +
                            exchangeRateB * tokenB.balanceOf(msg.sender) +
                            exchangeRateC * tokenC.balanceOf(msg.sender));

        // Transfer tokens from the sender to this contract
        tokenA.transferFrom(msg.sender, address(this), tokenA.balanceOf(msg.sender));
        tokenB.transferFrom(msg.sender, address(this), tokenB.balanceOf(msg.sender));
        tokenC.transferFrom(msg.sender, address(this), tokenC.balanceOf(msg.sender));

        // Transfer the calculated ETH value to the sender
        payable(msg.sender).transfer(totalETH);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can execute this function.");
        _;
    }

    function withdraw() public onlyOwner {
        // The owner can withdraw any remaining ETH in the contract
        payable(owner).transfer(address(this).balance);
    }
}
