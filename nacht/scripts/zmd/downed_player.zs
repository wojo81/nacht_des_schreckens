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

    class<zmd_DownedPlayer> chooseFor(zmd_Player player) {
        for (int i = 0; i != self.morphWeapons.size(); ++i) {
            if (player.countInv(self.morphWeapons[i]) != 0)
                return self.morphClasses[i];
        }
        return self.defaultMorph;
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

    zmd_Player reviver;

    zmd_AmmoHud ammoHud;
    zmd_PowerupHud powerupHud;

    Default {
        +PlayerPawn.noThrustWhenInvul
        +invulnerable
        +pickup
        +special

        Player.viewHeight 20;
        Player.runHealth 101;

        speed 0.2;
        height 20;
    }

    static void morphFrom(zmd_Player player) {
        let downedPool = zmd_DownedPlayerPool.fetch();
        let downTime = player.countInv('zmd_Revive') == 0?
            zmd_DownedPlayer.regularDownTime:
            zmd_DownedPlayer.soloDownTime;
        player.a_morph(downedPool.chooseFor(player), downTime,  mrf_loseActualWeapon | mrf_whenInvulnerable, 'zmd_DownedFlash', 'zmd_DownedFlash');
    }

    override void touch(Actor toucher) {
        let player = zmd_Player(toucher);
        if (player)
            player.hintHud.setMessage('[Tap to Revive]');
    }

    override bool used(Actor user) {
        let player = zmd_Player(user);
        if (player) {
            player.hintHud.clearMessage();
            if (self.beingRevived)
                if (self.ticksTillRevive <= 0)
                    self.finishRevive();
                else
                    self.ticksTillReset = self.totalTicksTillReset;
            else
                self.initiateRevive(player);
            return true;
        }
        return false;
    }

    override void postMorph(Actor player, bool current) {
        console.printf("test");
        let player = zmd_Player(player);
        self.ammoHud = zmd_AmmoHud(self.findInventory('zmd_AmmoHud'));
        self.powerupHud = zmd_PowerupHud(self.findInventory('zmd_PowerupHud'));
    }

    override void postUnmorph(Actor player, bool current) {
        if (player.countInv('zmd_Revive') == 0) {
            player.die(player, player);
            return;
        }

        let player = zmd_Player(player);
        foreach (perk : player.perks)
            player.takeInventory(perk, 1);
        player.perks.resize(0);
        player.perkHud.clear();
        player.a_setBlend("red", 0.4, 35 * 3);
    }

    override void tick() {
        super.tick();
        self.powerupHud.update();
        if (self.beingRevived) {
            --self.ticksTillRevive;
            --self.ticksTillReset;
            if (self.ticksTillReset == 0) {
                self.beingRevived = false;
                self.reviver.reviveHud.end();
            }
        }
    }

    void initiateRevive(zmd_Player reviver) {
        self.beingRevived = true;
        self.ticksTillReset = self.totalTicksTillReset;
        if (reviver.countInv('zmd_QuickRevive'))
            self.ticksTillRevive = self.totalTicksTillQuickRevive;
        else
            self.ticksTillRevive = self.totalTicksTillRevive;
        reviver.reviveHud.begin(self.ticksTillRevive);
        self.reviver = reviver;
    }

    void finishRevive() {
        self.reviver.reviveHud.end();
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