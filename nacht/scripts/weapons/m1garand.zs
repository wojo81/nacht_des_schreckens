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
        tnt1 a 0 whenNoActiveAmmo('EmptyRaise');
    Raise:
        m1c0 a 1 a_raise;
        loop;
    Ready:
        tnt1 a 0 whenZoomed('ZoomReady');
        tnt1 a 0 whenNoActiveAmmo('EmptyIdle');
    Idle:
        m1c0 a 1 readyWeapon;
        loop;
    Deselect:
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenNoActiveAmmo('EmptyLower');
    Lower:
        m1c0 a 1 a_lower;
        loop;
    Fire:
        tnt1 a 0 whenNoActiveAmmo('Ready');
        tnt1 a 0 whenZoomed('ZoomFire');
        tnt1 a 0 whenLastActiveAmmo('LastFire');
        m1f0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/m1g_fire");
        tnt1 a 0 shootBullets(3, 25, 1);
        m1f0 bcdef 2 ff;
        goto Ready;
    Reload:
        tnt1 a 0 whenFullAmmo('Ready');
        tnt1 a 0 whenNoAmmo('Ready');
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenAnyActiveAmmo('PartialReload');
        m1d0 abcdefghijk 3 fr;
        tnt1 a 0 a_startSound("weapons/m1g_clipin");
        m1d0 lmnop 3 fr;
        tnt1 a 0 a_startSound("weapons/m1g_close");
        m1d0 qrstuvwx 3 fr;
        tnt1 a 0 reload;
        goto Ready;
    Zoom:
        tnt1 a 0 toggleZoom;
    ZoomIn:
        tnt1 a 0 zoomIn;
        tnt1 a 0 whenNoActiveAmmo('EmptyZoomIn');
        m1b0 abcdef 2;
    ZoomReady:
        tnt1 a 0 whenNoActiveAmmo('EmptyZoomIdle');
    ZoomIdle:
        tnt1 a 0 whenShouldZoomOut('ZoomOut');
        m1h0 a 2 readyWeapon;
        loop;
    ZoomOut:
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenNoActiveAmmo('EmptyZoomOut');
        m1b0 fedcba 2;
        goto Ready;
    ZoomFire:
        tnt1 a 0 whenLastActiveAmmo('LastZoomFire');
        m1i0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/m1g_fire");
        tnt1 a 0 shootBullets(0.5, 25, 1);
        m1i0 bcdef 2 ff;
        goto Ready;
    LastFire:
        m1g0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/m1g_fire");
        tnt1 a 0 shootBullets(3, 25, 1);
        m1g0 bcd 2 ff;
        tnt1 a 0 a_startSound("weapons/m1g_ping");
        m1g0 e 2 ff;
        goto Ready;
    LastZoomFire:
        m1j0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/m1g_fire");
        tnt1 a 0 shootBullets(0.5, 25, 1);
        m1j0 bcd 2 ff;
        tnt1 a 0 a_startSound("weapons/m1g_ping");
        m1j0 ef 2 ff;
        goto Ready;
    PartialReload:
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
    EmptyRaise:
        m1l0 a 1 a_raise;
        loop;
    EmptyIdle:
        m1l0 a 1 readyWeapon;
        loop;
    EmptyLower:
        m1l0 a 1 a_lower;
        loop;
    EmptyZoomIn:
        m1k0 abcdef 2;
    EmptyZoomIdle:
        tnt1 a 0 whenShouldZoomOut('EmptyZoomOut');
        m1m0 a 1 readyWeapon;
        loop;
    EmptyZoomOut:
        m1k0 fedcba 2;
        goto Ready;
    }
}

class M1GarandAmmo : Ammo {
    Default {
        Inventory.maxAmount 128;
    }
}
