class zmd_DoubleTapMachine : zmd_PerkMachine {
    Default {
        zmd_PerkMachine.cost 2000;
        zmd_PerkMachine.drink 'zmd_DoubleTapDrink';
    }

    States {
    Spawn:
        qkrv a 1;
        loop;
    }
}

class zmd_DoubleTapDrink : zmd_Drink {
    Default {
        zmd_Drink.perk 'zmd_DoubleTap';
    }
}

class zmd_DoubleTap : zmd_Perk {
    Default {
        Inventory.icon 'dtic';
    }

    override void attachToOwner(Actor other) {
        super.attachToOwner(other);
        zmd_Player(owner).fastFire = true;
    }
}