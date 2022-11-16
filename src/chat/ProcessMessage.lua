local util = require(script.Parent:WaitForChild('Util'))

function ProcessMessage(message, ChatWindow, ChatSettings)
    print(message)
end

return {
    [util.KEY_COMMAND_PROCESSOR_TYPE] = util.COMPLETED_MESSAGE_PROCESSOR,
    [util.KEY_PROCESSOR_FUNCTION] = ProcessMessage
}
