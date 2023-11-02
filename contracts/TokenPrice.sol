// SPDX-License-Identifier: MIT
pragma solidity =0.5.16;

import "@uniswap/v2-core/contracts/UniswapV2Pair.sol";

contract FetchPrice {
    // wETH contract address in Goerli
    address ethAddress = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;

    // Returns Address of the Given pair of ERC20 Contract addresses
    function getPairAddress(address token0, address token1) private pure returns(address) {
        // Address of token0 < token1 for generating valid pair address
        // Refer UniSwap Docs 
        require(token0 < token1, "Invalid Sequencing for token pair");
        
        // Fetching Pair Address for given token from UniswapFactory
        address pair = address(uint(keccak256(abi.encodePacked(
            hex'ff',
            0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f,
            keccak256(
                abi.encodePacked(
                    token0, 
                    token1
                )
            ),     
            hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f'
        ))));
        return pair;
    }

    // Returns Amount of tokens of provided address which are equivalent to _amount of wETH
    function getTokenPrice(address tokenAddress, uint _amount) public view returns(uint)
    {
        address pairAddress;
        address token0Addr;
        address token1Addr;

        if(tokenAddress < ethAddress){
            token0Addr = tokenAddress;
            token1Addr = ethAddress;
        } else {
            token0Addr = ethAddress;
            token1Addr = tokenAddress;
        }

        pairAddress = getPairAddress(token0Addr, token1Addr);
        
        // Checking whether pair is available on uniswap
        require(pairAddress != address(0), "Pair not available");

        IUniswapV2Pair pair = IUniswapV2Pair(pairAddress);
        IERC20 token0 = IERC20(pair.token0());
        IERC20 token1 = IERC20(pair.token1());

        // Fetching Reserves of token pair from UniSwap
        (uint Res0, uint Res1,) = pair.getReserves();

        if(tokenAddress < ethAddress){
            // return _amount of token0 needed to buy token1 in token0 * 10^18 format
            return (_amount * Res0 * 1 ether)/(Res1*(10**uint(token1.decimals()))); 
        } else {
            // return _amount of token0 needed to buy token1 in token0 * 10^18 format
            return (_amount * Res1 * 1 ether)/(Res0*(10**uint(token0.decimals())));  
        }
    }   
}