class zmd_LastStand : Inventory {
	const speed = 0.2;
    const multiplayerDuration = 35 * 30;
    const soloDuration = 35 * 10;

    zmd_InventoryManager manager;
    Actor reviveHandle;
    int duration;

    Default {
        Inventory.maxAmount 1;
    }

    override void tick() {
        if (duration-- == 0) {
            self.destroy();
        }
    }

    override void attachToOwner(Actor owner) {
        super.attachToOwner(owner);

        let player = PlayerPawn(owner);
        if (player != null) {
            console.printf("\cf"..self.owner.player.getUserName().."\cj went down!");
            self.manager = zmd_InventoryManager.fetchFrom(player);
            self.manager.switchWeapon = false;

            player.changeTid(0);
            player.speed = self.speed;
            player.viewHeight = 5;
            player.height = 7;
            player.attackZOffset = -18;
            player.viewbob = 0.25;
            player.jumpz = 0;
            player.binvulnerable = true;
            player.bnoThrustWhenInvul = true;
        }

        if (multiplayer) {
            self.duration = self.multiplayerDuration;
            self.reviveHandle = zmd_ReviveHandle.spawnFrom(self);
        } else {
            self.duration = self.soloDuration;
        }
    }

    override void detachFromOwner() {
        let player = PlayerPawn(owner);
        if (player != null) {
            player.speed = zmd_InventoryManager.fetchFrom(player).speed;
            player.viewHeight = player.Default.viewHeight;
            player.attackZOffset = player.Default.attackZOffset;
            player.height = player.Default.viewHeight;
            player.viewbob = player.Default.viewBob;
            player.jumpz = player.Default.jumpz;
            player.binvulnerable = false;
            player.bnoThrustWhenInvul = false;

            if (player.findInventory('zmd_Revive') == null) {
                player.changeTid(0);
                player.giveInventory('zmd_Spectate', 1);
            } else {
                self.manager.clearPerks();
                self.manager.removeTemp();
                self.manager.switchWeapon = true;
                player.a_setBlend("red", 0.4, 35 * 3);
                player.takeInventory('zmd_Revive', 1);
				player.setInventory('zmd_Vitality', 50);
                player.changeTid(zmd_Player.liveTid);
                thing_hate(zmd_Spawning.regularTid, zmd_Player.liveTid, 0);
            }
        }

        if (multiplayer) {
            self.reviveHandle.destroy();
        }

        super.detachFromOwner();
    }
}

class zmd_LastStandWeaponPool : EventHandler {
    Array<class<Weapon> > weapons;

    static class<Weapon> chooseFor(Actor player) {
        let self = zmd_LastStandWeaponPool(EventHandler.find('zmd_LastStandWeaponPool'));
        foreach (weapon : self.weapons) {
            if (player.findInventory(weapon)) {
                return weapon;
            }
        }
        return zmd_InventoryManager.fetchFrom(player).startingWeapon;
    }

    override void worldLoaded(WorldEvent e) {
        self.weapons.push('zmd_Raygun');
        self.weapons.push('zmd_Magnum');
    }
}

class zmd_ReviveHandle : zmd_Interactable {
    const regularReviveDuration = 35 * 5;
    const quickReviveDuration = 35 * 3;
    const minimumReviveDuration = 35;
    const maxResetDuration = 10;

    zmd_LastStand lastStand;
    PlayerPawn reviver;
    int reviveDuration, resetDuration;

    static Actor spawnFrom(zmd_LastStand lastStand) {
        let reviveHandle = zmd_ReviveHandle(Actor.spawn('zmd_ReviveHandle', lastStand.owner.pos, allow_replace));
        reviveHandle.lastStand = lastStand;
        return reviveHandle;
    }

    override void tick() {
        super.tick();
        self.setOrigin(lastStand.owner.pos, false);
        if (self.reviver != null) {
            --self.reviveDuration;
            --self.resetDuration;
            if (self.resetDuration == 0) {
                zmd_InventoryManager(self.reviver.findInventory('zmd_InventoryManager')).reviveHud.end();
                self.reviver = null;
            }
        }
    }

    override void doTouch(PlayerPawn player) {
        zmd_HintHud(player.findInventory('zmd_HintHud')).setMessage('[Tap to Revive]');
    }

    override bool doUse(PlayerPawn player) {
        zmd_HintHud(player.findInventory('zmd_HintHud')).clearMessage();
        if (self.reviver != null) {
            if (self.reviveDuration <= 0) {
                self.end();
            } else {
                self.resetDuration = self.maxResetDuration;
            }
        } else {
            self.begin(player);
        }
        return true;
    }

    void begin(PlayerPawn reviver) {
        self.resetDuration = self.maxResetDuration;
        self.reviveDuration = reviver.findInventory('zmd_QuickRevive') == null? self.regularReviveDuration: self.quickReviveDuration;
        self.reviver = reviver;
        zmd_ReviveHud(reviver.findInventory('zmd_ReviveHud')).begin(self.reviveDuration);
    }

    void end() {
        zmd_ReviveHud(self.reviver.findInventory('zmd_ReviveHud')).end();
        self.lastStand.owner.giveInventory('zmd_Revive', 1);
        self.lastStand.destroy();
    }
}

class zmd_ReviveHud : zmd_HudItem {
    bool active;
    int duration, maxDuration;

    override void update() {
        if (self.active && self.duration != 0) {
            --self.duration;
        }
    }

    override void draw(zmd_Hud hud, int state, double tickFrac) {
        if (self.active) {
            hud.drawBar('revback', 'revfore', self.duration, self.maxDuration, (0, -30), 1, 0, hud.di_screen_center_bottom);
        }
    }

    void begin(int duration) {
        self.active = true;
        self.duration = duration;
        self.maxDuration = duration;
    }

    void end() {
        self.active = false;
    }
}