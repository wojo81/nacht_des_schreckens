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

    States {
    Sprites0:
        ds0c a 0;
        goto super::Sprites0;
    Sprites1:
        ds1c a 0;
        goto super::Sprites1;
    Sprites2:
        ds2c a 0;
        goto super::Sprites2;
    }
}

class zmd_SpeedCola : zmd_Perk {
    Default {
        Inventory.icon 'scic';
    }

    override void attachToOwner(Actor other) {
        super.attachToOwner(other);
        let player = zmd_Player(owner);
        player.fastReload = true;
        foreach (weapon : player.heldWeapons)
            zmd_Weapon(weapon).activateFastReload();
    }

    override void detachFromOwner() {
        let player = zmd_Player(owner);
        player.fastReload = false;
        foreach (weapon : player.heldWeapons)
            zmd_Weapon(weapon).deactivateFastReload();
        super.detachFromOwner();
    }
}