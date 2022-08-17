package;

import Command;
import EventDispacher;

class Configuration extends EventDispacher<Command> {

    // ** Publics.

    public var options:Map<String, Command> = new Map<String, Command>();

    public function new() {
        
        super();
    }

    public function parse(args:Array<String>):Void {

        // ** 

        var _lastCommand:Command = null;

        while (args.length > 0) {
            
            var arg:String = args.shift();

            if (isCommand(arg)) {
                
                var _option:Command = options.get(arg);

                if (_option == null) {

                    throw "Command `" + arg + "` " + "doesn't exist!";
                }
                else {

                    _option.value = args.shift();

                    _lastCommand = _option;
                }
            } 
            else {
                
                if (_lastCommand == null) {
                    
                    var _unknownProperty = arg;

                    continue;
                }

                if (_lastCommand.propertyExists(arg)) {

                    _lastCommand.addProperty(arg, args.shift());
                }
                else throw "Parameter `" + arg + "` " + "doesn't exist!";
            }
        }
    }

    public function parseOld(args:Array<String>):Void {
        
        // ** Local functions.

        function isCommand(arg:String):Bool {

            return arg.charAt(0) == "-";
        }

        var lastOption:Command = null;

        var index:Int = 0;

        while (index < args.length - 1) {

            var arg:String = args[index];

            trace(arg);

            if (isCommand(arg)) {

                var _option:Command = options.get(arg);

                if (_option == null) {

                    throw "Command `" + arg + "` " + "doesn't exist!";
                }
                else {
                    
                    index ++;

                    _option.value = args[index];

                    lastOption = _option;
                }
            }
            else {

                if (lastOption.propertyExists(arg)) {

                    index ++;

                    lastOption.addProperty(arg, args[index]);
                }
                else throw "Parameter `" + arg + "` " + "doesn't exist!";
            }

            index ++;
        }
    }

    public function addOption(name:String, command:Command):Void {

        options.set(name, command);
    }

    public function getOption(name:String):Command {
        
        return options.get(name);
    }

    public function hasValue(name:String):Bool {
        
        var _command:Command = options.get(name);

        if (_command == null) return false;

        if (_command.value == null) return false;
        else return true;
    }

    public function runCommands():Void {
        
        trace(this.__listeners);

        for (name => option in options) {

            trace(option.value);

            if (option.value == null) continue;

            dispatchEvent(option, option.type);
        }
    }

    private inline function isCommand(arg:String):Bool {

        return arg.charAt(0) == "-";
    }
}

class StepIterator {

    var end:Int;

    var step:Int;

    var index:Int;
  
    public inline function new(start:Int, end:Int, step:Int) {

      this.index = start;

      this.end = end;
      
      this.step = step;
    }
  
    public inline function hasNext() return index < end;
    
    public inline function next() return (index += step) - step;
  }