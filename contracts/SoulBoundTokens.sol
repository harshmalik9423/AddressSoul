// SPDX-License-Identifier: MIT
pragma solidity =0.5.16;

import './TokenPrice.sol';
import '@uniswap/v2-core/contracts/interfaces/IERC20.sol';

contract SoulBoundTokens {

    struct AddressSoul {
        address addr;
    }

    mapping (address => AddressSoul) private souls;

    string public name;
    address public operator;
    uint public price;
    FetchPrice priceOracle = new FetchPrice();
    
    event Mint(address _soul);

    constructor(string memory _name, uint _price) public {
        name = _name;
        operator = msg.sender;
        price = _price;
    }

    modifier onlyOwner() {
        require(msg.sender == operator, "Owner Only process called");
        _;
    }

    function createAddressSoul(address minter) private  {
        AddressSoul memory _soul;
        _soul.addr = minter;
        souls[minter] = _soul;
        emit Mint(_soul.addr);
    }

    // Mints an AddressSoul for user
    // Accepts payment in form of any ERC20 Token listed on UniSwap
    function mintByERCToken(address erc20Address) external {
        require(souls[msg.sender].addr == address(0), "AddressSoul already exists");
        require(erc20Address != address(0), "Zero address provieded to ERC20 contract");

        uint priceInToken = priceOracle.getTokenPrice(erc20Address, price);

        // Transferring required tokens from minter to the contract
        // ** NOTE 
        //    Minter should approve the contract to transfer require amount of tokens
        // **
        require(IERC20(erc20Address).transferFrom(msg.sender, address(this), priceInToken), "Token Payment Failed");

        createAddressSoul(msg.sender);
    }

    // Mints and AddressSoul for user
    // Accepts payment in form of Native Token
    function mint() external payable {
        require(souls[msg.sender].addr == address(0), "AddressSoul already exists");
        require(msg.value == price, "Invalid ETH paid for minting AddressSoul");

        createAddressSoul(msg.sender);
    }

    // Returns Price of Minting an NFT in units of given ERC20 Token Address (Formatted in token * 10^18)
    function getPriceByToken(address erc20Address) public view returns(uint) {
        return priceOracle.getTokenPrice(erc20Address, price);
    }

    // Returns the Balance of contract for a given ERC20 token
    function getBalanceForToken(address erc20Address) public view onlyOwner returns(uint) {
        return IERC20(erc20Address).balanceOf(address(this));
    }

    // Returns true if sender has minted an AddressSoul
    function hasSoul(address _soul) public view returns (bool) {
        if (souls[_soul].addr == address(0)) {
            return false;
        } else {
            return true;
        }
    }

    // Returns the content(address) of the AddressSoul of the sender
    function getSoul(address _soul) external view returns (address) {
        require(hasSoul(msg.sender) == true, "User does not own an AddressSoul");
        return souls[_soul].addr;
    }
}