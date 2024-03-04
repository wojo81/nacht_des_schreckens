class zmd_Door : zmd_Interactable {
    int cost;

    property cost: cost;

    Default {
        radius 30;
        height 80;
        zmd_Door.cost 1000;

        +solid;
        +wallSprite;
    }

    override void doTouch(zmd_Player player) {
        player.hintHud.setMessage(zmd_Interactable.costOf(cost));
    }

    override bool doUse(zmd_Player player) {
        if (player.maybePurchase(cost)) {
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