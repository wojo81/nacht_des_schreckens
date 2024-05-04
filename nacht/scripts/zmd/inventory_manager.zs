class zmd_InventoryManager : Inventory {
    bool spectating;
    bool gameOver;

    Array<zmd_HudItem> hudItems;
    Array<class<zmd_Perk> > perks;
    Array<Weapon> weapons;
    class<Weapon> fist;
    Array<class<Inventory> > startingItems;
    int maxWeaponCount;

    zmd_HintHud hintHud;
    zmd_PointsHud pointsHud;
    zmd_PowerupHud powerupHud;
    zmd_PerkHud perkHud;
    zmd_AmmoHud ammoHud;
    zmd_ReviveHud reviveHud;

    bool fastReload;
    bool doubleFire;

    Default {
        Inventory.maxAmount 1;
        +Inventory.undroppable
        +Inventory.untossable
        +Inventory.persistentPower
    }

    static bool couldPickup(PlayerPawn player, class<Weapon> weapon) {
        let inventoryManager = zmd_InventoryManager(player.findInventory('zmd_InventoryManager'));
        return (!inventoryManager.atCapacity() || inventoryManager.owns(player.player.readyWeapon)) && player.countInv(weapon) == 0;
    }

    override void postBeginPlay() {
        super.postBeginPlay();

        let iterator = ThinkerIterator.create('Inventory');
        Thinker thinker;
        while (thinker = iterator.next()) {
            let item = Inventory(thinker);
            if (item != null && item.owner == owner && !(item is 'Ammo')) {
                self.startingItems.push(item.getClass());
                let weapon = Weapon(thinker);
                if (weapon != null && weapon.owner == owner && weapon.ammoType1 == null)
                    self.fist = weapon.getClass();
            }
        }

        self.hintHud = zmd_HintHud(self.addHud('zmd_HintHud'));
        self.pointsHud = zmd_PointsHud(self.addHud('zmd_PointsHud'));
        self.powerupHud = zmd_PowerupHud(self.addHud('zmd_PowerupHud'));
        self.perkHud = zmd_PerkHud(self.addHud('zmd_PerkHud'));
        self.reviveHud = zmd_ReviveHud(self.addHud('zmd_ReviveHud'));
        self.ammoHud = zmd_AmmoHud(self.addHud('zmd_AmmoHud'));
        self.addHud('zmd_RoundHud');

        self.weapons.push(owner.player.readyWeapon);

        self.maxWeaponCount = 2;

        let mysteryBoxPool = zmd_MysteryBoxPool.fetch();
        let playerNumber = owner.playerNumber();

        if (owner is 'zmd_Player') {
            mysteryBoxPool.add(playerNumber, 'Raygun');
            mysteryBoxPool.add(playerNumber, 'M1Garand');
            mysteryBoxPool.add(playerNumber, 'DoubleBarrelShotgun');
            mysteryBoxPool.add(playerNumber, 'Raygun');
            mysteryBoxPool.add(playerNumber, 'Ppsh');
            mysteryBoxPool.add(playerNumber, 'Magnum');
            mysteryBoxPool.add(playerNumber, 'Thompson');
            mysteryBoxPool.add(playerNumber, 'Kar98');
            mysteryBoxPool.add(playerNumber, 'Carbine');
        } else {
            let slots = owner.player.weapons;
            for (int x = 0; x <= 7; ++x) {
                for (int y = 0; y != slots.slotSize(x); ++y) {
                    let weapon = slots.getWeapon(x, y);
                    let sprite = getDefaultByType(weapon).spawnState.sprite;
                    if (getDefaultByType(weapon).canPickup(owner) && !(weapon is self.fist))
                        mysteryBoxPool.add(playerNumber, weapon);
                }
            }
        }
    }

    override bool handlePickup(Inventory item) {
        if (item is 'zmd_Drink') {
            let drink = zmd_Drink(item);
            if (self.fastReload)
                drink.activateFastReload();
        } else if (item is 'zmd_Perk') {
            self.perks.push(item.getClassName());
            zmd_PerkHud(self.owner.findInventory('zmd_PerkHud')).add(item);
        } else if (item is 'Weapon') {
            let weapon = Weapon(item);
            bool slotted; (slotted) = self.owner.player.weapons.locateWeapon(weapon.getClass());
            if (slotted && item.canPickup(self.owner)) {
                if (self.atCapacity()) {
                    let cweapon = self.owner.player.readyWeapon;
                    if (cweapon == null)
                        cweapon = self.owner.player.pendingWeapon;
                    self.abandon(cweapon);
                    if (cweapon is 'zmd_Weapon')
                        owner.setInventory(cweapon.Default.ammoType1, 0);
                    owner.removeInventory(cweapon);
                }
                let zweapon = zmd_Weapon(weapon);
                if (zweapon != null) {
                    if (self.fastReload)
                        zweapon.activateFastReload();
                    if (self.doubleFire)
                        zweapon.activateDoubleFire();
                }
                self.weapons.push(weapon);
            }
        }
        return super.handlePickup(item);
    }

    void reset() {
        self.owner.clearInventory();
        foreach (item : self.startingItems) {
            self.owner.giveInventory(item, 1);
            if (self.owner.countInv('zmd_Points') < 1500)
                self.owner.setInventory('zmd_Points', 1500);
        }
    }

    bool owns(Weapon weapon) {
        return self.weapons.find(weapon) != self.weapons.size();
    }

    void abandon(Weapon weapon) {
        self.weapons.delete(self.weapons.find(weapon));
    }

    bool atCapacity() {
        return self.weapons.size() == self.maxWeaponCount;
    }

    zmd_HudItem addHud(class<zmd_HudItem> hudItem) {
        self.owner.giveInventory(hudItem, 1);
        let hudItem = zmd_HudItem(self.owner.findInventory(hudItem));
        self.hudItems.push(hudItem);
        return hudItem;
    }

    void fillWeapons() {
        foreach (weapon : self.weapons) {
            let ammoType = getDefaultByType(weapon.getClass()).ammoType1;
            if (ammoType != null) {
                let ammoCount = Inventory(getDefaultByType(ammoType)).maxAmount;
                self.owner.setInventory(ammoType, ammoCount);
            }
        }
    }

    void activateFastReload() {
        self.fastReload = true;
        foreach (weapon : self.weapons) {
            let weapon = zmd_Weapon(weapon);
            if (weapon != null)
                zmd_Weapon(weapon).activateFastReload();
        }
    }

    void deactivateFastReload() {
        self.fastReload = false;
        foreach (weapon : self.weapons) {
            let weapon = zmd_Weapon(weapon);
            if (weapon != null)
                zmd_Weapon(weapon).deactivateFastReload();
        }
    }

    void activateDoubleFire() {
        self.doubleFire = true;
        foreach (weapon : self.weapons) {
            let weapon = zmd_Weapon(weapon);
            if (weapon != null)
                zmd_Weapon(weapon).activateDoubleFire();
        }
    }

    void deactivateDoubleFire() {
        self.doubleFire = false;
        foreach (weapon : self.weapons) {
            let weapon = zmd_Weapon(weapon);
            if (weapon != null)
                zmd_Weapon(weapon).deactivateDoubleFire();
        }
    }

    void clearPerks() {
        foreach (perk : self.perks)
            self.owner.takeInventory(perk, 1);
        self.perks.resize(0);
        self.perkHud.clear();
    }
}

class zmd_InventoryGiver : EventHandler {
    static void giveTo(PlayerPawn player) {
        player.changeTid(zmd_Player.liveTid);
        player.giveInventory('zmd_InventoryManager', 1);
        player.giveInventory('zmd_DownedPlayerManager', 1);
        player.setInventory('zmd_Points', 500);
        player.giveInventory('zmd_Regen', 1);
        player.giveInventory('zmd_PickupDropper', 1);
        EventHandler.sendInterfaceEvent(player.playerNumber(), 'addInventoryManager');
    }

    override void worldLoaded(WorldEvent e) {
        zmd_Rounds.fetch().globalSound.start("game/intro_cinematic", chan_5);
        foreach (player : players)
            if (player.mo != null)
                player.mo.giveInventory('zmd_Intro', 1);
    }

    override void interfaceProcess(ConsoleEvent e) {
        if (e.name == 'addInventoryManager' && statusbar != null && statusbar.cplayer != null && statusbar.cplayer.mo != null && statusbar is 'zmd_Hud')
            zmd_Hud(statusbar).inventoryManager = zmd_InventoryManager(statusbar.cplayer.mo.findInventory('zmd_InventoryManager'));
    }
}