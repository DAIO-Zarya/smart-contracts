// import DeployPoolsBasedPresale from '../ignition/modules/deploy/main/DeployPoolsBasedPresale.ignition';
// import GrantRoles from '../ignition/modules/utilitary/GrantRoles.ignition';

// export default (hre: any, owner: string, pauser: string, minter: string) => async () => {
//   const { poolsBasedPresale } = await hre.ignition.deploy(DeployPoolsBasedPresale, {
//     parameters: {
//       DeployPoolsBasedPresale: {
//         owner,
//         pauser,
//       },
//     },
//   });

  // await hre.ignition.deploy(GrantRoles, {
  //   parameters: {
  //     GrantRoles: {
  //       dogeGoGoAddress: await dogeGoGo.getAddress(),
  //       poolsBasedPresaleAddress: await poolsBasedPresale.getAddress(),
  //       lockedBalanceAddress: await lockedBalance.getAddress(),
  //     },
  //   },
  // });
//   return { dogeGoGo, poolsBasedPresale, lockedBalance };
// };
