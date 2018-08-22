pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "./TokenStorage.sol";

library ERC20Lib {

    using SafeMath for uint;

    // EVENTS
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    // EXTERNAL
    function transfer(TokenStorage db, address caller, address to, uint value) 
        external
        returns (bool success) 
    {
        db.subBalance(caller, value);
        db.addBalance(to, value);
        emit Transfer(caller, to, value);
        return true;
    }

    function transferFrom(
        TokenStorage db, 
        address caller, 
        address from, 
        address to, 
        uint value
    ) 
        external
        returns (bool success) 
    {
        uint allowance = db.getAllowed(from, caller);
        db.subBalance(from, value);
        db.addBalance(to, value);
        db.setAllowed(from, caller, allowance.sub(value));
        emit Transfer(from, to, value);
        return true;
    }

    // TODO: race condition
    function approve(TokenStorage db, address caller, address spender, uint value) 
        public
        returns (bool success) 
    {
        db.setAllowed(caller, spender, value);
        emit Approval(caller, spender, value);
        return true;
    }

    // EXTERNAL CONSTANT
    function balanceOf(TokenStorage db, address _owner) 
        external
        view 
        returns (uint balance) 
    {
        return db.getBalance(_owner);
    }

    function allowance(TokenStorage db, address _owner, address spender) 
        external
        view 
        returns (uint remaining) 
    {
        return db.getAllowed(_owner, spender);
    }

}
