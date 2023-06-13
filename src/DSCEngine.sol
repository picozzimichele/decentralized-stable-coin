// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

//1.10.25

/*
 * @title DSCEngine
 * @author Michele Picozzi
 *
 * The system is designed to be as minimal as possible, and to have the tokens to maintain 1token = 1 dollar peg.
 * This stablecoin has the properties:
 * 1. Collateral: Exogenous BTC & ETH
 * 2. Dollar Pegged
 * 3. Stable Algorithmically
 *
 * it is similar to DAI if DAI had no governance, no fees, adn was only backed by WBTC and WETH
 *
 * Our DSC System should always be overcollateralized, at no point should the value of all collateral <= value of all DSC.
 *
 * @notice This contract is a work in progress and is not ready for production
 * @notice this is the core of the DSC System. It handles all the logic for mining and redeeming DSC as well as withdrawind and depositing collateral
 */

contract DSCEngine is ReentrancyGuard {
    // ERRORS
    error DSCEngine__NeedsMoreThanZero();
    error DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
    error DSCEngine__TokenNotAllowed();
    error DSCEngine__TransferFailed();

    //STATE VARIABLES
    mapping(address token => address priceFeed) private s_priceFeeds;
    mapping(address user => mapping(address token => uint256 amount)) private s_collateralDeposited;

    DecentralizedStableCoin private immutable i_dsc;

    // EVENTS
    event CollateralDeposited(address indexed user, address indexed token, uint256 indexed amount);

    // MODIFIERS
    modifier moreThanZero(uint256 _amount) {
        if (_amount <= 0) {
            revert DSCEngine__NeedsMoreThanZero();
        }
        _;
    }

    modifier isAllowedToken(address token) {
        if (s_priceFeeds[token] == address(0)) {
            revert DSCEngine__TokenNotAllowed();
        }
        _;
    }

    // FUNCTIONS
    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address dscAddress) {
        //USD PriceFeed
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
        }
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
        }
        i_dsc = DecentralizedStableCoin(dscAddress);
    }

    //EXTERNAL FUNCTIONS
    function depositCollateralAndMintDsc() external {}

    /*
     * @notice follows CEI (Check-Effect-Interaction) pattern
     * @params tokenCollateralAddress: the address of the collateral token to be deposited
     * @params amountCollateral: the amount of collateral to be deposited
     */
    function depositCollateral(address tokenCollateralAddress, uint256 amountCollateral)
        external
        moreThanZero(amountCollateral)
        isAllowedToken(tokenCollateralAddress)
        nonReentrant
    {
        s_collateralDeposited[msg.sender][tokenCollateralAddress] += amountCollateral;
        emit CollateralDeposited(msg.sender, tokenCollateralAddress, amountCollateral);
        bool success = IERC20(tokenCollateralAddress).transferFrom(msg.sender, address(this), amountCollateral);
        if (!success) {
            revert DSCEngine__TransferFailed();
        }
    }

    function redeemCollateralForDsc() external {}

    function redeemCollateral() external {}

    function mintDsc() external {}

    function burnDsc() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}
}
