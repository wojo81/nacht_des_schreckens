class zmd_Pickup : zmd_Interactable {
    class<Weapon> pickupClass;

    override void postbeginPlay() {
        if (getDefaultByType(self.pickupClass) is 'zmd_Weapon')
            self.scale = (0.5, 0.5);
    }

    static zmd_Pickup takeFrom(Actor giver, Weapon given) {
        let self = zmd_Pickup(Actor.spawn('zmd_Pickup', giver.pos, allow_replace));
        let ammoType = given.ammoType1;
        let ammoCount = given.countInv(ammoType);

        self.pickupClass = given.getClassName();
        self.a_giveInventory(self.pickupClass);
        self.sprite = given.Default.spawnState.sprite;
        self.setInventory(ammoType, ammoCount);

        let taken = zmd_Weapon(self.findInventory(given.getClassName()));
        if (taken != null)
            taken.activeAmmo = zmd_Weapon(given).activeAmmo;
        giver.setInventory(ammoType, 0);
        giver.takeInventory(self.pickupClass, 1);
        return self;
    }

    override void doTouch(PlayerPawn player) {
        if (zmd_InventoryManager.couldPickup(player, self.pickupClass))
            zmd_HintHud(player.findInventory('zmd_HintHud')).setMessage('[Pickup]');
    }

    override bool doUse(PlayerPawn player) {
        if (zmd_InventoryManager.couldPickup(player, self.pickupClass)) {
            self.giveTo(player);
            return true;
        }
        return false;
    }

    void giveTo(Actor taker) {
        let ammoType = getDefaultByType(self.pickupClass).ammoType1;
        let oldAmmoCount = taker.countInv(ammoType);
        let ammoCount = self.countInv(ammoType);
        let given = Weapon(self.findInventory(self.pickupClass));

        taker.a_giveInventory(self.pickupClass, 1);
        taker.setInventory(ammoType, max(ammoCount, oldAmmoCount));

        let taken = zmd_Weapon(taker.findInventory(self.pickupClass));
        if (taken != null)
            taken.activeAmmo = zmd_Weapon(given).activeAmmo;
        self.destroy();
    }

    States {
    Spawn:
        #### a 2100;
        stop;
    }
}

class zmd_PickupDropper : Inventory {
    const key = bt_user2;
    const cost = 750;

    bool readyToDrop;
    int ticksSinceTap;

    Default {
        Inventory.maxAmount 1;
        +Inventory.undroppable
        +Inventory.untossable
        +Inventory.persistentPower
    }

    override void doEffect() {
        if (self.readyToDrop) {
            ++self.ticksSinceTap;
            if (self.justTapped()) {
                self.dropPickup();
                self.readyToDrop = false;
            }
        } else if (self.justTapped()) {
            self.readyToDrop = true;
        } else if (self.ticksSinceTap > 35) {
            self.readyToDrop = false;
            self.ticksSinceTap = 0;
        }
    }

    bool justTapped() {
        return self.owner.getPlayerInput(modInput_oldButtons) & self.key && !(self.owner.getPlayerInput(modInput_buttons) & self.key);
    }

    void dropPickup() {
        let player = PlayerPawn(self.owner);
        let weapon = self.owner.player.readyWeapon;
        let manager = zmd_InventoryManager(player.findInventory('zmd_InventoryManager'));

        if (manager.owns(weapon)) {
            if (zmd_Points.takeFrom(player, self.cost)) {
                manager.abandon(weapon);
                zmd_Pickup.takeFrom(player, weapon);
            }
        } else if ((weapon is 'zmd_Drink' && !zmd_Drink(weapon).isEmpty && zmd_Points.takeFrom(player, self.cost)) || true) {
            zmd_Pickup.takeFrom(player, weapon);
        }
    }
}