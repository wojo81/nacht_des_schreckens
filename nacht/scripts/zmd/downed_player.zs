class zmd_DownedPlayerSelection : EventHandler {
    class<zmd_DownedPlayer> defaultMorph;

    Array<class<Weapon> > morphWeapons;
    Array<class<zmd_DownedPlayer> > morphClasses;

    void addMorph(class<Weapon> morphWeapon, class<zmd_DownedPlayer> morphClass) {
        self.morphWeapons.push(morphWeapon);
        self.morphClasses.push(morphClass);
    }

    class<zmd_DownedPlayer> pick(zmd_Player player) {
        for (int i = 0; i != self.morphWeapons.size(); ++i) {
            if (player.countInv(self.morphWeapons[i]))
                return self.morphClasses[i];
        }
        return self.defaultMorph;
    }

    override void worldLoaded(WorldEvent e) {
        self.defaultMorph = 'zmd_DownedPlayerWithColt';
        self.addMorph('Raygun', 'zmd_DownedPlayerWithRaygun');
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

class zmd_DownedFlash : Actor {}

class zmd_DownedPlayer : DoomPlayer {
    const totalTicksTillRevive = 35 * 5;
    const totalTicksTillQuickRevive = 35 * 3;
    const totalTicksTillReset = 10;

    int ticksTillRevive;
    int ticksTillReset;

    bool beingRevived;

    zmd_Player reviver;

    Default {
        +invulnerable
        +special

        Player.viewHeight 20;
        Player.runHealth 101;

        speed 0.2;
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

    override void postUnmorph(Actor mo, bool current) {
        let player = zmd_Player(mo);
        foreach (perk : player.perks)
            player.takeInventory(perk, 1);
        if (mo.countInv('zmd_Revive') == 0)
            mo.die(mo, mo);
        else {
            mo.takeInventory('zmd_Revive', 1);
            mo.a_setBlend("red", 0.4, 35 * 3);
        }
    }

    override void tick() {
        super.tick();
        if (self.beingRevived) {
            --self.ticksTillRevive;
            --self.ticksTillReset;
            if (self.ticksTillReset == 0) {
                self.beingRevived = false;
                self.reviver.reviveHud.deactivate();
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
        reviver.reviveHud.activate(self.ticksTillRevive);
        self.reviver = reviver;
    }

    void finishRevive() {
        self.reviver.reviveHud.deactivate();
        self.giveInventory('zmd_Revive', 1);
        self.unmorph(self, 0, true);
    }
}

class zmd_Revive : Inventory {
    Default {
        Inventory.maxAmount 1;
    }
}


class zmd_ReviveHud : zmd_HudElement {
    bool active;
    int ticksLeft;
    int totalTicks;

    override void tick() {
        if (self.active && self.ticksLeft != 0)
            --self.ticksLeft;
    }

    override void draw(zmd_Hud hud, int state, double tickFrac) {
        if (self.active)
            hud.drawBar('revback', 'revfore', self.ticksLeft, self.totalTicks, (0, -30), 1, 0, hud.di_screen_center_bottom);
    }

    void activate(int totalTicks) {
        self.active = true;
        self.ticksLeft = totalTicks;
        self.totalTicks = totalTicks;
    }

    void deactivate() {
        self.active = false;
    }
}