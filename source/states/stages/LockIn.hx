package states.stages;

class LockIn extends BaseStage {
    override function create() {
        var bg = new BGSprite("bgs/lockin", -585, -350, 0, 0);
        bg.scale.set(1.2, 1.2);
        add(bg);
    }
}