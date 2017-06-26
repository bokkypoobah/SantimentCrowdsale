pragma solidity ^0.4.11;

import "./ERC20.sol";

//Decision made.
// 1 - Provider is solely responsible to consider failed sub charge as an error and stop the service,
//    therefore there is no separate error state or counter for that in this Token Contract.
//
// 2 - A call originated from the user (isContract(msg.sender)==false) should throw an exception on error,
//     but it should return "false" on error if called from other contract (isContract(msg.sender)==true).
//     Reason: thrown exception are easier to see in wallets, returned boolean values are easier to evaluate in the code of the calling contract.
//
//ToDo:
// 4 - check: all functions for access modifiers: _from, _to, _others
// 5 - check: all function for re-entrancy
// 6 - check: all _paymentData
// 7 - check Cancel/Hold/Unhold Offer functionality
// 8 - validate linking modules and deployment process: attachToken(address token) public
// 9 - validate function currentStatus(uint subId) public constant
//ToDo later:
// 0 - embed force archive subscription into sub cancellation.
//     (Currently difficult/impossible because low level call is missing return value)
//
//Ask:
// Given: subscription one year:

contract PaymentListener {

    function onPayment(address _from, uint _value, bytes _paymentData) returns (bool);
    function onSubExecuted(uint subId) returns (bool);
    function onSubNew(uint newSubId, uint offerId) returns (bool);
    function onSubCanceled(uint subId, address caller) returns (bool);
    function onSubUnHold(uint subId, address caller, bool isOnHold) returns (bool);

}

///@notice XRateProvider is an external service providing an exchange rate from external currency to SAN token.
/// it used for subscriptions priced in other currency than SAN (even calculated and paid formally in SAN).
/// if non-default XRateProvider is set for some subscription, then the amount in SAN for every periodic payment
/// will be recalculated using provided exchange rate.
///
/// Please note, that the exchange rate fraction is (uint32,uint32) number. It should be enough to express
/// any real exchange rate volatility. Nevertheless you are advised to avoid too big numbers in the fraction.
/// Possiibly you could implement the ratio of multiple token per SAN in order to keep the average ratio around 1:1.
///
/// The default XRateProvider (with id==0) defines exchange rate 1:1 and represents exchange rate of SAN token to itself.
/// this provider is set by defalult and thus the subscription becomes nominated in SAN.
//
contract XRateProvider {

    //@dev returns current exchange rate (in form of a simple fraction) from other currency to SAN (f.e. ETH:SAN).
    //@dev fraction numbers are restricted to uint16 to prevent overflow by calculation;
    function getRate() returns (uint32 /*nominator*/, uint32 /*denominator*/);

    //@dev provides a code for another currency, f.e. "ETH" or "USD"
    function getCode() returns (string);
}


//@notice data structure for SubscriptionModule
contract SubscriptionBase {
    enum Status {NOT_EXIST, OFFER, PAID, CHARGEABLE, ON_HOLD, CANCELED, EXPIRED, ARCHIVED}

    //@dev subscription and subscription offer use the same structure. Offer is technically a template for subscription.
    struct Subscription {
        address transferFrom;   // customer (unset in subscription offer)
        address transferTo;     // service provider
        uint pricePerHour;      // price in SAN per hour (possibly recalculated using exchange rate)
        uint32 initialXrate_n;  // nominator
        uint32 initialXrate_d;  // denominator
        uint16 xrateProviderId; // id of a registered exchange rate provider
        uint paidUntil;         // subscription is paid until time
        uint chargePeriod;      // subscription can't be charged more often than this period
        uint depositAmount;     // upfront deposit on creating subscription (possibly recalculated using exchange rate)

        uint startOn;           // for offer: can't be accepted before  <startOn> ; for subscription: can't be charged before <startOn>
        uint expireOn;          // for offer: can't be accepted after  <expireOn> ; for subscription: can't be charged after  <expireOn>
        uint execCounter;       // for offer: max num of subscriptions available  ; for subscription: num of charges made.
        bytes descriptor;       // subscription payload (subject): evaluated by service provider.
        uint onHoldSince;       // subscription: on-hold since time or 0 if not onHold. offer: unused: //ToDo: to be implemented
    }

    struct Deposit {
        uint value;         // value on deposit
        address owner;      // usually a customer
        bytes descriptor;   // service related descriptor to be evaluated by service provider
    }

    event NewSubscription(address customer, address service, uint offerId, uint subId);
    event NewDeposit(uint depositId, uint value, address sender);
    event NewXRateProvider(address addr, uint16 xRateProviderId, address sender);
    event DepositReturned(uint depositId, address returnedTo);
    event SubscriptionDepositReturned(uint subId, uint amount, address returnedTo, address sender);
    event OfferOnHold(uint offerId, bool onHold, address sender);
    event OfferCanceled(uint offerId, address sender);
    event SubOnHold(uint offerId, bool onHold, address sender);
    event SubCanceled(uint subId, address sender);

}

