import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.display.SimpleButton;
import flash.external.ExternalInterface;
import flash.events.Event;
import flash.system.System;

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
    var call:String     = flash.Lib.current.loaderInfo.parameters.call;
    var callBack:String = flash.Lib.current.loaderInfo.parameters.callBack;

    if(callBack == null) callBack = "function(){}";

    flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
    flash.Lib.current.stage.align     = flash.display.StageAlign.TOP_LEFT;

    var button:SimpleButton = new SimpleButton();
    button.useHandCursor    = true;
    button.upState          = flash.Lib.attach("button_up");
    button.overState        = flash.Lib.attach("button_over");
    button.downState        = flash.Lib.attach("button_down");
    button.hitTestState     = flash.Lib.attach("button_down");

    button.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {
      flash.system.System.setClipboard(ExternalInterface.call(call));
      ExternalInterface.call(callBack, 'onClick', call);
    });

    button.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent) {
      ExternalInterface.call(callBack, 'onMouseEnter', call);
    });

    button.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent) {
      ExternalInterface.call(callBack, 'onMouseLeave', call);
    });

    flash.Lib.current.addChild(button);
  }
}
