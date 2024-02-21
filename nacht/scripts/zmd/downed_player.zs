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
    const reviveTime = 35 * 5;

    int reviveCountdown;
    int reviveCooldown;

    bool beingRevived;

    zmd_Player reviver;

    Default {
        +invulnerable
        +special

        Player.viewHeight 20;
        Player.runHealth 101;

        speed 0.2;
    }

    override void beginPlay() {
        self.reviveCountdown = self.reviveTime;
    }

    override void touch(Actor toucher) {
        let toucher = zmd_Player(toucher);
        if (toucher)
            toucher.setMessage('[Revive]');
    }

    override bool used(Actor user) {
        let player = zmd_Player(user);
        if (player) {
            player.clearMessage();
            advanceRevive(player);
            return true;
        }
        return false;
    }

    override void postUnmorph(Actor mo, bool current) {
        let player = zmd_Player(mo);
        foreach (perk : player.perks)
            player.takeInventory(perk, 1);
        if (mo.countInv('zmd_Revive') == 0) {
            mo.die(mo, mo);
        } else {
            mo.takeInventory('zmd_Revive', 1);
            mo.a_setBlend("red", 0.4, 35 * 3);
        }
    }

    override void tick() {
        if (self.beingRevived) {
            self.reviver.updateReviveIndicator(self.reviveCountdown);
            if (self.reviveCooldown == 0) {
                self.beingRevived = false;
                self.reviver.updateReviveIndicator(self.reviveTime);
            } else {
                self.reviveCountdown -= self.reviver.countInv('zmd_QuickRevive') + 1;
                --self.reviveCooldown;
            }
        } else if (self.reviveCountdown != self.reviveTime) {
            self.reviveCountdown += 2;
            if (self.reviveCountDown > self.reviveTime) {
                self.reviveCountDown = self.reviveTime;
            }
        }
        super.tick();
    }

    void advanceRevive(zmd_Player reviver) {
        self.beingRevived = true;
        self.reviver = reviver;
        self.reviveCooldown = 20;
        if (self.reviveCountdown <= 0)
            finishRevive();
    }

    void finishRevive() {
        self.reviver.flashReviveIndicator();
        self.giveInventory('zmd_Revive', 1);
        self.unmorph(self, 0, true);
    }
}

class zmd_Revive : Inventory {
    Default {
        Inventory.maxAmount 1;
    }
}