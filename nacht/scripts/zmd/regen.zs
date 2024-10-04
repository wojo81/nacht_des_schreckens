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

    property delay: ticksTillHealing;

    Default {
        Inventory.maxAmount 1;
        zmd_Regen.delay 35 * 3;

        +Inventory.undroppable
        +Inventory.untossable
        +Inventory.persistentPower
    }

    override void attachToOwner(Actor owner) {
        super.attachToOwner(owner);
        self.maxHealth = owner.Default.health;
    }

    override void modifyDamage(int damage, Name damageType, out int newDamage, bool passive, Actor inflictor, Actor source, int flags) {
        if (passive) {
            self.ticksTillHealing = self.Default.ticksTillHealing;
            self.shouldHeal = false;
        }
    }

    override void doEffect() {
        if (self.shouldHeal) {
            if (self.owner.health >= self.maxHealth) {
                self.shouldHeal = false;
            } else {
                self.owner.giveInventory('zmd_vitality', 1);
            }
        }
        if (self.ticksTillHealing > 0 && --self.ticksTillHealing == 0) {
            self.shouldHeal = true;
        }
    }
}