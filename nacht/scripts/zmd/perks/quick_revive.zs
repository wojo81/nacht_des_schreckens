class zmd_QuickReviveMachine : zmd_PerkMachine {
    bool isSolo;
    int buyCount;

    Default {
        zmd_PerkMachine.cost 1500;
        zmd_PerkMachine.drink 'zmd_QuickReviveDrink';
    }

    override void postBeginPlay() {
        super.postBeginPlay();

        let playerCount = 0;
        for (;playerCount != players.size() && players[playerCount].mo != null; ++playerCount);

        if (playerCount == 1) {
            self.cost = 500;
            self.drink = 'zmd_ReviveDrink';
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

class zmd_QuickReviveDrink : zmd_Drink {
    Default {
        zmd_Drink.perk 'zmd_QuickRevive';
    }

    States {
    Sprites0:
        dq0r a 0;
        goto super::Sprites0;
    Sprites1:
        dq1r a 0;
        goto super::Sprites1;
    Sprites2:
        dq2r a 0;
        goto super::Sprites2;
    }
}

class zmd_ReviveDrink : zmd_QuickReviveDrink {
    Default {
        zmd_Drink.perk 'zmd_Revive';
    }
}

class zmd_QuickRevive : zmd_Perk {
    Default {
        Inventory.Icon 'qric';
    }
}

class zmd_Revive : zmd_QuickRevive {}