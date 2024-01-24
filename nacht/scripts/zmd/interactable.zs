class zmd_Interactable : Actor abstract {
    bool active;

    property active: active;

    Default {
       zmd_Interactable.active true;
        +special
    }

    override void touch(Actor toucher) {
        if (active) {
            let player = zmd_Player(toucher);
            if (player) {
                doTouch(player);
            }
        }
    }

    override bool used(Actor user) {
        if (active) {
            let player = zmd_Player(user);
            if (player) {
                let wasUsed = doUse(player);
                if (wasUsed) {
                    player.clearMessage();
                }
            }
        }
        return false;
    }

    static String costOf(int cost) {
        return "[Cost: "..cost.."]";
    }

    abstract void doTouch(zmd_Player player);
    abstract bool doUse(zmd_Player player);
}