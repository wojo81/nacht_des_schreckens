class zmd_Player : DoomPlayer {
    const regularHealthMin = 150;
    const juggHealthMin = 0;

    int healthMin;

    int weaponCount;
    int maxWeaponCount;
    Array<String> heldWeapons;
    Array<String> perks;
    bool justTookDamage;

    String message;
    int messageTics;

    Array<int> pointDeltas;
    bool usedPointDeltas;

    int reviveCountup;
    int flashingTicks;
    int flashCount;
    bool flashRevive;

    zmd_DownedPlayerSelection downedPlayerSelection;

    Default {
        Player.StartItem 'Colt';
        Player.StartItem 'ColtAmmo', 40;
        Player.startItem 'zmd_Points', 5000;
        Player.StartItem 'zmd_Regen';
        Player.StartItem 'NTM_QuickMelee';
        Player.StartItem 'zmd_InventoryManager';

        Player.WeaponSlot 1, 'ZPistol', 'Raygun', 'Colt', 'Ppsh', 'M1Garand', 'DoubleBarrelShotgun';

        Player.maxHealth 250;
    }

    override void beginPlay() {
        super.beginPlay();
        self.healthMin = regularHealthMin;
        self.weaponCount = 0;
        self.maxWeaponCount = 2;
        self.justTookDamage = false;
    }

    override void postBeginPlay() {
        super.postBeginPlay();
        self.downedPlayerSelection = zmd_DownedPlayerSelection(EventHandler.find('zmd_DownedPlayerSelection'));
    }

    bool atWeaponCapacity() {
        if (self.weaponCount == self.maxWeaponCount) {
            return true;
        } else {
            ++self.weaponCount;
            return false;
        }
    }

    void enableWeaponPerks() {
        let useFastReload = self.countInv('zmd_SpeedCola');
        let useDoubleFire = self.countInv('zmd_DoubleTap');

        foreach (heldWeapon : heldWeapons) {
            let heldWeapon = zmd_Weapon(self.findInventory(heldWeapon));
            if (heldWeapon) {
                heldWeapon.useFastReload = useFastReload;
                heldWeapon.useDoubleFire = useDoubleFire;
            }
        }
    }

    void disableWeaponPerks() {
        foreach (heldWeapon : heldWeapons) {
            let heldWeapon = zmd_Weapon(self.findInventory(heldWeapon));
            if (heldWeapon) {
                heldWeapon.useFastReload = false;
                heldWeapon.useDoubleFire = false;
            }
        }
    }

    override int damageMobJ(Actor inflictor, Actor source, int damage, Name mod, int flags, double angle) {
        if (inflictor != self && self.health - damage <= self.healthMin) {
            self.disableWeaponPerks();
            self.morph(self, self.downedPlayerSelection.pick(self), null, 30 * 35, mrf_loseActualWeapon | mrf_whenInvulnerable, 'zmd_DownedFlash', 'zmd_DownedFlash');
            return 0;
        }
        self.justTookDamage = true;
        return super.damageMobJ(inflictor, source, damage, mod, flags, angle);
    }

    bool maybePurchase(int cost) {
        if (countInv('zmd_Points') >= cost) {
            takeInventory('zmd_Points', cost);
            pointDeltas.push(-cost);
            return true;
        }
        return false;
    }

    void setMessage(String message) {
        self.message = message;
        self.messageTics = 35;
    }

    void clearMessage() {
        self.message = '';
        self.messageTics = 0;
    }

    override void tick() {
        super.tick();

        if (self.messageTics-- == 0) {
            self.message = '';
        }
        if (self.usedPointDeltas) {
            self.pointDeltas.clear();
            self.usedPointDeltas = false;
        }
        if (self.pointDeltas.size() != 0) {
            self.usedPointDeltas = true;
        }

        if (self.flashRevive) {
            ++self.flashingTicks;
            if (self.flashingTicks == 10) {
                self.flashingTicks = 0;
                if (self.flashCount++ == 2) {
                    self.flashRevive = false;
                    self.flashCount = 0;
                }
            }
        }
    }

    void updateReviveIndicator(int countdown) {
        self.reviveCountup = zmd_DownedPlayer.reviveTime - countdown;
    }

    void flashReviveIndicator() {
        self.reviveCountup = 0;
        self.flashRevive = true;
    }
}