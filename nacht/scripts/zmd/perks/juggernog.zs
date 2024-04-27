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
    zmd_Regen regen;

    Default {
        Inventory.icon 'jnic';
    }

    override void attachToOwner(Actor other) {
        super.attachToOwner(other);
        self.regen = zmd_Regen(other.findInventory('zmd_Regen'));
        self.regen.shouldHeal = true;
        self.regen.maxHealth = getDefaultByType('zmd_Vitality').maxAmount;
    }

    override void detachFromOwner() {
        self.regen.maxHealth = self.regen.Default.maxHealth;
        super.detachFromOwner();
    }
}