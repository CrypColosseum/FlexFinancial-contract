pragma solidity ^0.6.12;

library PoolConstant {

    enum PoolTypes {
        FlexStake_deprecated, // no perf fee
        FlexFlip_deprecated, // deprecated
        CakeStake, FlipToFlip, FlipToCake,
        Flex, // no perf fee
        FlexBNB,
        Venus,
        Collateral,
        FlexToFlex,
        FlipToReward,
        FlexV2,
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
        uint pFlex;
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
