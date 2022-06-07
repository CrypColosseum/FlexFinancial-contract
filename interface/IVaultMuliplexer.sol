// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;


interface IVaultMultiplexer {
    struct PositionInfo {
        address account;
        uint depositedAt;
    }

    struct UserInfo {
        uint[] positionList;
        mapping(address => uint) debtShare;
    }

    struct PositionState {
        address account;
        bool liquidated;
        uint balance;
        uint principal;
        uint earned;
        uint debtRatio;
        uint debtToken0;
        uint debtToken1;
        uint token0Value;
        uint token1Value;
        uint token0Refund;
        uint token1Refund;
        uint debtRatioLimit;
        uint depositedAt;
    }

    struct VaultState {
        uint balance;
        uint tvl;
        uint debtRatioLimit;
    }

    // view function
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getPositionOwner(uint id) external view  returns (address);

    // view function
    function balance() external view returns(uint);
    function balanceOf(uint id) external view returns(uint);
    function principalOf(uint id) external view returns(uint);
    function earned(uint id) external view returns(uint);
    function debtValOfPosition(uint id) external view returns (uint[] memory);
    function debtRatioOf(uint id) external view returns (uint);

    // events
    event OpenPosition(address indexed account, uint indexed id);
    event ClosePosition(address indexed account, uint indexed id);

    event Deposited(address indexed account, uint indexed id, uint token0Amount, uint token1Amount, uint lpAmount);
    event Withdrawn(address indexed account, uint indexed id, uint amount, uint token0Amount, uint token1Amount);
    event Borrow(address indexed account, uint indexed id, uint token0Borrow, uint token1Borrow);
    event Repay(address indexed account, uint indexed id, uint token0Repay, uint token1Repay);

    event RewardAdded(address indexed token, uint reward);
    event ClaimReward(address indexed account, uint indexed id, uint reward);
}
