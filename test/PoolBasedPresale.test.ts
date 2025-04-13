// import { SignerWithAddress } from '@nomicfoundation/hardhat-ethers/signers';
// import hre, { ethers } from 'hardhat';
// import { ZeroAddress, parseEther } from 'ethers';
// import { expect } from 'chai';
// import { loadFixture, time, takeSnapshot, SnapshotRestorer } from '@nomicfoundation/hardhat-network-helpers';

// import mainFixture from '../fixtures/MainWithMocks.fixture';
// import { PoolsBasedPresale, MockERC20, LockedBalance } from '../typechain-types';

// describe('PoolsBasedPresale', () => {
//   let presale: PoolsBasedPresale;
//   let tokenToSell: MockERC20;
//   let paymentToken: MockERC20;
//   let lockedBalance: LockedBalance;
//   let owner: SignerWithAddress, proxyAdminOwner: SignerWithAddress, pauser: SignerWithAddress, minter: SignerWithAddress;

//   let deployedContracts: any;
//   let snapshot: SnapshotRestorer;
//   let defaultDuration: bigint;

//   const minAmount: bigint = parseEther('0.0001');

//   beforeEach(async () => {
//     [owner, proxyAdminOwner, pauser, minter] = await ethers.getSigners();

//     deployedContracts = await loadFixture(mainFixture(hre));

//     tokenToSell = deployedContracts.MockERC20;
//     presale = deployedContracts.poolsBasedPresale;
//     paymentToken = deployedContracts.mockERC20;
//     lockedBalance = deployedContracts.lockedBalance;

//     defaultDuration = BigInt(time.duration.days(7));
//   });

//   describe('Initialization', () => {
//     it('should initialize with the correct roles', async () => {
//       const defaultAdminRole = await presale.DEFAULT_ADMIN_ROLE();
//       const pauserRole = await presale.PAUSER_ROLE();

//       expect(await presale.hasRole(defaultAdminRole, await owner.getAddress())).to.be.true;
//       expect(await presale.hasRole(pauserRole, await pauser.getAddress())).to.be.true;
//     });
//   });

//   describe('Pause and Unpause', () => {
//     beforeEach(async () => {
//       snapshot = await takeSnapshot();
//     });

//     afterEach(async () => {
//       await snapshot.restore();
//     });

//     it('should pause the contract if called by the pauser', async () => {
//       await presale.connect(pauser).pause();
//       expect(await presale.paused()).to.be.true;
//     });

//     it('should unpause the contract if called by the pauser', async () => {
//       await presale.connect(pauser).pause();
//       await presale.connect(pauser).unpause();
//       expect(await presale.paused()).to.be.false;
//     });
//   });

//   describe('Presale Creation and Validation', () => {
//     beforeEach(async () => {
//       snapshot = await takeSnapshot();
//     });

//     afterEach(async () => {
//       await snapshot.restore();
//     });

//     it('should create a presale with valid parameters', async () => {
//       const duration = 86400; // 1 day in seconds
//       const startTimeOffset = 3600; // 1 hour in seconds
//       const amountToSell = parseEther('1000');
//       const priceNumerator = 1;
//       const priceDenominator = 100;
//       const canMint = true;

//       await presale.connect(owner).togglePaymentTokenStatus(await paymentToken.getAddress(), true);

//       await expect(
//         presale
//           .connect(owner)
//           .createPresale(
//             duration,
//             defaultDuration,
//             startTimeOffset,
//             amountToSell,
//             priceNumerator,
//             priceDenominator,
//             await lockedBalance.getAddress(),
//             await paymentToken.getAddress(),
//             canMint,
//             minAmount,
//           ),
//       ).to.emit(presale, 'PresaleCreated');
//     });

//     it('should revert if duration is zero', async () => {
//       await expect(
//         presale.connect(owner).createPresale(
//           0, // duration,
//           defaultDuration, // unlock duration
//           0, // startTimeOffset
//           parseEther('1000'),
//           1,
//           100,
//           await lockedBalance.getAddress(),
//           await paymentToken.getAddress(),
//           true,
//           minAmount,
//         ),
//       ).to.be.revertedWithCustomError(presale, 'PresaleDurationMustBeGTZero');
//     });

//     it('should revert if amountToSell is zero', async () => {
//       await expect(
//         presale.connect(owner).createPresale(
//           86400,
//           defaultDuration,
//           0,
//           0, // amountToSell
//           1,
//           100,
//           await lockedBalance.getAddress(),
//           await paymentToken.getAddress(),
//           true,
//           minAmount,
//         ),
//       ).to.be.revertedWithCustomError(presale, 'AmountToSellMustBeGTZero');
//     });

//     it('should revert if priceNumerator is zero', async () => {
//       await expect(
//         presale.connect(owner).createPresale(
//           86400,
//           defaultDuration,
//           0,
//           parseEther('1000'),
//           0, // priceNumerator
//           100,
//           await lockedBalance.getAddress(),
//           await paymentToken.getAddress(),
//           true,
//           minAmount,
//         ),
//       ).to.be.revertedWithCustomError(presale, 'PriceNumeratorMustBeGTZero');
//     });

//     it('should revert if priceDenominator is zero', async () => {
//       await expect(
//         presale.connect(owner).createPresale(
//           86400,
//           defaultDuration,
//           0,
//           parseEther('1000'),
//           1,
//           0, // priceDenominator
//           await lockedBalance.getAddress(),
//           await paymentToken.getAddress(),
//           true,
//           minAmount,
//         ),
//       ).to.be.revertedWithCustomError(presale, 'PriceDenominatorMustBeGTZero');
//     });

