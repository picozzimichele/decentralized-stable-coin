// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

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

contract DSCEngine {
    // ERRORS
    error DSCEngine__NeedsMoreThanZero();

    //STATE VARIABLES
    mapping(address token => address priceFeed) private s_priceFeeds;

    // MODIFIERS
    modifier moreThanZero(uint256 _amount) {
        if (_amount <= 0) {
            revert DSCEngine__NeedsMoreThanZero();
        }
        _;
    }

    modifier isAllowedToken(address token) {
        _;
    }

    // FUNCTIONS
    constructor() {}

    //EXTERNAL FUNCTIONS
    function depositCollateralAndMintDsc() external {}

    /*
     * @params tokenCollateralAddress: the address of the collateral token to be deposited
     * @params amountCollateral: the amount of collateral to be deposited
     */
    function depositCollateral(
        address tokenCollateralAddress,
        uint256 amountCollateral
    ) external moreThanZero(amountCollateral) {}

    function redeemCollateralForDsc() external {}

    function redeemCollateral() external {}

    function mintDsc() external {}

    function burnDsc() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}
}
