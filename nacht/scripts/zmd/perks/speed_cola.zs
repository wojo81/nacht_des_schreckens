class zmd_SpeedColaMachine : zmd_PerkMachine {
    Default {
        zmd_PerkMachine.cost 3000;
        zmd_PerkMachine.drink 'zmd_SpeedColaDrink';
    }

    States {
    Spawn:
        qkrv a 1;
        loop;
    }
}

class zmd_SpeedColaDrink : zmd_Drink {
    Default {
        zmd_Drink.perk 'zmd_SpeedCola';
    }
}

class zmd_SpeedCola : zmd_Perk {
    Default {
        Inventory.icon 'scic';
    }

    override void attachToOwner(Actor other) {
        super.attachToOwner(other);
        zmd_Player(owner).fastReload = true;
    }
}