class zmd_JuggernogMachine : zmd_PerkMachine {
    Default {
        zmd_PerkMachine.cost 2500;
        zmd_PerkMachine.drink 'zmd_JuggernogDrink';
    }

    States {
    Spawn:
        qkrv a 1;
        loop;
    }
}

class zmd_JuggernogDrink : zmd_Drink {
    Default {
        zmd_Drink.perk 'zmd_Juggernog';
    }

    States {
    Sprites0:
        dj0n a 0;
        goto super::Sprites0;
    Sprites1:
        dj1n a 0;
        goto super::Sprites1;
    Sprites2:
        dj2n a 0;
        goto super::Sprites2;
    }
}

class zmd_Juggernog : zmd_Perk {
    Default {
        Inventory.icon 'jnic';
    }

    override void attachToOwner(Actor other) {
        super.attachToOwner(other);
        zmd_Player(self.owner).healthMin = zmd_Player.juggHealthMin;
    }

    override void detachFromOwner() {
        zmd_Player(self.owner).healthMin = zmd_Player.regularHealthMin;
        super.detachFromOwner();
    }
}