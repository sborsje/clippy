import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.display.SimpleButton;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.external.ExternalInterface;

class Clippy {
  // Main
  static function main() {
    flash.system.Security.allowDomain("*");

    var callBack:String = flash.Lib.current.loaderInfo.parameters.callBack;
    var text:String     = flash.Lib.current.loaderInfo.parameters.text;
    var id:String       = flash.Lib.current.loaderInfo.parameters.id;

    if(callBack == null)  callBack = "function(){}";

    flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
    flash.Lib.current.stage.align     = flash.display.StageAlign.TOP_LEFT;

    // button
    var button:SimpleButton = new SimpleButton();
    button.useHandCursor    = true;
    button.upState          = flash.Lib.attach("button_up");
    button.overState        = flash.Lib.attach("button_over");
    button.downState        = flash.Lib.attach("button_down");
    button.hitTestState     = flash.Lib.attach("button_down");

    button.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {
      if (text != null) {
        flash.system.System.setClipboard(text);
        ExternalInterface.call(callBack, text, id);
      } else {
        flash.system.System.setClipboard(ExternalInterface.call(callBack, "mouseClick", id));
      }
    });

    button.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent) {
      ExternalInterface.call(callBack, "mouseOver", id);
    });

    button.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent) {
      ExternalInterface.call(callBack, "mouseOut", id);
    });

    button.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent) {
      ExternalInterface.call(callBack, "mouseDown", id);
    });

    button.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent) {
       ExternalInterface.call(callBack, "mouseUp", id);
    });

    flash.Lib.current.addChild(button);
  }
}
