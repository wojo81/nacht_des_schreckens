class zmd_Weapon : Weapon abstract {
    bool useDoubleFire;
    bool useFastReload;
    bool zoomed;
    bool toggledZoom;
    readonly int clipCapacity;
    int clipSize;
    readonly int fastReloadRate;
    readonly int fastFireRate;

    property clipCapacity: clipCapacity;
    property fastReloadRate: fastReloadRate;
    property fastFireRate: fastFireRate;

    Default {
        Weapon.bobStyle 'InverseSmooth';

        +Weapon.noAutoAim
        +Weapon.noAutoFire
        +Weapon.ammo_optional
    }

    override void postBeginPlay() {
        super.postBeginPlay();
        self.toggledZoom = CVar.getCVar('toggledZoom', owner.player).getBool();
        self.clipSize += self.clipCapacity;
        self.owner.takeInventory(self.ammoType1, self.clipCapacity);
        zmd_Player(owner).enableWeaponPerks();
    }

    action State toggleZoom() {
        if (!invoker.zoomed)
            return resolveState('Zoom.In');
        return resolveState('Zoom.Out');
    }

    action State perhapsZoomOut() {
        if (!invoker.toggledZoom && !(invoker.owner.player.cmd.buttons & bt_zoom))
            return resolveState('Zoom.Out');
        return resolveState(null);
    }

    action void zoomIn() {
        invoker.zoomed = true;
        a_zoomFactor(1.5);
    }

    action void zoomOut() {
        invoker.zoomed = false;
        a_zoomFactor(1.0);
    }

    action State perhapsZoomFire() {
        if (invoker.zoomed)
            return resolveState('Zoom.Fire');
        return resolveState(null);
    }

    action void readyWeapon() {
        if (invoker.zoomed && !invoker.toggledZoom)
            a_weaponReady(wrf_allowReload);
        else
            a_weaponReady(wrf_allowReload | wrf_allowZoom);
    }

    action void reload() {
        invoker.clipSize = invoker.clipCapacity;
        invoker.owner.takeInventory(invoker.ammoType1, invoker.clipCapacity);
    }

    action void reloadPartially() {
        let reserveAmmo = invoker.owner.countInv(invoker.ammoType1);
        let activeAmmo = invoker.clipSize;
        let maxActive = invoker.clipCapacity;

        let transferAmmo = min(maxActive - activeAmmo, reserveAmmo);
        if (transferAmmo == 0)
            invoker.owner.takeInventory(invoker.ammoType1, reserveAmmo);
        invoker.owner.takeInventory(invoker.ammoType1, transferAmmo);
        invoker.clipSize += transferAmmo;
    }

    action void shoot(double spread, int damage, int bullets = -1) {
        a_fireBullets(spread, spread, bullets, damage << invoker.useDoubleFire, flags: fbf_noRandom);
        --invoker.clipSize;
    }

    action void shootProjectile(String projectile) {
        a_fireProjectile(projectile, useAmmo: false);
        --invoker.clipSize;
    }

    action State perhapsNoFire() {
        if (!invoker.clipSize)
            return resolveState('Ready');
        return resolveState(null);
    }

    action State perhapsNoReload() {
        if (!invoker.owner.countInv(invoker.ammoType1))
            return resolveState('Ready');
        return resolveState(null);
    }

    action State perhapsFireLast() {
        if (invoker.clipSize == 1)
            return resolveState('Fire.Last');
        return resolveState(null);
    }

    action State perhapsZoomReady() {
        if (invoker.zoomed)
            return resolveState('Zoom.Ready');
        return resolveState(null);
    }

    action State perhapsZoomFireLast() {
        if (invoker.clipSize == 1)
            return resolveState('Zoom.Fire.Last');
        return resolveState(null);
    }

    action State perhapsReloadPartial() {
        if (invoker.clipSize)
            return resolveState('Reload.Partial');
        return resolveState(null);
    }

    action State perhapsReloadPartialOnly() {
        if ((invoker.clipSize != 0 && invoker.clipSize != invoker.clipCapacity) || invoker.owner.countInv(invoker.ammoType1) < invoker.clipCapacity)
            return resolveState('Reload.Partial');
        return resolveState(null);
    }

    action State perhapsRaiseEmpty() {
        if (!invoker.clipSize)
            return resolveState('Raise.Empty');
        return resolveState(null);
    }

    action State perhapsIdleEmpty() {
        if (!invoker.clipSize)
            return resolveState('Idle.Empty');
        return resolveState(null);
    }

    action State perhapsLowerEmpty() {
        if (!invoker.clipSize)
            return resolveState('Lower.Empty');
        return resolveState(null);
    }

    action State perhapsZoomInEmpty() {
        if (!invoker.clipSize)
            return resolveState('Zoom.In.Empty');
        return resolveState(null);
    }

    action State perhapsZoomIdleEmpty() {
        if (!invoker.clipSize)
            return resolveState('Zoom.Idle.Empty');
        return resolveState(null);
    }

    action State perhapsZoomOutEmpty() {
        if (!invoker.clipSize)
            return resolveState('Zoom.Out.Empty');
        return resolveState(null);
    }

    action State perhapsNoFireEmpty() {
        if (!invoker.clipSize)
            return resolveState('Ready.Empty');
        return resolveState(null);
    }

    action State perhapsNoZoomFireEmpty() {
        if (!invoker.clipSize)
            return resolveState('Zoom.Ready.Empty');
        return resolveState(null);
    }

    action void ff() {
        if (invoker.useDoubleFire)
            a_setTics(invoker.fastFireRate);
    }

    action void fr() {
        if (invoker.useFastReload)
            a_setTics(invoker.fastReloadRate);
    }
}