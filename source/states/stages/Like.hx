package states.stages;
class Like extends BaseStage {override function opponentNoteHit(note:objects.Note) if (game.health > 0.25   ) game.set_health(game.health - 0.005);}