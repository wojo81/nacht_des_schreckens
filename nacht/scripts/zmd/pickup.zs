class zmd_Pickup : zmd_Interactable {
    class<Weapon> item;

    static zmd_Pickup takeFrom(Actor giver, Weapon given) {
        let self = zmd_Pickup(Actor.spawn('zmd_Pickup', giver.pos, allow_replace));
        self.addInventory(given);
        self.addInventory(giver.findInventory(given.Default.ammoType1));
        self.item = given.getClass();
        self.sprite = given.Default.spawnState.sprite;
        self.scale = given.Default.scale;
        return self;
    }

    override void doTouch(PlayerPawn player) {
        if (zmd_InventoryManager.couldPickup(player, self.item))
            zmd_HintHud(player.findInventory('zmd_HintHud')).setMessage('[Pickup]');
    }

    override bool doUse(PlayerPawn player) {
        if (zmd_InventoryManager.couldPickup(player, self.item)) {
            self.giveTo(player);
            return true;
        }
        return false;
    }

    void giveTo(Actor taker) {
        let taken = Weapon(self.findInventory(self.item));
        if (taken != null) {
            zmd_InventoryManager(taker.findInventory('zmd_InventoryManager')).handlePickup(taken);
            taker.addInventory(taken);
            taker.addInventory(self.findInventory(taken.Default.ammoType1));
        } else {
            taker.giveInventory(self.item, 1);
        }
        taker.a_selectWeapon(self.item);
        self.item = null;
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

        if (weapon == null)
            return;

        let manager = zmd_InventoryManager(player.findInventory('zmd_InventoryManager'));

        if (manager.owns(weapon)) {
            if (zmd_Points.takeFrom(player, self.cost)) {
                manager.abandon(weapon);
                zmd_Pickup.takeFrom(player, weapon);
            }
        } else if ((weapon is 'zmd_Drink' && !zmd_Drink(weapon).isEmpty && zmd_Points.takeFrom(player, self.cost))) {
            zmd_Pickup.takeFrom(player, weapon);
        } else {
            zmd_Pickup.takeFrom(player, weapon);
        }
    }
}