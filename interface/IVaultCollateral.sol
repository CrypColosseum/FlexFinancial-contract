// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

interface IVaultCollateral {
    function WITHDRAWAL_FEE_PERIOD() external view returns (uint);
    function WITHDRAWAL_FEE_UNIT() external view returns (uint);
    function WITHDRAWAL_FEE() external view returns (uint);

    function stakingToken() external view returns (address);
    function collateralValueMin() external view returns (uint);

    function balance() external view returns (uint);
    function availableOf(address account) external view returns (uint);
    function collateralOf(address account) external view returns (uint);
    function realizedInETH(address account) external view returns (uint);
    function depositedAt(address account) external view returns (uint);

    function addCollateral(uint amount) external;
    function addCollateralETH() external payable;
    function removeCollateral() external;

    event CollateralAdded(address indexed user, uint amount);
    event CollateralRemoved(address indexed user, uint amount, uint profitInETH);
    event CollateralUnlocked(address indexed user, uint amount, uint profitInETH, uint lossInETH);
    event Recovered(address token, uint amount);
}
