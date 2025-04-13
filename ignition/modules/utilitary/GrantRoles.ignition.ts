// import { buildModule } from '@nomicfoundation/hardhat-ignition/modules';
// import { ZeroAddress } from 'ethers';

// const moduleName = 'GrantRoles';
// export default buildModule(moduleName, (m) => {
//   const dogeGoGoAddress = m.getParameter('dogeGoGoAddress', ZeroAddress);
//   const poolsBasedPresaleAddress = m.getParameter('poolsBasedPresaleAddress', ZeroAddress);
//   const lockedBalanceAddress = m.getParameter('lockedBalanceAddress', ZeroAddress);

//   const dogeGoGo = m.contractAt('DogeGoGo', dogeGoGoAddress);
//   const lockedBalance = m.contractAt('LockedBalance', lockedBalanceAddress);

//   const minterRoleDgg = m.staticCall(dogeGoGo, 'MINTER_ROLE');
//   const operationsProviderRoleLockedBalance = m.staticCall(lockedBalance, 'OPERATIONS_PROVIDER_ROLE');

//   m.call(dogeGoGo, 'setExternalBalanceProvider', [lockedBalanceAddress]);
//   m.call(dogeGoGo, 'grantRole', [minterRoleDgg, lockedBalanceAddress], { id: 'GrantRoles_DogeGoGo_grantRole_LockedBalance' });

//   m.call(lockedBalance, 'grantRole', [operationsProviderRoleLockedBalance, poolsBasedPresaleAddress]);
//   return {};
// });
