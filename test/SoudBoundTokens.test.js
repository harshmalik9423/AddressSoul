const { expect } = require('chai');
const { ethers, waffle } = require('hardhat');
const { parseUnits } = ethers.utils;

describe('SoulBoundTokens', () => {
  let SoulBoundTokens;
  let soulBoundTokens;
  let owner;
  let user;
  let erc20Token;

  beforeEach(async () => {
    [owner, user] = await ethers.getSigners();

    // Deploy the ERC20 Token contract
    const ERC20Token = await ethers.getContractFactory('ERC20Token');
    erc20Token = await ERC20Token.deploy();
    erc20Token = await erc20Token.deployed();

    // Deploy the SoulBoundTokens contract
    SoulBoundTokens = await ethers.getContractFactory('SoulBoundTokens');
    soulBoundTokens = await SoulBoundTokens.deploy('SoulBound', 100);
    soulBoundTokens = await soulBoundTokens.deployed();

    // Approve soulboundtokens contract to transfer tokens
    await erc20Token.connect(owner).approve(soulBoundTokens.address, parseUnits('10000'));
  });

  it('should allow minting by ERC20 tokens', async () => {
    const initialBalance = await erc20Token.balanceOf(soulBoundTokens.address);

    await soulBoundTokens.connect(user).mintByERCToken(erc20Token.address);

    const finalBalance = await erc20Token.balanceOf(soulBoundTokens.address);
    const userSoul = await soulBoundTokens.getSoul(user.address);

    expect(finalBalance.sub(initialBalance)).to.equal(parseUnits('100', 18));
    expect(userSoul).to.equal(user.address);
  });

  it('should allow minting by native tokens', async () => {
    ownerAddress = await owner.getAddress();
    userAddress = await owner.getAddress();

    const initialBalance = await ethers.provider.getBalance(soulBoundTokens.address);

    soulBoundTokens.connect(user).mint({ value: parseUnits('100', 18) }).then(() => {
        done();
    });

    const finalBalance = await ethers.provider.getBalance(soulBoundTokens.address);
    const userSoul = await soulBoundTokens.getSoul(userAddress);

    expect(finalBalance.sub(initialBalance)).to.equal(parseUnits('100', 18));
    expect(userSoul).to.equal(user.address);
  });



});
