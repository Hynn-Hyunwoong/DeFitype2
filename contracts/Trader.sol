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
        address inputToken = path[0];
        // transferFromInput
        IERC20(inputToken).transferFrom(msg.sender, address(this), amountIn);

        //approve inputToken
        approveToken(inputToken, ROUTER);
        //swap 
        IUniswapV2Router01(ROUTER).swapExactTokensForTokens(
            amountIn, // uint amountIn,
            0, // uint amountOutMin,
            path, // address[] calldata path,
            msg.sender, // address to,
            block.timestamp + 10 // uint deadline
        );
    }

    function swapTokenToExactToken(uint amountOut, uint amountInMax, address[] calldata path) external {
        // estimate amountIn
        uint[] memory amountsIn = IUniswapV2Router01(ROUTER).getAmountsIn(amountOut, path); // uint[] memory amountsIn
        uint amountIn = amountsIn[0];
        
        //validate check
        require(amountIn <= amountInMax, "Trader: amountInMax is not enough");
        
        // transferFrom inputToken
        address inputToken = path[0];
        IERC20(inputToken).transferFrom(msg.sender, address(this), amountIn);

        //approve
        approveToken(inputToken, ROUTER);

        //swap
        IUniswapV2Router01(ROUTER).swapTokensForExactTokens(
            amountOut, // uint amountOut,
            amountInMax, // uint amountInMax,
            path, // address[] calldata path,
            msg.sender, // address to,
            block.timestamp + 10 // uint deadline
        );

    }

    function swapExactKlayToToken(address[] calldata path) payable external {
        // checking validate
        require(path[0] == WKLAY, "Trader: path[0] is not WKLAY");
        require(msg.value >0, "Trader: msg.value is not enough");

        //swap
        IUniswapV2Router01(ROUTER).swapExactETHForTokens{value:msg.value}(
            0, // uint amountOutMin,
            path, // address[] calldata path,
            msg.sender, // address to,
            block.timestamp + 10 // uint deadline
        );
    }

    function swapKlayToExactToken(uint amountOut, address[] calldata path) payable external {
        // check path
        require(path[0] == WKLAY, "Trader: path[0] is not WKLAY");
        require(msg.value >0, "Trader: msg.value is not enough");

        // estimate KLAY amount
        uint[] memory amountsIn = IUniswapV2Router01(ROUTER).getAmountsIn(amountOut, path); // uint[] memory amountsIn
        uint amountIn = amountsIn[0];
        //swap
        IUniswapV2Router01(ROUTER).swapETHForExactTokens{value:amountsIn[0]}(
            amountOut, // uint amountOut,
            path, // address[] calldata path,
            msg.sender, // address to,
            block.timestamp + 10 // uint deadline
        );

        // msg.value - amountsIn[0] -> refund
        if (msg.value > amountsIn[0]){
            (bool success, ) = (msg.sender).call{value: msg.value - amountsIn[0]}(new bytes(0));
            require(success, "Trader: refund failed");
        } 
    }

    // TOKEN -> KLAY
    function swapExactTokenToKlay(uint amountIn, address[] calldata path) external {
        // check path
        require(path[path.length-1] == WKLAY, "Trader: path[last] is not WKLAY");

        // transferFrom
        address inputToken = path[0];
        IERC20(inputToken).transferFrom(msg.sender, address(this), amountIn);

        // approve
        approveToken(inputToken, ROUTER);

        // swap
        IUniswapV2Router01(ROUTER).swapExactTokensForETH(
            amountIn, // uint amountIn,
            0, // uint amountOutMin,
            path, // address[] calldata path,
            msg.sender, // address to,
            block.timestamp + 10 // uint deadline
        );
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