//     it('should revert if tokenToSell is ZeroAddress', async () => {
//       await expect(
//         presale.connect(owner).createPresale(
//           86400,
//           defaultDuration,
//           0,
//           parseEther('1000'),
//           1,
//           100,
//           ethers.ZeroAddress, // tokenToSell
//           await paymentToken.getAddress(),
//           true,
//           minAmount,
//         ),
//       ).to.be.revertedWithCustomError(presale, 'InvalidTokenToSell');
//     });

//     it('should revert if payment token is blocked', async () => {
//       await expect(
//         presale
//           .connect(owner)
//           .createPresale(
//             86400,
//             defaultDuration,
//             0,
//             parseEther('1000'),
//             1,
//             100,
//             await lockedBalance.getAddress(),
//             await paymentToken.getAddress(),
//             true,
//             minAmount,
//           ),
//       ).to.be.revertedWithCustomError(presale, 'PaymentTokenIsBlocked');
//     });
//   });

//   describe('Presale Update', () => {
//     beforeEach(async () => {
//       const duration = 86400;
//       const startTimeOffset = 3600;
//       const amountToSell = parseEther('1000');
//       const priceNumerator = 1;
//       const priceDenominator = 100;
//       const canMint = true;

//       await presale.connect(owner).togglePaymentTokenStatus(await paymentToken.getAddress(), true);
//       await presale
//         .connect(owner)
//         .createPresale(
//           duration,
//           defaultDuration,
//           startTimeOffset,
//           amountToSell,
//           priceNumerator,
//           priceDenominator,
//           await lockedBalance.getAddress(),
//           await paymentToken.getAddress(),
//           canMint,
//           minAmount,
//         );

//       snapshot = await takeSnapshot();
//     });

//     afterEach(async () => {
//       await snapshot.restore();
//     });

//     it('should update a presale with valid parameters', async () => {
//       const priceNumerator = 2;
//       const priceDenominator = 200;
//       const canMint = false;

//       await expect(
//         presale.connect(owner).updatePresale(
//           0, // presale index
//           priceNumerator,
//           priceDenominator,
//           minAmount,
//           await tokenToSell.getAddress(),
//           await paymentToken.getAddress(),
//           canMint,
//           defaultDuration,
//         ),
//       ).to.emit(presale, 'PresaleUpdated');
//     });
//   });

//   describe('Buying from Presale', () => {
//     beforeEach(async () => {
//       const duration = 86400;
//       const startTimeOffset = 0;
//       const amountToSell = parseEther('1000');
//       const priceNumerator = 1;
//       const priceDenominator = 100;
//       const canMint = true;

//       await presale.connect(owner).togglePaymentTokenStatus(await paymentToken.getAddress(), true);
//       await presale
//         .connect(owner)
//         .createPresale(
//           duration,
//           defaultDuration,
//           startTimeOffset,
//           amountToSell,
//           priceNumerator,
//           priceDenominator,
//           await lockedBalance.getAddress(),
//           await paymentToken.getAddress(),
//           canMint,
//           minAmount,
//         );

//       await presale
//         .connect(owner)
//         .createPresale(
//           duration,
//           defaultDuration,
//           startTimeOffset + 3600,
//           amountToSell,
//           priceNumerator,
//           priceDenominator,
//           await lockedBalance.getAddress(),
//           await paymentToken.getAddress(),
//           canMint,
//           minAmount,
//         );

//       snapshot = await takeSnapshot();
//     });

//     afterEach(async () => {
//       await snapshot.restore();
//     });

//     it('should allow buying tokens if the presale is active', async () => {
//       const amountToBuy = parseEther('10');
//       const cost = amountToBuy / 100n;

//       await paymentToken.connect(owner).mint(await minter.getAddress(), cost);
//       await paymentToken.connect(minter).approve(await presale.getAddress(), cost);

//       await expect(presale.connect(minter).buyFromPresale(0n, amountToBuy)).to.emit(presale, 'Bought');

//       expect(await tokenToSell.balanceOf(await minter.getAddress())).to.be.equal(0n);
//       await time.increase(defaultDuration);
//       expect(await tokenToSell.balanceOf(await minter.getAddress())).to.be.equal(amountToBuy);
//     });

//     it('should revert if the presale has not started yet', async () => {
//       await time.increase(3600 - 500); // move time forward to just before presale starts

//       const amountToBuy = parseEther('10');

//       await expect(presale.connect(minter).buyFromPresale(1, amountToBuy)).to.be.revertedWithCustomError(
//         presale,
//         'PresaleHasNotYetBeenStarted',
//       );
//     });

//     it('should revert if the presale has ended', async () => {
//       await time.increase(86400 + 1000); // move time forward to after presale ends

//       const amountToBuy = parseEther('10');

//       await expect(presale.connect(minter).buyFromPresale(0, amountToBuy)).to.be.revertedWithCustomError(
//         presale,
//         'PresaleHasFinished',
//       );
//     });

//     it('should revert if the presale has has not been met with minimum amount', async () => {
//       const amountToBuy = minAmount / 10n;

//       await expect(presale.connect(minter).buyFromPresale(0, amountToBuy)).to.be.revertedWithCustomError(
//         presale,
//         'MinAmountToBuyHasNotBeenMet',
//       );
//     });
//   });
// });