///@dev interface for SubscriptionModule
contract SubscriptionModule is SubscriptionBase, Base {
    function attachToken(address token) public;

    ///@dev the same like transfer methods, but with recipient's notification
    ///@param _value amount to transfer
    ///@param _paymentData is a payment descriptor evaluated by PaymentListener
    ///@param _to PaymentListener becomes notified and has chance to evaluate incoming payment and reject it.
    function paymentTo(uint _value, bytes _paymentData, PaymentListener _to) public returns (bool success);
    function paymentFrom(uint _value, bytes _paymentData, address _from, PaymentListener _to) public returns (bool success);

    ///@dev creates subscription offer.
    ///@dev all times  denominated in currency given by XrateProvider.
    function createSubscriptionOffer(uint _price, uint16 _xrateProviderId, uint _chargePeriod, uint _expireOn, uint _offerLimit, uint _depositValue, uint _startOn, bytes _descriptor) public returns (uint subId);
    function updateSubscriptionOffer(uint offerId, uint _offerLimit) public;
    function acceptSubscriptionOffer(uint _offerId, uint _expireOn, uint _startOn) public returns (uint newSubId);
    function cancelSubscription(uint subId) public;
    function cancelSubscription(uint subId, uint gasReserve) public;
    function holdSubscription(uint subId) public returns (bool success);
    function unholdSubscription(uint subId) public  returns (bool success);
    function executeSubscription(uint subId) public returns (bool success);
    function postponeDueDate(uint subId, uint newDueDate) public returns (bool success);
    function currentStatus(uint subId) public constant returns(Status status);
    function returnSubscriptionDesposit(uint subId) external;

    function holdSubscriptionOffer(uint offerId) public returns (bool success);
    function unholdSubscriptionOffer(uint offerId) public returns (bool success);
    function cancelSubscriptionOffer(uint offerId) public returns (bool);

    function claimSubscriptionDeposit(uint subId);
    function createDeposit(uint _value, bytes _descriptor) public returns (uint subId);
    function claimDeposit(uint depositId) public;
    function registerXRateProvider(XRateProvider addr) external returns (uint16 xrateProviderId);
    function enableServiceProvider(PaymentListener addr) external;
    function disableServiceProvider(PaymentListener addr) external;

    function subscriptionDetails(uint subId) external constant returns(
        address transferFrom,
        address transferTo,
        uint pricePerHour,
        uint32 initialXrate_n, //nominator
        uint32 initialXrate_d, //denominator
        uint16 xrateProviderId,
        uint chargePeriod,
        uint startOn,
        bytes descriptor
    );

    function subscriptionStatus(uint subId) external constant returns(
        uint depositAmount,
        uint expireOn,
        uint execCounter,
        uint paidUntil,
        uint onHoldSince
    );

    enum PaymentStatus {OK, BALANCE_ERROR, APPROVAL_ERROR}

    event Payment(address _from, address _to, uint _value, uint _fee, address sender, PaymentStatus status, uint subId);

}

