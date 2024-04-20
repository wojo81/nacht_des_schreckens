class zmd_Worry : Inventory {
    const key = bt_user1;

    zmd_WorryHandler handler;
    int ticksLeft;

    property tickLeft: ticksLeft;

    Default {
        Inventory.maxAmount 1;
        zmd_Worry.tickLeft 35 * 5;
    }

    static void giveTo(zmd_Player player, zmd_WorryHandler handler) {
        player.a_giveInventory('zmd_Worry');
        zmd_Worry(player.findInventory('zmd_Worry')).handler = handler;
    }

    override void doEffect() {
        if (owner.getPlayerInput(modInput_Buttons) & self.key)
            self.ticksLeft = self.Default.ticksLeft;
        if (self.ticksLeft-- == 0)
            self.handler.deactivate();
    }
}

class zmd_WorryHandler : EventHandler {
    zmd_Rounds rounds;

    static void bind_with(zmd_Rounds rounds) {
        let self = zmd_WorryHandler(EventHandler.find('zmd_WorryHandler'));
        rounds.worryHandler = self;
        self.rounds = rounds;
        return;
    }

    void activate() {
        foreach (player : players) {
            let player = zmd_Player(player.mo);
            if (player != null)
                zmd_Worry.giveTo(player, self);
        }
    }

    void deactivate() {
        self.rounds.nextRound();
        foreach (player : players) {
            let player = zmd_Player(player.mo);
            if (player != null)
                player.a_takeInventory('zmd_worry', 1);
        }
    }
}