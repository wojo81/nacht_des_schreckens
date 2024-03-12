class zmd_QuickReviveMachine : zmd_PerkMachine {
    bool selfRevive;
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
            self.selfRevive = true;
        }
    }

    override bool doUse(zmd_Player player) {
        if (super.doUse(player) && self.selfRevive) {
            if (++self.buyCount == 3)
                self.setStateLabel('Disappear');
            return true;
        }
        return false;
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