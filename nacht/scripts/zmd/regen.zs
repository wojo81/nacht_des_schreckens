class zmd_Regen : Inventory {
    int delay;
    int maxDelay;
    bool startHealing;
    int healPerTick;

    property delay: delay;
    property maxDelay: maxDelay;
    property startHealing: startHealing;
    property healPerTick: healPerTick;

    Default {
        Inventory.maxamount 1;
        +INVENTORY.UNDROPPABLE
        +INVENTORY.UNTOSSABLE
        +INVENTORY.PERSISTENTPOWER

        zmd_Regen.delay 0;
        zmd_Regen.maxDelay 35 * 2;
        zmd_Regen.startHealing false;
        zmd_Regen.healPerTick 2;
    }

    override void doEffect() {
        let player = zmd_Player(owner);
        if (player) {
            if (player.justTookDamage) {
                player.justTookDamage = false;
                self.delay = maxDelay;
                self.startHealing = false;
                return;
            }

            if (delay-- == 0) {
                self.startHealing = true;
            }

            if (self.startHealing) {
                owner.giveBody(healPerTick);
                if (player.health == player.maxHealth) {
                    self.startHealing = false;
                }
            }
        }
    }
}