package test;

import unit.TestCase;

@:enum
abstract ListenerType(UInt) from UInt to UInt {

	var ANY = 0;

    var FIRST = 1;

    var SECOND = 2;

    var THIRD = 3;
}

typedef CommandObject = {

    var name:String;

    var value:String;

    var defaultValue:String;

    var type:ListenerType;
}

typedef PropertyObject = {

    var name:String;

    var value:String;
}

class CommandsTest extends TestCase {
    
    override public function setup():Void {

    }

    override public function tearDown():Void {

    }

    public function test_getValueFromCommand():Void {

        // ** Setup

        var _testObject:CommandObject = {

            name: "-option",

            value: "optionValue",

            defaultValue: null,

            type: ListenerType.FIRST
        }

        function listener(command:Command, type:ListenerType) {

            assertEquals(_testObject.value, command.value);

            assertEquals(_testObject.type, type);
        }

        // ** Test

        var _args:Array<String> = [_testObject.name, _testObject.value];

        var _configuration = new Configuration();

        var _command:Command = new Command(ListenerType.FIRST, null);

        _configuration.addOption("-option", _command);
        
        _configuration.addEventListener(listener, 1, 0);

        _configuration.parse(_args);

        _configuration.runCommands();

        done();

        // **
    }
}