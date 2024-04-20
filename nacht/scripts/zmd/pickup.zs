class zmd_Pickup : zmd_Interactable {
    class<Weapon> pickupClass;

    Default {
        xScale 0.5;
        yScale 0.5;
    }

    static zmd_Pickup transferFrom(Actor from, Weapon fromWeapon) {
        let to = zmd_Pickup(Actor.spawn('zmd_Pickup', from.pos, allow_replace));
        to.pickupClass = fromWeapon.getClassName();
        to.a_giveInventory(to.pickupClass);
        to.sprite = fromWeapon.Default.spawnState.sprite;
        let toWeapon = Weapon(to.findInventory(to.pickupClass));
        to.a_takeInventory(fromWeapon.ammoType1, fromWeapon.ammoGive1);
        to.a_giveInventory(fromWeapon.ammoType1, from.countInv(fromWeapon.ammoType1));
        if (toWeapon is 'zmd_Weapon')
            zmd_Weapon(toWeapon).activeAmmo = zmd_Weapon(fromWeapon).activeAmmo;
        from.a_takeInventory(to.pickupClass, 1);
        from.a_takeInventory(toWeapon.ammoType1, 999);
        return to;
    }

    override void doTouch(zmd_Player player) {
        player.hintHud.setMessage('[Pickup]');
    }

    override bool doUse(zmd_Player player) {
        if (player.countInv(self.pickupClass) == 0) {
            self.transferTo(player);
            return true;
        }
        return false;
    }

    void transferTo(Actor to) {
        to.a_giveInventory(self.pickupClass);
        let pickup = Weapon(self.findInventory(self.pickupClass));
        let weapon = Weapon(to.findInventory(self.pickupClass));
        to.a_giveInventory(self.pickupClass..'Ammo', self.countInv(self.pickupClass..'Ammo'));
        let weapon2 = zmd_Weapon(weapon);
        if (weapon2)
            weapon2.activeAmmo = zmd_Weapon(pickup).activeAmmo;
        self.destroy();
    }

    States {
    Spawn:
        #### a 1;
        wait;
    }
}

class zmd_PickupDropper : Inventory {
    const key = bt_user2;
    const cost = 1500;

    bool readyToDrop;
    int ticksSinceTap;

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
        let player = zmd_Player(self.owner);
        if (player && self.owner.player.readyWeapon != null && !(self.owner.player.readyWeapon is 'zmd_Drink') && player.purchase(self.cost)) {
            let weaponClass = self.owner.player.readyWeapon;
            zmd_Pickup.transferFrom(player, self.owner.player.readyWeapon);
            player.heldWeapons.delete(player.heldWeapons.find(weaponClass));
        }
    }
}