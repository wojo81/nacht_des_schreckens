class zmd_M1GarandAmmo : Ammo {
    Default {
        Inventory.maxAmount 128;
    }
}

class zmd_M1Garand : zmd_Weapon {
    Default {
        Weapon.ammoGive 56;
        Weapon.ammoType 'zmd_M1GarandAmmo';
        zmd_Weapon.activeAmmo 8;
        zmd_Weapon.reloadFrameRate 3;
        zmd_Weapon.fireFrameRate 2;
        zmd_Weapon.keepPartialReload true;
    }

    States {
    Spawn:
        m2a0 a -1;
        loop;
    Select:
        tnt1 a 0 whenNoActiveAmmo('EmptyRaise');
    Raise:
        m2c0 a 1 a_raise;
        loop;
    Ready:
        tnt1 a 0 whenZoomed('ZoomReady');
        tnt1 a 0 whenNoActiveAmmo('EmptyIdle');
    Idle:
        m2c0 a 1 readyWeapon;
        loop;
    Deselect:
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenNoActiveAmmo('EmptyLower');
    Lower:
        m2c0 a 1 a_lower;
        loop;
    Fire:
        tnt1 a 0 whenNoActiveAmmo('Ready');
        tnt1 a 0 whenZoomed('ZoomFire');
        tnt1 a 0 whenLastActiveAmmo('LastFire');
        m2f0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/m1g_fire");
        tnt1 a 0 shootBullets(3, 25, 1);
        m2f0 bcdef 2 ff;
        goto Ready;
    Reload:
        tnt1 a 0 whenFullAmmo('Ready');
        tnt1 a 0 whenNoAmmo('Ready');
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenAnyActiveAmmo('PartialReload');
        m2d0 abcdefghijk 3 fr;
        tnt1 a 0 a_startSound("weapons/m1g_clipin");
        m2d0 lmnop 3 fr;
        tnt1 a 0 a_startSound("weapons/m1g_close");
        m2d0 qrstuvwx 3 fr;
        tnt1 a 0 reload;
        goto Ready;
    Zoom:
        tnt1 a 0 toggleZoom;
    ZoomIn:
        tnt1 a 0 zoomIn;
        tnt1 a 0 whenNoActiveAmmo('EmptyZoomIn');
        m2b0 abcdef 2;
    ZoomReady:
        tnt1 a 0 whenNoActiveAmmo('EmptyZoomIdle');
    ZoomIdle:
        tnt1 a 0 whenShouldZoomOut('ZoomOut');
        m2h0 a 2 readyWeapon;
        loop;
    ZoomOut:
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenNoActiveAmmo('EmptyZoomOut');
        m2b0 fedcba 2;
        goto Ready;
    ZoomFire:
        tnt1 a 0 whenLastActiveAmmo('LastZoomFire');
        m2i0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/m1g_fire");
        tnt1 a 0 shootBullets(0.5, 25, 1);
        m2i0 bcdef 2 ff;
        goto Ready;
    LastFire:
        m2g0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/m1g_fire");
        tnt1 a 0 shootBullets(3, 25, 1);
        m2g0 bcd 2 ff;
        tnt1 a 0 a_startSound("weapons/m1g_ping");
        m2g0 e 2 ff;
        goto Ready;
    LastZoomFire:
        m2j0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/m1g_fire");
        tnt1 a 0 shootBullets(0.5, 25, 1);
        m2j0 bcd 2 ff;
        tnt1 a 0 a_startSound("weapons/m1g_ping");
        m2j0 ef 2 ff;
        goto Ready;
    PartialReload:
        m2e0 abcdefghi 2 fr;
        tnt1 a 0 a_startSound("weapons/m1g_open");
        m2e0 jk 2 fr;
        tnt1 a 0 a_startSound("weapons/m1g_clipout");
        m2e0 lmnopqrstuvwxyz 2 fr;
        m2e1 abcdefg 2 fr;
        tnt1 a 0 a_startSound("weapons/m1g_clipin");
        m2e1 hijkl 2 fr;
        tnt1 a 0 a_startSound("weapons/m1g_close");
        m2e1 mnopqrstuvwxyz 2 fr;
        m2e2 a 2 fr;
        tnt1 a 0 reload;
        goto Ready;
    EmptyRaise:
        m2l0 a 1 a_raise;
        loop;
    EmptyIdle:
        m2l0 a 1 readyWeapon;
        loop;
    EmptyLower:
        m2l0 a 1 a_lower;
        loop;
    EmptyZoomIn:
        m2k0 abcdef 2;
    EmptyZoomIdle:
        tnt1 a 0 whenShouldZoomOut('ZoomOut');
        m2m0 a 1 readyWeapon;
        loop;
    EmptyZoomOut:
        m2k0 fedcba 2;
        goto Ready;
    }
}