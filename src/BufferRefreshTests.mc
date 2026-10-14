import Toybox.Graphics;
import Toybox.Test;

(:test)
class BufferRefreshTestView extends WatchFaceView {
    var renders = 0;
    var syncs = 0;

    function initialize() { WatchFaceView.initialize(); }
    function syncData() as Void { self.syncs += 1; }
    function ultraUpdate(dc as Graphics.Dc) as Void { self.renders += 1; }
    function engineTick(deltaTime) as Void {}
}

(:test)
function bufferRefreshesOncePerSecond(logger) {
    var view = new BufferRefreshTestView();
    var bitmap = Gfx.createBufferedBitmap({ :width => 1, :height => 1 });
    view.onLayout(bitmap.getDc());
    view.updateBuffer(1000);
    view.updateBuffer(1000);
    view.updateBuffer(1000);
    Test.assert(view.renders == 1 && view.syncs == 1);
    view.updateBuffer(1001);
    Test.assert(view.renders == 2 && view.syncs == 2);
    // A minute-sized gap and a backwards clock change must also refresh.
    view.updateBuffer(1061);
    view.updateBuffer(999);
    Test.assert(view.renders == 4 && view.syncs == 4);
    // A newly allocated bitmap must render even in the same second.
    view.onLayout(bitmap.getDc());
    view.updateBuffer(999);
    Test.assert(view.renders == 5 && view.syncs == 5);
    return true;
}
