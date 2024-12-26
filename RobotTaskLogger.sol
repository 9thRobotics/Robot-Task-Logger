// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RobotTaskLogger {
    enum TaskStatus { Pending, InProgress, Completed }

    struct Task {
        string taskName;
        TaskStatus status;
        uint256 timestamp;
    }

    mapping(address => Task[]) public robotTasks;
    address public owner;

    event TaskLogged(address indexed robot, string taskName, TaskStatus status, uint256 timestamp);
    event TaskUpdated(address indexed robot, uint256 taskIndex, TaskStatus status);
    event TaskDeleted(address indexed robot, uint256 taskIndex);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function logTask(address _robot, string memory _taskName) public onlyOwner {
        robotTasks[_robot].push(
            Task({taskName: _taskName, status: TaskStatus.Pending, timestamp: block.timestamp})
        );
        emit TaskLogged(_robot, _taskName, TaskStatus.Pending, block.timestamp);
    }

    function updateTaskStatus(address _robot, uint256 _taskIndex, TaskStatus _status) public onlyOwner {
        require(_taskIndex < robotTasks[_robot].length, "Invalid task index");
        robotTasks[_robot][_taskIndex].status = _status;
        emit TaskUpdated(_robot, _taskIndex, _status);
    }

    function deleteTask(address _robot, uint256 _taskIndex) public onlyOwner {
        require(_taskIndex < robotTasks[_robot].length, "Invalid task index");
        uint256 lastIndex = robotTasks[_robot].length - 1;
        if (_taskIndex != lastIndex) {
            robotTasks[_robot][_taskIndex] = robotTasks[_robot][lastIndex];
        }
        robotTasks[_robot].pop();
        emit TaskDeleted(_robot, _taskIndex);
    }

    function getTasks(address _robot) public view returns (Task[] memory) {
        return robotTasks[_robot];
    }
}
