class zmd_Worry : Inventory {
    const key = bt_user1;

    zmd_WorryHandler handler;
    int ticksLeft;

    property tickLeft: ticksLeft;

    Default {
        Inventory.maxAmount 1;
        zmd_Worry.tickLeft 35 * 5;
    }

    static void giveTo(PlayerPawn player, zmd_WorryHandler handler) {
        player.a_giveInventory('zmd_Worry');
        zmd_Worry(player.findInventory('zmd_Worry')).handler = handler;
    }

    override void doEffect() {
        if (self.justTapped())
            self.ticksLeft = self.Default.ticksLeft;
        else if (self.ticksLeft-- == 0)
            self.handler.deactivate();
    }

    bool justTapped() {
        return self.owner.getPlayerInput(modInput_oldButtons) & self.key && !(self.owner.getPlayerInput(modInput_buttons) & self.key);
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
            if (player.mo != null)
                zmd_Worry.giveTo(player.mo, self);
        }
    }

    void deactivate() {
        self.rounds.nextRound();
        foreach (player : players) {
            if (player.mo != null)
                player.mo.a_takeInventory('zmd_worry', 1);
        }
    }
}