class zmd_PowerupHandler : EventHandler {
    const maxSpawnCount = 4;

    Array<String> availablePowerups;
    Array<String> currentPowerups;
    int spawnCount;

    override void worldLoaded(WorldEvent e) {
        self.availablePowerups.push('zmd_InstakillDrop');
        self.availablePowerups.push('zmd_DoublePointsDrop');
        self.availablePowerups.push('zmd_FireSaleDrop');
        // self.availablePowerups.push('zmd_MaxAmmoDrop');
        // self.availablePowerups.push('zmd_NukeDrop');

        self.resetCycle();
        self.spawnCount = 0;
    }

    void resetCycle() {
        foreach (drop : availablePowerups)
            self.currentPowerups.push(drop);
    }

    void resetCount() {
        self.spawnCount = 0;
    }

    string maybeGet() {
        if (self.spawnCount != maxSpawnCount && random[randomSpawning](1, 1) == 1) {
            self.spawnCount++;
            int randomIndex = random[randomSpawning](0, self.currentPowerups.size() - 1);
            let randomPowerup = self.currentPowerups[randomIndex];
            self.currentPowerups.delete(randomIndex);
            if (self.currentPowerups.size() == 0)
                self.resetCycle();
            return randomPowerup;
        }
        return 'null';
    }
}

class zmd_TimedPowerup : Inventory {
    readonly String iconName;
    int ticksLeft;

    property iconName: iconName;
    property ticksLeft: ticksLeft;

    Default {
        zmd_TimedPowerup.ticksLeft 35 * 30;
    }

    override void tick() {
        if (self.ticksLeft == 0)
            self.destroy();
        else
            --self.ticksLeft;
    }

    override bool tryPickup(in out Actor toucher) {
        let player = zmd_Player(toucher);
        if (player)
            player.powerupHud.add(self.iconName, self.Default.ticksLeft);
        return super.tryPickup(toucher);
    }

    void reset() {
        self.ticksLeft = self.Default.ticksLeft;
    }
}

class zmd_SharedDrop : CustomInventory {
    action void giveToAllPlayers(class<Inventory> item, int amount = 1) {
        for (int i = 0; i != players.size() && players[i].mo != null; ++i)
            players[i].mo.giveInventory(item, amount);
    }
}

class zmd_InstaKill : zmd_TimedPowerup {
    Default {
        zmd_TimedPowerup.iconName 'ikic';
    }

    override bool handlePickup(Inventory item) {
        if (item is 'zmd_Instakill') {
            self.reset();
            return false;
        }
        return super.handlePickup(item);
    }
}

class zmd_InstaKillDrop : zmd_SharedDrop {
    Default {
        Inventory.PickupSound 'game/Instakill';
        -FLOATBOB;
    }

 States
 {
  Spawn:
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    TNT1 A 35;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    TNT1 A 35;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    TNT1 A 35;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    TNT1 A 35;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    TNT1 A 35;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    INST ABCDEFGH 5 BRIGHT;
    Goto Death;
  Pickup:
    TNT1 A 0 a_startSound("game/powerup_grab", 1);
    TNT1 A 0 giveToAllPlayers('zmd_Instakill');
    Stop;
  Death:
    TNT1 A 0;
    STOP;
 }
}

class zmd_DoublePoints : zmd_TimedPowerup {
    Default {
        zmd_TimedPowerup.iconName 'dpic';
    }

    override bool handlePickup(Inventory item) {
        if (item is 'zmd_DoublePoints')
            self.reset();
        return super.handlePickup(item);
    }
}

class zmd_DoublePointsDrop : zmd_SharedDrop {
    Default {
        Inventory.pickupSound 'game/DoublePoints';
        -FLOATBOB;
    }

 States
 {
  Spawn:
    INST A 1205 BRIGHT;
    TNT1 A 35;
    INST A 35 BRIGHT;
    TNT1 A 35;
    INST A 35 BRIGHT;
    TNT1 A 35;
    INST A 35 BRIGHT;
    TNT1 A 35;
    INST A 35 BRIGHT;
    TNT1 A 35;
    INST A 35 BRIGHT;
    goto Death;
  Pickup:
    TNT1 A 0 a_startSound("game/powerup_grab", 1);
    TNT1 A 0 giveToAllPlayers('zmd_DoublePoints');
    Stop;
  Death:
    TNT1 A 0;
    stop;
 }
}

class zmd_MaxAmmo : Inventory {
    override void doEffect() {
        let player = zmd_Player(owner);
        if (player) {
            for (int i = 0; i != player.heldWeapons.size(); ++i) {
                owner.player.mo.giveInventory(player.heldWeapons[i]..'Ammo', 999);
            }
        }
        owner.player.mo.takeInventory('zmd_MaxAmmo', 1);
    }
}

class zmd_MaxAmmoDrop : zmd_SharedDrop {
 Default {
    Inventory.PickupSound 'Game/MaxAmmo';
    +COUNTITEM;
    +NOGRAVITY;
    +INVENTORY.ALWAYSPICKUP;
 }

