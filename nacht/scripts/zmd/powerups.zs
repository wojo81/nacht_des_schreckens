class zmd_PowerupHandler : EventHandler {
    Array<String> availablePowerups;
    Array<String> currentPowerups;
    int spawnCount;
    int maxSpawnCount;

    override void worldLoaded(WorldEvent e) {
        availablePowerups.push('zmd_InstakillDrop');
        availablePowerups.push('zmd_DoublePointsDrop');
        availablePowerups.push('zmd_MaxAmmoDrop');
        availablePowerups.push('zmd_NukeDrop');

        resetCycle();
        spawnCount = 0;
        maxSpawnCount = 4;
    }

    void resetCycle() {
        foreach (drop : availablePowerups)
            currentPowerups.push(drop);
    }

    void resetCount() {
        spawnCount = 0;
    }

    string maybeGet() {
        if (spawnCount != maxSpawnCount && random[randomSpawning](1, 5) == 1) {
            spawnCount++;
            int randomIndex = random[randomSpawning](0, self.currentPowerups.size() - 1);
            let randomPowerup = self.currentPowerups[randomIndex];
            self.currentPowerups.delete(randomIndex);
            if (self.currentPowerups.size() == 0)
                resetCycle();
            return randomPowerup;
        }
        return 'null';
    }
}

class zmd_TimedPowerup : Inventory {
    int tickCount;
    int currentTicks;

    property tickCount: tickCount;
    property currentTicks: currentTicks;

    Default {
        zmd_TimedPowerup.tickCount 35 * 30;
        zmd_TimedPowerup.currentTicks 0;
    }

    void reset() {
        self.currentTicks = 0;
    }

    override void tick() {
        if (self.currentTicks == self.tickCount) {
            destroy();
        } else {
            ++self.currentTicks;
        }
    }
}

class zmd_SharedDrop : CustomInventory {
    action void giveToAllPlayers(class<Inventory> item, int amount = 1) {
        if (item is 'zmd_Points') {
            for (int i = 0; i != players.size() && players[i].mo != null; ++i) {
                zmd_Points.give(zmd_Player(players[i].mo), amount);
            }
        } else {
            for (int i = 0; i != players.size() && players[i].mo != null; ++i) {
                players[i].mo.giveInventory(item, amount);
            }
        }
    }
}

class zmd_InstaKill : zmd_TimedPowerup {
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
    override bool handlePickup(Inventory item) {
        if (item is 'zmd_DoublePoints') {
            reset();
        }
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
    override bool handlePickup(Inventory item) {
        if (item is 'zmd_FireSale')
            reset();
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
        tnt1 a 0 a_giveInventory('zmd_FireSaleRemover', 1);
        tnt1 a 0 spawnBoxes;
        Stop;
      Death:
        TNT1 A 0;
        STOP;
     }
}