package states.stages;

class BuryBG extends BaseStage {
    var buryBG:BGSprite;
    override function create() {
        add(buryBG = new BGSprite("bgs/buryBG", -614, -414, 0, 0));
        buryBG.scale.set(1.2, 1.2);
    }
}