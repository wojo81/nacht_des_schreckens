class zmd_DownedPlayerPool : EventHandler {
    class<zmd_DownedPlayer> defaultMorph;

    Array<class<Weapon> > morphWeapons;
    Array<class<zmd_DownedPlayer> > morphClasses;

    static zmd_DownedPlayerPool fetch() {
        return zmd_DownedPlayerPool(EventHandler.find('zmd_DownedPlayerPool'));
    }

    override void worldLoaded(WorldEvent e) {
        self.defaultMorph = 'zmd_DownedPlayerWithColt';
        self.addMorph('Raygun', 'zmd_DownedPlayerWithRaygun');
        self.addMorph('Magnum', 'zmd_DownedPlayerWithMagnum');
    }

    void addMorph(class<Weapon> morphWeapon, class<zmd_DownedPlayer> morphClass) {
        self.morphWeapons.push(morphWeapon);
        self.morphClasses.push(morphClass);
    }

    class<zmd_DownedPlayer> chooseFor(PlayerPawn player) {
        for (int i = 0; i != self.morphWeapons.size(); ++i) {
            if (player.findInventory(self.morphWeapons[i]) != null) {
                return self.morphClasses[i];
            }
        }
        return self.defaultMorph;
    }
}

class zmd_DownedPlayerManager : Inventory {
    Default {
        Inventory.maxAmount 1;
        +Inventory.undroppable
        +Inventory.untossable
        +Inventory.persistentPower
    }

    override void modifyDamage(int damage, Name damageType, out int newDamage, bool receivedDamage, Actor inflictor, Actor source, int flags) {
        if (receivedDamage && damage >= self.owner.health) {
            newDamage = 0;
            console.printf("\cf"..self.owner.player.getUserName().."\cj went down!");
            let worry = zmd_Worry(self.owner.findInventory('zmd_Worry'));
            if (worry != null) {
                worry.handler.deactivate();
            }
            zmd_DownedPlayer.morphFrom(PlayerPawn(self.owner));
        }
    }
}

class zmd_DownedFlash : Actor {}

class zmd_DownedPlayer : DoomPlayer {
    const downDuration = 35 * 30;
    const soloDownDuration = 35 * 10;
    const quickReviveDuration = 35 * 3;

    int reviveDuration, resetDuration;
    bool beingRevived;
    PlayerPawn reviver;

    zmd_AmmoHud ammoHud;
    zmd_PowerupHud powerupHud;

    property reviveDuration: reviveDuration;
    property resetDuration: resetDuration;

    Default {
        zmd_DownedPlayer.reviveDuration 35 * 5;
        zmd_DownedPlayer.resetDuration 10;

        Player.viewHeight 20;
        Player.runHealth 101;
        Player.forwardMove 0.25, 0.125;
        Player.sideMove 0.2, 0.1;
        height 20;

        +PlayerPawn.noThrustWhenInvul
        +invulnerable
        +pickup
        +special
    }

    static void morphFrom(PlayerPawn player) {
        let downedPool = zmd_DownedPlayerPool.fetch();
        let downDuration = multiplayer? zmd_DownedPlayer.downDuration: zmd_DownedPlayer.soloDownDuration;
        player.a_morph(downedPool.chooseFor(player), downDuration,  mrf_loseActualWeapon | mrf_whenInvulnerable, 'zmd_DownedFlash', 'zmd_DownedFlash');
    }

    override void postBeginPlay() {
        super.postBeginPlay();
        if (!multiplayer) {
            if (self.findInventory('zmd_Revive') == null) {
                self.giveInventory('zmd_GameOverSpectate', 1);
                zmd_Rounds.fetch().globalSound.start("game/gameover");
            }
        } else  {
            let anyLivePlayers = false;
            foreach (player : players) {
                if (player.mo != null && !(player.mo is 'zmd_DownedPlayer' || player.mo.findInventory('zmd_Spectate') != null)) {
                    anyLivePlayers = true;
                    break;
                }
            }
            if (!anyLivePlayers) {
                foreach (player : players) {
                    player.mo.takeInventory('zmd_Spectate', 1);
                    player.mo.giveInventory('zmd_GameOverSpectate', 1);
                }
                zmd_Rounds.fetch().globalSound.start("game/gameover");
            }
        }
    }

