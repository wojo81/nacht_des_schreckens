class zmd_Door : zmd_Interactable {
    meta int cost;

    property cost: cost;

    Default {
        radius 30;
        height 150;
        zmd_Door.cost 1000;

        +solid;
        +wallSprite;
    }

    override void doTouch(zmd_Player player) {
        player.hintHud.setMessage(self.costOf(cost));
    }

    override bool doUse(zmd_Player player) {
        if (player.purchase(cost)) {
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