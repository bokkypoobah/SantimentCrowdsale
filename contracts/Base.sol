pragma solidity ^0.4.8;

contract BalanceStore {
    mapping (address => uint256) balances;
    function balanceOf(address _owner) constant returns (uint256 balance);
}

contract Base {

    modifier only(address allowed) {
        if (msg.sender != allowed) throw;
        _;
    }

    modifier only2(address allowed1, address allowed2) {
        if (msg.sender != allowed1 && msg.sender != allowed2) throw;
        _;
    }

    //prevents reentrancy attacs
    bool private locked = false;
    modifier noReentrancy() {
        if (locked) throw;
        locked = true;
        _;
        locked = false;
    }

    function max(uint a, uint b) returns (uint) { return a >= b ? a : b; }
    function min(uint a, uint b) returns (uint) { return a <= b ? a : b; }
    function min(uint a, uint b, uint c) returns (uint) { return a <= b ? min(a,c) : min(b,c); }

    function assert(bool expr) { if (!expr) throw; }

    event loga(address a);
}


contract SubscriptionBase {
    enum Status {OFFER, RUNNING, CHARGEABLE, ON_HOLD, CANCELED}

    struct Subscription {
        address transferFrom;
        address transferTo;
        uint pricePerHour;
        uint nextChargeOn;
        uint chargePeriod;
        uint deposit;  //ID in Subscription and VALUE in Offer

        uint startOn;
        uint validUntil;
        uint execCounter;
        bytes descriptor;
        uint onHoldSince;
    }

    struct Deposit {
        uint value;
        address owner;
        bytes descriptor;
    }

}

contract PaymentListener is SubscriptionBase {

    function onPayment(address _from, uint _value, bytes _paymentData) returns (bool);
    function onSubExecuted(uint subId) returns (bool);
    function onSubscriptionChange(uint subId, Status status, bytes _paymentData) returns (bool);

}
