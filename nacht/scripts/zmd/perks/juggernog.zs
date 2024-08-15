class zmd_JuggernogMachine : zmd_PerkMachine {
    Default {
        zmd_PerkMachine.cost 2500;
        zmd_PerkMachine.drink 'zmd_JuggernogDrink';
    }

    States {
    Spawn:
        jgng a 1;
        loop;
    }
}

class zmd_JuggernogDrink : zmd_Drink {
    Default {
        zmd_Drink.perk 'zmd_Juggernog';
        tag 'Juggernog';
    }

    States {
    Sprites:
        dj0n a 0;
        dj1n a 0;
        dj2n a 0;
    Spawn:
        jga0 a -1;
        loop;
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
        self.regen.maxHealth = self.owner.Default.health;
        self.owner.setInventory('zmd_Vitality', self.owner.Default.health);
        if (self.owner.health > self.owner.Default.health) {
            self.owner.a_damageSelf(self.owner.health - self.owner.Default.health);
        }
        super.detachFromOwner();
    }
}