class zmd_Interactable : Actor abstract {
    Default {
        +special
    }

    override void touch(Actor toucher) {
        let player = zmd_Player(toucher);
        if (player)
            doTouch(player);
    }

    override bool used(Actor user) {
        if (self.bspecial) {
            let player = zmd_Player(user);
            if (player) {
                let wasUsed = doUse(player);
                if (wasUsed)
                    player.hintHud.clearMessage();
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