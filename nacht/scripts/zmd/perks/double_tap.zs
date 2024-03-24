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

    States {
    Sprites0:
        dd0t a 0;
        goto super::Sprites0;
    Sprites1:
        dd1t a 0;
        goto super::Sprites1;
    Sprites2:
        dd2t a 0;
        goto super::Sprites2;
    }
}

class zmd_DoubleTap : zmd_Perk {
    Default {
        Inventory.icon 'dtic';
    }

    override void attachToOwner(Actor other) {
        super.attachToOwner(other);
        let player = zmd_Player(owner);
        player.doubleFire = true;
        foreach (weapon : player.heldWeapons)
            weapon.activateDoubleFire();
    }

    override void detachFromOwner() {
        let player = zmd_Player(owner);
        player.doubleFire = false;
        foreach (weapon : player.heldWeapons)
            weapon.deactivateDoubleFire();
        super.detachFromOwner();
    }
}