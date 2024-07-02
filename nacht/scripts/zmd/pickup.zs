class zmd_Pickup : zmd_Interactable {
    class<Inventory> item;

    static int, int, Vector2 getInfo(readonly<Inventory> item) {
        let state = item.spawnState;
        if (state.getSpriteTexture(0).exists() && state.sprite != 0) {
            return state.sprite, state.frame, item.scale;
        }
        int sprite, frame; Vector2 scale;
        [sprite, frame, scale] = zmd_NullPickup.getInfo();
        return sprite, frame, scale;
    }

    static zmd_Pickup take(Weapon given, Vector3 pos) {
        let self = zmd_Pickup(Actor.spawn('zmd_Pickup', pos, allow_replace));
        self.item = given.getClass();
        self.addInventory(given);
        [self.sprite, self.frame, self.scale] = zmd_Pickup.getInfo(given);
        return self;
    }

    static zmd_Pickup takeFrom(Actor giver, Weapon given) {
        let self = zmd_Pickup.take(given, giver.pos);
        let ammo = given.Default.ammoType1;
        if (ammo != null) {
            self.addInventory(giver.findInventory(ammo));
        }
        return self;
    }

    override void doTouch(PlayerPawn player) {
        if (zmd_InventoryManager.couldPickup(player, self.item)) {
            zmd_HintHud(player.findInventory('zmd_HintHud')).setMessage("[Pickup "..getDefaultByType(self.item).getTag().."]");
        }
    }

    override bool doUse(PlayerPawn player) {
        if (zmd_InventoryManager.couldPickup(player, self.item)) {
            self.giveTo(player);
            return true;
        }
        return false;
    }

    virtual void giveTo(Actor taker) {
        let taken = Weapon(self.findInventory(self.item));
        let ammo = getDefaultByType((class<Weapon>)(self.item)).ammoType1;
        if (taken != null) {
            zmd_InventoryManager(taker.findInventory('zmd_InventoryManager')).handlePickup(taken);
            taker.addInventory(taken);
            if (ammo != null) {
                taker.addInventory(self.findInventory(ammo));
            }
        } else {
            taker.giveInventory(self.item, 1);
            if (!(self.item is 'zmd_Weapon') && ammo != null) {
                taker.giveInventory(ammo, getDefaultByType(ammo).maxAmount / 3);
            }
        }
        taker.a_selectWeapon((class<Weapon>)(self.item));
        self.destroy();
    }

    States {
    Spawn:
        #### # 2100;
        stop;
    }
}

class zmd_CustomPickup : zmd_Pickup {
    static zmd_CustomPickup take(CustomInventory given) {
        let self = zmd_CustomPickup(Actor.spawn('zmd_CustomPickup', given.pos, allow_replace));
        self.item = given.getClass();
        [self.sprite, self.frame, self.scale] = zmd_Pickup.getInfo(given);
        return self;
    }

    override void giveTo(Actor taker) {
        taker.giveInventory(self.item, 1);
        self.destroy();
    }
}

class zmd_NullPickup : Inventory {
    static int, int, Vector2 getInfo() {
        let self = getDefaultbyType('zmd_NullPickup');
        let state = self.spawnState;
        return state.sprite, state.frame, self.scale;
    }

    States {
    Spawn:
        nill a -1;
        loop;
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

        let manager = zmd_InventoryManager.fetchFrom(player);

        if (manager.owns(weapon)) {
            if (zmd_Points.takeFrom(player, self.cost)) {
                manager.abandon(weapon);
                zmd_Pickup.takeFrom(player, weapon);
            }
        } else if (weapon is 'zmd_Drink' && !zmd_Drink(weapon).consumed) {
            if (zmd_Points.takeFrom(player, self.cost)) {
                zmd_Pickup.takeFrom(player, weapon);
            }
        } else {
            zmd_Pickup.takeFrom(player, weapon);
        }
    }
}