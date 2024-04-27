class zmd_Vitality : MaxHealth {
    Default {
        Inventory.amount 1;
        Inventory.maxAmount 250;

        +countItem
        +Inventory.alwaysPickup
    }
}

class zmd_Regen : Inventory {
    int maxHealth;
    int ticksTillHealing;
    bool shouldHeal;
    zmd_Vitality vitality;

    property delay: ticksTillHealing;
    property startingHealth: maxHealth;

    Default {
        Inventory.maxAmount 1;
        +Inventory.undroppable
        +Inventory.untossable
        +Inventory.persistentPower

        zmd_Regen.delay 35 * 3;
        zmd_Regen.startingHealth 100;
    }

    override void modifyDamage(int damage, Name damageType, out int newDamage, bool passive, Actor inflictor, Actor source, int flags) {
        if (passive) {
            self.ticksTillHealing = self.Default.ticksTillHealing;
            self.shouldHeal = false;
        }
    }

    override void doEffect() {
        if (self.shouldHeal) {
            if (self.owner.health >= self.maxHealth)
                self.shouldHeal = false;
            else
                self.owner.a_giveInventory('zmd_Vitality');
        }
        if (self.ticksTillHealing > 0 && --self.ticksTillHealing == 0)
            self.shouldHeal = true;
    }
}