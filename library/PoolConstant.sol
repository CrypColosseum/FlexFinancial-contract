// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;



library PoolConstant {

    enum PoolTypes {
        BunnyStake_deprecated, // no perf fee
        BunnyFlip_deprecated, // deprecated
        CakeStake, FlipToFlip, FlipToCake,
        Bunny, // no perf fee
        BunnyBNB,
        Venus,
        Collateral,
        BunnyToBunny,
        FlipToReward,
        BunnyV2,
        Qubit,
        bQBT, flipToQBT,
        Multiplexer
    }

    struct PoolInfo {
        address pool;
        uint balance;
        uint principal;
        uint available;
        uint tvl;
        uint utilized;
        uint liquidity;
        uint pBASE;
        uint pBUNNY;
        uint depositedAt;
        uint feeDuration;
        uint feePercentage;
        uint portfolio;
    }

    struct RelayInfo {
        address pool;
        uint balanceInUSD;
        uint debtInUSD;
        uint earnedInUSD;
    }

    struct RelayWithdrawn {
        address pool;
        address account;
        uint profitInETH;
        uint lossInETH;
    }
}