    override void touch(Actor toucher) {
        if (!(toucher is 'zmd_DownedPlayer')) {
            zmd_HintHud(toucher.findInventory('zmd_HintHud')).setMessage('[Tap to Revive]');
        }
    }

    override bool used(Actor user) {
        if (!(user is 'zmd_DownedPlayer')) {
            zmd_HintHud(user.findInventory('zmd_HintHud')).clearMessage();
            if (self.beingRevived) {
                if (self.reviveDuration <= 0) {
                    self.finishRevive();
                } else {
                    self.resetDuration = self.Default.resetDuration;
                }
            } else {
                self.initiateRevive(PlayerPawn(user));
            }
            return true;
        }
        return false;
    }

    override void postMorph(Actor player, bool current) {
        self.changeTid(0);
        thing_hate(zmd_Spawning.regularTid, zmd_Player.liveTid, 0);
        self.ammoHud = zmd_AmmoHud(self.findInventory('zmd_AmmoHud'));
        self.powerupHud = zmd_PowerupHud(self.findInventory('zmd_PowerupHud'));
    }

    override void postUnmorph(Actor player, bool current) {
        let manager = zmd_InventoryManager(player.findInventory('zmd_InventoryManager'));
        if (!manager.gameOver) {
            player.a_setBlend("red", 0.4, 35 * 3);
            if (player.findInventory('zmd_Revive') == null) {
                player.giveInventory('zmd_Spectate', 1);
            } else {
                self.changeTid(zmd_Player.liveTid);
                thing_hate(zmd_Spawning.regularTid, zmd_Player.liveTid, 0);
                manager.clearPerks();
            }
        }
    }

    override void tick() {
        super.tick();
        if (self.beingRevived) {
            --self.reviveDuration;
            --self.resetDuration;
            if (self.resetDuration == 0) {
                self.beingRevived = false;
                zmd_InventoryManager(self.reviver.findInventory('zmd_InventoryManager')).reviveHud.end();
            }
        }
    }

    void initiateRevive(PlayerPawn reviver) {
        self.beingRevived = true;
        self.resetDuration = self.Default.resetDuration;
        self.reviveDuration = reviver.findInventory('zmd_QuickRevive') == null? self.Default.reviveDuration: self.quickReviveDuration;
        self.reviver = reviver;
        zmd_ReviveHud(reviver.findInventory('zmd_ReviveHud')).begin(self.reviveDuration);
    }

    void finishRevive() {
        zmd_ReviveHud(self.reviver.findInventory('zmd_ReviveHud')).end();
        self.giveInventory('zmd_Revive', 1);
        self.unmorph(self, 0, true);
    }
}

class zmd_DownedPlayerWithColt : zmd_DownedPlayer {
    Default {
        Player.morphWeapon 'Colt';
    }
}

class zmd_DownedPlayerWithRaygun : zmd_DownedPlayer {
    Default {
        Player.morphWeapon 'Raygun';
    }
}

class zmd_DownedPlayerWithMagnum : zmd_DownedPlayer {
    Default {
        Player.morphWeapon 'Magnum';
    }
}

class zmd_ReviveHud : zmd_HudItem {
    bool active;
    int duration, totalDuration;

    override void update() {
        if (self.active && self.duration != 0) {
            --self.duration;
        }
    }

    override void draw(zmd_Hud hud, int state, double tickFrac) {
        if (self.active) {
            hud.drawBar('revback', 'revfore', self.duration, self.totalDuration, (0, -30), 1, 0, hud.di_screen_center_bottom);
        }
    }

    void begin(int duration) {
        self.active = true;
        self.duration = duration;
        self.totalDuration = totalDuration;
    }

    void end() {
        self.active = false;
    }
}