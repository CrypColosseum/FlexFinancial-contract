// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {PoolConstant} from "../library/PoolConstant.sol";
import "../interfaces/IVaultCollateral.sol";
import "./calculator/PriceCalculatorETH.sol";


contract DashboardETH is OwnableUpgradeable {
    using SafeMath for uint;

    PriceCalculatorETH public constant priceCalculator = PriceCalculatorETH();

    address public constant WETH = ;

    /* ========== INITIALIZER ========== */

    function initialize() external initializer {
        __Ownable_init();
    }

    /* ========== TVL Calculation ========== */

    function tvlOfPool(address pool) public view returns (uint tvl) {
        IVaultCollateral strategy = IVaultCollateral(pool);
        (, tvl) = priceCalculator.valueOfAsset(strategy.stakingToken(), strategy.balance());
    }

    /* ========== Pool Information ========== */

    function infoOfPool(address pool, address account) public view returns (PoolConstant.PoolInfo memory) {
        IVaultCollateral strategy = IVaultCollateral(pool);
        PoolConstant.PoolInfo memory poolInfo;

        uint collateral = strategy.collateralOf(account);
        (, uint collateralInUSD) = priceCalculator.valueOfAsset(strategy.stakingToken(), collateral);

        poolInfo.pool = pool;
        poolInfo.balance = collateralInUSD;
        poolInfo.principal = collateral;
        poolInfo.available = strategy.availableOf(account);
        poolInfo.tvl = tvlOfPool(pool);
        poolInfo.pBASE = strategy.realizedInETH(account);
        poolInfo.depositedAt = strategy.depositedAt(account);
        poolInfo.feeDuration = strategy.WITHDRAWAL_FEE_PERIOD();
        poolInfo.feePercentage = strategy.WITHDRAWAL_FEE();
        poolInfo.portfolio = portfolioOfPoolInUSD(pool, account);
        return poolInfo;
    }

    function poolsOf(address account, address[] memory pools) public view returns (PoolConstant.PoolInfo[] memory) {
        PoolConstant.PoolInfo[] memory results = new PoolConstant.PoolInfo[](pools.length);
        for (uint i = 0; i < pools.length; i++) {
            results[i] = infoOfPool(pools[i], account);
        }
        return results;
    }

    /* ========== Portfolio Calculation ========== */

    function portfolioOfPoolInUSD(address pool, address account) internal view returns (uint) {
        IVaultCollateral strategy = IVaultCollateral(pool);
        address stakingToken = strategy.stakingToken();

        (, uint collateralInUSD) = priceCalculator.valueOfAsset(stakingToken, strategy.collateralOf(account));
        (, uint availableInUSD) = priceCalculator.valueOfAsset(stakingToken, strategy.availableOf(account));
        (, uint profitInUSD) = priceCalculator.valueOfAsset(WETH, strategy.realizedInETH(account));
        return collateralInUSD.add(availableInUSD).add(profitInUSD);
    }

    function portfolioOf(address account, address[] memory pools) public view returns (uint deposits) {
        deposits = 0;
        for (uint i = 0; i < pools.length; i++) {
            deposits = deposits.add(portfolioOfPoolInUSD(pools[i], account));
        }
    }
}
