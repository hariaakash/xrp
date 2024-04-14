// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Token1 is IERC20 {
    string public name = "Token1";
    string public symbol = "TKN1";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1000000 ether;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value) external returns (bool) {
        require(_to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) external returns (bool) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
        require(_to != address(0), "Invalid address");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        
        emit Transfer(_from, _to, _value);
        return true;
    }
}

contract Token2 is IERC20 {
    string public name = "Token2";
    string public symbol = "TKN2";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1000000 ether;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value) external returns (bool) {
        require(_to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) external returns (bool) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
        require(_to != address(0), "Invalid address");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        
        emit Transfer(_from, _to, _value);
        return true;
    }
}

contract HedgingContract {
    using SafeERC20 for IERC20;

    struct ForwardContract {
        uint256 amount;
        uint256 exchangeRate; // 1 Token1 = exchangeRate Token2
        uint256 expiration; // Expiration timestamp
        address creator;
    }

    mapping(address => ForwardContract) public forwardContracts;

    function createForwardContract(address _token1, uint256 _amount, uint256 _exchangeRate, uint256 _expiration) external {
        require(_amount > 0, "Invalid amount");
        require(_exchangeRate > 0, "Invalid exchange rate");
        require(_expiration > block.timestamp, "Invalid expiration");

        IERC20(_token1).transferFrom(msg.sender, address(this), _amount);
    
        forwardContracts[msg.sender] = ForwardContract({
            amount: _amount,
            exchangeRate: _exchangeRate,
            expiration: _expiration,
            creator: msg.sender
        });
    }

    function executeForwardContract(address _token2) external {
        ForwardContract storage contractData = forwardContracts[msg.sender];
        require(contractData.expiration > block.timestamp, "Contract expired");

        uint256 token2Amount = (contractData.amount * contractData.exchangeRate) / (10**18);
        IERC20(_token2).transfer(msg.sender, token2Amount);

        delete forwardContracts[msg.sender];
    }
}
