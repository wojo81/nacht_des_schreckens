class zmd_Door : zmd_Interactable {
    meta int cost;

    property cost: cost;

    Default {
        radius 20;
        height 150;
        zmd_Door.cost 1000;

        +solid;
        +wallSprite;
    }

    override void doTouch(PlayerPawn player) {
        zmd_HintHud(player.findInventory('zmd_HintHud')).setMessage(self.costOf(cost));
    }

    override bool doUse(PlayerPawn player) {
        if (zmd_Points.takeFrom(player, self.cost)) {
            player.a_startSound("game/purchase");
            foreach (tid : self.args)
                zmd_Spawning.addSpawners(tid);
            self.destroy();
            return true;
        }
        return false;
    }

    States {
    Spawn:
        door a 1;
        loop;
    }
}

class zmd_Boxes : zmd_Door {
    States {
    Spawn:
        boxs a 1;
        loop;
    }
}