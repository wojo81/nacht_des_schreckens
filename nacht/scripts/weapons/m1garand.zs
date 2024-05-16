class M1Garand : zmd_Weapon {
    Default {
        Weapon.ammoGive 56;
        Weapon.ammoType 'M1GarandAmmo';
        zmd_Weapon.activeAmmo 8;
        zmd_Weapon.reloadFrameRate 3;
        zmd_Weapon.fireFrameRate 2;
        zmd_Weapon.keepPartialReload false;
    }

    States {
    Spawn:
        m1a0 a -1;
        loop;
    Select:
        tnt1 a 0 whenNoActiveAmmo('Raise.Empty');
    Raise:
        m1c0 a 1 a_raise;
        loop;
    Ready:
        tnt1 a 0 whenZoomed('Zoom.Ready');
        tnt1 a 0 whenNoActiveAmmo('Idle.Empty');
    Idle:
        m1c0 a 1 readyWeapon;
        loop;
    Deselect:
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenNoActiveAmmo('Lower.Empty');
    Lower:
        m1c0 a 1 a_lower;
        loop;
    Fire:
        tnt1 a 0 whenNoActiveAmmo('Ready');
        tnt1 a 0 whenZoomed('Zoom.Fire');
        tnt1 a 0 whenLastActiveAmmo('Fire.Last');
        m1f0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/m1g_fire");
        tnt1 a 0 shootBullets(3, 25, 1);
        m1f0 bcdef 2 ff;
        goto Ready;
    Reload:
        tnt1 a 0 whenNoAmmo('Ready');
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenAnyActiveAmmo('Reload.Partial');
        m1d0 abcdefghijk 3 fr;
        tnt1 a 0 a_startSound("weapons/m1g_clipin");
        m1d0 lmnop 3 fr;
        tnt1 a 0 a_startSound("weapons/m1g_close");
        m1d0 qrstuvwx 3 fr;
        tnt1 a 0 reload;
        goto Ready;
    Zoom:
        tnt1 a 0 toggleZoom;
    Zoom.In:
        tnt1 a 0 zoomIn;
        tnt1 a 0 whenNoActiveAmmo('Zoom.In.Empty');
        m1b0 abcdef 2;
    Zoom.Ready:
        tnt1 a 0 whenNoActiveAmmo('Zoom.Idle.Empty');
    Zoom.Idle:
        tnt1 a 0 whenShouldZoomOut('Zoom.Out');
        m1h0 a 2 readyWeapon;
        loop;
    Zoom.Out:
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenNoActiveAmmo('Zoom.Out.Empty');
        m1b0 fedcba 2;
        goto Ready;
    Zoom.Fire:
        tnt1 a 0 whenLastActiveAmmo('Zoom.Fire.Last');
        m1i0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/m1g_fire");
        tnt1 a 0 shootBullets(0.5, 25, 1);
        m1i0 bcdef 2 ff;
        goto Ready;
    Fire.Last:
        m1g0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/m1g_fire");
        tnt1 a 0 shootBullets(3, 25, 1);
        m1g0 bcd 2 ff;
        tnt1 a 0 a_startSound("weapons/m1g_ping");
        m1g0 e 2 ff;
        goto Ready;
    Zoom.Fire.Last:
        m1j0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/m1g_fire");
        tnt1 a 0 shootBullets(0.5, 25, 1);
        m1j0 bcd 2 ff;
        tnt1 a 0 a_startSound("weapons/m1g_ping");
        m1j0 ef 2 ff;
        goto Ready;
    Reload.Partial:
        m1e0 abcdefghi 2 fr;
        tnt1 a 0 a_startSound("weapons/m1g_open");
        m1e0 jk 2 fr;
        tnt1 a 0 a_startSound("weapons/m1g_clipout");
        m1e0 lmnopqrstuvwxyz 2 fr;
        m1e1 abcdefg 2 fr;
        tnt1 a 0 a_startSound("weapons/m1g_clipin");
        m1e1 hijkl 2 fr;
        tnt1 a 0 a_startSound("weapons/m1g_close");
        m1e1 mnopqrstuvwxyz 2 fr;
        m1e2 a 2 fr;
        tnt1 a 0 reload;
        goto Ready;
    Raise.Empty:
        m1l0 a 1 a_raise;
        loop;
    Idle.Empty:
        m1l0 a 1 readyWeapon;
        loop;
    Lower.Empty:
        m1l0 a 1 a_lower;
        loop;
    Zoom.In.Empty:
        m1k0 abcdef 2;
    Zoom.Idle.Empty:
        tnt1 a 0 whenShouldZoomOut('Zoom.Out');
        m1m0 a 1 readyWeapon;
        loop;
    Zoom.Out.Empty:
        m1k0 fedcba 2;
        goto Ready;
    }
}

class M1GarandAmmo : Ammo {
    Default {
        Inventory.maxAmount 128;
    }
}