 States {
  Spawn:
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    TNT1 A 35;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    TNT1 A 35;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    TNT1 A 35;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    TNT1 A 35;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    TNT1 A 35;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    MAXA ABCDEFGH 5 BRIGHT;
    Goto Death;
  Pickup:
    TNT1 A 0 a_startSound("game/powerup_grab", 1);
    TNT1 A 0 giveToAllPlayers('zmd_MaxAmmo');
    Stop;
  Death:
    TNT1 A 0;
    STOP;
 }
}

class zmd_NukeDrop : zmd_SharedDrop {
    Default {
        Inventory.PickupSound 'game/Nuke';
        -FLOATBOB;
    }

     States {
      Spawn:
        NUKE A 1205 BRIGHT;
        TNT1 A 35;
        NUKE A 35 BRIGHT;
        TNT1 A 35;
        NUKE A 35 BRIGHT;
        TNT1 A 35;
        NUKE A 35 BRIGHT;
        TNT1 A 35;
        NUKE A 35 BRIGHT;
        TNT1 A 35;
        NUKE A 35 BRIGHT;
        Goto Death;
      Pickup:
        TNT1 A 0 a_startSound("game/powerup_grab", 1);
        TNT1 A 0 giveToAllPlayers('zmd_Points', 400);
        TNT1 A 0 thing_destroy(115, true);
        Stop;
      Death:
        TNT1 A 0;
        STOP;
     }
}

class zmd_FireSale : zmd_TimedPowerup {
    Default {
        zmd_TimedPowerup.iconName 'fsic';
    }

    override bool handlePickup(Inventory item) {
        if (item is 'zmd_FireSale') {
            self.reset();
            return false;
        }
        return super.handlePickup(item);
    }
}

class zmd_FireSaleRemover : zmd_TimedPowerup {
    override void detachFromOwner() {
        zmd_MysteryBoxHandler(EventHandler.find('zmd_MysteryBoxHandler')).removeAllBoxes();
    }
}

class zmd_FireSaleDrop : zmd_SharedDrop {
    zmd_MysteryBoxHandler handler;

    Default {
        Inventory.pickupSound 'game/fire_sale';
        -floatbob;
    }

    action void spawnBoxes() {
        zmd_MysteryBoxHandler(EventHandler.find('zmd_MysteryBoxHandler')).spawnAllBoxes();
    }

     States {
      Spawn:
        maxa A 1205 BRIGHT;
        TNT1 A 35;
        maxa A 35 BRIGHT;
        TNT1 A 35;
        maxa A 35 BRIGHT;
        TNT1 A 35;
        maxa A 35 BRIGHT;
        TNT1 A 35;
        maxa A 35 BRIGHT;
        TNT1 A 35;
        maxa A 35 BRIGHT;
        Goto Death;
      Pickup:
        TNT1 A 0 a_startSound("game/powerup_grab", 1);
        TNT1 A 0 giveToAllPlayers('zmd_FireSale');
        tnt1 a 0 spawnBoxes;
        Stop;
      Death:
        TNT1 A 0;
        STOP;
     }
}

class zmd_PowerupHud : zmd_HudElement {
    const offsetDelta = 13;

    Array<zmd_PowerupIcon> icons;

    override void tick() {
        for (let i = 0; i != icons.size(); ++i) {
            let icon = icons[i];
            icon.tick();
            if (icon.ticksLeft == 0) {
                icons.delete(i);
                for (let j = 0; j != i; ++j)
                    icons[j].offset += self.offsetDelta;
                for (let j = i; j != icons.size(); ++j)
                    icons[j].offset -= self.offsetDelta;
                --i;
            }
        }
    }

    override void draw(zmd_Hud hud, int state, double tickFrac) {
        foreach (icon : self.icons)
            icon.draw(hud, state, tickFrac);
    }

    void add(String name, int ticksLeft) {
        for (int i = 0; i != self.icons.size(); ++i) {
            let icon = self.icons[i];
            if (name == icon.name) {
                icon.reset(ticksLeft);
                for (int j = 0; j != i; ++j)
                    self.icons[j].offset += self.offsetDelta;
                return;
            }
            icon.offset -= self.offsetDelta;
        }
        if (self.icons.size() == 0)
            self.icons.push(zmd_PowerupIcon.create(name, 0, ticksLeft));
        else
            self.icons.push(zmd_PowerupIcon.create(name, self.icons[self.icons.size() - 1].offset + 2 * self.offsetDelta, ticksLeft));
    }
}

class zmd_PowerupIcon : zmd_HudElement {
    String name;
    int offset;
    int ticksLeft;
    double alpha;

    static zmd_PowerupIcon create(String name, int offset, int ticksLeft) {
        let icon = new('zmd_PowerupIcon');
        icon.name = name;
        icon.offset = offset;
        icon.ticksLeft = ticksLeft;
        icon.alpha = 1.0;
        return icon;
    }

    override void tick() {
        --self.ticksLeft;
    }

    override void draw(zmd_Hud hud, int state, double tickFrac) {
        hud.drawImage(self.name, (self.offset, -3), hud.di_screen_center_bottom | hud.di_item_center_bottom, alpha, scale: (0.5, 0.5));
    }

    void reset(int ticksLeft) {
        self.ticksLeft = ticksLeft;
    }
}