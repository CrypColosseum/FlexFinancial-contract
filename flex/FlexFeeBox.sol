// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;


import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";

import "../library/WhitelistUpgradeable.sol";
import "../library/SafeToken.sol";

import "../interfaces/IFlexPool.sol";
import "../interfaces/ISafeSwapBNB.sol";
import "../interfaces/IZap.sol";


contract FlexFeeBox is WhitelistUpgradeable {
    using SafeBEP20 for IBEP20;
    using SafeMath for uint;
    using SafeToken for address;

    /* ========== CONSTANT ========== */

    ISafeSwapBNB public constant safeSwapBNB = ISafeSwapBNB();
    IZap public constant zapBSC = IZap();

    address private constant WBNB = ;
    address private constant Flex = ;
    address private constant CAKE = ;
    address private constant USDT = ;
    address private constant BUSD = ;
    address private constant VAI = ;
    address private constant ETH = ;
    address private constant BTCB = ;
    address private constant DOT = ;
    address private constant USDC = ;
    address private constant DAI = ;

    address private constant Flex_BNB = ;
    address private constant CAKE_BNB = ;
    address private constant USDT_BNB = ;
    address private constant BUSD_BNB = ;
    address private constant USDT_BUSD = ;
    address private constant VAI_BUSD = ;
    address private constant ETH_BNB = ;
    address private constant BTCB_BNB = ;
    address private constant DOT_BNB = ;
    address private constant BTCB_BUSD = ;
    address private constant DAI_BUSD = ;
    address private constant USDC_BUSD = ;


    /* ========== STATE VARIABLES ========== */

    address public keeper;
    address public FlexPool;

    /* ========== MODIFIERS ========== */

    modifier onlyKeeper {
        require(msg.sender == keeper || msg.sender == owner(), "FlexFeeBox: caller is not the owner or keeper");
        _;
    }

    /* ========== INITIALIZER ========== */

    receive() external payable {}

    function initialize() external initializer {
        __WhitelistUpgradeable_init();
    }

    /* ========== VIEWS ========== */

    function redundantTokens() public pure returns (address[8] memory) {
        return [USDT, BUSD, VAI, ETH, BTCB, USDC, DAI, DOT];
    }

    function flips() public pure returns (address[12] memory) {
        return [Flex_BNB, CAKE_BNB, USDT_BNB, BUSD_BNB, USDT_BUSD, VAI_BUSD, ETH_BNB, BTCB_BNB, DOT_BNB, BTCB_BUSD, DAI_BUSD, USDC_BUSD];
    }

    function pendingRewards() public view returns (uint bnb, uint cake, uint Flex) {
        bnb = address(this).balance;
        cake = IBEP20(CAKE).balanceOf(address(this));
        Flex = IBEP20(Flex).balanceOf(address(this));
    }

    /* ========== RESTRICTED FUNCTIONS ========== */

    function setKeeper(address _keeper) external onlyOwner {
        keeper = _keeper;
    }

    function setFlexPool(address _FlexPool) external onlyOwner {
        FlexPool = _FlexPool;
    }

    function swapToRewards() public onlyKeeper {
        require(FlexPool != address(0), "FlexFeeBox: FlexPool must be set");

        address[] memory _tokens = IFlexPool(FlexPool).rewardTokens();
        uint[] memory _amounts = new uint[](_tokens.length);
        for (uint i = 0; i < _tokens.length; i++) {
            uint _amount = _tokens[i] == WBNB ? address(this).balance : IBEP20(_tokens[i]).balanceOf(address(this));
            if (_amount > 0) {
                if (_tokens[i] == WBNB) {
                    SafeToken.safeTransferETH(FlexPool, _amount);
                } else {
                    IBEP20(_tokens[i]).safeTransfer(FlexPool, _amount);
                }
            }
            _amounts[i] = _amount;
        }

        IFlexPool(FlexPool).notifyRewardAmounts(_amounts);
    }

    function harvest() external onlyKeeper {
        splitPairs();

        address[8] memory _tokens = redundantTokens();
        for (uint i = 0; i < _tokens.length; i++) {
            _convertToken(_tokens[i], IBEP20(_tokens[i]).balanceOf(address(this)));
        }

        swapToRewards();
    }

    function splitPairs() public onlyKeeper {
        address[12] memory _flips = flips();
        for (uint i = 0; i < _flips.length; i++) {
            _convertToken(_flips[i], IBEP20(_flips[i]).balanceOf(address(this)));
        }
    }

    function covertTokensPartial(address[] memory _tokens, uint[] memory _amounts) external onlyKeeper {
        for (uint i = 0; i < _tokens.length; i++) {
            _convertToken(_tokens[i], _amounts[i]);
        }
    }

    /* ========== PRIVATE FUNCTIONS ========== */

    function _convertToken(address token, uint amount) private {
        uint balance = IBEP20(token).balanceOf(address(this));
        if (amount > 0 && balance >= amount) {
            if (IBEP20(token).allowance(address(this), address(zapBSC)) == 0) {
                IBEP20(token).approve(address(zapBSC), uint(- 1));
            }
            zapBSC.zapOut(token, amount);
        }
    }

    // @dev use when WBNB received from minter
    function _unwrap(uint amount) private {
        uint balance = IBEP20(WBNB).balanceOf(address(this));
        if (amount > 0 && balance >= amount) {
            if (IBEP20(WBNB).allowance(address(this), address(safeSwapBNB)) == 0) {
                IBEP20(WBNB).approve(address(safeSwapBNB), uint(-1));
            }

            safeSwapBNB.withdraw(amount);
        }
    }

}
