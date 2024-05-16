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
            if (player.countInv(self.morphWeapons[i]) != 0)
                return self.morphClasses[i];
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

    override void modifyDamage(int damage, Name damageType, out int newDamage, bool passive, Actor inflictor, Actor source, int flags) {
        if (passive && damage >= self.owner.health) {
            newDamage = 0;
            console.printf("\cf"..self.owner.player.getUserName().."\cj went down!");
            let worry = zmd_Worry(self.owner.findInventory('zmd_Worry'));
            if (worry != null)
                worry.handler.deactivate();
            zmd_DownedPlayer.morphFrom(PlayerPawn(self.owner));
        }
    }
}

class zmd_DownedFlash : Actor {}

class zmd_DownedPlayer : DoomPlayer {
    const regularDownTime = 35 * 30;
    const soloDownTime = 35 * 10;

    const totalTicksTillRevive = 35 * 5;
    const totalTicksTillQuickRevive = 35 * 3;
    const totalTicksTillReset = 10;

    int ticksTillRevive;
    int ticksTillReset;

    bool beingRevived;

    PlayerPawn reviver;

    zmd_AmmoHud ammoHud;
    zmd_PowerupHud powerupHud;

    Default {
        +PlayerPawn.noThrustWhenInvul
        +invulnerable
        +pickup
        +special

        Player.viewHeight 20;
        Player.runHealth 101;

        Player.forwardMove 0.25, 0.125;
        Player.sideMove 0.2, 0.1;
        height 20;
    }

    static void morphFrom(PlayerPawn player) {
        let downedPool = zmd_DownedPlayerPool.fetch();
        let downTime = multiplayer?
            zmd_DownedPlayer.regularDownTime:
            zmd_DownedPlayer.soloDownTime;
        player.a_morph(downedPool.chooseFor(player), downTime,  mrf_loseActualWeapon | mrf_whenInvulnerable, 'zmd_DownedFlash', 'zmd_DownedFlash');
    }

    override void postBeginPlay() {
        super.postBeginPlay();
        if (!multiplayer) {
            if (self.countInv('zmd_Revive') == 0) {
                self.giveInventory('zmd_GameOverSpectate', 1);
                zmd_Rounds.fetch().globalSound.start("game/gameover");
            }
        } else  {
            let anyLivePlayers = false;
            foreach (player : players) {
                if (player.mo && !(player.mo is 'zmd_DownedPlayer' || player.mo.countInv('zmd_Spectate') != 0)) {
                    anyLivePlayers = true;
                    break;
                }
            }
            if (!anyLivePlayers) {
                foreach (player : players) {
                    player.mo.giveInventory('zmd_GameOverSpectate', 1);
                    player.mo.takeInventory('zmd_Spectate', 1);
                }
                zmd_Rounds.fetch().globalSound.start("game/gameover");
            }
        }
    }

    override void touch(Actor toucher) {
        if (!(toucher is 'zmd_DownedPlayer'))
            zmd_HintHud(toucher.findInventory('zmd_HintHud')).setMessage('[Tap to Revive]');
    }

    override bool used(Actor user) {
        if (!(user is 'zmd_DownedPlayer')) {
            zmd_HintHud(user.findInventory('zmd_HintHud')).clearMessage();
            if (self.beingRevived)
                if (self.ticksTillRevive <= 0)
                    self.finishRevive();
                else
                    self.ticksTillReset = self.totalTicksTillReset;
            else
                self.initiateRevive(PlayerPawn(user));
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
            if (player.countInv('zmd_Revive') == 0)
                player.a_giveInventory('zmd_Spectate');
            else {
                self.changeTid(zmd_Player.liveTid);
                thing_hate(zmd_Spawning.regularTid, zmd_Player.liveTid, 0);
                manager.clearPerks();
            }
        }
    }

    override void tick() {
        super.tick();
        if (self.beingRevived) {
            --self.ticksTillRevive;
            --self.ticksTillReset;
            if (self.ticksTillReset == 0) {
                self.beingRevived = false;
                zmd_InventoryManager(self.reviver.findInventory('zmd_InventoryManager')).reviveHud.end();
            }
        }
    }

    void initiateRevive(PlayerPawn reviver) {
        self.beingRevived = true;
        self.ticksTillReset = self.totalTicksTillReset;
        if (reviver.countInv('zmd_QuickRevive'))
            self.ticksTillRevive = self.totalTicksTillQuickRevive;
        else
            self.ticksTillRevive = self.totalTicksTillRevive;
        zmd_ReviveHud(reviver.findInventory('zmd_ReviveHud')).begin(self.ticksTillRevive);
        self.reviver = reviver;
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
    int ticksLeft;
    int totalTicks;

    override void update() {
        if (self.active && self.ticksLeft != 0)
            --self.ticksLeft;
    }

    override void draw(zmd_Hud hud, int state, double tickFrac) {
        if (self.active)
            hud.drawBar('revback', 'revfore', self.ticksLeft, self.totalTicks, (0, -30), 1, 0, hud.di_screen_center_bottom);
    }

    void begin(int totalTicks) {
        self.active = true;
        self.ticksLeft = totalTicks;
        self.totalTicks = totalTicks;
    }

    void end() {
        self.active = false;
    }
}