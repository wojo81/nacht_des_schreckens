class zmd_Weapon : Weapon {
    bool zoomed;
    bool toggledZoom;
    bool keepPartialReload;
    int activeAmmo;
    int reloadFrameRate;
    int fireFrameRate;

    property activeAmmo: activeAmmo;
    property reloadFrameRate: reloadFrameRate;
    property fireFrameRate: fireFrameRate;
    property keepPartialReload: keepPartialReload;

    Default {
        xscale 0.5;
        yscale 0.5;

        Weapon.bobStyle 'InverseSmooth';
        Weapon.ammoUse 1;

        +Weapon.noAutoAim
        +Weapon.noAutoFire
        +Weapon.ammo_optional
    }

    override void postBeginPlay() {
        super.postBeginPlay();
        self.toggledZoom = CVar.getCVar('toggledZoom', players[self.playerNumber()]).getBool();
    }

    void activateFastReload() {
        self.reloadFrameRate = self.Default.reloadFrameRate - 1;
    }

    void activateDoubleFire() {
        self.fireFrameRate = self.Default.fireFrameRate - 1;
    }

    void deactivateFastReload() {
        self.reloadFrameRate = self.Default.reloadFrameRate;
    }

    void deactivateDoubleFire() {
        self.fireFrameRate = self.Default.fireFrameRate;
    }

    action State toggleZoom() {
        return invoker.zoomed? resolveState('ZoomOut'): resolveState('ZoomIn');
    }

    action void zoomIn() {
        a_zoomFactor(1.5);
        invoker.zoomed = true;
        invoker.bobRangeX = 0.2;
        invoker.bobRangeY = 0.2;
    }

    action void zoomOut() {
        a_zoomFactor(1.0);
        invoker.zoomed = false;
        invoker.bobRangeX = 1.0;
        invoker.bobRangeY = 1.0;
    }

    action void readyWeapon() {
        if (invoker.zoomed && !invoker.toggledZoom)
            a_weaponReady(wrf_allowReload);
        else
            a_weaponReady(wrf_allowReload | wrf_allowZoom);
    }

    action void reload() {
        if (invoker.keepPartialReload) {
            let ammo = self.countInv(invoker.ammoType1);
            let transferAmmo = min(invoker.Default.activeAmmo - invoker.activeAmmo, ammo);
            invoker.owner.takeInventory(invoker.ammoType1, transferAmmo);
            invoker.activeAmmo += transferAmmo;
        } else {
            invoker.activeAmmo = invoker.Default.activeAmmo;
            invoker.owner.takeInventory(invoker.ammoType1, invoker.Default.activeAmmo);
        }
    }

    action void shootBullets(double spread, int damage, int bullets) {
        if (bullets == 1)
            bullets = -1;
        a_fireBullets(spread, spread, bullets, damage, flags: fbf_noRandom);
        invoker.activeAmmo -= invoker.ammoUse1;
    }

    action Actor, Actor shootProjectile(class<Rocket> projectile) {
        invoker.activeAmmo -= invoker.Default.ammoUse1;
        Actor x, y;
        [x, y] = a_fireProjectile(projectile, useAmmo: false);
        return x, y;
    }

    action State when(bool condition, StateLabel label) {
        return condition? resolveState(label): resolveState(null);
    }

    action State whenZoomed(StateLabel label) {
        return invoker.when(invoker.zoomed, label);
    }

    action State whenNotZoomed(StateLabel label) {
        return invoker.when(!invoker.zoomed, label);
    }

    action State whenShouldZoomOut(StateLabel label) {
        return invoker.when(!invoker.toggledZoom && !(invoker.owner.player.cmd.buttons & bt_zoom), label);
    }

    action State whenNoActiveAmmo(StateLabel label) {
        return invoker.when(invoker.activeAmmo == 0, label);
    }

    action State whenAnyActiveAmmo(StateLabel label) {
        return invoker.when(invoker.activeAmmo != 0, label);
    }

    action State whenLastActiveAmmo(StateLabel label) {
        return invoker.when(invoker.activeAmmo == invoker.Default.ammoUse1, label);
    }

    action State whenNoAmmo(StateLabel label) {
        return invoker.when(self.countInv(invoker.ammoType1) == 0, label);
    }

    action State whenFullAmmo(StateLabel label) {
        return invoker.when(invoker.activeAmmo == invoker.Default.activeAmmo, label);
    }

    action void fr() {
        self.a_setTics(invoker.reloadFrameRate);
    }

    action void ff() {
        self.a_setTics(invoker.fireFrameRate);
    }
}