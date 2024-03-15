class zmd_QuickReviveMachine : zmd_PerkMachine {
    bool isSolo;
    int buyCount;

    Default {
        zmd_PerkMachine.cost 1500;
        zmd_PerkMachine.perk 'zmd_QuickRevive';
    }

    override void postBeginPlay() {
        super.postBeginPlay();

        let playerCount = 0;
        for (;playerCount != players.size() && players[playerCount].mo != null; ++playerCount);

        if (playerCount == 1) {
            self.cost = 500;
            self.perk = 'zmd_Revive';
            self.isSolo = true;
        }
    }

    override bool doUse(zmd_Player player) {
        let used = super.doUse(player);
        if (used && self.isSolo)
            if (++self.buyCount == 3)
                self.setStateLabel('Disappear');
        return used;
    }

    States {
    Spawn:
        qkrv a 1;
        loop;
    Disappear:
        stop;
    }
}

class zmd_QuickRevive : zmd_Perk {
    Default {
        Inventory.Icon 'qric';
    }
}

class zmd_Revive : zmd_Perk {
    Default {
        Inventory.icon 'qric';
    }
}