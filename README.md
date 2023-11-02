# AddressSoul
SoulBoundTokens contract allows a users to mint his AddressSoul NFT using any token pair with WETH available on Uniswap Goerli.
You can edit the various contract addresses to explore on various testnets.

## Prerequites
1. Hardhat
2. Alchemy/Infura API Key
3. A Private Key with enough GoerliETH balance.

## Steps to Run
1. Install all dependencies using:
  > npm install

2. Config .env file with below variables.
> API_URL="Alchemy/Infura URL with API key"
> 
> PRIVATE_KEY="Your testnet private key"

3. Deploy the contracts on Goerli testnet using the script:
>  npx hardhat --network goerli run scripts/deploy.js

4. Now you can interact with the contract using any interface(Remix, Hardhat, etc).
   To Fetch the price of minting an NFT in terms of an ERC20 token, use below function:
>  SoulBoundTokens.getPriceByToken(Your_ERC20Token_Address)
>  User needs to allow the AddressSoul contract for transferring Required amount of ERC20 token before minting.


## References
1. Refer below URL for checking available pairs on Uniswap on Goerli.
> https://www.geckoterminal.com/goerli-testnet/uniswap-goerli-testnet/pools

2. A sample is deployed on Ethereum Goerli Testnet on following address:
> 0x96C6fb5427c0C49217bC8F6338231351bd1e4b8b