//@dev implementation
contract SubscriptionModuleImpl is SubscriptionModule, Owned  {

    ///@dev list of all registered service provider contracts impelmented as a map for better lookup.
    mapping (address=>bool) public providerRegistry;

    ///@dev all subscriptions and offers (incl. ARCHIVED).
    mapping (uint => Subscription) public subscriptions;

    ///@dev all active simple deposits gived by depositId.
    mapping (uint => Deposit) public deposits;

    ///@dev addresses of registered exchange rate providers.
    XRateProvider[] public xrateProviders;

    ///@dev ongoing counter for subscription ids starting from 1.
    ///     Current value represents an id of last created subscription.
    uint public subscriptionCounter = 0;

    ///@dev ongoing counter for simple deposit ids starting from 1.
    ///     Current value represents an id of last created deposit.
    uint public depositCounter = 0;

    ///@dev Token contract with ERC20ModuleSupport addon.
    ///     Subscription Module operates on its balances via ERC20ModuleSupport interface as trusted module.
    ERC20ModuleSupport san;

    // *************************************************
    // *     reject all ether sent to this contract    *
    // *************************************************
    function () {
        throw;
    }

    // *************************************************
    // *            setup and configuration            *
    // *************************************************

    ///@dev constructor
    function SubscriptionModuleImpl() {
        owner = msg.sender;
        xrateProviders.push(XRateProvider(this)); //this is a default SAN:SAN (1:1) provider with default id == 0
    }

    ///@dev attach SAN token to work with; can be done only once.
    function attachToken(address token) public {
        assert(address(san) == 0); //only in new deployed state
        san = ERC20ModuleSupport(token);
    }

    ///@dev register a new service provider to the platform.
    function enableServiceProvider(PaymentListener addr) external only(owner) {
        providerRegistry[addr] = true;
    }


    ///@dev de-register the service provider with given `addr`.
    function disableServiceProvider(PaymentListener addr) external only(owner) {
        delete providerRegistry[addr];
    }

    ///@dev register new exchange rate provider.
    ///     XRateProvider can't be de-registered, because they could be still in use by some subscription.
    function registerXRateProvider(XRateProvider addr) external only(owner) returns (uint16 xrateProviderId) {
        xrateProviderId = uint16(xrateProviders.length);
        xrateProviders.push(addr);
        NewXRateProvider(addr, xrateProviderId, msg.sender);
    }

    ///@dev xrateProviders length accessor.
    function getXRateProviderLength() external constant returns (uint) {
        return xrateProviders.length;
    }


    // *************************************************
    // *           single payment methods              *
    // *************************************************

    ///@notice makes single payment to service provider.
    ///@param _value - amount of SAN token to sent
    ///@param _paymentData - 'payment purpose' code usually issued by service provider to customer before payment.
    ///@param _to - service provider contract
    ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
    //
    function paymentTo(uint _value, bytes _paymentData, PaymentListener _to) public returns (bool success) {
        if (san._fulfillPayment(msg.sender, _to, _value, 0, msg.sender)) {
            // a PaymentListener (a ServiceProvider) has here an opportunity verify and reject the payment
            assert (PaymentListener(_to).onPayment(msg.sender, _value, _paymentData));
            return true;
        } else if (isContract(msg.sender)) { return false; }
          else { throw; }
    }


    ///@notice makes single preapproved payment to service provider. An amount must be already preapproved by payment sender to recepient.
    ///@param _value - amount of SAN token to sent
    ///@param _paymentData - 'payment purpose' code usually issued by service provider to customer before payment.
    ///@param _from - sender of the payment (other than msg.sender)
    ///@param _to - service provider contract
    ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
    //
    function paymentFrom(uint _value, bytes _paymentData, address _from, PaymentListener _to) public returns (bool success) {
        if (san._fulfillPreapprovedPayment(_from, _to, _value, msg.sender)) {
            // a PaymentListener (a ServiceProvider) has here an opportunity verify and reject the payment
            assert (PaymentListener(_to).onPayment(_from, _value, _paymentData));
            return true;
        } else if (isContract(msg.sender)) { return false; }
          else { throw; }
    }


    // *************************************************
    // *            subscription handling              *
    // *************************************************

    ///@dev convenience getter for some subscription fields
    function subscriptionDetails(uint subId) external constant returns (
        address transferFrom,
        address transferTo,
        uint pricePerHour,
        uint32 initialXrate_n, //nominator
        uint32 initialXrate_d, //denominator
        uint16 xrateProviderId,
        uint chargePeriod,
        uint startOn,
        bytes descriptor
    ) {
        Subscription sub = subscriptions[subId];
        return (sub.transferFrom, sub.transferTo, sub.pricePerHour, sub.initialXrate_n, sub.initialXrate_d, sub.xrateProviderId, sub.chargePeriod, sub.startOn, sub.descriptor);
    }


    ///@dev convenience getter for some subscription fields
    ///     a caller must know, that the subscription with given id exists, because all these fields can be 0 even the subscription with given id exists.
    function subscriptionStatus(uint subId) external constant returns(
        uint depositAmount,
        uint expireOn,
        uint execCounter,
        uint paidUntil,
        uint onHoldSince
    ) {
        Subscription sub = subscriptions[subId];
        return (sub.depositAmount, sub.expireOn, sub.execCounter, sub.paidUntil, sub.onHoldSince);
    }


    ///@notice execute periodic subscription payment.
    ///        Any of customer, service provider and platform owner can execute this function.
    ///        This ensures, that the subscription charge doesn't become delayed.
    ///        At least the platform owner has an incentive to get fee and thus can trigger the function.
    ///        An execution fails if subscription is not in status `CHARGEABLE`.
    ///@param subId - subscription to be charged.
    ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
    //
    function executeSubscription(uint subId) public returns (bool) {
        Subscription storage sub = subscriptions[subId];
        assert (_isNotOffer(sub));
        assert (msg.sender == sub.transferFrom || msg.sender == sub.transferTo || msg.sender == owner);
        if (_currentStatus(sub)==Status.CHARGEABLE) {
            var _from = sub.transferFrom;
            var _to = sub.transferTo;
            var _value = _amountToCharge(sub);
            if (san._fulfillPayment(_from, _to, _value, subId, msg.sender)) {
                sub.paidUntil  = max(sub.paidUntil, sub.startOn) + sub.chargePeriod;
                ++sub.execCounter;
                // a PaymentListener (a ServiceProvider) has here an opportunity to verify and reject the payment
                assert (PaymentListener(_to).onSubExecuted(subId));
                return true;
            }
        }
        if (isContract(msg.sender)) { return false; }
        else { throw; }
    }

    ///@notice move `paidUntil` forward to given `newDueDate`. It waives payments for given time.
    ///        This function can be used by service provider to `give away` some service time for free.
    ///@param subId - id of subscription to be postponed.
    ///@param newDueDate - new `paidUntil` datetime; require `newDueDate > paidUntil`.
    ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
    //
    function postponeDueDate(uint subId, uint newDueDate) public returns (bool success){
        Subscription storage sub = subscriptions[subId];
        assert (_isNotOffer(sub));
        assert (sub.transferTo == msg.sender); //only Service Provider is allowed to postpone the DueDate
        if (sub.paidUntil < newDueDate) {
            sub.paidUntil = newDueDate;
            return true;
        } else if (isContract(msg.sender)) { return false; }
          else { throw; }
    }

    ///@dev return current status of subscription with gived id;
    function currentStatus(uint subId) public constant returns(Status status) {
        return _currentStatus(subscriptions[subId]);
    }

    function _currentStatus(Subscription storage sub) internal constant returns(Status status) {
        if (sub.transferTo == 0) {
            //every subscription or offer has this field set. If not -- there is no record to given id at all.
            return Status.NOT_EXIST;
        } else if (sub.onHoldSince>0) {
            return Status.ON_HOLD;
        } else if (sub.transferFrom==0) {
            return Status.OFFER;
        } else if (sub.paidUntil >= sub.expireOn) {
            return now < sub.expireOn
                ? Status.CANCELED
                : sub.depositAmount > 0
                    ? Status.EXPIRED
                    : Status.ARCHIVED;
        } else if (sub.paidUntil <= now) {
            return Status.CHARGEABLE;
        } else {
            return Status.PAID;
        }
    }


    ///@notice create a new subscription offer.
    ///@dev only registered service provider is allowed to create offers.
    ///@dev subscription uses SAN token for payment, but an exact amount to be paid or deposit is calculated using exchange rate from external xrateProvider (previosly registered on platform).
    ///    This allows to create a subscription bound to another token or even fiat currency.
    ///@param _pricePerHour - subscription price per hour in SAN
    ///@param _xrateProviderId - id of external exchange rate provider from subscription currency to SAN; "0" means subscription is priced in SAN natively.
    ///@param _chargePeriod - time period to charge; subscription can't be charged more often than this period. Time units are native ethereum time, returning by `now`, i.e. seconds.
    ///@param _expireOn - offer can't be accepted after this time.
    ///@param _offerLimit - how many subscription are available to created from this offer; there is no magic number for unlimited offer -- use big number instead.
    ///@param _depositAmount - upfront deposit required for creating a subscription; this deposit becomes fully returned on subscription is over.
    ///       currently this deposit is not subject of platform fees and will be refunded in full. Next versions of this module can use deposit in case of outstanding payments.
    ///@param _startOn - a subscription from this offer can't be created before this time. Time units are native ethereum time, returning by `now`, i.e. seconds.
    ///@param _descriptor - arbitrary bytes as an offer descriptor. This descriptor is copied into subscription and then service provider becomes it passed in notifications.
    //
    function createSubscriptionOffer(uint _pricePerHour, uint16 _xrateProviderId, uint _chargePeriod, uint _expireOn, uint _offerLimit, uint _depositAmount, uint _startOn, bytes _descriptor)
    public
    onlyRegisteredProvider
    returns (uint subId) {
        assert (_startOn < _expireOn);
        assert (_chargePeriod <= 10 years);
        var (_xrate_n, _xrate_d) = _xrateProviderId == 0 ? (1,1) : XRateProvider(xrateProviders[_xrateProviderId]).getRate();
        assert (_xrate_n > 0 && _xrate_d > 0);
        subscriptions[++subscriptionCounter] = Subscription ({
            transferFrom    : 0,                  // empty transferFrom field means we have an offer, not a subscription
            transferTo      : msg.sender,         // service provider is a beneficiary of subscripton payments
            pricePerHour    : _pricePerHour,      // price per hour in SAN (recalculated from base currency if needed)
            xrateProviderId : _xrateProviderId,   // id of registered exchange rate provider or zero if an offer is nominated in SAN.
            initialXrate_n  : _xrate_n,           // fraction nominator of the initial exchange rate
            initialXrate_d  : _xrate_d,           // fraction denominator of the initial exchange rate
            paidUntil       : 0,                  // service is considered to be paid until this time; no charge is possible while subscription is paid for now.
            chargePeriod    : _chargePeriod,      // period in seconds (ethereum block time unit) to charge.
            depositAmount   : _depositAmount,     // deposit required for subscription accept.
            startOn         : _startOn,
            expireOn        : _expireOn,
            execCounter     : _offerLimit,
            descriptor      : _descriptor,
            onHoldSince     : 0                   // offer is not on hold by default.
        });
        return subscriptionCounter;               // returns an id of the new offer.
    }


    ///@notice updates currently available number of subscription for this offer.
    ///        Other offer's parameter can't be updated because they are considered to be a public offer reviewed by customers.
    ///        The service provider should recreate the offer as a new one in case of other changes.
    //
    function updateSubscriptionOffer(uint _offerId, uint _offerLimit) {
        Subscription storage offer = subscriptions[_offerId];
        assert (_isOffer(offer));
        assert (offer.transferTo == msg.sender); //only Provider is allowed to update the offer.
        offer.execCounter = _offerLimit;
    }


    ///@notice accept given offer and create a new subscription on the base of it.
    ///
    ///@dev the service provider (offer.`transferTo`) becomes notified about new subscription by call `onSubNew(newSubId, _offerId)`.
    ///     It is provider's responsibility to retrieve and store any necessary information about offer and this new subscription. Some of info is only available at this point.
    ///     The Service Provider can also reject the new subscription by throwing an exception or returning `false` from `onSubNew(newSubId, _offerId)` event handler.
    ///@param _offerId   - id of the offer to be accepted
    ///@param _expireOn  - subscription expiration time; no charges are possible behind this time.
    ///@param _startOn   - subscription start time; no charges are possible before this time.
    ///                    If the `_startOn` is in the past or is zero, it means start the subscription ASAP.
    //
    function acceptSubscriptionOffer(uint _offerId, uint _expireOn, uint _startOn) public returns (uint newSubId) {
        assert (_startOn < _expireOn);
        Subscription storage offer = subscriptions[_offerId];
        assert (_isOffer(offer));
        assert (offer.startOn == 0     || offer.startOn  <= now);
        assert (offer.expireOn == 0    || offer.expireOn >= now);
        assert (offer.onHoldSince == 0);
        assert (offer.execCounter > 0);
        newSubId = subscriptionCounter + 1;
        //create a clone of the offer...
        Subscription storage newSub = subscriptions[newSubId] = offer;
        //... and adjust some fields specific to subscription
        newSub.transferFrom = msg.sender;
        newSub.execCounter = 0;
        newSub.paidUntil = newSub.startOn = max(_startOn, now);     //no debts before actual creation time!
        newSub.expireOn = _expireOn;
        newSub.depositAmount = _applyXchangeRate(newSub.depositAmount, newSub);
        //depositAmount is now stored in the sub, so burn the same amount from customer's account.
        assert (san._burnForDeposit(msg.sender, newSub.depositAmount));
        assert (PaymentListener(newSub.transferTo).onSubNew(newSubId, _offerId)); //service provider can still reject the new subscription here

        NewSubscription(newSub.transferFrom, newSub.transferTo, _offerId, newSubId);
        --offer.execCounter;
        return (subscriptionCounter = newSubId);
    }


    ///@notice cancel an offer given by `offerId`.
    ///@dev sets offer.`expireOn` to `expireOn`.
    ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
    //
    function cancelSubscriptionOffer(uint offerId) public returns (bool) {
        Subscription storage offer = subscriptions[offerId];
        assert (_isOffer(offer));
        assert (offer.transferTo == msg.sender || owner == msg.sender); //only service provider or platform owner is allowed to cancel the offer
        if (offer.expireOn>now){
            offer.expireOn = now;
            OfferCanceled(offerId, msg.sender);
            return true;
        } else if (isContract(msg.sender)) { return false; }
          else { throw; }
    }


    ///@notice cancel an subscription given by `subId` (a graceful version).
    ///@notice IMPORTANT: a malicious service provider can consume all gas and preventing subscription from cancellation.
    ///        If so, use `cancelSubscription(uint subId, uint gasReserve)` as the forced version.
    ///         see `cancelSubscription(uint subId, uint gasReserve)` for more documentation.
    //
    function cancelSubscription(uint subId) public {
        return cancelSubscription(subId, 0);
    }


    ///@notice cancel an subscription given by `subId` (a forced version).
    ///        Cancellation means no further charges to this subscription are possible. The provided subscription deposit can be withdrawn only `paidUntil` period is over.
    ///        Depending on nature of the service provided, the service provider can allow an immediate deposit withdrawal by `returnSubscriptionDesposit(uint subId)` call, but its on his own.
    ///        In some business cases a deposit must remain locked until `paidUntil` period is over even, the subscription is already canceled.
    ///@notice gasReserve is a gas amount reserved for contract execution AFTER service provider becomes `onSubCanceled(uint256,address)` notification.
    ///        It guarantees, that cancellation becomes executed even a (malicious) service provider consumes all gas provided.
    ///        If so, use `cancelSubscription(uint subId, uint gasReserve)` as the forced version.
    ///        This difference is because the customer must always have a possibility to cancel his contract even the service provider disagree on cancellation.
    ///@param subId - subscription to be cancelled
    ///@param gasReserve - gas reserved for call finalization (minimum reservation is 10000 gas)
    //
    function cancelSubscription(uint subId, uint gasReserve) public {
        Subscription storage sub = subscriptions[subId];
        assert (sub.transferFrom == msg.sender || owner == msg.sender); //only subscription owner or platform owner is allowed to cancel it
        assert (_isNotOffer(sub));
        var _to = sub.transferTo;
        sub.expireOn = max(now, sub.paidUntil);
        if (msg.sender != _to) {
            //supress re-throwing of exceptions; reserve enough gas to finish this function
            gasReserve = max(gasReserve,10000);  //reserve minimum 10000 gas
            assert (msg.gas > gasReserve);       //sanity check
            if (_to.call.gas(msg.gas-gasReserve)(bytes4(sha3("onSubCanceled(uint256,address)")), subId, msg.sender)){
                //do nothing. it is notification only.
                //Later: is it possible to evaluate return value here? If is better to return the subscription deposit here.
            }
        }
        SubCanceled(subId, msg.sender);
    }


    ///@notice place an active offer on hold; it means no subscriptions can be created from this offer.
    ///        Only service provider (or platform owner) is allowed to hold/unhold a subscription offer.
    ///@param offerId - id of the offer to be placed on hold.
    ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
    //
    function holdSubscriptionOffer(uint offerId) public returns (bool success) {
        Subscription storage offer = subscriptions[offerId];
        assert (_isOffer(offer));
        require (msg.sender == offer.transferTo || msg.sender == owner); //only owner or service provider can place the offer on hold.
        if (offer.onHoldSince == 0) {
            offer.onHoldSince = now;
            OfferOnHold(offerId, true, msg.sender);
            return true;
        } else if (isContract(msg.sender)) { return false; }
          else { throw; }
    }

    ///@notice resume on-hold offer; subscriptions can be created from this offer again (if other conditions are met).
    ///        Only service provider (or platform owner) is allowed to hold/unhold a subscription offer.
    ///@param offerId - id of the offer to be resumed.
    ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
    //
    function unholdSubscriptionOffer(uint offerId) public returns (bool success) {
        Subscription storage offer = subscriptions[offerId];
        assert (_isOffer(offer));
        require (msg.sender == offer.transferTo || msg.sender == owner); //only owner or service provider can reactivate the offer.
        if (offer.onHoldSince > 0) {
            offer.onHoldSince = 0;
            OfferOnHold(offerId, false, msg.sender);
            return true;
        } else if (isContract(msg.sender)) { return false; }
          else { throw; }
    }

    ///@notice called by customer or service provider to place a subscription on hold.
    ///        If call is originated by customer the service provider can reject the request.
    ///        A subscription on hold will not be charged. The service is usually not provided as well.
    ///        During hold time a subscription preserve remaining paid time period, which becomes available after unhold.
    ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
    //
    function holdSubscription (uint subId) public returns (bool success) {
        Subscription storage sub = subscriptions[subId];
        assert (_isNotOffer(sub));
        var _to = sub.transferTo;
        require (msg.sender == _to || msg.sender == sub.transferFrom); //only customer or provider can place the subscription on hold.
        if (sub.onHoldSince == 0) {
            if (msg.sender == _to || PaymentListener(_to).onSubUnHold(subId, msg.sender, true)) {
                sub.onHoldSince = now;
                SubOnHold(subId, true, msg.sender);
                return true;
            }
        } else if (isContract(msg.sender)) { return false; }
          else { throw; }
    }

    ///@notice called by customer or service provider to unhold subscription.
    ///        If call is originated by customer the service provider can reject the request.
    ///        A subscription on hold will not be charged. The service is usually not provided as well.
    ///        During hold time a subscription preserve remaining paid time period, which becomes available after unhold.
    ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
    //
    function unholdSubscription(uint subId) public returns (bool success) {
        Subscription storage sub = subscriptions[subId];
        assert (_isNotOffer(sub));
        var _to = sub.transferTo;
        require (msg.sender == _to || msg.sender == sub.transferFrom); //only customer or provider can place the subscription on hold.
        if (sub.onHoldSince > 0) {
            if (msg.sender == _to || PaymentListener(_to).onSubUnHold(subId, msg.sender, false)) {
                sub.paidUntil += now - sub.onHoldSince;
                sub.onHoldSince = 0;
                SubOnHold(subId, false, msg.sender);
                return true;
            }
        } else if (isContract(msg.sender)) { return false; }
          else { throw; }
    }



    // *************************************************
    // *              deposit handling                 *
    // *************************************************

    ///@notice can be called by provider on CANCELED subscription to return a subscription deposit to customer immediately.
    ///        Customer can anyway collect his deposit after `paidUntil` period is over.
    ///@param subId - subscription holding the deposit
    //
    function returnSubscriptionDesposit(uint subId) external {
        Subscription storage sub = subscriptions[subId];
        assert (_isNotOffer(sub));
        assert (_currentStatus(sub) == Status.CANCELED);
        assert (sub.depositAmount > 0); //sanity check
        assert (sub.transferTo == msg.sender || owner == msg.sender); //only subscription owner or platform owner is allowed to release deposit.
        sub.expireOn = now;
        _returnSubscriptionDesposit(subId, sub);
    }


    ///@notice called by customer on EXPIRED subscription (`paidUntil` period is over) to collect a subscription deposit.
    ///        Customer can anyway collect his deposit after `paidUntil` period is over.
    ///@param subId - subscription holding the deposit
    //
    function claimSubscriptionDeposit(uint subId) public {
        Subscription storage sub = subscriptions[subId];
        assert (_isNotOffer(sub));
        assert (_currentStatus(sub) == Status.EXPIRED);
        assert (sub.transferFrom == msg.sender);
        assert (sub.depositAmount > 0);
        _returnSubscriptionDesposit(subId, sub);
    }


    //@dev returns subscription deposit to customer
    function _returnSubscriptionDesposit(uint subId, Subscription storage sub) internal {
        uint depositAmount = sub.depositAmount;
        sub.depositAmount = 0;
        san._mintFromDeposit(sub.transferFrom, depositAmount);
        SubscriptionDepositReturned(subId, depositAmount, sub.transferFrom, msg.sender);
    }


    ///@notice create simple unlocked deposit, required by some services. It can be considered as prove of customer's stake.
    ///        This desposit can be claimed back by the customer at anytime.
    ///        The service provider is responsible to check the deposit before providing the service.
    ///@param _value - non zero deposit amount.
    ///@param _descriptor - is a uniq key, usually given by service provider to the customer in order to make this deposit unique.
    ///        Service Provider should reject deposit with unknown descriptor, because most probably it is in use for some another service.
    ///@return depositId - a handle to claim back the deposit later.
    //
    function createDeposit(uint _value, bytes _descriptor) public returns (uint depositId) {
        require (_value > 0);
        assert (san._burnForDeposit(msg.sender,_value));
        deposits[++depositCounter] = Deposit ({
            owner : msg.sender,
            value : _value,
            descriptor : _descriptor
        });
        NewDeposit(depositCounter, _value, msg.sender);
        return depositCounter;
    }


    ///@notice return previously created deposit to the user. User can collect only own deposit.
    ///        The service provider is responsible to check the deposit before providing the service.
    ///@param _depositId - an id of the deposit to be collected.
    //
    function claimDeposit(uint _depositId) public {
        var deposit = deposits[_depositId];
        require (deposit.owner == msg.sender);
        var value = deposits[_depositId].value;
        delete deposits[_depositId];
        san._mintFromDeposit(msg.sender, value);
        DepositReturned(_depositId, msg.sender);
    }



    // *************************************************
    // *            some internal functions            *
    // *************************************************

    function _amountToCharge(Subscription storage sub) internal returns (uint) {
        return _applyXchangeRate(sub.pricePerHour * sub.chargePeriod, sub) / 1 hours;
    }

    function _applyXchangeRate(uint amount, Subscription storage sub) internal returns (uint) {
        if (sub.xrateProviderId > 0) {
            // xrate_n: nominator
            // xrate_d: denominator of the exchange rate fraction.
            var (xrate_n, xrate_d) = XRateProvider(xrateProviders[sub.xrateProviderId]).getRate();
            amount = amount * sub.initialXrate_n * xrate_d / sub.initialXrate_d / xrate_n;
        }
        return amount;
    }

    function _isOffer(Subscription storage sub) internal constant returns (bool){
        return sub.transferFrom == 0 && sub.transferTo != 0;
    }

    function _isNotOffer(Subscription storage sub) internal constant returns (bool){
        return sub.transferFrom != 0 && sub.transferTo != 0;
    }

    function _exists(Subscription storage sub) internal constant returns (bool){
        return sub.transferTo != 0;   //existing subscription or offer has always transferTo set.
    }

    modifier onlyRegisteredProvider(){
        if (!providerRegistry[msg.sender]) throw;
        _;
    }

} //SubscriptionModuleImpl
