import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.display.SimpleButton;
import flash.external.ExternalInterface;
import flash.events.Event;
import flash.system.System;

class Clippy extends SimpleButton {
  // Main
  static function main() {
    flash.system.Security.allowDomain("*");

    flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
    flash.Lib.current.stage.align     = flash.display.StageAlign.TOP_LEFT;

    flash.Lib.current.addChild(new Clippy());
  }

  var callBack:String;
  var text:String;
  var id:String;

  public function new() {
    super();

    useHandCursor    = true;
    upState          = flash.Lib.attach("button_up");
    overState        = flash.Lib.attach("button_over");
    downState        = flash.Lib.attach("button_down");
    hitTestState     = flash.Lib.attach("button_down");

    addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    flash.Lib.current.stage.addEventListener(Event.RESIZE, onStageResize);
  }

  function onAddedToStage(e:Event) {
    onStageResize(null);

    callBack = flash.Lib.current.stage.loaderInfo.parameters.callBack;
    text     = flash.Lib.current.stage.loaderInfo.parameters.text;
    id       = flash.Lib.current.stage.loaderInfo.parameters.id;

    if(callBack == null)  callBack = "function(){}";

    // Add hooks to for javascript to call
    ExternalInterface.addCallback("enable", enable);
    ExternalInterface.addCallback("disable", disable);

    // Let javascript know we are ready for use
    enable();
    ExternalInterface.call(callBack, "loaded", id);
  }

  function onStageResize(e:Event) {
    width  = flash.Lib.current.stage.stageWidth;
    height = flash.Lib.current.stage.stageHeight;
  }

  public function enable() {
    enabled = true;
    addEventListener(MouseEvent.CLICK, onMouseEvent);
    addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
    addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
    addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
    addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
  }

  public function disable() {
    enabled = false;
    removeEventListener(MouseEvent.CLICK, onMouseEvent);
    removeEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
    removeEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
    removeEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
    removeEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
  }

  function onMouseEvent(e:MouseEvent) {
    switch(e.type) {
      case MouseEvent.CLICK:
        if (text != null) {
          System.setClipboard(text);
          ExternalInterface.call(callBack, text, id);
        } else {
          System.setClipboard(ExternalInterface.call(callBack, "click", id));
        }
      case MouseEvent.MOUSE_OVER:
        ExternalInterface.call(callBack, "mouseenter", id);
      case MouseEvent.MOUSE_OUT:
        ExternalInterface.call(callBack, "mouseleave", id);
      case MouseEvent.MOUSE_DOWN:
        ExternalInterface.call(callBack, "mousedown", id);
      case MouseEvent.MOUSE_UP:
        ExternalInterface.call(callBack, "mouseup", id);
    }
  }
}
