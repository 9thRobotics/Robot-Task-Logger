// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RobotTaskLogger {
    struct Task {
        string taskName;
        bool completed;
        uint256 timestamp;
    }

    mapping(address => Task[]) public robotTasks;

    function logTask(address _robot, string memory _taskName) public {
        robotTasks[_robot].push(
            Task({taskName: _taskName, completed: true, timestamp: block.timestamp})
        );
    }

    function getTasks(address _robot) public view returns (Task[] memory) {
        return robotTasks[_robot];
    }
}