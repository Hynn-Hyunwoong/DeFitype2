// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./interfaces/IERC20.sol";
import "./interfaces/IUniswapV2Router02.sol";
import "./interfaces/IUniswapV2Factory.sol";
import "./interfaces/IMasterChef.sol";
import "hardhat/console.sol";

contract Trader {
    // contracts
    address constant FACTORY = 0x90B06a1B5920E45c5f0aC3D701728669527bF275;
    address constant ROUTER = 0x0D827eaDe12e5f296e3Dd0e08fc38ad990dC1142;
    address constant CHEF = 0x5bc059C6fAC255702Ea697415f82e44c5ec3CB76;

    // tokens
    address constant WKLAY = 0x043c471bEe060e00A56CcD02c0Ca286808a5A436;
    address constant WHLE = 0x15308179057A1d5e56C61a612b1EADfA5F669Aad;
    
    constructor() {}

    receive () external payable {}

    // ------------- VIEW ------------- 

    function pendingReward(uint pid) external view returns (uint) {
        // TODO
        return 0;
    }

    function pendingRewardAll() external view returns (uint) {
        // TODO
        return 0;
    }

    function depositBalance(uint pid) external view returns (uint) {
        // TODO
        return 0;
    }

    // ------------- LIQUIDITY ------------- 

    function addLiquidityKlay(address token, uint amountDesired) payable external {
        // trasnferFrom
        IERC20(token).transferFrom(msg.sender, address(this), amountDesired);

        // approvetoken
        approveToken(token, ROUTER);
        IUniswapV2Router01(ROUTER).addLiquidityETH(
            token, // address token,
            amountDesired,  // uint amountTokenDesired,
            0,  // uint amountTokenMin,
            0,  // uint amountETHMin,
            msg.sender,  // address to,
            block.timestamp + 10 // uint deadline
            );
    }

    function addLiquidity(address tokenA, address tokenB, uint amountA, uint amountB) external {
        // transferFrom
        IERC20(tokenA).transferFrom(msg.sender, address(this), amountA);
        IERC20(tokenB).transferFrom(msg.sender, address(this), amountB);
        // approveToken
        // path is this contract bottom
        approveToken(tokenA, ROUTER);
        approveToken(tokenB, ROUTER);

        //addLiquidity
        IUniswapV2Router01(ROUTER).addLiquidity(
            tokenA, // address tokenA,
            tokenB, // address tokenB,
            amountA, // uint amountADesired,
            amountB, // uint amountBDesired,
            0, // uint amountAMin,
            0, // uint amountBMin,
            msg.sender, // address to,
            block.timestamp +10 // uint deadline +10
        );

    }

    function removeLiquidity(address tokenA, address tokenB, uint liquidity) external {
        // setter lp
        address lp = IUniswapV2Factory(FACTORY).getPair(tokenA, tokenB);
        // transferfrom LP
        IERC20(lp).transferFrom(msg.sender, address(this), liquidity);

        // approveToken
        approveToken(lp, ROUTER);

        //removeLiquidity
        IUniswapV2Router01(ROUTER).removeLiquidity(
            tokenA, // address tokenA,
            tokenB, // address tokenB,
            liquidity, // uint liquidity,
            0, // uint amountAMin,
            0, // uint amountBMin,
            msg.sender, // address to,
            block.timestamp +10 // uint deadline +10
        );
    }

    function removeLiquidityKlay(address token, uint liquidity) external {
        // setter lp
        address lp = IUniswapV2Factory(FACTORY).getPair(token, WKLAY);
        // transferfrom LP
        IERC20(lp).transferFrom(msg.sender, address(this), liquidity);

        // approve
        approveToken(lp, ROUTER);

        //remodeLiquidtyETH
        IUniswapV2Router01(ROUTER).removeLiquidityETH(
            token, // address token,
            liquidity, // uint liquidity,
            0, // uint amountTokenMin,
            0, // uint amountETHMin,
            msg.sender, // address to,
            block.timestamp +10 // uint deadline +10sec
        );

    }

    // ------------- SWAP ------------- 

    function swapExactTokenToToken(uint amountIn, address[] calldata path) external {
        // TODO
    }

    function swapTokenToExactToken(uint amountOut, uint amountInMax, address[] calldata path) external {
        // TODO
    }

    function swapExactKlayToToken(address[] calldata path) payable external {
        // TODO
    }

    function swapKlayToExactToken(uint amountOut, address[] calldata path) payable external {
        // TODO
    }


    // ------------- FARM ------------- 

    function deposit(uint pid, uint amount) external {
        // TODO
    }

    function withdraw(uint pid, uint amount) external {
        // TODO
    }

    function harvest() public {
        // TODO
    }

    function claimReward() external {
        // TODO
    }

    // ------------- UTILS ------------- 

    function approveToken(address token, address spender) private {
        if (IERC20(token).allowance(address(this), spender) == 0) {
            IERC20(token).approve(spender, type(uint).max);
        }
    }
}