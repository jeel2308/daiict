pragma solidity >=0.4.21 <0.7.0;

import "./TokenInterface.sol";

contract Token is TokenInterface {
    uint256 private constant MAX_UINT256 = 2**256 - 1;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowed;

    string public name;
    uint8 public decimals;
    string public symbol;

    constructor(
        uint256 _initialAmount,
        string memory _tokenName,
        uint8 _decimalUnits,
        string memory _tokenSymbol
    ) public {
        balances[msg.sender] = _initialAmount;
        totalSupply = _initialAmount;
        name = _tokenName;
        decimals = _decimalUnits;
        symbol = _tokenSymbol;
    }

    function transfer(address _to, uint256 _value)
        public
        override
        returns (bool success)
    {
        require(balances[msg.sender] >= _value, "Insufficient Balance");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function cashOut(address _from, uint256 _value)
        public
        returns (bool success)
    {
        require(balances[_from] >= _value, "Insufficient Balance");
        balances[_from] -= _value;
        balances[msg.sender] += _value;
        emit Transfer(_from, msg.sender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value)
        public
        override
        returns (bool success)
    {
        uint256 allowance = allowed[_from][msg.sender];
        require(
            balances[_from] >= _value && allowance >= _value,
            "Insufficient Balance"
        );
        balances[_to] += _value;
        balances[_from] -= _value;
        if (allowance < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }
        emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function balanceOf(address _owner)
        public
        view
        override
        returns (uint256 balance)
    {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value)
        public
        override
        returns (bool success)
    {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function allowance(address _owner, address _spender)
        public
        view
        override
        returns (uint256 remaining)
    {
        return allowed[_owner][_spender];
    }
}