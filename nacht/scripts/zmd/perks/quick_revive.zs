class zmd_QuickReviveMachine : zmd_PerkMachine {
    bool isSolo;
    int buyCount;

    Default {
        zmd_PerkMachine.cost 1500;
        zmd_PerkMachine.drink 'zmd_QuickReviveDrink';
    }

    override void postBeginPlay() {
        super.postBeginPlay();

        if (!multiplayer) {
            self.cost = 500;
            self.drink = 'zmd_ReviveDrink';
            self.isSolo = true;
        }
    }

    override bool doUse(PlayerPawn player) {
        let used = super.doUse(player);
        if (used && self.isSolo)
            if (++self.buyCount == 3)
                self.setStateLabel('Vanish');
        return used;
    }

    States {
    Spawn:
        qkrv a 1;
        loop;
    Vanish:
        stop;
    }
}

class zmd_QuickReviveDrink : zmd_Drink {
    Default {
        zmd_Drink.perk 'zmd_QuickRevive';
        zmd_Drink.bottle 'zmd_QuickReviveBottle';
    }

    States {
    Sprites:
        dq0r a 0;
        dq1r a 0;
        dq2r a 0;
    Spawn:
        qra0 a -1;
        loop;
    }
}

class zmd_QuickReviveBottle : zmd_Bottle {
    Default {
        zmd_Bottle.sprite 'qra0';
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